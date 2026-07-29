# Design Notes

## Package Boundaries

The root `moonbit-thermochem` package owns the domain model and numerical
operations. It defines formulas, temperature ranges, NASA7 segments, species,
mixtures, reactions, and the heat-balance solver. This keeps the fundamental
thermochemical API independent of bundled data and input formats.

The `data` package supplies a deliberately small set of documented gas-species
records and named reactions. The `parser` package translates the compact NASA7
text format into root-package `Species` values. The `examples` package turns
the data and root APIs into reproducible combustion and ammonia-synthesis
reports, while `cmd/thermochem` exposes those reports as a small CLI. Each
outer package depends inward on the root API; the root package does not depend
on parser, data, examples, or the CLI.

## NASA7 Evaluation

For a temperature `T` within a segment's inclusive range, the implementation
uses the standard seven-coefficient NASA form:

```text
Cp / R = a1 + a2*T + a3*T^2 + a4*T^3 + a5*T^4
H / (R*T) = a1 + a2*T/2 + a3*T^2/3 + a4*T^3/4 + a5*T^4/5 + a6/T
S / R = a1*ln(T) + a2*T + a3*T^2/2 + a4*T^3/3 + a5*T^4/4 + a7
```

`Species` converts these dimensionless forms with `R = 8.31446261815324`
J/mol/K. Thus, `cp_molar` and `entropy_molar` return J/mol/K, while
`enthalpy_molar` returns J/mol. A lookup outside all NASA7 segments raises a
typed `ThermoError::NoThermoSegment` instead of extrapolating a coefficient
set.

## Compact Parser Subset

`parser.parse_nasa7_thermo` intentionally accepts a compact, line-oriented
subset rather than fixed-column NASA or Chemkin files. Every species record has
three non-empty lines:

```text
name phase low mid high
LOW  a1 a2 a3 a4 a5 a6 a7
HIGH a1 a2 a3 a4 a5 a6 a7
```

`phase` is `G`, `L`, or `S`; the temperature bounds must satisfy
`low <= mid <= high`; and the parser requires exactly seven coefficients in
each row. It reports malformed input with `ThermoError::ParseError`, including
line and column information. The parser currently derives the molecular formula
from `name`, so names must be parseable as chemical formulas. It does not read
fixed-width records, compositions, transport properties, or metadata fields.

## Heat-Balance Solver

`solve_bisection` solves a scalar root only after confirming that the endpoint
values bracket a sign change. It repeatedly halves the interval until either
the residual magnitude or interval width is within the supplied tolerance, and
raises `ThermoError::SolverFailed` for invalid brackets or exhausted iteration
budgets.

`adiabatic_flame_temperature` applies that method to a simplified constant-
pressure enthalpy balance: reactant enthalpy at the initial temperature equals
product enthalpy at the final temperature. The calculation is an equilibrium-
free, dissociation-free estimate constrained by the available NASA7 ranges and
the supplied temperature bracket. It is useful for reproducible examples, not
a replacement for a full combustion-equilibrium solver.

See [data sources](data-sources.md) for the bundled coefficient provenance.
