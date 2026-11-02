# TCC-III Engine Case with H2 Combustion and Water Injection (tcc3_comb)

## Overview
This case is a variant of `tutorials/tcc3` for **premixed hydrogen (H2) combustion
with water (steam) injection**, using the OpenFOAM 14 `XiFluid` solver module
(premixed/partially-premixed combustion, engine mesh motion supported) instead of
the cold-flow `fluid` module.

The geometry, engine kinematics (piston/valves), remeshing workflow and mesh
generation are identical to `tcc3`.

## Combustion setup

- **Solver**: `solver XiFluid;` in `system/controlDict` (loaded by `foamRun`).
- **Fuel**: hydrogen, premixed with air at stoichiometric conditions
  (`fu.u = 0.0285` at the inlet, `stoichiometricAirFuelMassRatio 34.074`).
- **Water injection**: modelled as steam dilution of the intake charge through the
  `egr.u` field (`0.orig/egr.u`): 20% mass fraction of H2O at the `inlet` patch.
  Change `inletValue` in `0.orig/egr.u` to vary the injected water amount.
- **Ignition**: spark kernel in the `sparkPlug` cell zone (see
  `constant/zonesGenerator` and `constant/fvModels`), starting at 700 CAD
  (firing TDC is 720/0 CAD), period 720 CAD.
- **Laminar flame speed**: Ravi-Petersen correlation for hydrogen-in-air
  (`constant/combustionProperties`), which includes diluent (EGR/steam) effects.
- **Flame wrinkling**: equilibrium Xi model with Gulder equilibrium relation, cubic
  profile and KTS generation rate.
- **Thermophysical model**: two-phase (unburnt `u` / burnt `b`)
  `uInhomogeneousEGR`/`bInhomogeneous` mixtures with pseudo-species
  `fuel` (H2), `oxidant` (air) and `products` (H2O-rich), JANAF thermodynamics,
  Sutherland transport, perfect gas EOS — see `constant/physicalProperties.u`,
  `constant/physicalProperties.b` and `constant/*_thermo.foam`.

## Case structure

Same as `tcc3`, plus the combustion fields in `0.orig/`:

- `b` — burnt mass fraction (progress variable, 0 = unburnt)
- `Xi` — flame wrinkling factor
- `fu.u` — fuel mass fraction in the unburnt phase
- `ft.b` — fuel mass fraction in the burnt phase
- `egr.u` — diluent (injected water/steam) mass fraction in the unburnt phase
- `T.u`, `T.b` — unburnt/burnt phase temperatures (replaces `T`)
- `alphat.u`, `alphat.b` — turbulent thermal diffusivity per phase (replaces `alphat`)

and in `constant/`:

- `combustionProperties` — laminar flame speed and flame wrinkling models
- `fvModels` — ignition and kernel correction models
- `physicalProperties.u` / `physicalProperties.b` (+ `fuel/oxidant/products_thermo.foam`)
- `momentumTransport.u` / `momentumTransport.b` — turbulence per phase

## Running the case

From the `tutorials/tcc3_comb` directory (OpenFOAM 14 environment sourced):

```bash
./Allclean
./Allmesh  # same meshing workflow as tcc3 (engineDict.coarse by default)
./Allrun
```

## Notes

- The `tracer` field and the port/chamber monitoring functionObjects from `tcc3`
  are kept; `writeObjects(Su, Xi)` and `bXiProgress` are added in `system/functions`.
- For liquid water spray injection (evaporating droplets) instead of steam, a
  Lagrangian parcel coupling would be required on top of `XiFluid`.
