///|
pub fn ammonia_synthesis_report(
  temperature~ : Double,
) -> String raise @moonbit-thermochem.ThermoError {
  let reaction = @data.ammonia_synthesis()
  let enthalpy = reaction.enthalpy(temperature~)
  "\{reaction.label}\ntemperature: \{temperature} K\nreaction enthalpy: \{enthalpy / 1000.0} kJ/mol reaction"
}
