///|
let gas_constant_j_per_mol_k : Double = 8.31446261815324

///|
pub(all) enum Phase {
  Gas
  Liquid
  Solid
} derive(Debug, Eq)

///|
pub(all) enum ThermoModel {
  Nasa7(Array[Nasa7Segment])
} derive(Debug, Eq)

///|
pub(all) struct Species {
  name : String
  formula : Formula
  phase : Phase
  molar_mass : Double
  formation_enthalpy : Double
  model : ThermoModel
} derive(Debug, Eq)

///|
pub fn Species::new(
  name~ : String,
  formula~ : Formula,
  phase~ : Phase,
  molar_mass~ : Double,
  formation_enthalpy~ : Double,
  model~ : ThermoModel,
) -> Species {
  { name, formula, phase, molar_mass, formation_enthalpy, model }
}

///|
fn Species::nasa7_segment_for(
  self : Species,
  temperature : Double,
) -> Nasa7Segment raise ThermoError {
  match self.model {
    Nasa7(segments) => {
      for segment in segments {
        if segment.range.contains(temperature) {
          return segment
        }
      }
      raise ThermoError::NoThermoSegment(species=self.name, temperature~)
    }
  }
}

///|
pub fn Species::cp_molar(
  self : Species,
  temperature~ : Double,
) -> Double raise ThermoError {
  self.nasa7_segment_for(temperature).cp_over_r(temperature) *
  gas_constant_j_per_mol_k
}

///|
pub fn Species::enthalpy_molar(
  self : Species,
  temperature~ : Double,
) -> Double raise ThermoError {
  self.nasa7_segment_for(temperature).h_over_rt(temperature) *
  gas_constant_j_per_mol_k *
  temperature
}

///|
pub fn Species::entropy_molar(
  self : Species,
  temperature~ : Double,
) -> Double raise ThermoError {
  self.nasa7_segment_for(temperature).s_over_r(temperature) *
  gas_constant_j_per_mol_k
}
