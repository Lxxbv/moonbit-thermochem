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

///|
test "reaction enthalpy weights coefficients on both sides" {
  let reactant = fake_species("A", 10.0)
  let product = fake_species("B", 25.0)
  let reaction = Reaction::new(
    label="2A -> 3B",
    reactants=[StoichTerm::new(species=reactant, coefficient=2.0)],
    products=[StoichTerm::new(species=product, coefficient=3.0)],
  )
  inspect(reaction.enthalpy(temperature=298.15), content="55")
}

///|
test "reaction propagates missing nasa7 segment" {
  let species = Species::new(
    name="out-of-range",
    formula=parse_formula("H"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::Nasa7([
      Nasa7Segment::new(
        range=TemperatureRange::new(lower=200.0, upper=6000.0),
        a1=3.5,
        a2=0.0,
        a3=0.0,
        a4=0.0,
        a5=0.0,
        a6=0.0,
        a7=1.0,
      ),
    ]),
  )
  let reaction = Reaction::new(
    label="A ->",
    reactants=[StoichTerm::new(species~, coefficient=1.0)],
    products=[],
  )
  try reaction.enthalpy(temperature=100.0) catch {
    ThermoError::NoThermoSegment(species="out-of-range", temperature=100.0) =>
      inspect("missing", content="missing")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected missing segment")
  }
}
