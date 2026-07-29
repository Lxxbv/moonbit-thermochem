///|
test "builtin species table returns methane and nitrogen" {
  let methane = get_species("CH4")
  let nitrogen = get_species("N2")
  inspect(methane.name, content="CH4")
  inspect(nitrogen.name, content="N2")
}

///|
test "builtin methane combustion reaction shape" {
  let reaction = methane_combustion()
  inspect(reaction.reactants.length(), content="2")
  inspect(reaction.products.length(), content="2")
}

///|
test "builtin species reports missing names" {
  try get_species("Ar") catch {
    @moonbit-thermochem.ThermoError::MissingSpecies(name="Ar") =>
      inspect("missing", content="missing")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected missing species")
  }
}
