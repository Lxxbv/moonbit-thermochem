///|
fn check_element(symbol : String, number : Int, name : String) -> Unit raise {
  let info = element_info(symbol)
  inspect(info.atomic_number, content=number.to_string())
  inspect(info.name, content=name)
  inspect(info.atomic_weight > 0.0, content="true")
  inspect(is_known_element(symbol), content="true")
}

///|
fn check_formula_mass(
  text : String,
  lower : Double,
  upper : Double,
) -> Unit raise {
  let formula = parse_formula(text)
  let mass = formula.molar_mass()
  inspect(mass > lower, content="true")
  inspect(mass < upper, content="true")
  inspect(formula.to_formula_string().length() > 0, content="true")
}

///|
fn check_reaction_shape(
  text : String,
  reactants : Int,
  products : Int,
) -> Unit raise {
  let parsed = parse_reaction_equation(text)
  inspect(parsed.reactants.length(), content=reactants.to_string())
  inspect(parsed.products.length(), content=products.to_string())
  inspect(parsed.label, content=text)
}

///|
test "periodic table reference entries 1 to 20" {
  check_element("H", 1, "hydrogen")
  check_element("He", 2, "helium")
  check_element("Li", 3, "lithium")
  check_element("Be", 4, "beryllium")
  check_element("B", 5, "boron")
  check_element("C", 6, "carbon")
  check_element("N", 7, "nitrogen")
  check_element("O", 8, "oxygen")
  check_element("F", 9, "fluorine")
  check_element("Ne", 10, "neon")
  check_element("Na", 11, "sodium")
  check_element("Mg", 12, "magnesium")
  check_element("Al", 13, "aluminium")
  check_element("Si", 14, "silicon")
  check_element("P", 15, "phosphorus")
  check_element("S", 16, "sulfur")
  check_element("Cl", 17, "chlorine")
  check_element("Ar", 18, "argon")
  check_element("K", 19, "potassium")
  check_element("Ca", 20, "calcium")
}

///|
test "periodic table reference entries 21 to 40" {
  check_element("Sc", 21, "scandium")
  check_element("Ti", 22, "titanium")
  check_element("V", 23, "vanadium")
  check_element("Cr", 24, "chromium")
  check_element("Mn", 25, "manganese")
  check_element("Fe", 26, "iron")
  check_element("Co", 27, "cobalt")
  check_element("Ni", 28, "nickel")
  check_element("Cu", 29, "copper")
  check_element("Zn", 30, "zinc")
  check_element("Ga", 31, "gallium")
  check_element("Ge", 32, "germanium")
  check_element("As", 33, "arsenic")
  check_element("Se", 34, "selenium")
  check_element("Br", 35, "bromine")
  check_element("Kr", 36, "krypton")
  check_element("Rb", 37, "rubidium")
  check_element("Sr", 38, "strontium")
  check_element("Y", 39, "yttrium")
  check_element("Zr", 40, "zirconium")
}

///|
test "periodic table reference entries 41 to 60" {
  check_element("Nb", 41, "niobium")
  check_element("Mo", 42, "molybdenum")
  check_element("Tc", 43, "technetium")
  check_element("Ru", 44, "ruthenium")
  check_element("Rh", 45, "rhodium")
  check_element("Pd", 46, "palladium")
  check_element("Ag", 47, "silver")
  check_element("Cd", 48, "cadmium")
  check_element("In", 49, "indium")
  check_element("Sn", 50, "tin")
  check_element("Sb", 51, "antimony")
  check_element("Te", 52, "tellurium")
  check_element("I", 53, "iodine")
  check_element("Xe", 54, "xenon")
  check_element("Cs", 55, "caesium")
  check_element("Ba", 56, "barium")
  check_element("La", 57, "lanthanum")
  check_element("Ce", 58, "cerium")
  check_element("Pr", 59, "praseodymium")
  check_element("Nd", 60, "neodymium")
}

///|
test "periodic table reference entries 61 to 80" {
  check_element("Pm", 61, "promethium")
  check_element("Sm", 62, "samarium")
  check_element("Eu", 63, "europium")
  check_element("Gd", 64, "gadolinium")
  check_element("Tb", 65, "terbium")
  check_element("Dy", 66, "dysprosium")
  check_element("Ho", 67, "holmium")
  check_element("Er", 68, "erbium")
  check_element("Tm", 69, "thulium")
  check_element("Yb", 70, "ytterbium")
  check_element("Lu", 71, "lutetium")
  check_element("Hf", 72, "hafnium")
  check_element("Ta", 73, "tantalum")
  check_element("W", 74, "tungsten")
  check_element("Re", 75, "rhenium")
  check_element("Os", 76, "osmium")
  check_element("Ir", 77, "iridium")
  check_element("Pt", 78, "platinum")
  check_element("Au", 79, "gold")
  check_element("Hg", 80, "mercury")
}

