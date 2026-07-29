///|
pub(all) struct StoichTerm {
  species : Species
  coefficient : Double
} derive(Debug, Eq)

///|
pub fn StoichTerm::new(species~ : Species, coefficient~ : Double) -> StoichTerm {
  { species, coefficient }
}

///|
pub(all) struct Reaction {
  label : String
  reactants : Array[StoichTerm]
  products : Array[StoichTerm]
} derive(Debug, Eq)

///|
pub fn Reaction::new(
  label~ : String,
  reactants~ : Array[StoichTerm],
  products~ : Array[StoichTerm],
) -> Reaction {
  { label, reactants, products }
}

///|
fn enthalpy_sum(
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
pub fn Reaction::enthalpy(
  self : Reaction,
  temperature~ : Double,
) -> Double raise ThermoError {
  enthalpy_sum(self.products, temperature) -
  enthalpy_sum(self.reactants, temperature)
}
