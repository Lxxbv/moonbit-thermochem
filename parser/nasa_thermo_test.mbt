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
