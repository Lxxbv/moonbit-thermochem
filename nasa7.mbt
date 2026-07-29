///|
pub(all) struct Nasa7Segment {
  range : TemperatureRange
  a1 : Double
  a2 : Double
  a3 : Double
  a4 : Double
  a5 : Double
  a6 : Double
  a7 : Double
} derive(Debug, Eq)

///|
pub fn Nasa7Segment::new(
  range~ : TemperatureRange,
  a1~ : Double,
  a2~ : Double,
  a3~ : Double,
  a4~ : Double,
  a5~ : Double,
  a6~ : Double,
  a7~ : Double,
) -> Nasa7Segment {
  { range, a1, a2, a3, a4, a5, a6, a7 }
}

///|
pub fn Nasa7Segment::cp_over_r(
  self : Nasa7Segment,
  temperature : Double,
) -> Double raise ThermoError {
  self.range.validate(temperature)
  let t2 = temperature * temperature
  let t3 = t2 * temperature
  let t4 = t3 * temperature
  self.a1 + self.a2 * temperature + self.a3 * t2 + self.a4 * t3 + self.a5 * t4
}

///|
pub fn Nasa7Segment::h_over_rt(
  self : Nasa7Segment,
  temperature : Double,
) -> Double raise ThermoError {
  self.range.validate(temperature)
  let t2 = temperature * temperature
  let t3 = t2 * temperature
  let t4 = t3 * temperature
  self.a1 +
  self.a2 * temperature / 2.0 +
  self.a3 * t2 / 3.0 +
  self.a4 * t3 / 4.0 +
  self.a5 * t4 / 5.0 +
  self.a6 / temperature
}

///|
pub fn Nasa7Segment::s_over_r(
  self : Nasa7Segment,
  temperature : Double,
) -> Double raise ThermoError {
  self.range.validate(temperature)
  let t2 = temperature * temperature
  let t3 = t2 * temperature
  let t4 = t3 * temperature
  self.a1 * @math.ln(temperature) +
  self.a2 * temperature +
  self.a3 * t2 / 2.0 +
  self.a4 * t3 / 3.0 +
  self.a5 * t4 / 4.0 +
  self.a7
}
