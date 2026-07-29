# Development Retrospective

## Architectural Choices

The project was organized around a small root library before adding data,
parsing, examples, and a CLI. This makes the thermodynamic model usable with
other data sources and keeps the bundled data from becoming an implicit
dependency of numerical calculations. Typed `ThermoError` values carry
recoverable failures such as missing species, invalid temperature ranges,
parser errors, and solver failures.

NASA7 coefficients were represented as temperature-ranged segments. That
matches the source data, permits explicit range validation, and keeps the
conversion from dimensionless polynomials to SI molar quantities in one place.
The reaction API calculates products minus reactants with stoichiometric
coefficients; bisection was selected for the example heat balance because its
bracketing behavior is transparent and predictable.

## Development Process

Development used iterative implementation and verification, including
AI-agent assistance for code exploration, draft generation, and command
execution. The project remains a human-directed work product: the repository
does not attribute authorship to automated tools or invent additional
contributors. Changes were reviewed against the public API, data provenance,
and target-specific MoonBit checks.

The compact parser and deterministic CLI were deliberately scoped to make the
example workflows easy to reproduce. Keeping those boundaries explicit avoided
presenting a small demonstration data set as a general chemical-kinetics or
equilibrium package.

## References

The bundled NASA7 coefficients are transcribed from Cantera's public
[GRI-Mech 3.0 `gri30.yaml` at Cantera v3.0.0](https://raw.githubusercontent.com/Cantera/cantera/v3.0.0/data/gri30.yaml).
The polynomial convention is cross-referenced with
[NASA/TP-2002-211556](https://ntrs.nasa.gov/citations/20020085330). The exact
data scope, provenance, and derived formation-enthalpy convention are recorded
in [data-sources.md](data-sources.md).

## Known Limitations

- The bundled data set contains eight gas species only and is intended for
  examples, not comprehensive mechanism work.
- The parser accepts only the documented compact three-line NASA7 subset; it
  does not support fixed-column NASA/Chemkin records or species metadata.
- Parser-produced species use `0.0` for molar mass and formation enthalpy,
  because those fields are absent from the compact input format.
- NASA7 evaluation rejects temperatures outside a species' available segments
  rather than extrapolating.
- The flame-temperature calculation omits dissociation, phase changes, heat
  loss, pressure effects, and equilibrium composition.
