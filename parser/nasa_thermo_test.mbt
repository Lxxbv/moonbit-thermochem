///|
test "parse compact nasa7 species record" {
  let text =
    #|CH4 G 200.0 1000.0 6000.0
    #|LOW 5.14987613 -0.0136709788 0.000049181005 0.0000000000 0.0000000000 -10246.6476 -4.64130376
    #|HIGH 1.63552643 0.0100842795 -0.00000336916254 0.0000000000 0.0000000000 -10005.0048 9.99313326
    #|
  let species = parse_nasa7_thermo(text)
  inspect(species.length(), content="1")
  inspect(species[0].name, content="CH4")
}

///|
test "parser constructs low and high NASA7 segments" {
  let text =
    #|CH4 G 200.0 1000.0 6000.0
    #|LOW 3.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|HIGH 4.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|
  let species = parse_nasa7_thermo(text)[0]
  let low_cp = species.cp_molar(temperature=300.0)
  let high_cp = species.cp_molar(temperature=2000.0)
  inspect(low_cp > 24.94 && low_cp < 24.95, content="true")
  inspect(high_cp > 33.25 && high_cp < 33.26, content="true")
}

///|
test "parser reports bad header range at middle temperature" {
  let text =
    #|CH4 G 1000 200 6000
    #|LOW 1.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|HIGH 1.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|
  try parse_nasa7_thermo(text) catch {
    @moonbit-thermochem.ThermoError::ParseError(line=1, column=12, message~) =>
      inspect(message, content="expected low <= mid <= high")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}

///|
test "parser reports physical location for formula errors in later records" {
  let text =
    #|CH4 G 200.0 1000.0 6000.0
    #|LOW 1.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|HIGH 1.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|CH4! G 200.0 1000.0 6000.0
    #|LOW 1.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|HIGH 1.0 0.0 0.0 0.0 0.0 0.0 0.0
    #|
  try parse_nasa7_thermo(text) catch {
    @moonbit-thermochem.ThermoError::ParseError(line=4, column=4, message~) =>
      inspect(message, content="expected uppercase element symbol")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}

///|
test "parser reports line for bad coefficient" {
  let text =
    #|CH4 G 200.0 1000.0 6000.0
    #|LOW bad -0.013 0.0 0.0 0.0 -1.0 0.0
    #|HIGH 1.0 0.0 0.0 0.0 0.0 -1.0 0.0
    #|
  try parse_nasa7_thermo(text) catch {
    @moonbit-thermochem.ThermoError::ParseError(line=2, column=5, message~) =>
      inspect(message, content="invalid number")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}
