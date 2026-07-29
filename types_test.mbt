///|
test "temperature range accepts endpoints and interior" {
  let range = TemperatureRange::new(lower=200.0, upper=1000.0)
  inspect(range.contains(200.0), content="true")
  inspect(range.contains(500.0), content="true")
  inspect(range.contains(1000.0), content="true")
}

///|
test "temperature range rejects outside values" {
  let range = TemperatureRange::new(lower=200.0, upper=1000.0)
  inspect(range.contains(199.9), content="false")
  inspect(range.contains(1000.1), content="false")
}

///|
test "temperature validation reports bad value" {
  let range = TemperatureRange::new(lower=200.0, upper=1000.0)
  try range.validate(150.0) catch {
    ThermoError::TemperatureOutOfRange(value~, lower~, upper~) =>
      inspect("\{value} < \{lower}..\{upper}", content="150 < 200..1000")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected out of range")
  }
}
