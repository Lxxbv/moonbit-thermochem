///|
pub(all) enum EnergyUnit {
  JoulePerMol
  KilojoulePerMol
} derive(Debug, Eq)

///|
pub(all) enum HeatCapacityUnit {
  JoulePerMolKelvin
  KilojoulePerMolKelvin
} derive(Debug, Eq)

///|
pub(all) enum TemperatureUnit {
  Kelvin
  Celsius
} derive(Debug, Eq)

///|
pub fn j_per_mol_to_kj_per_mol(value : Double) -> Double {
  value / 1000.0
}

///|
pub fn kj_per_mol_to_j_per_mol(value : Double) -> Double {
  value * 1000.0
}

///|
pub fn j_per_mol_k_to_kj_per_mol_k(value : Double) -> Double {
  value / 1000.0
}

///|
pub fn kj_per_mol_k_to_j_per_mol_k(value : Double) -> Double {
  value * 1000.0
}

///|
pub fn kelvin_to_celsius(value : Double) -> Double {
  value - 273.15
}

///|
pub fn celsius_to_kelvin(value : Double) -> Double {
  value + 273.15
}

///|
pub fn convert_molar_energy(
  value : Double,
  from~ : EnergyUnit,
  to~ : EnergyUnit,
) -> Double {
  match (from, to) {
    (JoulePerMol, JoulePerMol) => value
    (KilojoulePerMol, KilojoulePerMol) => value
    (JoulePerMol, KilojoulePerMol) => j_per_mol_to_kj_per_mol(value)
    (KilojoulePerMol, JoulePerMol) => kj_per_mol_to_j_per_mol(value)
  }
}

///|
pub fn convert_molar_heat_capacity(
  value : Double,
  from~ : HeatCapacityUnit,
  to~ : HeatCapacityUnit,
) -> Double {
  match (from, to) {
    (JoulePerMolKelvin, JoulePerMolKelvin) => value
    (KilojoulePerMolKelvin, KilojoulePerMolKelvin) => value
    (JoulePerMolKelvin, KilojoulePerMolKelvin) =>
      j_per_mol_k_to_kj_per_mol_k(value)
    (KilojoulePerMolKelvin, JoulePerMolKelvin) =>
      kj_per_mol_k_to_j_per_mol_k(value)
  }
}

///|
pub fn convert_temperature(
  value : Double,
  from~ : TemperatureUnit,
  to~ : TemperatureUnit,
) -> Double {
  match (from, to) {
    (Kelvin, Kelvin) => value
    (Celsius, Celsius) => value
    (Kelvin, Celsius) => kelvin_to_celsius(value)
    (Celsius, Kelvin) => celsius_to_kelvin(value)
  }
}
