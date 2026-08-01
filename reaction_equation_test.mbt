///|
test "parse methane combustion reaction equation" {
  let parsed = parse_reaction_equation("CH4 + 2 O2 -> CO2 + 2 H2O")
  inspect(parsed.reactants.length(), content="2")
  inspect(parsed.products.length(), content="2")
  inspect(parsed.reactants[0].name, content="CH4")
  inspect(parsed.reactants[0].coefficient, content="1")
  inspect(parsed.reactants[1].name, content="O2")
  inspect(parsed.reactants[1].coefficient, content="2")
  inspect(parsed.products[0].name, content="CO2")
  inspect(parsed.products[0].coefficient, content="1")
  inspect(parsed.products[1].name, content="H2O")
  inspect(parsed.products[1].coefficient, content="2")
  inspect(parsed.label, content="CH4 + 2 O2 -> CO2 + 2 H2O")
}

///|
test "parse ammonia synthesis reaction equation" {
  let parsed = parse_reaction_equation("N2 + 3 H2 -> 2 NH3")
  inspect(parsed.reactants.length(), content="2")
  inspect(parsed.products.length(), content="1")
  inspect(parsed.reactants[0].name, content="N2")
  inspect(parsed.reactants[0].coefficient, content="1")
  inspect(parsed.reactants[1].name, content="H2")
  inspect(parsed.reactants[1].coefficient, content="3")
  inspect(parsed.products[0].name, content="NH3")
  inspect(parsed.products[0].coefficient, content="2")
}

///|
test "reaction parser handles decimal air dilution coefficients" {
  let parsed = parse_reaction_equation(
    "CH4 + 2 O2 + 7.52 N2 -> CO2 + 2 H2O + 7.52 N2",
  )
  inspect(parsed.reactants.length(), content="3")
  inspect(parsed.products.length(), content="3")
  inspect(parsed.reactants[2].name, content="N2")
  inspect(parsed.reactants[2].coefficient, content="7.52")
  inspect(parsed.products[2].name, content="N2")
  inspect(parsed.products[2].coefficient, content="7.52")
}

///|
test "reaction parser binds parsed equation with a lookup function" {
  let parsed = parse_reaction_equation("CH4 + 2 O2 -> CO2 + 2 H2O")
  let reaction = parsed.to_reaction(name => {
    Species::new(
      name~,
      formula=parse_formula(name),
      phase=Phase::Gas,
      molar_mass=0.0,
      formation_enthalpy=0.0,
      model=ThermoModel::ConstantEnthalpy(10.0),
    )
  })
  inspect(reaction.reactants.length(), content="2")
  inspect(reaction.products.length(), content="2")
  inspect(reaction.reactants[0].species.name, content="CH4")
  inspect(reaction.products[1].coefficient, content="2")
}

///|
test "reaction parser rejects missing arrow" {
  try parse_reaction_equation("CH4 + O2 CO2 + H2O") catch {
    ThermoError::ParseError(
      line=1,
      column=1,
      message="expected exactly one reaction arrow"
    ) => inspect("missing arrow", content="missing arrow")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}

///|
test "reaction parser rejects empty sides" {
  try parse_reaction_equation("CH4 -> ") catch {
    ThermoError::ParseError(line=1, column=8, message="expected species term") =>
      inspect("empty products", content="empty products")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}

///|
test "reaction parser rejects invalid coefficients" {
  try parse_reaction_equation("two CH4 + O2 -> CO2 + H2O") catch {
    ThermoError::ParseError(
      line=1,
      column=1,
      message="invalid stoichiometric coefficient"
    ) => inspect("bad coefficient", content="bad coefficient")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}

///|
test "reaction parser rejects nonpositive coefficients" {
  try parse_reaction_equation("0 CH4 + O2 -> CO2 + H2O") catch {
    ThermoError::ParseError(
      line=1,
      column=1,
      message="expected positive stoichiometric coefficient"
    ) => inspect("bad coefficient", content="bad coefficient")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}

///|
test "reaction parser reports formula error at term location" {
  try parse_reaction_equation("CH4 + 2 O2 -> co2 + 2 H2O") catch {
    ThermoError::ParseError(
      line=1,
      column=15,
      message="expected uppercase element symbol"
    ) => inspect("bad formula", content="bad formula")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}
