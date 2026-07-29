///|
pub(all) struct SpeciesAmount {
  species : Species
  amount : Double
} derive(Debug, Eq)

///|
pub fn SpeciesAmount::new(
  species~ : Species,
  amount~ : Double,
) -> SpeciesAmount {
  { species, amount }
}

///|
pub(all) struct Mixture {
  amounts : Array[SpeciesAmount]
} derive(Debug, Eq)

///|
pub fn Mixture::new(amounts~ : Array[SpeciesAmount]) -> Mixture {
  { amounts, }
}
