///|
fn absolute(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
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
