///|
pub(all) struct ElementInfo {
  symbol : String
  name : String
  atomic_number : Int
  atomic_weight : Double
} derive(Debug, Eq)

///|
pub(all) struct ElementMass {
  symbol : String
  count : Int
  atomic_weight : Double
  total_mass : Double
  mass_fraction : Double
} derive(Debug, Eq)

///|
fn element_info_or_none(symbol : String) -> ElementInfo? {
  match symbol {
    "H" =>
      Some({ symbol, name: "hydrogen", atomic_number: 1, atomic_weight: 1.008 })
    "He" =>
      Some({ symbol, name: "helium", atomic_number: 2, atomic_weight: 4.002602 })
    "Li" =>
      Some({ symbol, name: "lithium", atomic_number: 3, atomic_weight: 6.94 })
    "Be" =>
      Some({
        symbol,
        name: "beryllium",
        atomic_number: 4,
        atomic_weight: 9.0121831,
      })
    "B" =>
      Some({ symbol, name: "boron", atomic_number: 5, atomic_weight: 10.81 })
    "C" =>
      Some({ symbol, name: "carbon", atomic_number: 6, atomic_weight: 12.011 })
    "N" =>
      Some({ symbol, name: "nitrogen", atomic_number: 7, atomic_weight: 14.007 })
    "O" =>
      Some({ symbol, name: "oxygen", atomic_number: 8, atomic_weight: 15.999 })
    "F" =>
      Some({
        symbol,
        name: "fluorine",
        atomic_number: 9,
        atomic_weight: 18.998403163,
      })
    "Ne" =>
      Some({ symbol, name: "neon", atomic_number: 10, atomic_weight: 20.1797 })
    "Na" =>
      Some({
        symbol,
        name: "sodium",
        atomic_number: 11,
        atomic_weight: 22.98976928,
      })
    "Mg" =>
      Some({
        symbol,
        name: "magnesium",
        atomic_number: 12,
        atomic_weight: 24.305,
      })
    "Al" =>
      Some({
        symbol,
        name: "aluminium",
        atomic_number: 13,
        atomic_weight: 26.9815385,
      })
    "Si" =>
      Some({ symbol, name: "silicon", atomic_number: 14, atomic_weight: 28.085 })
    "P" =>
      Some({
        symbol,
        name: "phosphorus",
        atomic_number: 15,
        atomic_weight: 30.973761998,
      })
    "S" =>
      Some({ symbol, name: "sulfur", atomic_number: 16, atomic_weight: 32.06 })
    "Cl" =>
      Some({ symbol, name: "chlorine", atomic_number: 17, atomic_weight: 35.45 })
    "Ar" =>
      Some({ symbol, name: "argon", atomic_number: 18, atomic_weight: 39.948 })
    "K" =>
      Some({
        symbol,
        name: "potassium",
        atomic_number: 19,
        atomic_weight: 39.0983,
      })
    "Ca" =>
      Some({ symbol, name: "calcium", atomic_number: 20, atomic_weight: 40.078 })
    "Sc" =>
      Some({
        symbol,
        name: "scandium",
        atomic_number: 21,
        atomic_weight: 44.955908,
      })
    "Ti" =>
      Some({
        symbol,
        name: "titanium",
        atomic_number: 22,
        atomic_weight: 47.867,
      })
    "V" =>
      Some({
        symbol,
        name: "vanadium",
        atomic_number: 23,
        atomic_weight: 50.9415,
      })
    "Cr" =>
      Some({
        symbol,
        name: "chromium",
        atomic_number: 24,
        atomic_weight: 51.9961,
      })
    "Mn" =>
      Some({
        symbol,
        name: "manganese",
        atomic_number: 25,
        atomic_weight: 54.938044,
      })
    "Fe" =>
      Some({ symbol, name: "iron", atomic_number: 26, atomic_weight: 55.845 })
    "Co" =>
      Some({
        symbol,
        name: "cobalt",
        atomic_number: 27,
        atomic_weight: 58.933194,
      })
    "Ni" =>
      Some({ symbol, name: "nickel", atomic_number: 28, atomic_weight: 58.6934 })
    "Cu" =>
      Some({ symbol, name: "copper", atomic_number: 29, atomic_weight: 63.546 })
    "Zn" =>
      Some({ symbol, name: "zinc", atomic_number: 30, atomic_weight: 65.38 })
    "Ga" =>
      Some({ symbol, name: "gallium", atomic_number: 31, atomic_weight: 69.723 })
    "Ge" =>
      Some({
        symbol,
        name: "germanium",
        atomic_number: 32,
        atomic_weight: 72.63,
      })
    "As" =>
      Some({
        symbol,
        name: "arsenic",
        atomic_number: 33,
        atomic_weight: 74.921595,
      })
    "Se" =>
      Some({
        symbol,
        name: "selenium",
        atomic_number: 34,
        atomic_weight: 78.971,
      })
    "Br" =>
      Some({ symbol, name: "bromine", atomic_number: 35, atomic_weight: 79.904 })
    "Kr" =>
      Some({ symbol, name: "krypton", atomic_number: 36, atomic_weight: 83.798 })
    "Rb" =>
      Some({
        symbol,
        name: "rubidium",
        atomic_number: 37,
        atomic_weight: 85.4678,
      })
    "Sr" =>
      Some({
        symbol,
        name: "strontium",
        atomic_number: 38,
        atomic_weight: 87.62,
      })
    "Y" =>
      Some({
        symbol,
        name: "yttrium",
        atomic_number: 39,
        atomic_weight: 88.90584,
      })
    "Zr" =>
      Some({
        symbol,
        name: "zirconium",
        atomic_number: 40,
        atomic_weight: 91.224,
      })
    "Nb" =>
      Some({
        symbol,
        name: "niobium",
        atomic_number: 41,
        atomic_weight: 92.90637,
      })
    "Mo" =>
      Some({
        symbol,
        name: "molybdenum",
        atomic_number: 42,
        atomic_weight: 95.95,
      })
    "Tc" =>
      Some({
        symbol,
        name: "technetium",
        atomic_number: 43,
        atomic_weight: 98.0,
      })
    "Ru" =>
      Some({
        symbol,
        name: "ruthenium",
        atomic_number: 44,
        atomic_weight: 101.07,
      })
    "Rh" =>
      Some({
        symbol,
        name: "rhodium",
        atomic_number: 45,
        atomic_weight: 102.9055,
      })
    "Pd" =>
      Some({
        symbol,
        name: "palladium",
        atomic_number: 46,
        atomic_weight: 106.42,
      })
    "Ag" =>
      Some({
        symbol,
        name: "silver",
        atomic_number: 47,
        atomic_weight: 107.8682,
      })
    "Cd" =>
      Some({
        symbol,
        name: "cadmium",
        atomic_number: 48,
        atomic_weight: 112.414,
      })
    "In" =>
      Some({ symbol, name: "indium", atomic_number: 49, atomic_weight: 114.818 })
    "Sn" =>
      Some({ symbol, name: "tin", atomic_number: 50, atomic_weight: 118.71 })
    "Sb" =>
      Some({
        symbol,
        name: "antimony",
        atomic_number: 51,
        atomic_weight: 121.76,
      })
    "Te" =>
      Some({
        symbol,
        name: "tellurium",
        atomic_number: 52,
        atomic_weight: 127.6,
      })
    "I" =>
      Some({
        symbol,
        name: "iodine",
        atomic_number: 53,
        atomic_weight: 126.90447,
      })
    "Xe" =>
      Some({ symbol, name: "xenon", atomic_number: 54, atomic_weight: 131.293 })
    "Cs" =>
      Some({
        symbol,
        name: "caesium",
        atomic_number: 55,
        atomic_weight: 132.90545196,
      })
    "Ba" =>
      Some({ symbol, name: "barium", atomic_number: 56, atomic_weight: 137.327 })
    "La" =>
      Some({
        symbol,
        name: "lanthanum",
        atomic_number: 57,
        atomic_weight: 138.90547,
      })
    "Ce" =>
      Some({ symbol, name: "cerium", atomic_number: 58, atomic_weight: 140.116 })
    "Pr" =>
      Some({
        symbol,
        name: "praseodymium",
        atomic_number: 59,
        atomic_weight: 140.90766,
      })
    "Nd" =>
      Some({
        symbol,
        name: "neodymium",
        atomic_number: 60,
        atomic_weight: 144.242,
      })
    "Pm" =>
      Some({
        symbol,
        name: "promethium",
        atomic_number: 61,
        atomic_weight: 145.0,
      })
    "Sm" =>
      Some({
        symbol,
        name: "samarium",
        atomic_number: 62,
        atomic_weight: 150.36,
      })
    "Eu" =>
      Some({
        symbol,
        name: "europium",
        atomic_number: 63,
        atomic_weight: 151.964,
      })
    "Gd" =>
      Some({
        symbol,
        name: "gadolinium",
        atomic_number: 64,
        atomic_weight: 157.25,
      })
    "Tb" =>
      Some({
        symbol,
        name: "terbium",
        atomic_number: 65,
        atomic_weight: 158.92535,
      })
    "Dy" =>
      Some({
        symbol,
        name: "dysprosium",
        atomic_number: 66,
        atomic_weight: 162.5,
      })
    "Ho" =>
      Some({
        symbol,
        name: "holmium",
        atomic_number: 67,
        atomic_weight: 164.93033,
      })
    "Er" =>
      Some({ symbol, name: "erbium", atomic_number: 68, atomic_weight: 167.259 })
    "Tm" =>
      Some({
        symbol,
        name: "thulium",
        atomic_number: 69,
        atomic_weight: 168.93422,
      })
    "Yb" =>
      Some({
        symbol,
        name: "ytterbium",
        atomic_number: 70,
        atomic_weight: 173.045,
      })
    "Lu" =>
      Some({
        symbol,
        name: "lutetium",
        atomic_number: 71,
        atomic_weight: 174.9668,
      })
    "Hf" =>
      Some({ symbol, name: "hafnium", atomic_number: 72, atomic_weight: 178.49 })
    "Ta" =>
      Some({
        symbol,
        name: "tantalum",
        atomic_number: 73,
        atomic_weight: 180.94788,
      })
    "W" =>
      Some({
        symbol,
        name: "tungsten",
        atomic_number: 74,
        atomic_weight: 183.84,
      })
    "Re" =>
      Some({
        symbol,
        name: "rhenium",
        atomic_number: 75,
        atomic_weight: 186.207,
      })
    "Os" =>
      Some({ symbol, name: "osmium", atomic_number: 76, atomic_weight: 190.23 })
    "Ir" =>
      Some({
        symbol,
        name: "iridium",
        atomic_number: 77,
        atomic_weight: 192.217,
      })
    "Pt" =>
      Some({
        symbol,
        name: "platinum",
        atomic_number: 78,
        atomic_weight: 195.084,
      })
    "Au" =>
      Some({
        symbol,
        name: "gold",
        atomic_number: 79,
        atomic_weight: 196.966569,
      })
    "Hg" =>
      Some({
        symbol,
        name: "mercury",
        atomic_number: 80,
        atomic_weight: 200.592,
      })
    "Tl" =>
      Some({
        symbol,
        name: "thallium",
        atomic_number: 81,
        atomic_weight: 204.38,
      })
    "Pb" =>
      Some({ symbol, name: "lead", atomic_number: 82, atomic_weight: 207.2 })
    "Bi" =>
      Some({
        symbol,
        name: "bismuth",
        atomic_number: 83,
        atomic_weight: 208.9804,
      })
    "Po" =>
      Some({ symbol, name: "polonium", atomic_number: 84, atomic_weight: 209.0 })
    "At" =>
      Some({ symbol, name: "astatine", atomic_number: 85, atomic_weight: 210.0 })
    "Rn" =>
      Some({ symbol, name: "radon", atomic_number: 86, atomic_weight: 222.0 })
    "Fr" =>
      Some({ symbol, name: "francium", atomic_number: 87, atomic_weight: 223.0 })
    "Ra" =>
      Some({ symbol, name: "radium", atomic_number: 88, atomic_weight: 226.0 })
    "Ac" =>
      Some({ symbol, name: "actinium", atomic_number: 89, atomic_weight: 227.0 })
    "Th" =>
      Some({
        symbol,
        name: "thorium",
        atomic_number: 90,
        atomic_weight: 232.0377,
      })
    "Pa" =>
      Some({
        symbol,
        name: "protactinium",
        atomic_number: 91,
        atomic_weight: 231.03588,
      })
    "U" =>
      Some({
        symbol,
        name: "uranium",
        atomic_number: 92,
        atomic_weight: 238.02891,
      })
    "Np" =>
      Some({
        symbol,
        name: "neptunium",
        atomic_number: 93,
        atomic_weight: 237.0,
      })
    "Pu" =>
      Some({
        symbol,
        name: "plutonium",
        atomic_number: 94,
        atomic_weight: 244.0,
      })
    "Am" =>
      Some({
        symbol,
        name: "americium",
        atomic_number: 95,
        atomic_weight: 243.0,
      })
    "Cm" =>
      Some({ symbol, name: "curium", atomic_number: 96, atomic_weight: 247.0 })
    "Bk" =>
      Some({
        symbol,
        name: "berkelium",
        atomic_number: 97,
        atomic_weight: 247.0,
      })
    "Cf" =>
      Some({
        symbol,
        name: "californium",
        atomic_number: 98,
        atomic_weight: 251.0,
      })
    "Es" =>
      Some({
        symbol,
        name: "einsteinium",
        atomic_number: 99,
        atomic_weight: 252.0,
      })
    "Fm" =>
      Some({ symbol, name: "fermium", atomic_number: 100, atomic_weight: 257.0 })
    "Md" =>
      Some({
        symbol,
        name: "mendelevium",
        atomic_number: 101,
        atomic_weight: 258.0,
      })
    "No" =>
      Some({
        symbol,
        name: "nobelium",
        atomic_number: 102,
        atomic_weight: 259.0,
      })
    "Lr" =>
      Some({
        symbol,
        name: "lawrencium",
        atomic_number: 103,
        atomic_weight: 266.0,
      })
    "Rf" =>
      Some({
        symbol,
        name: "rutherfordium",
        atomic_number: 104,
        atomic_weight: 267.0,
      })
    "Db" =>
      Some({ symbol, name: "dubnium", atomic_number: 105, atomic_weight: 268.0 })
    "Sg" =>
      Some({
        symbol,
        name: "seaborgium",
        atomic_number: 106,
        atomic_weight: 269.0,
      })
    "Bh" =>
      Some({ symbol, name: "bohrium", atomic_number: 107, atomic_weight: 270.0 })
    "Hs" =>
      Some({ symbol, name: "hassium", atomic_number: 108, atomic_weight: 277.0 })
    "Mt" =>
      Some({
        symbol,
        name: "meitnerium",
        atomic_number: 109,
        atomic_weight: 278.0,
      })
    "Ds" =>
      Some({
        symbol,
        name: "darmstadtium",
        atomic_number: 110,
        atomic_weight: 281.0,
      })
    "Rg" =>
      Some({
        symbol,
        name: "roentgenium",
        atomic_number: 111,
        atomic_weight: 282.0,
      })
    "Cn" =>
      Some({
        symbol,
        name: "copernicium",
        atomic_number: 112,
        atomic_weight: 285.0,
      })
    "Nh" =>
      Some({
        symbol,
        name: "nihonium",
        atomic_number: 113,
        atomic_weight: 286.0,
      })
    "Fl" =>
      Some({
        symbol,
        name: "flerovium",
        atomic_number: 114,
        atomic_weight: 289.0,
      })
    "Mc" =>
      Some({
        symbol,
        name: "moscovium",
        atomic_number: 115,
        atomic_weight: 290.0,
      })
    "Lv" =>
      Some({
        symbol,
        name: "livermorium",
        atomic_number: 116,
        atomic_weight: 293.0,
      })
    "Ts" =>
      Some({
        symbol,
        name: "tennessine",
        atomic_number: 117,
        atomic_weight: 294.0,
      })
    "Og" =>
      Some({
        symbol,
        name: "oganesson",
        atomic_number: 118,
        atomic_weight: 294.0,
      })
    _ => None
  }
}

