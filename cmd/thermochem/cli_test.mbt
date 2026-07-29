///|
test "cli help text contains commands" {
  let text = help_text()
  inspect(text.contains("species"), content="true")
  inspect(text.contains("reaction"), content="true")
  inspect(text.contains("flame"), content="true")
  inspect(text.contains("flame methane-air 298.15"), content="true")
}

///|
test "cli renders the documented demos" {
  let species = render(["species", "CH4", "1200"])
  inspect(species.contains("CH4"), content="true")
  inspect(species.contains("temperature: 1200 K"), content="true")

  let reaction = render(["reaction", "methane-combustion", "298.15"])
  inspect(reaction.contains("CH4 + 2 O2 -> CO2 + 2 H2O"), content="true")
  inspect(reaction.contains("temperature: 298.15 K"), content="true")
  inspect(reaction.contains("reaction enthalpy"), content="true")

  let flame = render(["flame", "methane-air", "298.15"])
  inspect(flame.contains("methane-air"), content="true")
  inspect(flame.contains("CH4 + 2 O2 + 7.52 N2"), content="true")
  inspect(flame.contains("temperature: 298.15 K"), content="true")
  inspect(flame.contains("flame temperature"), content="true")
  inspect(flame.contains("reaction enthalpy"), content="false")

  let ammonia = render(["ammonia", "700"])
  inspect(ammonia.contains("N2 + 3 H2 -> 2 NH3"), content="true")
  inspect(ammonia.contains("temperature: 700 K"), content="true")
}

///|
test "cli reports invalid temperatures" {
  inspect(
    render(["species", "CH4", "hot"]),
    content="error: temperature must be a number",
  )
  inspect(
    render(["flame", "methane-air", "hot"]),
    content="error: temperature must be a number",
  )
}
