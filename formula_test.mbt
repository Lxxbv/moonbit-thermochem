///|
test "parse simple formula counts elements" {
  let formula = parse_formula("CH4")
  inspect(formula.count("C"), content="1")
  inspect(formula.count("H"), content="4")
  inspect(formula.count("O"), content="0")
}

///|
test "parse multi-letter element formula" {
  let formula = parse_formula("NH3")
  inspect(formula.count("N"), content="1")
  inspect(formula.count("H"), content="3")
}

///|
test "formula rejects lowercase start" {
  try parse_formula("ch4") catch {
    ThermoError::ParseError(line=1, column=1, message~) =>
      inspect(message, content="expected uppercase element symbol")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}
