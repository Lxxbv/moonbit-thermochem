///|
pub fn methane_combustion_report(
  initial_temperature~ : Double,
) -> String raise @moonbit-thermochem.ThermoError {
  let reaction = @data.methane_combustion()
  let enthalpy = reaction.enthalpy(temperature=initial_temperature)
  let flame_temperature_line = try {
    let flame_temperature = @moonbit-thermochem.adiabatic_flame_temperature(
      reaction,
      initial_temperature~,
    )
    "flame temperature: \{flame_temperature} K"
  } catch {
    @moonbit-thermochem.ThermoError::NoThermoSegment(..) =>
      "flame temperature: unavailable (outside bundled data range)"
    error => raise error
  }
  "\{reaction.label}\ntemperature: \{initial_temperature} K\nreaction enthalpy: \{enthalpy / 1000.0} kJ/mol reaction\n\{flame_temperature_line}"
}
