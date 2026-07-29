///|
fn species_constant_cp_segment() -> Nasa7Segment raise ThermoError {
  Nasa7Segment::new(
    range=TemperatureRange::new(lower=200.0, upper=6000.0),
    a1=3.5,
    a2=0.0,
    a3=0.0,
    a4=0.0,
    a5=0.0,
    a6=0.0,
    a7=1.0,
  )
}

///|
test "species delegates to nasa7 segment and converts by gas constant" {
  let species = Species::new(
    name="H",
    formula=parse_formula("H"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::Nasa7([species_constant_cp_segment()]),
  )
  let cp = species.cp_molar(temperature=300.0)
  inspect(cp > 29.10 && cp < 29.11, content="true")
}

///|
test "species calculates nasa7 molar enthalpy and entropy" {
  let species = Species::new(
    name="H",
    formula=parse_formula("H"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::Nasa7([species_constant_cp_segment()]),
  )
  let enthalpy = species.enthalpy_molar(temperature=300.0)
  let entropy = species.entropy_molar(temperature=300.0)
  inspect(enthalpy > 8729.0 && enthalpy < 8731.0, content="true")
  inspect(entropy > 174.2 && entropy < 174.3, content="true")
}

///|
test "species reports missing segment for outside temperature" {
  let species = Species::new(
    name="H",
    formula=parse_formula("H"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::Nasa7([species_constant_cp_segment()]),
  )
  try species.cp_molar(temperature=100.0) catch {
    ThermoError::NoThermoSegment(species="H", temperature=100.0) =>
      inspect("missing", content="missing")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected missing segment")
  }
}
