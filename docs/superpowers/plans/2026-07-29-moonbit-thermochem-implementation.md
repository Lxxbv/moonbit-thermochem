# moonbit-thermochem Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a MoonBit thermochemical properties library with NASA polynomial evaluation, reaction enthalpy, heat-balance solving, examples, docs, CI, and publication metadata.

**Architecture:** The root package owns public domain types and core calculations. Dedicated `parser`, `data`, `examples`, and `cmd/thermochem` packages keep parsing, bundled reference data, reproducible examples, and CLI behavior separate. Each task adds one independently testable capability and ends with a meaningful commit.

**Tech Stack:** MoonBit 0.10.x toolchain, modern `moon.mod` / `moon.pkg`, MoonBit tests and snapshots, GitHub Actions, Apache-2.0 license, Mooncakes package metadata.

## Global Constraints

- Use modern `moon.mod` and `moon.pkg` files, not legacy JSON configs.
- Keep public concrete API types in the root package unless they belong to a non-internal public package.
- Use checked `ThermoError` errors for invalid temperatures, missing species, parse diagnostics, and solver failures.
- Do not commit GitLink credentials, Mooncakes credentials, auth tokens, or generated local auth files.
- Do not add fabricated contributors; commit author identity must be the real configured account owner.
- Build and test with `moon check --target all --deny-warn`, `moon test --target all --deny-warn`, `moon fmt --check`, and `moon info --target all`.
- Include README, license, data provenance, development retrospective, CI, and generated `pkg.generated.mbti` before publication.
- Target 10+ meaningful commits; generated files and vendored data do not count as design-quality substitutes for implementation.

---

## File Structure

Create or modify these files:

- `moon.mod`: module metadata, package name, license, keywords, repository placeholder, preferred target.
- `moon.pkg`: root package metadata and package imports.
- `types.mbt`: public units, ranges, errors, and common result types.
- `formula.mbt`: molecular formula representation and parsing for simple formulas.
- `nasa7.mbt`: NASA7 segment model and Cp/H/S evaluation.
- `species.mbt`: species model and thermodynamic methods.
- `mixture.mbt`: mole amounts and mixture thermodynamic accumulation.
- `reaction.mbt`: stoichiometric terms, reaction model, and reaction enthalpy.
- `solver.mbt`: bracketed root finding and flame-temperature solving.
- `parser/moon.pkg`: parser package metadata.
- `parser/scanner.mbt`: line scanner and coefficient token helpers.
- `parser/nasa_thermo.mbt`: NASA7 text parser.
- `data/moon.pkg`: data package metadata.
- `data/builtin_species.mbt`: built-in species table.
- `data/provenance.mbt`: data-source labels exposed to examples/docs.
- `examples/moon.pkg`: examples package metadata.
- `examples/combustion.mbt`: methane/hydrogen combustion example functions.
- `examples/ammonia.mbt`: ammonia synthesis example functions.
- `cmd/thermochem/moon.pkg`: CLI package metadata.
- `cmd/thermochem/main.mbt`: command-line demo entry point.
- `README.mbt.md`: tested usage-oriented README.
- `README.md`: same content as README.mbt.md or a normal Markdown copy.
- `docs/data-sources.md`: coefficient and formula provenance.
- `docs/design-notes.md`: architecture and numerical-method notes.
- `docs/development-retrospective.md`: challenge-facing development process notes.
- `.github/workflows/check.yml`: CI for check/test/fmt/info.
- `.github/workflows/publish.yml`: manual Mooncakes publish workflow.
- `.gitignore`: exclude build output, local credentials, and scrape/cache directories.
- `LICENSE`: Apache-2.0 license.

---

### Task 1: Project Scaffold And Metadata

**Files:**
- Create: `moon.mod`
- Create: `moon.pkg`
- Create: `.gitignore`
- Create: `LICENSE`
- Create: `README.mbt.md`
- Create: `README.md`