///|
pub fn element_info(symbol : String) -> ElementInfo raise ThermoError {
  match element_info_or_none(symbol) {
    Some(info) => info
    None => raise ThermoError::UnknownElement(symbol~)
  }
}

///|
pub fn atomic_weight(symbol : String) -> Double raise ThermoError {
  element_info(symbol).atomic_weight
}

///|
pub fn atomic_number(symbol : String) -> Int raise ThermoError {
  element_info(symbol).atomic_number
}

///|
pub fn element_name(symbol : String) -> String raise ThermoError {
  element_info(symbol).name
}

///|
pub fn is_known_element(symbol : String) -> Bool {
  match element_info_or_none(symbol) {
    Some(_) => true
    None => false
  }
}

///|
pub fn Formula::molar_mass(self : Formula) -> Double raise ThermoError {
  let mut total = 0.0
  for element in self.elements {
    total = total + atomic_weight(element.symbol) * element.count.to_double()
  }
  total
}

///|
pub fn Formula::element_mass(
  self : Formula,
  symbol : String,
) -> Double raise ThermoError {
  let count = self.count(symbol)
  if count == 0 {
    return 0.0
  }
  atomic_weight(symbol) * count.to_double()
}

///|
pub fn Formula::mass_fraction(
  self : Formula,
  symbol : String,
) -> Double raise ThermoError {
  let mass = self.element_mass(symbol)
  if mass == 0.0 {
    return 0.0
  }
  mass / self.molar_mass()
}

///|
pub fn Formula::element_masses(
  self : Formula,
) -> Array[ElementMass] raise ThermoError {
  let total = self.molar_mass()
  let masses : Array[ElementMass] = []
  for element in self.elements {
    let weight = atomic_weight(element.symbol)
    let mass = weight * element.count.to_double()
    masses.push({
      symbol: element.symbol,
      count: element.count,
      atomic_weight: weight,
      total_mass: mass,
      mass_fraction: mass / total,
    })
  }
  masses
}

///|
pub fn Formula::to_formula_string(self : Formula) -> String {
  let mut text = ""
  for element in self.elements {
    text = text + element.symbol
    if element.count != 1 {
      text = text + element.count.to_string()
    }
  }
  text
}