///|
test "periodic table reference entries 81 to 100" {
  check_element("Tl", 81, "thallium")
  check_element("Pb", 82, "lead")
  check_element("Bi", 83, "bismuth")
  check_element("Po", 84, "polonium")
  check_element("At", 85, "astatine")
  check_element("Rn", 86, "radon")
  check_element("Fr", 87, "francium")
  check_element("Ra", 88, "radium")
  check_element("Ac", 89, "actinium")
  check_element("Th", 90, "thorium")
  check_element("Pa", 91, "protactinium")
  check_element("U", 92, "uranium")
  check_element("Np", 93, "neptunium")
  check_element("Pu", 94, "plutonium")
  check_element("Am", 95, "americium")
  check_element("Cm", 96, "curium")
  check_element("Bk", 97, "berkelium")
  check_element("Cf", 98, "californium")
  check_element("Es", 99, "einsteinium")
  check_element("Fm", 100, "fermium")
}

///|
test "periodic table reference entries 101 to 118" {
  check_element("Md", 101, "mendelevium")
  check_element("No", 102, "nobelium")
  check_element("Lr", 103, "lawrencium")
  check_element("Rf", 104, "rutherfordium")
  check_element("Db", 105, "dubnium")
  check_element("Sg", 106, "seaborgium")
  check_element("Bh", 107, "bohrium")
  check_element("Hs", 108, "hassium")
  check_element("Mt", 109, "meitnerium")
  check_element("Ds", 110, "darmstadtium")
  check_element("Rg", 111, "roentgenium")
  check_element("Cn", 112, "copernicium")
  check_element("Nh", 113, "nihonium")
  check_element("Fl", 114, "flerovium")
  check_element("Mc", 115, "moscovium")
  check_element("Lv", 116, "livermorium")
  check_element("Ts", 117, "tennessine")
  check_element("Og", 118, "oganesson")
}

///|
test "formula mass reference cases for small molecules" {
  check_formula_mass("H2", 2.0, 2.1)
  check_formula_mass("O2", 31.9, 32.1)
  check_formula_mass("N2", 27.9, 28.2)
  check_formula_mass("CO", 27.9, 28.2)
  check_formula_mass("CO2", 43.9, 44.2)
  check_formula_mass("H2O", 18.0, 18.1)
  check_formula_mass("CH4", 16.0, 16.1)
  check_formula_mass("NH3", 17.0, 17.1)
  check_formula_mass("NO", 29.9, 30.1)
  check_formula_mass("NO2", 45.9, 46.1)
  check_formula_mass("N2O", 43.9, 44.1)
  check_formula_mass("H2O2", 33.9, 34.1)
}

///|
test "formula mass reference cases for hydrocarbons and oxygenates" {
  check_formula_mass("C2H2", 25.9, 26.1)
  check_formula_mass("C2H4", 28.0, 28.2)
  check_formula_mass("C2H6", 30.0, 30.2)
  check_formula_mass("C3H8", 44.0, 44.2)
  check_formula_mass("C4H10", 58.0, 58.2)
  check_formula_mass("C5H12", 72.0, 72.3)
  check_formula_mass("C6H14", 86.0, 86.3)
  check_formula_mass("C7H16", 100.0, 100.4)
  check_formula_mass("C8H18", 114.0, 114.4)
  check_formula_mass("C6H6", 78.0, 78.2)
  check_formula_mass("CH4O", 32.0, 32.1)
  check_formula_mass("C2H6O", 46.0, 46.2)
  check_formula_mass("C2H4O2", 60.0, 60.2)
  check_formula_mass("C3H6O", 58.0, 58.2)
  check_formula_mass("C3H8O", 60.0, 60.2)
}

///|
test "formula mass reference cases for inorganic compounds" {
  check_formula_mass("SO2", 64.0, 64.2)
  check_formula_mass("SO3", 79.9, 80.2)
  check_formula_mass("H2S", 34.0, 34.2)
  check_formula_mass("HNO3", 62.9, 63.1)
  check_formula_mass("H2SO4", 98.0, 98.2)
  check_formula_mass("HCl", 36.4, 36.6)
  check_formula_mass("NaCl", 58.4, 58.5)
  check_formula_mass("KCl", 74.5, 74.7)
  check_formula_mass("CaO", 56.0, 56.2)
  check_formula_mass("CaCO3", 100.0, 100.2)
  check_formula_mass("NaOH", 39.9, 40.1)
  check_formula_mass("KOH", 56.0, 56.2)
  check_formula_mass("MgO", 40.2, 40.4)
  check_formula_mass("Al2O3", 101.8, 102.1)
  check_formula_mass("SiO2", 60.0, 60.2)
}

