///|
fn check_species_at(name : String, temperature : Double) -> Unit raise {
  let species = get_species(name)
  let cp = species.cp_molar(temperature~)
  let entropy = species.entropy_molar(temperature~)
  inspect(cp > 0.0, content="true")
  inspect(cp < 1000.0, content="true")
  inspect(entropy > 0.0, content="true")
}

///|
test "reference cp grid for methane and oxygen" {
  check_species_at("CH4", 300.0)
  check_species_at("CH4", 500.0)
  check_species_at("CH4", 800.0)
  check_species_at("CH4", 1000.0)
  check_species_at("CH4", 1200.0)
  check_species_at("CH4", 2000.0)
  check_species_at("CH4", 3000.0)
  check_species_at("O2", 300.0)
  check_species_at("O2", 500.0)
  check_species_at("O2", 800.0)
  check_species_at("O2", 1000.0)
  check_species_at("O2", 1200.0)
  check_species_at("O2", 2000.0)
  check_species_at("O2", 3000.0)
}

///|
test "reference cp grid for nitrogen and carbon dioxide" {
  check_species_at("N2", 300.0)
  check_species_at("N2", 500.0)
  check_species_at("N2", 800.0)
  check_species_at("N2", 1000.0)
  check_species_at("N2", 1200.0)
  check_species_at("N2", 2000.0)
  check_species_at("N2", 3000.0)
  check_species_at("CO2", 300.0)
  check_species_at("CO2", 500.0)
  check_species_at("CO2", 800.0)
  check_species_at("CO2", 1000.0)
  check_species_at("CO2", 1200.0)
  check_species_at("CO2", 2000.0)
  check_species_at("CO2", 3000.0)
}

///|
test "reference cp grid for water and carbon monoxide" {
  check_species_at("H2O", 300.0)
  check_species_at("H2O", 500.0)
  check_species_at("H2O", 800.0)
  check_species_at("H2O", 1000.0)
  check_species_at("H2O", 1200.0)
  check_species_at("H2O", 2000.0)
  check_species_at("H2O", 3000.0)
  check_species_at("CO", 300.0)
  check_species_at("CO", 500.0)
  check_species_at("CO", 800.0)
  check_species_at("CO", 1000.0)
  check_species_at("CO", 1200.0)
  check_species_at("CO", 2000.0)
  check_species_at("CO", 3000.0)
}

///|
test "reference cp grid for hydrogen and ammonia" {
  check_species_at("H2", 300.0)
  check_species_at("H2", 500.0)
  check_species_at("H2", 800.0)
  check_species_at("H2", 1000.0)
  check_species_at("H2", 1200.0)
  check_species_at("H2", 2000.0)
  check_species_at("H2", 3000.0)
  check_species_at("NH3", 300.0)
  check_species_at("NH3", 500.0)
  check_species_at("NH3", 800.0)
  check_species_at("NH3", 1000.0)
  check_species_at("NH3", 1200.0)
  check_species_at("NH3", 2000.0)
  check_species_at("NH3", 3000.0)
}
