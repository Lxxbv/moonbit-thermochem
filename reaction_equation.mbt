///|
pub(all) struct ParsedStoichTerm {
  name : String
  formula : Formula
  coefficient : Double
} derive(Debug, Eq)

///|
pub(all) struct ParsedReaction {
  label : String
  reactants : Array[ParsedStoichTerm]
  products : Array[ParsedStoichTerm]
} derive(Debug, Eq)

///|
fn is_space(char : Char) -> Bool {
  char == ' ' || char == '\t' || char == '\r' || char == '\n'
}

///|
fn trim_string(text : String) -> String {
  let chars = text.to_array()
  let mut start = 0
  let mut finish = chars.length()
  while start < finish && is_space(chars[start]) {
    start += 1
  }
  while finish > start && is_space(chars[finish - 1]) {
    finish -= 1
  }
  let mut out = ""
  let mut index = start
  while index < finish {
    out = out + chars[index].to_string()
    index += 1
  }
  out
}

///|
fn slice_chars(text : String, start : Int, finish : Int) -> String {
  let chars = text.to_array()
  let mut out = ""
  let mut index = start
  while index < finish && index < chars.length() {
    out = out + chars[index].to_string()
    index += 1
  }
  out
}

///|
fn find_arrow(text : String) -> (Int?, Bool) {
  let chars = text.to_array()
  let mut found : Int? = None
  let mut multiple = false
  let mut index = 0
  while index + 1 < chars.length() {
    if chars[index] == '-' && chars[index + 1] == '>' {
      match found {
        Some(_) => multiple = true
        None => found = Some(index)
      }
    }
    index += 1
  }
  (found, multiple)
}

///|
fn first_non_space_column(text : String, base_column : Int) -> Int {
  let chars = text.to_array()
  let mut index = 0
  while index < chars.length() && is_space(chars[index]) {
    index += 1
  }
  base_column + index
}

///|
fn split_spaces(text : String) -> Array[String] {
  let chars = text.to_array()
  let parts : Array[String] = []
  let mut token = ""
  for char in chars {
    if is_space(char) {
      if token.length() > 0 {
        parts.push(token)
        token = ""
      }
    } else {
      token = token + char.to_string()
    }
  }
  if token.length() > 0 {
    parts.push(token)
  }
  parts
}

///|
fn parse_double_maybe(text : String) -> Double? {
  Some(@string.parse_double(text)) catch {
    _ => None
  }
}

///|
fn parse_term(
  text : String,
  base_column : Int,
) -> ParsedStoichTerm raise ThermoError {
  let trimmed = trim_string(text)
  if trimmed.length() == 0 {
    raise ThermoError::ParseError(
      line=1,
      column=base_column,
      message="expected species term",
    )
  }
  let tokens = split_spaces(trimmed)
  if tokens.length() > 2 {
    raise ThermoError::ParseError(
      line=1,
      column=base_column,
      message="expected optional coefficient followed by formula",
    )
  }
  let mut coefficient = 1.0
  let mut name = ""
  if tokens.length() == 1 {
    name = tokens[0]
  } else {
    match parse_double_maybe(tokens[0]) {
      Some(value) => {
        coefficient = value
        name = tokens[1]
      }
      None =>
        raise ThermoError::ParseError(
          line=1,
          column=base_column,
          message="invalid stoichiometric coefficient",
        )
    }
  }
  if coefficient <= 0.0 {
    raise ThermoError::ParseError(
      line=1,
      column=base_column,
      message="expected positive stoichiometric coefficient",
    )
  }
  let formula_column = base_column + trimmed.length() - name.length()
  let formula = parse_formula(name) catch {
    ThermoError::ParseError(column=local_column, message~, ..) =>
      raise ThermoError::ParseError(
        line=1,
        column=formula_column + local_column - 1,
        message~,
      )
    err => raise err
  }
  { name, formula, coefficient }
}

///|
fn parse_side(
  text : String,
  base_column : Int,
) -> Array[ParsedStoichTerm] raise ThermoError {
  let chars = text.to_array()
  let terms : Array[ParsedStoichTerm] = []
  let mut start = 0
  let mut index = 0
  while index <= chars.length() {
    if index == chars.length() || chars[index] == '+' {
      let piece = slice_chars(text, start, index)
      let column = first_non_space_column(piece, base_column + start)
      terms.push(parse_term(piece, column))
      start = index + 1
    }
    index += 1
  }
  if terms.length() == 0 {
    raise ThermoError::ParseError(
      line=1,
      column=base_column,
      message="expected species term",
    )
  }
  terms
}

///|
pub fn parse_reaction_equation(
  text : String,
) -> ParsedReaction raise ThermoError {
  let (arrow, multiple) = find_arrow(text)
  match arrow {
    Some(index) if !multiple => {
      let left = slice_chars(text, 0, index)
      let right = slice_chars(text, index + 2, text.length())
      let reactants = parse_side(left, 1)
      let products = parse_side(right, index + 3)
      { label: trim_string(text), reactants, products }
    }
    _ =>
      raise ThermoError::ParseError(
        line=1,
        column=1,
        message="expected exactly one reaction arrow",
      )
  }
}

///|
pub fn ParsedReaction::to_reaction(
  self : ParsedReaction,
  lookup : (String) -> Species raise ThermoError,
) -> Reaction raise ThermoError {
  let reactants : Array[StoichTerm] = []
  let products : Array[StoichTerm] = []
  for term in self.reactants {
    reactants.push(
      StoichTerm::new(species=lookup(term.name), coefficient=term.coefficient),
    )
  }
  for term in self.products {
    products.push(
      StoichTerm::new(species=lookup(term.name), coefficient=term.coefficient),
    )
  }
  Reaction::new(label=self.label, reactants~, products~)
}
