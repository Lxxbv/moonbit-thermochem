///|
pub(all) suberror ThermoError {
  InvalidTemperatureRange(lower~ : Double, upper~ : Double)
  TemperatureOutOfRange(value~ : Double, lower~ : Double, upper~ : Double)
  NoThermoSegment(species~ : String, temperature~ : Double)
  MissingSpecies(name~ : String)
  ParseError(line~ : Int, column~ : Int, message~ : String)
  SolverFailed(message~ : String)
} derive(Debug, Eq)

///|
pub(all) struct TemperatureRange {
  lower : Double
  upper : Double
} derive(Debug, Eq)

///|
pub fn TemperatureRange::new(
  lower~ : Double,
  upper~ : Double,
) -> TemperatureRange raise ThermoError {
  if lower > upper {
    raise ThermoError::InvalidTemperatureRange(lower~, upper~)
  }
  { lower, upper }
}

///|
pub fn TemperatureRange::contains(
  self : TemperatureRange,
  temperature : Double,
) -> Bool {
  self.lower <= temperature && temperature <= self.upper
}

///|
pub fn TemperatureRange::validate(
  self : TemperatureRange,
  temperature : Double,
) -> Unit raise ThermoError {
  if !self.contains(temperature) {
    raise ThermoError::TemperatureOutOfRange(
      value=temperature,
      lower=self.lower,
      upper=self.upper,
    )
  }
}