///|
test "formula mass reference cases for salts and process chemicals" {
  check_formula_mass("FeO", 71.7, 72.0)
  check_formula_mass("Fe2O3", 159.5, 159.8)
  check_formula_mass("CuO", 79.4, 79.7)
  check_formula_mass("ZnO", 81.3, 81.5)
  check_formula_mass("AgCl", 143.2, 143.4)
  check_formula_mass("PbS", 239.1, 239.4)
  check_formula_mass("BaSO4", 233.2, 233.5)
  check_formula_mass("Na2CO3", 105.8, 106.1)
  check_formula_mass("NaHCO3", 83.9, 84.1)
  check_formula_mass("KNO3", 100.9, 101.2)
  check_formula_mass("NH4Cl", 53.4, 53.6)
  check_formula_mass("N2H8SO4", 132.1, 132.3)
}

///|
test "formula mass reference cases for larger organics" {
  check_formula_mass("C6H12O6", 180.0, 180.3)
  check_formula_mass("C12H22O11", 342.2, 342.4)
  check_formula_mass("C8H10N4O2", 194.1, 194.3)
  check_formula_mass("C9H8O4", 180.1, 180.3)
  check_formula_mass("C2H3Cl", 62.4, 62.6)
  check_formula_mass("C2H4Cl2", 98.9, 99.1)
  check_formula_mass("CHCl3", 119.2, 119.5)
  check_formula_mass("CCl4", 153.7, 154.0)
  check_formula_mass("CF4", 87.9, 88.1)
  check_formula_mass("SF6", 146.0, 146.2)
  check_formula_mass("PF5", 125.9, 126.1)
  check_formula_mass("PCl3", 137.2, 137.4)
  check_formula_mass("PCl5", 208.1, 208.4)
  check_formula_mass("H3PO4", 97.9, 98.1)
}

///|
test "reaction equation reference cases for combustion" {
  check_reaction_shape("CH4 + 2 O2 -> CO2 + 2 H2O", 2, 2)
  check_reaction_shape("C2H6 + 3.5 O2 -> 2 CO2 + 3 H2O", 2, 2)
  check_reaction_shape("C3H8 + 5 O2 -> 3 CO2 + 4 H2O", 2, 2)
  check_reaction_shape("C4H10 + 6.5 O2 -> 4 CO2 + 5 H2O", 2, 2)
  check_reaction_shape("C2H2 + 2.5 O2 -> 2 CO2 + H2O", 2, 2)
  check_reaction_shape("CO + 0.5 O2 -> CO2", 2, 1)
  check_reaction_shape("2 H2 + O2 -> 2 H2O", 2, 1)
  check_reaction_shape("S + O2 -> SO2", 2, 1)
  check_reaction_shape("2 SO2 + O2 -> 2 SO3", 2, 1)
  check_reaction_shape("NH3 + 0.75 O2 -> 0.5 N2 + 1.5 H2O", 2, 2)
}

///|
test "reaction equation reference cases for synthesis and process chemistry" {
  check_reaction_shape("N2 + 3 H2 -> 2 NH3", 2, 1)
  check_reaction_shape("H2 + Cl2 -> 2 HCl", 2, 1)
  check_reaction_shape("2 NO + O2 -> 2 NO2", 2, 1)
  check_reaction_shape("2 NO2 -> N2O4", 1, 1)
  check_reaction_shape("CaO + CO2 -> CaCO3", 2, 1)
  check_reaction_shape("NaOH + HCl -> NaCl + H2O", 2, 2)
  check_reaction_shape("2 Na + Cl2 -> 2 NaCl", 2, 1)
  check_reaction_shape("4 Fe + 3 O2 -> 2 Fe2O3", 2, 1)
  check_reaction_shape("2 Cu + O2 -> 2 CuO", 2, 1)
  check_reaction_shape("Zn + S -> ZnS", 2, 1)
}

///|
test "reaction equation reference cases for decomposition" {
  check_reaction_shape("2 H2O2 -> 2 H2O + O2", 1, 2)
  check_reaction_shape("CaCO3 -> CaO + CO2", 1, 2)
  check_reaction_shape("2 KClO3 -> 2 KCl + 3 O2", 1, 2)
  check_reaction_shape("2 NaHCO3 -> Na2CO3 + CO2 + H2O", 1, 3)
  check_reaction_shape("NH4Cl -> NH3 + HCl", 1, 2)
  check_reaction_shape("N2O4 -> 2 NO2", 1, 1)
  check_reaction_shape("2 HgO -> 2 Hg + O2", 1, 2)
  check_reaction_shape("2 Ag2O -> 4 Ag + O2", 1, 2)
}
