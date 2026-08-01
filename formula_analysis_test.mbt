///|
test "atomic weights cover common thermochemical elements" {
  inspect(
    atomic_weight("H") > 1.007 && atomic_weight("H") < 1.009,
    content="true",
  )
  inspect(
    atomic_weight("C") > 12.00 && atomic_weight("C") < 12.02,
    content="true",
  )
  inspect(
    atomic_weight("N") > 14.00 && atomic_weight("N") < 14.02,
    content="true",
  )
  inspect(
    atomic_weight("O") > 15.99 && atomic_weight("O") < 16.01,
    content="true",
  )
  inspect(
    atomic_weight("Na") > 22.98 && atomic_weight("Na") < 23.00,
    content="true",
  )
  inspect(
    atomic_weight("Cl") > 35.44 && atomic_weight("Cl") < 35.46,
    content="true",
  )
}

///|
test "atomic weight reports unknown element" {
  try atomic_weight("Xx") catch {
    ThermoError::UnknownElement(symbol="Xx") =>
      inspect("unknown", content="unknown")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected unknown element")
  }
}

///|
test "formula molar mass handles simple species" {
  inspect(parse_formula("CH4").molar_mass() > 16.03, content="true")
  inspect(parse_formula("CH4").molar_mass() < 16.05, content="true")
  inspect(parse_formula("CO2").molar_mass() > 44.00, content="true")
  inspect(parse_formula("CO2").molar_mass() < 44.02, content="true")
  inspect(parse_formula("NH3").molar_mass() > 17.02, content="true")
  inspect(parse_formula("NH3").molar_mass() < 17.04, content="true")
  inspect(parse_formula("NaCl").molar_mass() > 58.43, content="true")
  inspect(parse_formula("NaCl").molar_mass() < 58.45, content="true")
}

///|
test "formula molar mass handles repeated elements" {
  let acetic = parse_formula("CH3COOH")
  inspect(acetic.count("C"), content="2")
  inspect(acetic.count("H"), content="4")
  inspect(acetic.count("O"), content="2")
  inspect(acetic.molar_mass() > 60.04, content="true")
  inspect(acetic.molar_mass() < 60.06, content="true")
}

///|
test "formula mass contribution and fraction are explicit" {
  let methane = parse_formula("CH4")
  inspect(methane.element_mass("C") > 12.00, content="true")
  inspect(methane.element_mass("H") > 4.03, content="true")
  inspect(methane.mass_fraction("C") > 0.748, content="true")
  inspect(methane.mass_fraction("C") < 0.750, content="true")
  inspect(methane.mass_fraction("O"), content="0")
}

///|
test "formula element mass table keeps count weight and fraction" {
  let water = parse_formula("H2O")
  let masses = water.element_masses()
  inspect(masses.length(), content="2")
  inspect(masses[0].symbol, content="H")
  inspect(masses[0].count, content="2")
  inspect(masses[0].total_mass > 2.015, content="true")
  inspect(masses[0].mass_fraction > 0.111, content="true")
  inspect(masses[1].symbol, content="O")
  inspect(masses[1].count, content="1")
  inspect(masses[1].total_mass > 15.99, content="true")
  inspect(masses[1].mass_fraction > 0.888, content="true")
}

///|
test "formula display string preserves normalized parsed order" {
  inspect(parse_formula("CH4").to_formula_string(), content="CH4")
  inspect(parse_formula("CH3COOH").to_formula_string(), content="C2H4O2")
  inspect(parse_formula("NaCl").to_formula_string(), content="NaCl")
}

///|
test "formula analysis fails when an element has no weight" {
  let formula = Formula::{ elements: [{ symbol: "Q", count: 1 }] }
  try formula.molar_mass() catch {
    ThermoError::UnknownElement(symbol="Q") =>
      inspect("unknown", content="unknown")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected unknown element")
  }
}
