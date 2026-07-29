///|
fn absolute(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}

///|
fn stoichiometric_enthalpy(
  terms : Array[StoichTerm],
  temperature : Double,
) -> Double raise ThermoError {
  let mut total = 0.0
  for term in terms {
    total = total + term.coefficient * term.species.enthalpy_molar(temperature~)
  }
  total
}

///|
/// Solves a bracketed scalar root by bisection.
pub fn solve_bisection(
  lower~ : Double,
  upper~ : Double,
  tolerance~ : Double,
  max_iterations~ : Int,
  f : (Double) -> Double raise ThermoError,
) -> Double raise ThermoError {
  let mut lower = lower
  let mut upper = upper
  let mut lower_value = f(lower)
  let upper_value = f(upper)
  if lower_value * upper_value > 0.0 {
    raise ThermoError::SolverFailed(message="root is not bracketed")
  }
  if lower_value == 0.0 {
    return lower
  }
  if upper_value == 0.0 {
    return upper
  }
  let mut iteration = 0
  while iteration < max_iterations {
    let midpoint = (lower + upper) / 2.0
    let midpoint_value = f(midpoint)
    if absolute(midpoint_value) <= tolerance || upper - lower <= tolerance {
      return midpoint
    }
    if lower_value * midpoint_value <= 0.0 {
      upper = midpoint
    } else {
      lower = midpoint
      lower_value = midpoint_value
    }
    iteration = iteration + 1
  }
  raise ThermoError::SolverFailed(message="maximum iterations reached")
}

///|
/// Solves the simplified adiabatic heat balance for final product temperature.
pub fn adiabatic_flame_temperature(
  reaction : Reaction,
  initial_temperature~ : Double,
  lower_bound? : Double = 300.0,
  upper_bound? : Double = 4000.0,
) -> Double raise ThermoError {
  let reactants_enthalpy = stoichiometric_enthalpy(
    reaction.reactants,
    initial_temperature,
  )
  solve_bisection(
    lower=lower_bound,
    upper=upper_bound,
    tolerance=0.000001,
    max_iterations=100,
    temperature => {
      stoichiometric_enthalpy(reaction.products, temperature) -
      reactants_enthalpy
    },
  )
}
