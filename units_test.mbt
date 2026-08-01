///|
test "molar energy unit conversions are reversible" {
  inspect(j_per_mol_to_kj_per_mol(12500.0), content="12.5")
  inspect(kj_per_mol_to_j_per_mol(12.5), content="12500")
  inspect(
    j_per_mol_k_to_kj_per_mol_k(83.1446261815324),
    content="0.0831446261815324",
  )
  inspect(
    kj_per_mol_k_to_j_per_mol_k(0.0831446261815324),
    content="83.1446261815324",
  )
}

///|
test "temperature display conversions preserve offsets" {
  inspect(kelvin_to_celsius(298.15), content="25")
  inspect(celsius_to_kelvin(25.0), content="298.15")
  inspect(kelvin_to_celsius(273.15), content="0")
  inspect(celsius_to_kelvin(-273.15), content="0")
}

///|
test "generic molar energy conversion uses explicit units" {
  inspect(
    convert_molar_energy(
      12500.0,
      from=EnergyUnit::JoulePerMol,
      to=EnergyUnit::KilojoulePerMol,
    ),
    content="12.5",
  )
  inspect(
    convert_molar_energy(
      12.5,
      from=EnergyUnit::KilojoulePerMol,
      to=EnergyUnit::JoulePerMol,
    ),
    content="12500",
  )
}

///|
test "generic heat capacity conversion uses explicit units" {
  inspect(
    convert_molar_heat_capacity(
      83.1446261815324,
      from=HeatCapacityUnit::JoulePerMolKelvin,
      to=HeatCapacityUnit::KilojoulePerMolKelvin,
    ),
    content="0.0831446261815324",
  )
  inspect(
    convert_molar_heat_capacity(
      0.0831446261815324,
      from=HeatCapacityUnit::KilojoulePerMolKelvin,
      to=HeatCapacityUnit::JoulePerMolKelvin,
    ),
    content="83.1446261815324",
  )
}

///|
test "temperature conversion enum reports unsupported rankine-free paths" {
  inspect(
    convert_temperature(
      25.0,
      from=TemperatureUnit::Celsius,
      to=TemperatureUnit::Kelvin,
    ),
    content="298.15",
  )
  inspect(
    convert_temperature(
      298.15,
      from=TemperatureUnit::Kelvin,
      to=TemperatureUnit::Celsius,
    ),
    content="25",
  )
}