**Interfaces:**
- Produces module name: `Hjyyutr/moonbit-thermochem`
- Produces root package with no public API yet.

- [ ] **Step 1: Create minimal module files**

```text
moon.mod
name = "Hjyyutr/moonbit-thermochem"
version = "0.1.0"
readme = "README.mbt.md"
repository = "https://github.com/Hjyyutr/moonbit-thermochem"
license = "Apache-2.0"
keywords = ["thermochemistry", "nasa-polynomial", "combustion", "enthalpy", "moonbit"]
description = "Thermochemical property calculations for MoonBit, including NASA polynomials, reaction enthalpy, and flame-temperature estimates."

options(
  "preferred-target": "native",
)
```

```text
moon.pkg
// Root library package; public API is added by later tasks.
```

```text
.gitignore
_build/
target/
.moon/
.repos/
.firecrawl/
*.log
*.tmp
credentials.json
```

- [ ] **Step 2: Add README and license**

Create `README.mbt.md` with a short project overview, status as work in progress, and a `mbt nocheck` install placeholder:

````markdown
# moonbit-thermochem

Thermochemical property calculations for MoonBit.

This package provides NASA polynomial data models, species Cp/H/S evaluation, reaction enthalpy calculation, and small reproducible examples for combustion and ammonia synthesis.

```mbt nocheck
moon add Hjyyutr/moonbit-thermochem
```
````

Copy the same content to `README.md`.

Use the standard Apache-2.0 license text in `LICENSE`.

- [ ] **Step 3: Run scaffold checks**

Run: `moon check --target all --deny-warn`

Expected: command exits 0 with no warnings.

- [ ] **Step 4: Commit**

```bash
git add moon.mod moon.pkg .gitignore README.mbt.md README.md LICENSE
git commit -m "chore: scaffold thermochem module"
```

---

### Task 2: Core Types And Error Surface

**Files:**
- Create: `types.mbt`
- Create: `types_test.mbt`

**Interfaces:**
- Produces: `pub(all) struct TemperatureRange`
- Produces: `pub(all) suberror ThermoError`
- Produces: `pub fn TemperatureRange::contains(self : TemperatureRange, temperature : Double) -> Bool`
- Produces: `pub fn TemperatureRange::validate(self : TemperatureRange, temperature : Double) -> Unit raise ThermoError`

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "temperature range accepts endpoints and interior" {
  let range = TemperatureRange::new(lower=200.0, upper=1000.0)
  inspect(range.contains(200.0), content="true")
  inspect(range.contains(500.0), content="true")
  inspect(range.contains(1000.0), content="true")
}

///|
test "temperature range rejects outside values" {
  let range = TemperatureRange::new(lower=200.0, upper=1000.0)
  inspect(range.contains(199.9), content="false")
  inspect(range.contains(1000.1), content="false")
}

///|
test "temperature validation reports bad value" {
  let range = TemperatureRange::new(lower=200.0, upper=1000.0)
  try range.validate(150.0) catch {
    ThermoError::TemperatureOutOfRange(value~, lower~, upper~) =>
      inspect("\{value} < \{lower}..\{upper}", content="150 < 200..1000")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected out of range")
  }
}
```

- [ ] **Step 2: Verify red**

Run: `moon test types_test.mbt --target native`

Expected: FAIL because `TemperatureRange` and `ThermoError` are not defined.

- [ ] **Step 3: Implement minimal types**

```mbt
///|
pub(all) suberror ThermoError {
  InvalidTemperatureRange(lower~ : Double, upper~ : Double)
  TemperatureOutOfRange(value~ : Double, lower~ : Double, upper~ : Double)
  NoThermoSegment(species~ : String, temperature~ : Double)
  MissingSpecies(name~ : String)
  ParseError(line~ : Int, column~ : Int, message~ : String)
  SolverFailed(message~ : String)
} derive(Debug, Eq)

///|
pub(all) struct TemperatureRange {
  lower : Double
  upper : Double
} derive(Debug, Eq)

