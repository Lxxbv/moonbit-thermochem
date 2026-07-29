///|
priv struct Token {
  text : String
  column : Int
}

///|
fn scan_line(line : String) -> Array[Token] {
  let tokens : Array[Token] = []
  let chars = line.to_array()
  let mut index = 0
  while index < chars.length() {
    while index < chars.length() &&
          (chars[index] == ' ' || chars[index] == '\t') {
      index += 1
    }
    if index == chars.length() {
      break
    }
    let column = index + 1
    let mut text = ""
    while index < chars.length() && chars[index] != ' ' && chars[index] != '\t' {
      text = text + chars[index].to_string()
      index += 1
    }
    tokens.push({ text, column })
  }
  tokens
}
