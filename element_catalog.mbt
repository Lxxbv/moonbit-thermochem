///|
pub fn element_period(symbol : String) -> Int raise ThermoError {
  match symbol {
    "H" => 1
    "He" => 1
    "Li" => 2
    "Be" => 2
    "B" => 2
    "C" => 2
    "N" => 2
    "O" => 2
    "F" => 2
    "Ne" => 2
    "Na" => 3
    "Mg" => 3
    "Al" => 3
    "Si" => 3
    "P" => 3
    "S" => 3
    "Cl" => 3
    "Ar" => 3
    "K" => 4
    "Ca" => 4
    "Sc" => 4
    "Ti" => 4
    "V" => 4
    "Cr" => 4
    "Mn" => 4
    "Fe" => 4
    "Co" => 4
    "Ni" => 4
    "Cu" => 4
    "Zn" => 4
    "Ga" => 4
    "Ge" => 4
    "As" => 4
    "Se" => 4
    "Br" => 4
    "Kr" => 4
    "Rb" => 5
    "Sr" => 5
    "Y" => 5
    "Zr" => 5
    "Nb" => 5
    "Mo" => 5
    "Tc" => 5
    "Ru" => 5
    "Rh" => 5
    "Pd" => 5
    "Ag" => 5
    "Cd" => 5
    "In" => 5
    "Sn" => 5
    "Sb" => 5
    "Te" => 5
    "I" => 5
    "Xe" => 5
    "Cs" => 6
    "Ba" => 6
    "La" => 6
    "Ce" => 6
    "Pr" => 6
    "Nd" => 6
    "Pm" => 6
    "Sm" => 6
    "Eu" => 6
    "Gd" => 6
    "Tb" => 6
    "Dy" => 6
    "Ho" => 6
    "Er" => 6
    "Tm" => 6
    "Yb" => 6
    "Lu" => 6
    "Hf" => 6
    "Ta" => 6
    "W" => 6
    "Re" => 6
    "Os" => 6
    "Ir" => 6
    "Pt" => 6
    "Au" => 6
    "Hg" => 6
    "Tl" => 6
    "Pb" => 6
    "Bi" => 6
    "Po" => 6
    "At" => 6
    "Rn" => 6
    "Fr" => 7
    "Ra" => 7
    "Ac" => 7
    "Th" => 7
    "Pa" => 7
    "U" => 7
    "Np" => 7
    "Pu" => 7
    "Am" => 7
    "Cm" => 7
    "Bk" => 7
    "Cf" => 7
    "Es" => 7
    "Fm" => 7
    "Md" => 7
    "No" => 7
    "Lr" => 7
    "Rf" => 7
    "Db" => 7
    "Sg" => 7
    "Bh" => 7
    "Hs" => 7
    "Mt" => 7
    "Ds" => 7
    "Rg" => 7
    "Cn" => 7
    "Nh" => 7
    "Fl" => 7
    "Mc" => 7
    "Lv" => 7
    "Ts" => 7
    "Og" => 7
    _ => raise ThermoError::UnknownElement(symbol~)
  }
}