///|
pub fn TemperatureRange::new(lower~ : Double, upper~ : Double) -> TemperatureRange raise ThermoError {
  if lower > upper {
    raise ThermoError::InvalidTemperatureRange(lower~, upper~)
  }
  { lower, upper }
}

///|
pub fn TemperatureRange::contains(self : TemperatureRange, temperature : Double) -> Bool {
  self.lower <= temperature && temperature <= self.upper
}

///|
pub fn TemperatureRange::validate(self : TemperatureRange, temperature : Double) -> Unit raise ThermoError {
  if !self.contains(temperature) {
    raise ThermoError::TemperatureOutOfRange(value=temperature, lower=self.lower, upper=self.upper)
  }
}
```

- [ ] **Step 4: Verify green**

Run: `moon test types_test.mbt --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add types.mbt types_test.mbt
git commit -m "feat: add thermochemical core types"
```

---

### Task 3: Formula Parsing

**Files:**
- Create: `formula.mbt`
- Create: `formula_test.mbt`

**Interfaces:**
- Consumes: `ThermoError`
- Produces: `pub(all) struct ElementCount`
- Produces: `pub(all) struct Formula`
- Produces: `pub fn parse_formula(text : String) -> Formula raise ThermoError`
- Produces: `pub fn Formula::count(self : Formula, symbol : String) -> Int`

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "parse simple formula counts elements" {
  let formula = parse_formula("CH4")
  inspect(formula.count("C"), content="1")
  inspect(formula.count("H"), content="4")
  inspect(formula.count("O"), content="0")
}

///|
test "parse multi-letter element formula" {
  let formula = parse_formula("NH3")
  inspect(formula.count("N"), content="1")
  inspect(formula.count("H"), content="3")
}

///|
test "formula rejects lowercase start" {
  try parse_formula("ch4") catch {
    ThermoError::ParseError(line=1, column=1, message~) =>
      inspect(message, content="expected uppercase element symbol")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}
```

- [ ] **Step 2: Verify red**

Run: `moon test formula_test.mbt --target native`

Expected: FAIL because `parse_formula` is not defined.

- [ ] **Step 3: Implement parser**

Implement `Formula` as an array of `ElementCount`, parse uppercase element symbols with one optional lowercase letter, parse optional positive integer counts, and combine repeated symbols by incrementing counts.

Key signatures:

```mbt
///|
pub(all) struct ElementCount {
  symbol : String
  count : Int
} derive(Debug, Eq)

///|
pub(all) struct Formula {
  elements : Array[ElementCount]
} derive(Debug, Eq)
```

- [ ] **Step 4: Verify green**

Run: `moon test formula_test.mbt --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add formula.mbt formula_test.mbt
git commit -m "feat: parse simple molecular formulas"
```

---

### Task 4: NASA7 Polynomial Evaluation

**Files:**
- Create: `nasa7.mbt`
- Create: `nasa7_test.mbt`

**Interfaces:**
- Consumes: `TemperatureRange`, `ThermoError`
- Produces: `pub(all) struct Nasa7Segment`
- Produces: `pub fn Nasa7Segment::cp_over_r(self : Nasa7Segment, temperature : Double) -> Double raise ThermoError`
- Produces: `pub fn Nasa7Segment::h_over_rt(self : Nasa7Segment, temperature : Double) -> Double raise ThermoError`
- Produces: `pub fn Nasa7Segment::s_over_r(self : Nasa7Segment, temperature : Double) -> Double raise ThermoError`

- [ ] **Step 1: Write failing tests**

