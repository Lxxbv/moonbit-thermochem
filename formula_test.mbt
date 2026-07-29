///|
test "parse simple formula counts elements" {
  let formula = parse_formula("CH4")
  inspect(formula.count("C"), content="1")
  inspect(formula.count("H"), content="4")
  inspect(formula.count("O"), content="0")
}

///|
test "parse multi-letter element formula" {
  let formula = parse_formula("NaCl")
  inspect(formula.count("Na"), content="1")
  inspect(formula.count("Cl"), content="1")
}

///|
test "formula combines repeated elements" {
  let formula = parse_formula("CH3COOH")
  inspect(formula.count("C"), content="2")
  inspect(formula.count("H"), content="4")
  inspect(formula.count("O"), content="2")
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

///|
test "formula rejects zero element count" {
  try parse_formula("H0") catch {
    ThermoError::ParseError(line=1, column=1, message~) =>
      inspect(message, content="expected positive element count")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}