///|
pub fn element_group(symbol : String) -> Int raise ThermoError {
  match symbol {
    "H" => 1
    "He" => 18
    "Li" => 1
    "Be" => 2
    "B" => 13
    "C" => 14
    "N" => 15
    "O" => 16
    "F" => 17
    "Ne" => 18
    "Na" => 1
    "Mg" => 2
    "Al" => 13
    "Si" => 14
    "P" => 15
    "S" => 16
    "Cl" => 17
    "Ar" => 18
    "K" => 1
    "Ca" => 2
    "Sc" => 3
    "Ti" => 4
    "V" => 5
    "Cr" => 6
    "Mn" => 7
    "Fe" => 8
    "Co" => 9
    "Ni" => 10
    "Cu" => 11
    "Zn" => 12
    "Ga" => 13
    "Ge" => 14
    "As" => 15
    "Se" => 16
    "Br" => 17
    "Kr" => 18
    "Rb" => 1
    "Sr" => 2
    "Y" => 3
    "Zr" => 4
    "Nb" => 5
    "Mo" => 6
    "Tc" => 7
    "Ru" => 8
    "Rh" => 9
    "Pd" => 10
    "Ag" => 11
    "Cd" => 12
    "In" => 13
    "Sn" => 14
    "Sb" => 15
    "Te" => 16
    "I" => 17
    "Xe" => 18
    "Cs" => 1
    "Ba" => 2
    "La" => 3
    "Ce" => 3
    "Pr" => 3
    "Nd" => 3
    "Pm" => 3
    "Sm" => 3
    "Eu" => 3
    "Gd" => 3
    "Tb" => 3
    "Dy" => 3
    "Ho" => 3
    "Er" => 3
    "Tm" => 3
    "Yb" => 3
    "Lu" => 3
    "Hf" => 4
    "Ta" => 5
    "W" => 6
    "Re" => 7
    "Os" => 8
    "Ir" => 9
    "Pt" => 10
    "Au" => 11
    "Hg" => 12
    "Tl" => 13
    "Pb" => 14
    "Bi" => 15
    "Po" => 16
    "At" => 17
    "Rn" => 18
    "Fr" => 1
    "Ra" => 2
    "Ac" => 3
    "Th" => 3
    "Pa" => 3
    "U" => 3
    "Np" => 3
    "Pu" => 3
    "Am" => 3
    "Cm" => 3
    "Bk" => 3
    "Cf" => 3
    "Es" => 3
    "Fm" => 3
    "Md" => 3
    "No" => 3
    "Lr" => 3
    "Rf" => 4
    "Db" => 5
    "Sg" => 6
    "Bh" => 7
    "Hs" => 8
    "Mt" => 9
    "Ds" => 10
    "Rg" => 11
    "Cn" => 12
    "Nh" => 13
    "Fl" => 14
    "Mc" => 15
    "Lv" => 16
    "Ts" => 17
    "Og" => 18
    _ => raise ThermoError::UnknownElement(symbol~)
  }
}

///|
pub fn element_block(symbol : String) -> String raise ThermoError {
  let group = element_group(symbol)
  match symbol {
    "La"
    | "Ce"
    | "Pr"
    | "Nd"
    | "Pm"
    | "Sm"
    | "Eu"
    | "Gd"
    | "Tb"
    | "Dy"
    | "Ho"
    | "Er"
    | "Tm"
    | "Yb"
    | "Lu"
    | "Ac"
    | "Th"
    | "Pa"
    | "U"
    | "Np"
    | "Pu"
    | "Am"
    | "Cm"
    | "Bk"
    | "Cf"
    | "Es"
    | "Fm"
    | "Md"
    | "No"
    | "Lr" => "f"
    _ =>
      if group == 1 || group == 2 || symbol == "He" {
        "s"
      } else if group >= 3 && group <= 12 {
        "d"
      } else {
        "p"
      }
  }
}

///|
pub fn element_standard_phase(symbol : String) -> String raise ThermoError {
  match symbol {
    "H" => "gas"
    "He" => "gas"
    "N" => "gas"
    "O" => "gas"
    "F" => "gas"
    "Ne" => "gas"
    "Cl" => "gas"
    "Ar" => "gas"
    "Kr" => "gas"
    "Xe" => "gas"
    "Rn" => "gas"
    "Og" => "gas"
    "Br" => "liquid"
    "Hg" => "liquid"
    _ => {
      let _ = element_info(symbol)
      "solid"
    }
  }
}

///|
pub fn element_is_naturally_abundant(symbol : String) -> Bool raise ThermoError {
  match symbol {
    "Tc" => false
    "Pm" => false
    "Np" => false
    "Pu" => false
    "Am" => false
    "Cm" => false
    "Bk" => false
    "Cf" => false
    "Es" => false
    "Fm" => false
    "Md" => false
    "No" => false
    "Lr" => false
    "Rf" => false
    "Db" => false
    "Sg" => false
    "Bh" => false
    "Hs" => false
    "Mt" => false
    "Ds" => false
    "Rg" => false
    "Cn" => false
    "Nh" => false
    "Fl" => false
    "Mc" => false
    "Lv" => false
    "Ts" => false
    "Og" => false
    _ => {
      let _ = element_info(symbol)
      true
    }
  }
}
