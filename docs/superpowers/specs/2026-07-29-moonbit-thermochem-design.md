# moonbit-thermochem Design

Date: 2026-07-29

## Context

`moonbit-thermochem` is planned as a MoonBit thermochemical properties library for the 2026 MoonBit software synthesis challenge. The public challenge material emphasizes a system-level project with engineering value, clear scope, reproducible build and run paths, full open-source history, documentation, test coverage, and long-term evolution potential.

The project should avoid mature MoonBit packages with highly overlapping functionality. A Mooncakes ecosystem scan found chemistry-adjacent and thermodynamics-adjacent packages, including:

- `SupremeHuaji/moonsmiles`: cheminformatics, SMILES parsing, molecular structure, molecular properties, and similarity.
- `SupremeHuaji/MoonMet`: meteorological calculations, atmospheric thermodynamics, pressure, humidity, and weather indices.

No mature Mooncakes package was found that focuses on NASA polynomial thermochemical data, species heat capacity/enthalpy/entropy evaluation, reaction enthalpy, thermal balance solving, or adiabatic flame temperature. This gives the project a clear ecosystem niche.

The Feishu wiki URL supplied by the user could not be read through the available web tools, likely because the page requires login, permission, or dynamic access. The implementation will still follow the public MoonBit challenge page requirements and leave a final checklist item for rechecking the Feishu guide when the user provides access or exported content.

## Goals

Build a reusable MoonBit library for basic thermochemical calculations:

- Represent species, elements, phase labels, NASA polynomial segments, and reference formation data.
- Evaluate Cp, H, and S across temperature ranges using NASA7 and an extensible model boundary for NASA9.
- Parse a practical subset of NASA thermo data files with useful diagnostics.
- Compute reaction enthalpy from stoichiometric equations and formation/thermal enthalpy data.
- Solve simple heat-balance problems, including constant-pressure adiabatic flame temperature.
- Provide examples for methane combustion, hydrogen combustion, and ammonia synthesis.
- Include enough tests, docs, data provenance, CI, and package metadata for repository review and Mooncakes publication.

## Non-Goals

The first version will not attempt full equilibrium chemistry, kinetics, transport properties, multiphase reactor modeling, or a complete chemical mechanism parser. Those topics are deliberately left as future extension points so the initial library remains testable and reviewable.

The project will not duplicate SMILES parsing, molecular graph analysis, meteorology, or weather-specific thermodynamics. It may later interoperate with chemistry packages through formula/species names, but will not depend on them for the core release.

## Recommended Approach

Use a modular core library plus a small CLI/demo package.

Alternative approaches considered:

- Minimal formula collection: faster to implement, but too narrow and weak for the challenge's engineering-quality expectations.
- Large equilibrium/combustion engine: impressive scope, but high risk and hard to validate within one iteration.
- Modular thermochemical core: balanced scope, strong domain identity, good testing surface, and natural extension path.

The modular thermochemical core is the selected approach.

## Package Structure

Planned layout:

```text
moonbit-thermochem/
  moon.mod
  moon.pkg
  types.mbt
  units.mbt
  formula.mbt
  nasa7.mbt
  nasa9.mbt
  species.mbt
  mixture.mbt
  reaction.mbt
  balance.mbt
  solver.mbt
  parser/
    moon.pkg
    token.mbt
    scanner.mbt
    nasa_thermo.mbt
    diagnostics.mbt
  data/
    moon.pkg
    builtin_species.mbt
    provenance.mbt
  examples/
    moon.pkg
    combustion.mbt
    ammonia.mbt
    reporting.mbt
  cmd/
    thermochem/
      moon.pkg
      main.mbt
  docs/
    data-sources.md
    design-notes.md
    development-retrospective.md
  .github/
    workflows/
      check.yml
      publish.yml
```

The root package owns public API types that users construct or inspect. Parser implementation details can live in the `parser` package if they are reusable and documented; any helper-only scanners should avoid leaking private helper types into the root API.

## Public API Shape

Core public types:

- `TemperatureRange`: lower/upper bounds in kelvin.
- `Nasa7Segment`: coefficient set plus valid temperature range.
- `ThermoModel`: enum wrapper for NASA7 and future NASA9 data.
- `Species`: name, formula, phase, molar mass, formation enthalpy, and thermo model.
- `StoichTerm`: species plus coefficient.
- `Reaction`: reactants, products, and label.
- `Mixture`: species mole amounts.
- `ThermoError`: checked errors for invalid temperature, missing species, bad data, parse diagnostics, and solver failure.

Core public functions and methods:

- `Species::cp_molar(species, temperature~) -> Double raise ThermoError`
- `Species::enthalpy_molar(species, temperature~) -> Double raise ThermoError`
- `Species::entropy_molar(species, temperature~) -> Double raise ThermoError`
- `Reaction::enthalpy(reaction, temperature~) -> Double raise ThermoError`
- `Mixture::enthalpy(mixture, temperature~) -> Double raise ThermoError`
- `adiabatic_flame_temperature(reaction, initial_temperature~, lower_bound?, upper_bound?) -> Double raise ThermoError`
- `parse_nasa7_thermo(text : String) -> Array[Species] raise ThermoError`

Naming will stay lower_snake for functions and UpperCamel for types. Optional parameters will use MoonBit's labeled optional syntax rather than option structs unless a real configuration object is justified.

## Data Model

The built-in data set should be deliberately small but useful:

- Fuel/oxidizer/product set: `CH4`, `O2`, `N2`, `CO2`, `H2O`, `CO`, `H2`.
- Ammonia synthesis set: `N2`, `H2`, `NH3`.
- Additional simple species for tests: `Ar`, `OH`, `O`, `H`, if available from public-domain/reference data.

