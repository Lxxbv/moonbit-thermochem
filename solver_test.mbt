///|
test "bisection solves monotonic root" {
  let root = solve_bisection(
    lower=0.0,
    upper=10.0,
    tolerance=0.000001,
    max_iterations=80,
    x => x - 2.0,
  )
  inspect(root > 1.999 && root < 2.001, content="true")
}

///|
test "bisection reports missing bracket" {
  try
    solve_bisection(
      lower=0.0,
      upper=10.0,
      tolerance=0.000001,
      max_iterations=80,
      x => x + 1.0,
    )
  catch {
    ThermoError::SolverFailed(message~) =>
      inspect(message, content="root is not bracketed")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected solver error")
  }
}

///|
fn test_species(
  name : String,
  model : ThermoModel,
) -> Species raise ThermoError {
  Species::new(
    name~,
    formula=parse_formula("H"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model~,
  )
}

///|
fn linear_enthalpy_species(name : String) -> Species raise ThermoError {
  test_species(
    name,
    Nasa7([
      Nasa7Segment::new(
        range=TemperatureRange::new(lower=1.0, upper=1000.0),
        a1=1.0,
        a2=0.0,
        a3=0.0,
        a4=0.0,
        a5=0.0,
        a6=0.0,
        a7=0.0,
      ),
    ]),
  )
}

///|
test "adiabatic flame temperature balances product and reactant enthalpy" {
  let reactant = test_species(
    "reactant",
    ThermoModel::ConstantEnthalpy(831.446261815324),
  )
  let product = linear_enthalpy_species("product")
  let reaction = Reaction::new(
    label="reactant -> product",
    reactants=[StoichTerm::new(species=reactant, coefficient=1.0)],
    products=[StoichTerm::new(species=product, coefficient=1.0)],
  )
  let temperature = adiabatic_flame_temperature(
    reaction,
    initial_temperature=298.15,
    lower_bound=50.0,
    upper_bound=200.0,
  )
  inspect(temperature > 99.999 && temperature < 100.001, content="true")
}

///|
test "adiabatic flame temperature reports missing bracket" {
  let reactant = test_species("reactant", ThermoModel::ConstantEnthalpy(0.0))
  let product = linear_enthalpy_species("product")
  let reaction = Reaction::new(
    label="reactant -> product",
    reactants=[StoichTerm::new(species=reactant, coefficient=1.0)],
    products=[StoichTerm::new(species=product, coefficient=1.0)],
  )
  try
    adiabatic_flame_temperature(
      reaction,
      initial_temperature=298.15,
      lower_bound=50.0,
      upper_bound=200.0,
    )
  catch {
    ThermoError::SolverFailed(message~) =>
      inspect(message, content="root is not bracketed")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected solver error")
  }
}
