///|
fn constant_species_for_balance(name : String) -> Species raise ThermoError {
  Species::new(
    name~,
    formula=parse_formula(name),
    phase=Phase::Gas,
    molar_mass=0.0,
    formation_enthalpy=0.0,
    model=ThermoModel::ConstantEnthalpy(0.0),
  )
}

///|
fn bind_balance_reaction(text : String) -> Reaction raise {
  parse_reaction_equation(text).to_reaction(name => {
    constant_species_for_balance(name)
  })
}

///|
test "parsed methane combustion is elementally balanced" {
  let parsed = parse_reaction_equation("CH4 + 2 O2 -> CO2 + 2 H2O")
  inspect(parsed.is_elementally_balanced(), content="true")
  let balance = parsed.element_balance()
  inspect(balance.length(), content="3")
  inspect(balance[0].symbol, content="C")
  inspect(balance[0].reactant_atoms, content="1")
  inspect(balance[0].product_atoms, content="1")
  inspect(balance[1].symbol, content="H")
  inspect(balance[1].reactant_atoms, content="4")
  inspect(balance[1].product_atoms, content="4")
  inspect(balance[2].symbol, content="O")
  inspect(balance[2].reactant_atoms, content="4")
  inspect(balance[2].product_atoms, content="4")
}

///|
test "parsed ammonia synthesis is elementally balanced" {
  let parsed = parse_reaction_equation("N2 + 3 H2 -> 2 NH3")
  inspect(parsed.is_elementally_balanced(), content="true")
  let balance = parsed.element_balance()
  inspect(balance.length(), content="2")
  inspect(balance[0].symbol, content="N")
  inspect(balance[0].reactant_atoms, content="2")
  inspect(balance[0].product_atoms, content="2")
  inspect(balance[1].symbol, content="H")
  inspect(balance[1].reactant_atoms, content="6")
  inspect(balance[1].product_atoms, content="6")
}

///|
test "parsed methane air equation keeps inert nitrogen balanced" {
  let parsed = parse_reaction_equation(
    "CH4 + 2 O2 + 7.52 N2 -> CO2 + 2 H2O + 7.52 N2",
  )
  inspect(parsed.is_elementally_balanced(), content="true")
  let balance = parsed.element_balance()
  inspect(balance.length(), content="4")
  inspect(balance[3].symbol, content="N")
  inspect(balance[3].reactant_atoms, content="15.04")
  inspect(balance[3].product_atoms, content="15.04")
}

///|
test "parsed unbalanced equation reports per element difference" {
  let parsed = parse_reaction_equation("CH4 + O2 -> CO2 + H2O")
  inspect(parsed.is_elementally_balanced(), content="false")
  let balance = parsed.element_balance()
  inspect(balance.length(), content="3")
  inspect(balance[0].symbol, content="C")
  inspect(balance[0].difference, content="0")
  inspect(balance[1].symbol, content="H")
  inspect(balance[1].difference, content="-2")
  inspect(balance[2].symbol, content="O")
  inspect(balance[2].difference, content="1")
}

///|
test "bound reaction balance uses species formulas" {
  let reaction = bind_balance_reaction("2 H2 + O2 -> 2 H2O")
  inspect(reaction.is_elementally_balanced(), content="true")
  let balance = reaction.element_balance()
  inspect(balance.length(), content="2")
  inspect(balance[0].symbol, content="H")
  inspect(balance[0].reactant_atoms, content="4")
  inspect(balance[0].product_atoms, content="4")
  inspect(balance[1].symbol, content="O")
  inspect(balance[1].reactant_atoms, content="2")
  inspect(balance[1].product_atoms, content="2")
}

///|
test "balance tolerance accepts small decimal drift" {
  let parsed = parse_reaction_equation(
    "0.3333333333 H2 + 0.1666666667 O2 -> 0.3333333333 H2O",
  )
  inspect(parsed.is_elementally_balanced(tolerance=1.0e-8), content="true")
  inspect(parsed.is_elementally_balanced(tolerance=1.0e-12), content="false")
}

///|
test "element balance helper exposes direct tolerance check" {
  let balance = ElementBalance::{
    symbol: "O",
    reactant_atoms: 2.0,
    product_atoms: 2.0000000001,
    difference: 0.0000000001,
  }
  inspect(balance.is_balanced(tolerance=1.0e-8), content="true")
  inspect(balance.is_balanced(tolerance=1.0e-12), content="false")
}
