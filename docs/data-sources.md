# Built-In Species Data Sources

The `data` package intentionally bundles only eight gas species: `CH4`, `O2`,
`N2`, `CO2`, `H2O`, `CO`, `H2`, and `NH3`. Their two-region NASA7
coefficients are transcribed from Cantera's public
[GRI-Mech 3.0 `gri30.yaml` at Cantera v3.0.0](https://raw.githubusercontent.com/Cantera/cantera/v3.0.0/data/gri30.yaml)
file. The same file identifies the source as GRI-Mech Version 3.0, released on
1999-07-30, and labels the records as NASA7.

NASA Glenn's [NASA/TP-2002-211556](https://ntrs.nasa.gov/citations/20020085330)
documents the related CEA convention: a seven-term heat-capacity polynomial
with integration constants for enthalpy and entropy. This package uses the
root package's compatible `Nasa7Segment` representation.

The `formation_enthalpy` fields are derived at 298.15 K from the same low
temperature NASA7 coefficients using the root package's enthalpy equation.
This is inside the declared range for every bundled species except `N2`, whose
record begins at 300 K; its stored value is therefore a 1.85 K extrapolation
for convenience metadata. The molar masses use conventional atomic weights from the
[NIST periodic table](https://physics.nist.gov/PhysRefData/PeriodicTable/).

## Limitation

This is a small bundled demonstration subset for examples and tests, not a
complete curated NASA Glenn/CEA import or an authoritative thermochemical
database. The reported temperature ranges are copied with the selected records:
`200-1000-3500 K` for `CH4`, `O2`, `CO2`, `H2O`, `CO`, and `H2`;
`300-1000-5000 K` for `N2`; and `200-1000-6000 K` for `NH3`. Applications
requiring validated production data should import and curate a complete source
table appropriate to their chemical system.