Each bundled species must carry provenance in docs and source comments near the data table. Data should be treated as factual reference material, not AI-generated numeric content.

## Calculation Details

NASA7 equations use the common nondimensional forms:

- `cp / R = a1 + a2 T + a3 T^2 + a4 T^3 + a5 T^4`
- `h / (R T) = a1 + a2 T / 2 + a3 T^2 / 3 + a4 T^3 / 4 + a5 T^4 / 5 + a6 / T`
- `s / R = a1 ln(T) + a2 T + a3 T^2 / 2 + a4 T^3 / 3 + a5 T^4 / 4 + a7`

The implementation will centralize the universal gas constant and unit conversions. Internal functions should keep units explicit in names or docstrings, especially joule/mol, kilojoule/mol, kelvin, and mole.

Reaction enthalpy is computed from products minus reactants, weighted by stoichiometric coefficients. Flame temperature solving balances product enthalpy against reactant enthalpy, using a bracketed root finder with explicit convergence and iteration limits.

## Parser

The parser will support a practical subset of NASA thermo text:

- Species name, optional phase, temperature limits, and seven coefficients per temperature segment.
- Comments and blank lines.
- Diagnostics with line/column context for malformed records.

The parser will not attempt to support every legacy fixed-column quirk in the first version. If a line-based record cannot be parsed confidently, it should raise a checked `ThermoError` with enough context for the caller to fix the input file.

## CLI And Examples

The CLI should provide reproducible workflows:

- `thermochem species CH4 --temperature 1200`
- `thermochem reaction methane-combustion --temperature 298.15`
- `thermochem flame methane-air --initial-temperature 298.15`

The first release may implement examples as executable demos before growing a fully general command parser. The README should show `moon run cmd/thermochem -- ...` commands that exercise the main paths.

## Testing Strategy

Tests will be written before production code for each feature slice:

- NASA7 Cp/H/S equations using known hand-checkable coefficients.
- Temperature segment selection and out-of-range errors.
- Formula and species construction.
- Reaction enthalpy sign and stoichiometric weighting.
- Parser happy path and malformed input diagnostics.
- Solver convergence and no-bracket failure.
- Built-in examples for methane combustion and ammonia synthesis.

Snapshot tests can be used for structured values and CLI output. Numerical tests should use explicit tolerances.

## CI And Toolchain

The project should use modern `moon.mod` and `moon.pkg` files, not legacy JSON configs. Local and CI validation should include:

```text
moon check --target all --deny-warn
moon test --target all --deny-warn
moon fmt --check
moon info --target all
git diff --exit-code
```

The CI workflow will be based on the MoonBit community templates and expanded for warning-deny checks. It should install the latest MoonBit toolchain in GitHub Actions. If the challenge guide specifically requires MoonBit 0.10.3, the README will note the minimum tested version while local development can use newer compatible toolchains.

## Repository Requirements

The repository should include:

- `README.mbt.md` and/or `README.md` with goal, scope, install, usage, examples, and limitations.
- OSI-approved license, likely Apache-2.0 unless the user chooses otherwise.
- Data provenance documentation.
- Development retrospective explaining architecture choices, AI-agent usage, and borrowed references.
- `.gitignore` excluding build products and web-scrape artifacts.
- Generated `pkg.generated.mbti` files after `moon info`, reviewed as the public API signal.
- At least 10 meaningful commits before remote publication, preferably 12-16.

No fabricated contributors should be introduced. GitHub commits should use the currently configured GitHub identity unless the user asks to change it. GitLink publication should use the GitLink account owner identity independently and must not copy GitHub author metadata if that would create a false contributor.

## Publication Plan

GitHub:

- Use `gh` only after authentication is readable from the environment.
- Create a public repository named `moonbit-thermochem`.
- Push the full commit history.
- Verify default branch and remote URL.

GitLink:

- Avoid storing the provided username/password in repository files, shell scripts, or documentation.
- Use credentials only through an interactive or credential-helper-safe flow.
- Keep GitLink author identity as the GitLink account owner.

Mooncakes:

- Ensure `moon.mod` package metadata is complete.
- Run final checks, `moon info`, and package validation.
- Use `moon login` or existing Mooncakes credentials, then `moon publish`.
- Do not publish until README, license, source provenance, generated interfaces, and CI are in place.

## Risks And Mitigations

- Numeric reference errors: use public reference data, document provenance, and create tolerance-based tests.
- Scope creep into full equilibrium chemistry: keep first release to thermal properties, reaction enthalpy, and simple heat-balance solving.
- Parser ambiguity: support a documented subset first, then add compatibility cases through tests.
- Toolchain drift: use modern `.mod/.pkg` files and deny warnings in CI.
- Challenge guide mismatch: recheck the Feishu guide before final submission once access is available.
- Secret leakage: never commit account credentials, generated auth files, or local publishing tokens.

## Acceptance Checklist

- The project builds and tests locally with MoonBit.
- `moon check --target all --deny-warn` passes.
- `moon test --target all --deny-warn` passes.
- `moon fmt --check` passes or formatting diff is empty.
- `moon info --target all` generates reviewed API files and leaves no unexpected diff.
- README explains goals, scope, examples, and limitations.
- License and data provenance are present.
- CI exists and mirrors local checks.
- MoonBit source scale is within the challenge target range after excluding generated files and vendored data.
- Commit history contains more than 10 meaningful commits by the real account owner.
- GitHub, GitLink, and Mooncakes publication are verified.