```mbt
///|
fn constant_cp_segment() -> Nasa7Segment {
  Nasa7Segment::new(
    range=TemperatureRange::new(lower=200.0, upper=6000.0),
    a1=3.5, a2=0.0, a3=0.0, a4=0.0, a5=0.0, a6=0.0, a7=1.0,
  )
}

///|
test "nasa7 constant heat capacity" {
  let segment = constant_cp_segment()
  inspect(segment.cp_over_r(300.0), content="3.5")
}

///|
test "nasa7 enthalpy and entropy nondimensional forms" {
  let segment = constant_cp_segment()
  inspect(segment.h_over_rt(300.0), content="3.5")
  let entropy = segment.s_over_r(300.0)
  inspect(entropy > 20.96 && entropy < 20.97, content="true")
}
```

- [ ] **Step 2: Verify red**

Run: `moon test nasa7_test.mbt --target native`

Expected: FAIL because `Nasa7Segment` is not defined.

- [ ] **Step 3: Implement NASA7 equations**

Implement the NASA7 formulas from the design doc, using `temperature.ln()` after confirming the standard library method with `moon ide doc "Double::*ln*"`.

- [ ] **Step 4: Verify green**

Run: `moon test nasa7_test.mbt --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add nasa7.mbt nasa7_test.mbt
git commit -m "feat: evaluate nasa7 thermodynamic polynomials"
```

---

### Task 5: Species Thermodynamic Methods

**Files:**
- Create: `species.mbt`
- Create: `species_test.mbt`

