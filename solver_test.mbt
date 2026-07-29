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
