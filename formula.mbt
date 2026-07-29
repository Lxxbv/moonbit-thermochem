///|
pub(all) struct ElementCount {
  symbol : String
  count : Int
} derive(Debug, Eq)

///|
pub(all) struct Formula {
  elements : Array[ElementCount]
} derive(Debug, Eq)

///|
pub fn parse_formula(text : String) -> Formula raise ThermoError {
  let chars = text.to_array()
  let elements : Array[ElementCount] = []
  let mut index = 0
  while index < chars.length() {
    let column = index + 1
    let first = chars[index]
    if !first.is_ascii_uppercase() {
      raise ThermoError::ParseError(
        line=1,
        column~,
        message="expected uppercase element symbol",
      )
    }
    let mut symbol = first.to_string()
    index += 1
    if index < chars.length() && chars[index].is_ascii_lowercase() {
      symbol = symbol + chars[index].to_string()
      index += 1
    }
    let mut count = 1
    if index < chars.length() && chars[index].is_ascii_digit() {
      count = 0
      while index < chars.length() && chars[index].is_ascii_digit() {
        count = count * 10 + chars[index].to_int() - '0'.to_int()
        index += 1
      }
      if count <= 0 {
        raise ThermoError::ParseError(
          line=1,
          column~,
          message="expected positive element count",
        )
      }
    }
    let mut found : Int? = None
    for i, element in elements {
      if element.symbol == symbol {
        found = Some(i)
      }
    }
    match found {
      Some(i) => elements[i] = { symbol, count: elements[i].count + count }
      None => elements.push({ symbol, count })
    }
  }
  if elements.length() == 0 {
    raise ThermoError::ParseError(
      line=1,
      column=1,
      message="expected uppercase element symbol",
    )
  }
  { elements, }
}

///|
pub fn Formula::count(self : Formula, symbol : String) -> Int {
  for element in self.elements {
    if element.symbol == symbol {
      return element.count
    }
  }
  0
}
