///|
pub(all) struct ElementBalance {
  symbol : String
  reactant_atoms : Double
  product_atoms : Double
  difference : Double
} derive(Debug, Eq)

///|
fn abs_double(value : Double) -> Double {
  if value < 0.0 {
    -value
  } else {
    value
  }
}

///|
fn include_symbol(symbols : Array[String], symbol : String) -> Unit {
  for existing in symbols {
    if existing == symbol {
      return
    }
  }
  symbols.push(symbol)
}

///|
fn include_formula_symbols(symbols : Array[String], formula : Formula) -> Unit {
  for element in formula.elements {
    include_symbol(symbols, element.symbol)
  }
}

///|
fn parsed_symbols(reaction : ParsedReaction) -> Array[String] {
  let symbols : Array[String] = []
  for term in reaction.reactants {
    include_formula_symbols(symbols, term.formula)
  }
  for term in reaction.products {
    include_formula_symbols(symbols, term.formula)
  }
  symbols
}

///|
fn reaction_symbols(reaction : Reaction) -> Array[String] {
  let symbols : Array[String] = []
  for term in reaction.reactants {
    include_formula_symbols(symbols, term.species.formula)
  }
  for term in reaction.products {
    include_formula_symbols(symbols, term.species.formula)
  }
  symbols
}

///|
fn parsed_side_atoms(
  terms : Array[ParsedStoichTerm],
  symbol : String,
) -> Double {
  let mut total = 0.0
  for term in terms {
    total = total + term.coefficient * term.formula.count(symbol).to_double()
  }
  total
}

///|
fn reaction_side_atoms(terms : Array[StoichTerm], symbol : String) -> Double {
  let mut total = 0.0
  for term in terms {
    total = total +
      term.coefficient * term.species.formula.count(symbol).to_double()
  }
  total
}

///|
pub fn ElementBalance::is_balanced(
  self : ElementBalance,
  tolerance? : Double = 1.0e-9,
) -> Bool {
  abs_double(self.difference) <= tolerance
}

///|
pub fn ParsedReaction::element_balance(
  self : ParsedReaction,
) -> Array[ElementBalance] {
  let balances : Array[ElementBalance] = []
  for symbol in parsed_symbols(self) {
    let reactant_atoms = parsed_side_atoms(self.reactants, symbol)
    let product_atoms = parsed_side_atoms(self.products, symbol)
    balances.push({
      symbol,
      reactant_atoms,
      product_atoms,
      difference: product_atoms - reactant_atoms,
    })
  }
  balances
}

///|
pub fn ParsedReaction::is_elementally_balanced(
  self : ParsedReaction,
  tolerance? : Double = 1.0e-9,
) -> Bool {
  for balance in self.element_balance() {
    if !balance.is_balanced(tolerance~) {
      return false
    }
  }
  true
}

///|
pub fn Reaction::element_balance(self : Reaction) -> Array[ElementBalance] {
  let balances : Array[ElementBalance] = []
  for symbol in reaction_symbols(self) {
    let reactant_atoms = reaction_side_atoms(self.reactants, symbol)
    let product_atoms = reaction_side_atoms(self.products, symbol)
    balances.push({
      symbol,
      reactant_atoms,
      product_atoms,
      difference: product_atoms - reactant_atoms,
    })
  }
  balances
}

///|
pub fn Reaction::is_elementally_balanced(
  self : Reaction,
  tolerance? : Double = 1.0e-9,
) -> Bool {
  for balance in self.element_balance() {
    if !balance.is_balanced(tolerance~) {
      return false
    }
  }
  true
}
