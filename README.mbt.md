# moonbit-thermochem

Thermochemical property calculations for MoonBit.

Status: Work in progress.

This package evaluates NASA7 heat-capacity, enthalpy, and entropy polynomials;
defines species and reactions; parses common reaction equations; checks
elemental balance; and includes a small, documented data set for combustion and
ammonia-synthesis examples. Values use SI molar units by default: J/mol/K for
heat capacity and entropy, and J/mol for enthalpy.

```mbt nocheck
moon add Hjyyutr/moonbit-thermochem
```

The core examples are checked as part of this checkout. Examples using the
separate `data` and `parser` packages are marked `nocheck`: MoonBit README doc
tests compile the root package and do not load sibling package imports.

## Look Up A Species

The bundled data set contains `CH4`, `O2`, `N2`, `CO2`, `H2O`, `CO`, `H2`, and
`NH3` gas species.

```mbt nocheck
let methane = @data.get_species("CH4")
inspect(methane.name, content="CH4")
```

## Evaluate Heat Capacity

`Species::cp_molar` selects the NASA7 segment covering the requested
temperature. It raises `ThermoError::NoThermoSegment` outside the species data
range.

```mbt check
///|
test "evaluate a NASA7 heat capacity" {
  let segment = Nasa7Segment::new(
    range=TemperatureRange::new(lower=200.0, upper=3500.0),
    a1=3.5,
    a2=0.0,
    a3=0.0,
    a4=0.0,
    a5=0.0,
    a6=0.0,
    a7=0.0,
  )
  let hydrogen = Species::new(
    name="H2",
    formula=parse_formula("H2"),
    phase=Phase::Gas,
    molar_mass=2.016,
    formation_enthalpy=0.0,
    model=ThermoModel::Nasa7([segment]),
  )
  inspect(hydrogen.cp_molar(temperature=1200.0) > 0.0, content="true")
}
```

## Calculate Reaction Enthalpy

Reaction enthalpy is the stoichiometric product enthalpy minus the
stoichiometric reactant enthalpy at the same temperature.

```mbt check
///|
test "calculate reaction enthalpy" {
  let formula = parse_formula("H2")
  let reactant = Species::new(
    name="H2",
    formula~,
    phase=Phase::Gas,
    molar_mass=2.016,
    formation_enthalpy=0.0,
    model=ThermoModel::ConstantEnthalpy(10.0),
  )
  let product = Species::new(
    name="H2O",
    formula=parse_formula("H2O"),
    phase=Phase::Gas,
    molar_mass=18.015,
    formation_enthalpy=0.0,
    model=ThermoModel::ConstantEnthalpy(4.0),
  )
  let reaction = Reaction::new(
    label="H2 -> H2O",
    reactants=[StoichTerm::new(species=reactant, coefficient=1.0)],
    products=[StoichTerm::new(species=product, coefficient=1.0)],
  )
  inspect(reaction.enthalpy(temperature=298.15), content="-6")
}
```

## Parse And Check Reactions

The root package can parse simple stoichiometric equations with integer or
decimal coefficients, then report elemental balance before a reaction is bound
to a species data set.

```mbt check
///|
test "parse and check reaction balance" {
  let parsed = parse_reaction_equation(
    "CH4 + 2 O2 + 7.52 N2 -> CO2 + 2 H2O + 7.52 N2",
  )
  inspect(parsed.is_elementally_balanced(), content="true")
  inspect(parsed.element_balance().length(), content="4")
}
```

## Formula And Element Utilities

Formula parsing combines repeated symbols and can compute molar mass, per
element mass contribution, and mass fraction from the built-in periodic table
helpers. The element catalog also exposes period, group, block, standard phase,
and a natural-abundance flag for lightweight validation and reporting.

```mbt check
///|
test "formula mass and unit helpers" {
  let methane = parse_formula("CH4")
  inspect(methane.molar_mass() > 16.0, content="true")
  inspect(methane.mass_fraction("C") > 0.7, content="true")
  inspect(element_group("O"), content="16")
  inspect(j_per_mol_to_kj_per_mol(12500.0), content="12.5")
}
```

## Parse Compact NASA7 Data

The parser accepts a compact, whitespace-separated three-line record: a header
followed by `LOW` and `HIGH` rows with seven coefficients each. The species
name must also be a parseable chemical formula.

```mbt nocheck
let text =
  #|H2 G 200.0 1000.0 3500.0
  #|LOW 2.34433112 0.00798052075 -0.000019478151 0.0000000201572094 -0.00000000000737611761 -917.935173 0.683010238
  #|HIGH 3.3372792 -0.000049402473 0.000000499456778 -0.00000000017958886 0.000000000000020025227  -950.158922 -3.20502331
  #|
let species = @parser.parse_nasa7_thermo(text)
inspect(species[0].name, content="H2")
```

## CLI Demo

Run the deterministic examples from a checkout:

```bash
moon run cmd/thermochem -- species CH4 1200
moon run cmd/thermochem -- reaction methane-combustion 298.15
moon run cmd/thermochem -- flame methane-air 298.15
moon run cmd/thermochem -- ammonia 700
```

For data provenance and scope, see [data sources](docs/data-sources.md). See
[design notes](docs/design-notes.md) for package boundaries and numerical
methods.
