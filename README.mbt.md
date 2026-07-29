# moonbit-thermochem

Thermochemical property calculations for MoonBit.

Status: Work in progress.

This package provides NASA polynomial data models, species Cp/H/S evaluation, reaction enthalpy calculation, and small reproducible examples for combustion and ammonia synthesis.

```mbt nocheck
moon add Hjyyutr/moonbit-thermochem
```

## CLI demo

Run the deterministic examples from a checkout:

```bash
moon run cmd/thermochem -- species CH4 1200
moon run cmd/thermochem -- reaction methane-combustion 298.15
moon run cmd/thermochem -- flame methane-air 298.15
moon run cmd/thermochem -- ammonia 700
```