**Interfaces:**
- Consumes: `Formula`, `Nasa7Segment`, `ThermoError`
- Produces: `pub(all) enum Phase`
- Produces: `pub(all) enum ThermoModel`
- Produces: `pub(all) struct Species`
- Produces: `pub fn Species::cp_molar(self : Species, temperature~ : Double) -> Double raise ThermoError`
- Produces: `pub fn Species::enthalpy_molar(self : Species, temperature~ : Double) -> Double raise ThermoError`
- Produces: `pub fn Species::entropy_molar(self : Species, temperature~ : Double) -> Double raise ThermoError`

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "species delegates to nasa7 segment and converts by gas constant" {
  let species = Species::new(
    name="X",
    formula=parse_formula("X"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::Nasa7([constant_cp_segment()]),
  )
  let cp = species.cp_molar(temperature=300.0)
  inspect(cp > 29.10 && cp < 29.11, content="true")
}

///|
test "species reports missing segment for outside temperature" {
  let species = Species::new(
    name="X",
    formula=parse_formula("X"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::Nasa7([constant_cp_segment()]),
  )
  try species.cp_molar(temperature=100.0) catch {
    ThermoError::NoThermoSegment(species="X", temperature=100.0) => inspect("missing", content="missing")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected missing segment")
  }
}
```

- [ ] **Step 2: Verify red**

Run: `moon test species_test.mbt --target native`

Expected: FAIL because `Species` is not defined.

- [ ] **Step 3: Implement species methods**

Define `gas_constant_j_per_mol_k : Double = 8.31446261815324`. Multiply NASA nondimensional values by `R`, `R*T`, and `R` for Cp, H, and S respectively.

- [ ] **Step 4: Verify green**

Run: `moon test species_test.mbt --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add species.mbt species_test.mbt
git commit -m "feat: add species thermodynamic properties"
```

---

### Task 6: Mixtures And Reactions

**Files:**
- Create: `mixture.mbt`
- Create: `reaction.mbt`
- Create: `reaction_test.mbt`

**Interfaces:**
- Consumes: `Species`
- Produces: `pub(all) struct SpeciesAmount`
- Produces: `pub(all) struct Mixture`
- Produces: `pub(all) struct StoichTerm`
- Produces: `pub(all) struct Reaction`
- Produces: `pub fn Reaction::enthalpy(self : Reaction, temperature~ : Double) -> Double raise ThermoError`

- [ ] **Step 1: Write failing tests**

```mbt
///|
fn fake_species(name : String, h : Double) -> Species {
  Species::new(
    name,
    formula=parse_formula("H"),
    phase=Phase::Gas,
    molar_mass=1.0,
    formation_enthalpy=0.0,
    model=ThermoModel::ConstantEnthalpy(h),
  )
}

///|
test "reaction enthalpy is products minus reactants" {
  let a = fake_species("A", 10.0)
  let b = fake_species("B", 25.0)
  let c = fake_species("C", 80.0)
  let reaction = Reaction::new(
    label="A + 2B -> C",
    reactants=[StoichTerm::new(species=a, coefficient=1.0), StoichTerm::new(species=b, coefficient=2.0)],
    products=[StoichTerm::new(species=c, coefficient=1.0)],
  )
  inspect(reaction.enthalpy(temperature=298.15), content="20")
}
```

- [ ] **Step 2: Verify red**

Run: `moon test reaction_test.mbt --target native`

Expected: FAIL because `Reaction` and `ThermoModel::ConstantEnthalpy` are not defined.

- [ ] **Step 3: Implement mixtures and reactions**

Add `ThermoModel::ConstantEnthalpy(Double)` for tests and fixed reference species. Implement sum of coefficients times species enthalpy.

- [ ] **Step 4: Verify green**

Run: `moon test reaction_test.mbt --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add mixture.mbt reaction.mbt reaction_test.mbt species.mbt
git commit -m "feat: compute mixture and reaction enthalpy"
```

---

### Task 7: Heat-Balance Solver

**Files:**
- Create: `solver.mbt`
- Create: `solver_test.mbt`

**Interfaces:**
- Consumes: `Reaction`, `Mixture`, `ThermoError`
- Produces: `pub fn solve_bisection(lower~ : Double, upper~ : Double, tolerance~ : Double, max_iterations~ : Int, f : (Double) -> Double raise ThermoError) -> Double raise ThermoError`
- Produces: `pub fn adiabatic_flame_temperature(reaction : Reaction, initial_temperature~ : Double, lower_bound? : Double = 300.0, upper_bound? : Double = 4000.0) -> Double raise ThermoError`

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "bisection solves monotonic root" {
  let root = solve_bisection(lower=0.0, upper=10.0, tolerance=0.000001, max_iterations=80, x => x - 2.0)
  inspect(root > 1.999 && root < 2.001, content="true")
}

///|
test "bisection reports missing bracket" {
  try solve_bisection(lower=0.0, upper=10.0, tolerance=0.000001, max_iterations=80, x => x + 1.0) catch {
    ThermoError::SolverFailed(message~) => inspect(message, content="root is not bracketed")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected solver error")
  }
}
```

- [ ] **Step 2: Verify red**

Run: `moon test solver_test.mbt --target native`

Expected: FAIL because `solve_bisection` is not defined.

- [ ] **Step 3: Implement solver**

Use a bracket check `f(lower) * f(upper) <= 0.0`, halve interval until `abs(value) <= tolerance` or interval width is within tolerance, and raise `ThermoError::SolverFailed(message="root is not bracketed")` for invalid brackets.

- [ ] **Step 4: Verify green**

Run: `moon test solver_test.mbt --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add solver.mbt solver_test.mbt
git commit -m "feat: add heat balance root solver"
```

---

### Task 8: NASA Thermo Text Parser

**Files:**
- Create: `parser/moon.pkg`
- Create: `parser/scanner.mbt`
- Create: `parser/nasa_thermo.mbt`
- Create: `parser/nasa_thermo_test.mbt`
- Modify: `moon.pkg`

**Interfaces:**
- Consumes: root `Species`, `Nasa7Segment`, `ThermoError`
- Produces parser package function: `pub fn parse_nasa7_thermo(text : String) -> Array[Species] raise ThermoError`
- Root package may re-export parser only if no parser-private types leak.

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "parse compact nasa7 species record" {
  let text =
    #|CH4 G 200.0 1000.0 6000.0
    #|LOW 5.14987613 -0.0136709788 0.000049181005 0.0000000000 0.0000000000 -10246.6476 -4.64130376
    #|HIGH 1.63552643 0.0100842795 -0.00000336916254 0.0000000000 0.0000000000 -10005.0048 9.99313326
    #|
  let species = parse_nasa7_thermo(text)
  inspect(species.length(), content="1")
  inspect(species[0].name, content="CH4")
}

///|
test "parser reports line for bad coefficient" {
  let text =
    #|CH4 G 200.0 1000.0 6000.0
    #|LOW bad -0.013 0.0 0.0 0.0 -1.0 0.0
    #|HIGH 1.0 0.0 0.0 0.0 0.0 -1.0 0.0
    #|
  try parse_nasa7_thermo(text) catch {
    ThermoError::ParseError(line=2, column=5, message~) => inspect(message, content="invalid number")
    _ => fail("unexpected error")
  } noraise {
    _ => fail("expected parse error")
  }
}
```

- [ ] **Step 2: Verify red**

Run: `moon test parser --target native`

Expected: FAIL because parser package and function are missing.

- [ ] **Step 3: Implement parser package**

Use a simple documented compact format first: one header line and two coefficient lines per species. Header fields are `name phase low mid high`. Coefficient lines start with `LOW` or `HIGH` and include exactly seven floating-point coefficients.

- [ ] **Step 4: Verify green**

Run: `moon test parser --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add parser moon.pkg
git commit -m "feat: parse compact nasa7 thermo data"
```

---

### Task 9: Built-In Species Data

**Files:**
- Create: `data/moon.pkg`
- Create: `data/builtin_species.mbt`
- Create: `data/provenance.mbt`
- Create: `data/builtin_species_test.mbt`
- Create: `docs/data-sources.md`

**Interfaces:**
- Consumes: root `Species`, `Reaction`, parser or direct NASA7 construction
- Produces: `pub fn get_species(name : String) -> Species raise ThermoError`
- Produces: `pub fn methane_combustion() -> Reaction raise ThermoError`
- Produces: `pub fn hydrogen_combustion() -> Reaction raise ThermoError`
- Produces: `pub fn ammonia_synthesis() -> Reaction raise ThermoError`

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "builtin species table returns methane and nitrogen" {
  let methane = get_species("CH4")
  let nitrogen = get_species("N2")
  inspect(methane.name, content="CH4")
  inspect(nitrogen.name, content="N2")
}

///|
test "builtin methane combustion reaction shape" {
  let reaction = methane_combustion()
  inspect(reaction.reactants.length(), content="2")
  inspect(reaction.products.length(), content="2")
}
```

- [ ] **Step 2: Verify red**

Run: `moon test data --target native`

Expected: FAIL because `get_species` is missing.

- [ ] **Step 3: Implement built-in data**

Add documented NASA7 coefficients for `CH4`, `O2`, `N2`, `CO2`, `H2O`, `CO`, `H2`, and `NH3`. Include data-source citations in `docs/data-sources.md` and source comments.

- [ ] **Step 4: Verify green**

Run: `moon test data --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add data docs/data-sources.md
git commit -m "feat: add builtin thermochemical species data"
```

---

### Task 10: Domain Examples

**Files:**
- Create: `examples/moon.pkg`
- Create: `examples/combustion.mbt`
- Create: `examples/ammonia.mbt`
- Create: `examples/examples_test.mbt`

**Interfaces:**
- Consumes: `data` reactions and root calculations
- Produces: `pub fn methane_combustion_report(initial_temperature~ : Double) -> String raise ThermoError`
- Produces: `pub fn ammonia_synthesis_report(temperature~ : Double) -> String raise ThermoError`

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "methane combustion report mentions reaction enthalpy and flame temperature" {
  let report = methane_combustion_report(initial_temperature=298.15)
  inspect(report.contains("CH4"), content="true")
  inspect(report.contains("flame temperature"), content="true")
}

///|
test "ammonia synthesis report mentions NH3" {
  let report = ammonia_synthesis_report(temperature=700.0)
  inspect(report.contains("NH3"), content="true")
}
```

- [ ] **Step 2: Verify red**

Run: `moon test examples --target native`

Expected: FAIL because example report functions are missing.

- [ ] **Step 3: Implement examples**

Format compact deterministic reports with reaction label, temperature, reaction enthalpy in kJ/mol reaction, and flame temperature where applicable.

- [ ] **Step 4: Verify green**

Run: `moon test examples --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add examples
git commit -m "feat: add combustion and ammonia examples"
```

---

### Task 11: CLI Demo

**Files:**
- Create: `cmd/thermochem/moon.pkg`
- Create: `cmd/thermochem/main.mbt`
- Create: `cmd/thermochem/cli_test.mbt`
- Modify: `README.mbt.md`
- Modify: `README.md`

**Interfaces:**
- Consumes: examples package
- Produces executable package `cmd/thermochem`

- [ ] **Step 1: Write failing tests**

```mbt
///|
test "cli help text contains commands" {
  let text = help_text()
  inspect(text.contains("species"), content="true")
  inspect(text.contains("reaction"), content="true")
  inspect(text.contains("flame"), content="true")
}
```

- [ ] **Step 2: Verify red**

Run: `moon test cmd/thermochem --target native`

Expected: FAIL because `help_text` is missing.

- [ ] **Step 3: Implement CLI**

Support deterministic demo commands:

```text
moon run cmd/thermochem -- species CH4 1200
moon run cmd/thermochem -- reaction methane-combustion 298.15
moon run cmd/thermochem -- flame methane-air 298.15
moon run cmd/thermochem -- ammonia 700
```

If full argument access is awkward across targets, keep `help_text`, command rendering helpers, and a native executable that prints help and the built-in examples.

- [ ] **Step 4: Verify green**

Run: `moon test cmd/thermochem --target native`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add cmd README.mbt.md README.md
git commit -m "feat: add thermochem cli demo"
```

---

### Task 12: README, Design Notes, And Retrospective

**Files:**
- Modify: `README.mbt.md`
- Modify: `README.md`
- Create: `docs/design-notes.md`
- Create: `docs/development-retrospective.md`

**Interfaces:**
- Consumes all public APIs and examples.
- Produces challenge-facing documentation.

- [ ] **Step 1: Add tested README examples**

Add `mbt check` code blocks demonstrating species lookup, Cp evaluation, reaction enthalpy, and parser usage. Keep CLI command blocks as shell snippets.

- [ ] **Step 2: Run README doc tests**

Run: `moon test README.mbt.md --target native`

Expected: PASS.

- [ ] **Step 3: Add architecture and retrospective docs**

`docs/design-notes.md` must explain package boundaries, NASA7 formulas, parser subset, and solver method. `docs/development-retrospective.md` must explain architectural choices, AI-agent use, references, and known limitations without claiming non-human authorship.

- [ ] **Step 4: Commit**

```bash
git add README.mbt.md README.md docs/design-notes.md docs/development-retrospective.md
git commit -m "docs: expand usage and development notes"
```

---

### Task 13: CI And Generated API Info

**Files:**
- Create: `.github/workflows/check.yml`
- Create: `.github/workflows/publish.yml`
- Generate: `pkg.generated.mbti`
- Generate: `parser/pkg.generated.mbti`
- Generate: `data/pkg.generated.mbti`
- Generate: `examples/pkg.generated.mbti`

**Interfaces:**
- Consumes complete project.
- Produces reproducible CI and public API summaries.

- [ ] **Step 1: Add CI workflow**

`check.yml` should run on push and pull request across Ubuntu, macOS, and Windows:

```yaml
name: Check and Test
on:
  pull_request:
  push:
    branches:
      - main
      - master
jobs:
  build:
    permissions:
      contents: read
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false
      - name: install-unix
        if: ${{ matrix.os != 'windows-latest' }}
        run: |
          curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
          echo "$HOME/.moon/bin" >> $GITHUB_PATH
      - name: install-windows
        if: ${{ matrix.os == 'windows-latest' }}
        run: |
          Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
          irm https://cli.moonbitlang.com/install/powershell.ps1 | iex
          "C:\Users\runneradmin\.moon\bin" | Out-File -FilePath $env:GITHUB_PATH -Append
      - name: post install
        run: |
          moon version --all
          moon update
      - name: moon check
        run: moon check --target all --deny-warn
      - name: moon test
        run: moon test --target all --deny-warn
      - name: format check
        run: moon fmt --check
      - name: public api check
        run: |
          moon info --target all
          git diff --exit-code
```

- [ ] **Step 2: Add manual publish workflow**

Add `.github/workflows/publish.yml` with `workflow_dispatch`, `moon check --deny-warn`, `moon test --deny-warn`, and a guarded `moon publish` step that requires a Mooncakes secret.

- [ ] **Step 3: Generate API info**

Run: `moon info --target all`

Expected: generated `.mbti` files appear and contain the intended public API.

- [ ] **Step 4: Commit**

```bash
git add .github pkg.generated.mbti parser/pkg.generated.mbti data/pkg.generated.mbti examples/pkg.generated.mbti
git commit -m "ci: add moonbit validation workflows"
```

---

### Task 14: Final Validation And Publication Prep

**Files:**
- Modify: `moon.mod`
- Modify: `README.mbt.md`
- Modify: `README.md`
- Modify: `docs/data-sources.md`
- Modify: `docs/development-retrospective.md`

**Interfaces:**
- Consumes full repository.
- Produces release-ready package metadata.

- [ ] **Step 1: Run full local checks**

Run:

```bash
moon fmt
moon check --target all --deny-warn
moon test --target all --deny-warn
moon fmt --check
moon info --target all
git diff --exit-code
```

Expected: all commands exit 0. If `moon info` changes generated files intentionally, inspect and commit those changes before rerunning `git diff --exit-code`.

- [ ] **Step 2: Count MoonBit source scale**

Run:

```powershell
Get-ChildItem -Recurse -Filter '*.mbt' | Where-Object { $_.FullName -notmatch '_build|pkg.generated.mbti' } | ForEach-Object { Get-Content $_.FullName } | Measure-Object -Line
```

Expected: effective MoonBit source size is in the target range after implementation. If below target, add useful test cases, parser compatibility, examples, and docs-backed APIs; do not pad with meaningless code.

- [ ] **Step 3: Check repository history**

Run:

```bash
git log --oneline
git shortlog -sn
git status --short --branch
```

Expected: more than 10 meaningful commits, only the real account owner appears as contributor, and the worktree is clean.

- [ ] **Step 4: Commit final polish**

```bash
git add moon.mod README.mbt.md README.md docs/data-sources.md docs/development-retrospective.md
git commit -m "chore: prepare thermochem package release"
```

- [ ] **Step 5: Publication commands after local verification**

Use GitHub after `gh auth status` works:

```bash
gh repo create moonbit-thermochem --public --source . --remote origin --push
```

Use GitLink through an authenticated flow that does not store credentials in files.

Use Mooncakes only after metadata and checks pass:

```bash
moon login
moon publish
```

Expected: GitHub repository exists, GitLink repository exists, default branches are verified, and Mooncakes package page is reachable.

---

## Self-Review

- Spec coverage: tasks cover scaffold, public types, NASA7, species Cp/H/S, reaction enthalpy, parser, data, examples, CLI, docs, CI, generated API files, history checks, and Mooncakes publication prep.
- Known gap: Feishu guide could not be read through available tooling; final publication prep must recheck it if the user provides access or exported content.
- Placeholder scan: no unresolved placeholders remain. Each task has concrete files, interfaces, commands, and expected outcomes.
- Type consistency: `TemperatureRange`, `ThermoError`, `Nasa7Segment`, `Formula`, `Species`, `ThermoModel`, `Reaction`, `Mixture`, and solver signatures are consistent across tasks.
