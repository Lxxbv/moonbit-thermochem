///|
fn fake_species(name : String, h : Double) -> Species raise ThermoError {
  Species::new(
    name~,
    formula=parse_formula("H"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::ConstantEnthalpy(h),
  )
}

///|
test "reaction enthalpy is products minus reactants" {
  let a = fake_species("A", 10.0)
  let b = fake_species("B", 25.0)
  let c = fake_species("C", 80.0)
  let reaction = Reaction::new(
    label="A + 2B -> C",
    reactants=[
      StoichTerm::new(species=a, coefficient=1.0),
      StoichTerm::new(species=b, coefficient=2.0),
    ],
    products=[StoichTerm::new(species=c, coefficient=1.0)],
  )
  inspect(reaction.enthalpy(temperature=298.15), content="20")
}
