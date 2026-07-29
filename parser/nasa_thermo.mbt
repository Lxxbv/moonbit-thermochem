///|
priv struct Header {
  name : String
  phase : @moonbit-thermochem.Phase
  low : Double
  mid : Double
  high : Double
}

///|
fn[T] parse_error(
  line~ : Int,
  column~ : Int,
  message~ : String,
) -> T raise @moonbit-thermochem.ThermoError {
  raise @moonbit-thermochem.ThermoError::ParseError(line~, column~, message~)
}

///|
fn parse_number(
  token : Token,
  line : Int,
) -> Double raise @moonbit-thermochem.ThermoError {
  @string.parse_double(token.text) catch {
    _ => parse_error(line~, column=token.column, message="invalid number")
  }
}

///|
fn parse_phase(
  token : Token,
  line : Int,
) -> @moonbit-thermochem.Phase raise @moonbit-thermochem.ThermoError {
  match token.text {
    "G" => @moonbit-thermochem.Phase::Gas
    "L" => @moonbit-thermochem.Phase::Liquid
    "S" => @moonbit-thermochem.Phase::Solid
    _ => parse_error(line~, column=token.column, message="invalid phase")
  }
}

///|
fn parse_header(
  tokens : Array[Token],
  line : Int,
) -> Header raise @moonbit-thermochem.ThermoError {
  if tokens.length() != 5 {
    parse_error(line~, column=1, message="expected name phase low mid high")
  }
  {
    name: tokens[0].text,
    phase: parse_phase(tokens[1], line),
    low: parse_number(tokens[2], line),
    mid: parse_number(tokens[3], line),
    high: parse_number(tokens[4], line),
  }
}

///|
fn parse_coefficients(
  tokens : Array[Token],
  expected : String,
  line : Int,
) -> Array[Double] raise @moonbit-thermochem.ThermoError {
  if tokens.length() != 8 || tokens[0].text != expected {
    parse_error(
      line~,
      column=1,
      message="expected \{expected} followed by seven coefficients",
    )
  }
  let coefficients : Array[Double] = []
  for index in 1..<=7 {
    coefficients.push(parse_number(tokens[index], line))
  }
  coefficients
}

///|
fn species_from_record(
  header : Header,
  low_coefficients : Array[Double],
  high_coefficients : Array[Double],
) -> @moonbit-thermochem.Species raise @moonbit-thermochem.ThermoError {
  let low = @moonbit-thermochem.Nasa7Segment::new(
    range=@moonbit-thermochem.TemperatureRange::new(
      lower=header.low,
      upper=header.mid,
    ),
    a1=low_coefficients[0],
    a2=low_coefficients[1],
    a3=low_coefficients[2],
    a4=low_coefficients[3],
    a5=low_coefficients[4],
    a6=low_coefficients[5],
    a7=low_coefficients[6],
  )
  let high = @moonbit-thermochem.Nasa7Segment::new(
    range=@moonbit-thermochem.TemperatureRange::new(
      lower=header.mid,
      upper=header.high,
    ),
    a1=high_coefficients[0],
    a2=high_coefficients[1],
    a3=high_coefficients[2],
    a4=high_coefficients[3],
    a5=high_coefficients[4],
    a6=high_coefficients[5],
    a7=high_coefficients[6],
  )
  @moonbit-thermochem.Species::new(
    name=header.name,
    formula=@moonbit-thermochem.parse_formula(header.name),
    phase=header.phase,
    molar_mass=0.0,
    formation_enthalpy=0.0,
    model=@moonbit-thermochem.ThermoModel::Nasa7([low, high]),
  )
}

///|
/// Parses compact NASA7 records with `name phase low mid high`, `LOW`, and `HIGH` lines.
pub fn parse_nasa7_thermo(
  text : String,
) -> Array[@moonbit-thermochem.Species] raise @moonbit-thermochem.ThermoError {
  let species : Array[@moonbit-thermochem.Species] = []
  let mut header : Header? = None
  let mut low_coefficients : Array[Double]? = None
  let mut line_number = 0
  for line in text.split("\n") {
    line_number += 1
    let tokens = scan_line(line.to_owned())
    if tokens.length() == 0 {
      continue
    }
    match (header, low_coefficients) {
      (None, None) => header = Some(parse_header(tokens, line_number))
      (Some(_), None) =>
        low_coefficients = Some(parse_coefficients(tokens, "LOW", line_number))
      (Some(record_header), Some(record_low)) => {
        let high_coefficients = parse_coefficients(tokens, "HIGH", line_number)
        species.push(
          species_from_record(record_header, record_low, high_coefficients),
        )
        header = None
        low_coefficients = None
      }
      (None, Some(_)) => abort("unreachable parser state")
    }
  }
  match (header, low_coefficients) {
    (None, None) => species
    _ => {
      parse_error(
        line=line_number + 1,
        column=1,
        message="incomplete NASA7 species record",
      )
      species
    }
  }
}
