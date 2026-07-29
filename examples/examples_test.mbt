///|
test "methane combustion report mentions reaction enthalpy and flame temperature" {
  let report = methane_combustion_report(initial_temperature=298.15)
  inspect(report.contains("CH4"), content="true")
  inspect(report.contains("flame temperature"), content="true")
}

///|
test "ammonia synthesis report mentions NH3" {
  let report = ammonia_synthesis_report(temperature=700.0)
  inspect(report.contains("NH3"), content="true")
}
