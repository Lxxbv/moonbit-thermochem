///|
fn check_catalog(
  symbol : String,
  period : Int,
  group : Int,
  block : String,
  phase : String,
  natural : Bool,
) -> Unit raise {
  inspect(element_period(symbol), content=period.to_string())
  inspect(element_group(symbol), content=group.to_string())
  inspect(element_block(symbol), content=block)
  inspect(element_standard_phase(symbol), content=phase)
  inspect(element_is_naturally_abundant(symbol), content=natural.to_string())
}

///|
test "catalog covers representative s and p block species" {
  check_catalog("H", 1, 1, "s", "gas", true)
  check_catalog("He", 1, 18, "s", "gas", true)
  check_catalog("Li", 2, 1, "s", "solid", true)
  check_catalog("Be", 2, 2, "s", "solid", true)
  check_catalog("B", 2, 13, "p", "solid", true)
  check_catalog("C", 2, 14, "p", "solid", true)
  check_catalog("N", 2, 15, "p", "gas", true)
  check_catalog("O", 2, 16, "p", "gas", true)
  check_catalog("F", 2, 17, "p", "gas", true)
  check_catalog("Ne", 2, 18, "p", "gas", true)
  check_catalog("Na", 3, 1, "s", "solid", true)
  check_catalog("Mg", 3, 2, "s", "solid", true)
  check_catalog("Al", 3, 13, "p", "solid", true)
  check_catalog("Si", 3, 14, "p", "solid", true)
  check_catalog("P", 3, 15, "p", "solid", true)
  check_catalog("S", 3, 16, "p", "solid", true)
  check_catalog("Cl", 3, 17, "p", "gas", true)
  check_catalog("Ar", 3, 18, "p", "gas", true)
}

///|
test "catalog covers representative transition elements" {
  check_catalog("Sc", 4, 3, "d", "solid", true)
  check_catalog("Ti", 4, 4, "d", "solid", true)
  check_catalog("V", 4, 5, "d", "solid", true)
  check_catalog("Cr", 4, 6, "d", "solid", true)
  check_catalog("Mn", 4, 7, "d", "solid", true)
  check_catalog("Fe", 4, 8, "d", "solid", true)
  check_catalog("Co", 4, 9, "d", "solid", true)
  check_catalog("Ni", 4, 10, "d", "solid", true)
  check_catalog("Cu", 4, 11, "d", "solid", true)
  check_catalog("Zn", 4, 12, "d", "solid", true)
  check_catalog("Y", 5, 3, "d", "solid", true)
  check_catalog("Zr", 5, 4, "d", "solid", true)
  check_catalog("Nb", 5, 5, "d", "solid", true)
  check_catalog("Mo", 5, 6, "d", "solid", true)
  check_catalog("Tc", 5, 7, "d", "solid", false)
  check_catalog("Ru", 5, 8, "d", "solid", true)
  check_catalog("Ag", 5, 11, "d", "solid", true)
  check_catalog("Cd", 5, 12, "d", "solid", true)
}

///|
test "catalog covers lanthanide and actinide rows" {
  check_catalog("La", 6, 3, "f", "solid", true)
  check_catalog("Ce", 6, 3, "f", "solid", true)
  check_catalog("Nd", 6, 3, "f", "solid", true)
  check_catalog("Pm", 6, 3, "f", "solid", false)
  check_catalog("Gd", 6, 3, "f", "solid", true)
  check_catalog("Lu", 6, 3, "f", "solid", true)
  check_catalog("Ac", 7, 3, "f", "solid", true)
  check_catalog("Th", 7, 3, "f", "solid", true)
  check_catalog("U", 7, 3, "f", "solid", true)
  check_catalog("Np", 7, 3, "f", "solid", false)
  check_catalog("Pu", 7, 3, "f", "solid", false)
  check_catalog("Am", 7, 3, "f", "solid", false)
  check_catalog("Cm", 7, 3, "f", "solid", false)
  check_catalog("Lr", 7, 3, "f", "solid", false)
}

///|
test "catalog covers heavy p block and synthetic entries" {
  check_catalog("Hg", 6, 12, "d", "liquid", true)
  check_catalog("Pb", 6, 14, "p", "solid", true)
  check_catalog("Bi", 6, 15, "p", "solid", true)
  check_catalog("Rn", 6, 18, "p", "gas", true)
  check_catalog("Rf", 7, 4, "d", "solid", false)
  check_catalog("Db", 7, 5, "d", "solid", false)
  check_catalog("Sg", 7, 6, "d", "solid", false)
  check_catalog("Bh", 7, 7, "d", "solid", false)
  check_catalog("Hs", 7, 8, "d", "solid", false)
  check_catalog("Mt", 7, 9, "d", "solid", false)
  check_catalog("Ds", 7, 10, "d", "solid", false)
  check_catalog("Rg", 7, 11, "d", "solid", false)
  check_catalog("Cn", 7, 12, "d", "solid", false)
  check_catalog("Nh", 7, 13, "p", "solid", false)
  check_catalog("Fl", 7, 14, "p", "solid", false)
  check_catalog("Mc", 7, 15, "p", "solid", false)
  check_catalog("Lv", 7, 16, "p", "solid", false)
  check_catalog("Ts", 7, 17, "p", "solid", false)
  check_catalog("Og", 7, 18, "p", "gas", false)
}

///|
test "catalog rejects unknown symbols consistently" {
  try element_period("Xx") catch {
    ThermoError::UnknownElement(symbol="Xx") =>
      inspect("unknown", content="unknown")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected unknown element")
  }
  try element_standard_phase("Q") catch {
    ThermoError::UnknownElement(symbol="Q") =>
      inspect("unknown", content="unknown")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected unknown element")
  }
}
