///|
test "builtin species table returns methane and nitrogen" {
  let methane = get_species("CH4")
  let nitrogen = get_species("N2")
  inspect(methane.name, content="CH4")
  inspect(nitrogen.name, content="N2")
}

///|
test "builtin species table returns every supported species" {
  inspect(get_species("CH4").name, content="CH4")
  inspect(get_species("O2").name, content="O2")
  inspect(get_species("N2").name, content="N2")
  inspect(get_species("CO2").name, content="CO2")
  inspect(get_species("H2O").name, content="H2O")
  inspect(get_species("CO").name, content="CO")
  inspect(get_species("H2").name, content="H2")
  inspect(get_species("NH3").name, content="NH3")
}

///|
test "builtin methane combustion reaction terms" {
  let reaction = methane_combustion()
  inspect(reaction.reactants[0].species.name, content="CH4")
  inspect(reaction.reactants[0].coefficient, content="1")
  inspect(reaction.reactants[1].species.name, content="O2")
  inspect(reaction.reactants[1].coefficient, content="2")
  inspect(reaction.products[0].species.name, content="CO2")
  inspect(reaction.products[0].coefficient, content="1")
  inspect(reaction.products[1].species.name, content="H2O")
  inspect(reaction.products[1].coefficient, content="2")
}

///|
test "builtin hydrogen combustion reaction terms" {
  let reaction = hydrogen_combustion()
  inspect(reaction.reactants[0].species.name, content="H2")
  inspect(reaction.reactants[0].coefficient, content="2")
  inspect(reaction.reactants[1].species.name, content="O2")
  inspect(reaction.reactants[1].coefficient, content="1")
  inspect(reaction.products[0].species.name, content="H2O")
  inspect(reaction.products[0].coefficient, content="2")
}

///|
test "builtin ammonia synthesis reaction terms" {
  let reaction = ammonia_synthesis()
  inspect(reaction.reactants[0].species.name, content="N2")
  inspect(reaction.reactants[0].coefficient, content="1")
  inspect(reaction.reactants[1].species.name, content="H2")
  inspect(reaction.reactants[1].coefficient, content="3")
  inspect(reaction.products[0].species.name, content="NH3")
  inspect(reaction.products[0].coefficient, content="2")
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
