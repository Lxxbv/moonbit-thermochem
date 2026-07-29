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
test "nasa7 constant heat capacity" {
  let segment = constant_cp_segment()
  inspect(segment.cp_over_r(300.0), content="3.5")
}

///|
test "nasa7 enthalpy and entropy nondimensional forms" {
  let segment = constant_cp_segment()
  inspect(segment.h_over_rt(300.0), content="3.5")
  let entropy = segment.s_over_r(300.0)
  inspect(entropy > 20.96 && entropy < 20.97, content="true")
}
