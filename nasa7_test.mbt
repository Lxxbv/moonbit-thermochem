///|
fn constant_cp_segment() -> Nasa7Segment raise ThermoError {
  Nasa7Segment::new(
    range=TemperatureRange::new(lower=200.0, upper=6000.0),
    a1=3.5,
    a2=0.0,
    a3=0.0,
    a4=0.0,
    a5=0.0,
    a6=0.0,
    a7=1.0,
  )
}

///|
fn nonzero_coefficient_segment() -> Nasa7Segment raise ThermoError {
  Nasa7Segment::new(
    range=TemperatureRange::new(lower=1.0, upper=10.0),
    a1=1.0,
    a2=0.1,
    a3=0.01,
    a4=0.001,
    a5=0.0001,
    a6=2.0,
    a7=3.0,
  )
}

///|
test "nasa7 constant heat capacity" {
  let segment = constant_cp_segment()
  inspect(segment.cp_over_r(300.0), content="3.5")
}

///|
test "nasa7 evaluates nonzero coefficients" {
  let segment = nonzero_coefficient_segment()
  let cp = segment.cp_over_r(2.0)
  let enthalpy = segment.h_over_rt(2.0)
  let entropy = segment.s_over_r(2.0)
  inspect(cp > 1.2495 && cp < 1.2497, content="true")
  inspect(enthalpy > 2.1156 && enthalpy < 2.1157, content="true")
  inspect(entropy > 3.9162 && entropy < 3.9163, content="true")
}

///|
test "nasa7 heat capacity rejects out of range temperature" {
  let segment = nonzero_coefficient_segment()
  try segment.cp_over_r(0.5) catch {
    ThermoError::TemperatureOutOfRange(value=0.5, lower=1.0, upper=10.0) => ()
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected out of range")
  }
}

///|
test "nasa7 enthalpy rejects out of range temperature" {
  let segment = nonzero_coefficient_segment()
  try segment.h_over_rt(0.5) catch {
    ThermoError::TemperatureOutOfRange(value=0.5, lower=1.0, upper=10.0) => ()
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected out of range")
  }
}

///|
test "nasa7 entropy rejects out of range temperature" {
  let segment = nonzero_coefficient_segment()
  try segment.s_over_r(0.5) catch {
    ThermoError::TemperatureOutOfRange(value=0.5, lower=1.0, upper=10.0) => ()
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected out of range")
  }
}

///|
test "nasa7 enthalpy and entropy nondimensional forms" {
  let segment = constant_cp_segment()
  inspect(segment.h_over_rt(300.0), content="3.5")
  let entropy = segment.s_over_r(300.0)
  inspect(entropy > 20.96 && entropy < 20.97, content="true")
}
