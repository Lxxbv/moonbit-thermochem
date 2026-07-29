///|
test "cli help text contains commands" {
  let text = help_text()
  inspect(text.contains("species"), content="true")
  inspect(text.contains("reaction"), content="true")
  inspect(text.contains("flame"), content="true")
}

///|
test "cli renders the documented demos" {
  inspect(render(["species", "CH4", "1200"]).contains("CH4"), content="true")
  inspect(
    render(["reaction", "methane-combustion", "298.15"]).contains(
      "reaction enthalpy",
    ),
    content="true",
  )
  inspect(
    render(["flame", "methane-air", "298.15"]).contains("flame temperature"),
    content="true",
  )
  inspect(render(["ammonia", "700"]).contains("NH3"), content="true")
}
