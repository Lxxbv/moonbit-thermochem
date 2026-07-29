///|
pub fn help_text() -> String {
  "Usage:\nmoon run cmd/thermochem -- species CH4 1200\nmoon run cmd/thermochem -- reaction methane-combustion 298.15\nmoon run cmd/thermochem -- flame methane-combustion 298.15\nmoon run cmd/thermochem -- ammonia 700\n\nCommands: species, reaction, flame, ammonia"
}

///|
fn parse_temperature(value : String) -> Double? {
  Some(@string.parse_double(value)) catch {
    _ => None
  }
}

///|
fn render_species(name : String, temperature : Double) -> String {
  try {
    let species = @data.get_species(name)
    "\{species.name}\ntemperature: \{temperature} K\nCp: \{species.cp_molar(temperature~)} J/mol/K\nenthalpy: \{species.enthalpy_molar(temperature~)} J/mol\nentropy: \{species.entropy_molar(temperature~)} J/mol/K"
  } catch {
    error => "error: \{to_repr(error)}"
  }
}

///|
fn render_reaction(temperature : Double) -> String {
  @examples.methane_combustion_report(initial_temperature=temperature) catch {
    error => "error: \{to_repr(error)}"
  }
}

///|
fn render_flame(temperature : Double) -> String {
  let reaction = @data.methane_combustion() catch {
    error => return "error: \{to_repr(error)}"
  }
  let flame_temperature = @moonbit-thermochem.adiabatic_flame_temperature(
    reaction,
    initial_temperature=temperature,
  ) catch {
    @moonbit-thermochem.ThermoError::NoThermoSegment(..) =>
      return "\{reaction.label}\ntemperature: \{temperature} K\nflame temperature: unavailable (outside bundled data range)"
    error => return "error: \{to_repr(error)}"
  }
  "\{reaction.label}\ntemperature: \{temperature} K\nflame temperature: \{flame_temperature} K"
}

///|
fn render_ammonia(temperature : Double) -> String {
  @examples.ammonia_synthesis_report(temperature~) catch {
    error => "error: \{to_repr(error)}"
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
    ["flame", "methane-combustion", temperature] =>
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

///|
fn main {
  match @env.args() {
    [_, .. args] => println(render(args.to_owned()))
    _ => println(help_text())
  }
}
