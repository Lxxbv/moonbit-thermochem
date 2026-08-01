///|
pub fn help_text() -> String {
  "Usage:\nmoon run cmd/thermochem -- species CH4 1200\nmoon run cmd/thermochem -- reaction methane-combustion 298.15\nmoon run cmd/thermochem -- flame methane-air 298.15\nmoon run cmd/thermochem -- ammonia 700\n\nCommands: species, reaction, flame, ammonia"
}

///|
fn parse_temperature(value : String) -> Double? {
  Some(@string.parse_double(value)) catch {
    _ => None
  }
}

///|
fn render_thermo_error(error : @moonbit-thermochem.ThermoError) -> String {
  match error {
    @moonbit-thermochem.ThermoError::InvalidTemperatureRange(lower~, upper~) =>
      "invalid temperature range: \{lower} > \{upper}"
    @moonbit-thermochem.ThermoError::TemperatureOutOfRange(
      value~,
      lower~,
      upper~
    ) => "temperature \{value} K outside range \{lower}-\{upper} K"
    @moonbit-thermochem.ThermoError::NoThermoSegment(species~, temperature~) =>
      "no thermo segment for \{species} at \{temperature} K"
    @moonbit-thermochem.ThermoError::MissingSpecies(name~) =>
      "missing species: \{name}"
    @moonbit-thermochem.ThermoError::UnknownElement(symbol~) =>
      "unknown element: \{symbol}"
    @moonbit-thermochem.ThermoError::ParseError(line~, column~, message~) =>
      "parse error at \{line}:\{column}: \{message}"
    @moonbit-thermochem.ThermoError::SolverFailed(message~) =>
      "solver failed: \{message}"
  }
}

///|
fn render_species(name : String, temperature : Double) -> String {
  try {
    let species = @data.get_species(name)
    "\{species.name}\ntemperature: \{temperature} K\nCp: \{species.cp_molar(temperature~)} J/mol/K\nenthalpy: \{species.enthalpy_molar(temperature~)} J/mol\nentropy: \{species.entropy_molar(temperature~)} J/mol/K"
  } catch {
    error => "error: \{render_thermo_error(error)}"
  }
}

///|
fn render_reaction(temperature : Double) -> String {
  @examples.methane_combustion_report(initial_temperature=temperature) catch {
    error => "error: \{render_thermo_error(error)}"
  }
}

///|
fn term(
  name : String,
  coefficient : Double,
) -> @moonbit-thermochem.StoichTerm raise @moonbit-thermochem.ThermoError {
  @moonbit-thermochem.StoichTerm::new(
    species=@data.get_species(name),
    coefficient~,
  )
}

///|
fn methane_air_combustion() -> @moonbit-thermochem.Reaction raise @moonbit-thermochem.ThermoError {
  @moonbit-thermochem.Reaction::new(
    label="methane-air: CH4 + 2 O2 + 7.52 N2 -> CO2 + 2 H2O + 7.52 N2",
    reactants=[term("CH4", 1.0), term("O2", 2.0), term("N2", 7.52)],
    products=[term("CO2", 1.0), term("H2O", 2.0), term("N2", 7.52)],
  )
}

///|
fn render_flame(temperature : Double) -> String {
  let reaction = methane_air_combustion() catch {
    error => return "error: \{render_thermo_error(error)}"
  }
  let flame_temperature = @moonbit-thermochem.adiabatic_flame_temperature(
    reaction,
    initial_temperature=temperature,
  ) catch {
    @moonbit-thermochem.ThermoError::NoThermoSegment(..) =>
      return "\{reaction.label}\ntemperature: \{temperature} K\nflame temperature: unavailable (outside bundled data range)"
    error => return "error: \{render_thermo_error(error)}"
  }
  "\{reaction.label}\ntemperature: \{temperature} K\nflame temperature: \{flame_temperature} K"
}

///|
fn render_ammonia(temperature : Double) -> String {
  @examples.ammonia_synthesis_report(temperature~) catch {
    error => "error: \{render_thermo_error(error)}"
  }
}

///|
pub fn render(args : Array[String]) -> String {
  match args {
    ["species", name, temperature] =>
      match parse_temperature(temperature) {
        Some(value) => render_species(name, value)
        None => "error: temperature must be a number"
      }
    ["reaction", "methane-combustion", temperature] =>
      match parse_temperature(temperature) {
        Some(value) => render_reaction(value)
        None => "error: temperature must be a number"
      }
    ["flame", "methane-air", temperature] =>
      match parse_temperature(temperature) {
        Some(value) => render_flame(value)
        None => "error: temperature must be a number"
      }
    ["ammonia", temperature] =>
      match parse_temperature(temperature) {
        Some(value) => render_ammonia(value)
        None => "error: temperature must be a number"
      }
    _ => help_text()
  }
}
