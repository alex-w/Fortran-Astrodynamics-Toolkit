![Fortran Astrodynamics Toolkit](media/logo.png)
============

[![GitHub release](https://img.shields.io/github/release/jacobwilliams/Fortran-Astrodynamics-Toolkit.svg?style=plastic)](https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/releases/latest)
[![DOI](https://zenodo.org/badge/21782788.svg)](https://zenodo.org/badge/latestdoi/21782788)
[![Build Status](https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/actions/workflows/CI.yml/badge.svg)](https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/actions)
[![codecov](https://codecov.io/gh/jacobwilliams/Fortran-Astrodynamics-Toolkit/branch/master/graph/badge.svg?token=BHtd51oUTE)](https://codecov.io/gh/jacobwilliams/Fortran-Astrodynamics-Toolkit)

![Image](https://raw.githubusercontent.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/master/tests/pork_chop/pork_chop.png)

## Overview

The goal of the Fortran Astrodynamics Toolkit is to produce a comprehensive library, written in modern Fortran (Fortran 2008+), of all the standard orbital mechanics algorithms.  This is a work in progress.  Currently-implemented and proposed capabilities include:

 * Lambert solvers
   - [x] Gooding
   - [x] Izzo
   - [x] Arora
 * Kepler propagators
   - [x] Gooding
   - [x] Shepperd
   - [x] Goodyear
 * ODE solvers (with event-finding)
   - [x] Runge-Kutta
   - [ ] Nystrom
   - [ ] Adams
 * Force models
   - [ ] point mass gravity field
   - [x] geopotential gravity
   - [ ] solar radiation pressure
   - [ ] atmospheric drag
   - [ ] relativistic effects
 * Reference frames
   - [x] IAU_EARTH
   - [x] IAU_MOON
 * Celestial Body Ephemerides
   - [x] JPLEPH
   - [x] SPICE
   - [x] Analytical Moon w.r.t Earth
   - [x] Analytical solar system primary bodies
 * Alternate equations of motion
   - [x] Circular restricted three-body problem
   - [x] Clohessy-Wiltshire
   - [x] Modified equinoctial elements
 * Misc
   - [x] orbital element conversions
   - [x] halo orbits
   - [ ] targeting and optimization
   - [ ] spacecraft engine models

## Examples

<a href="https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/tree/master/tests/crtbp"><img src="https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/blob/master/tests/crtbp/crtbp_test.png" align="center" height="300"></a>
<a href="https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/tree/master/tests/gravity"><img src="https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/blob/master/tests/gravity/trajectory.png" align="center" height="400"></a>
<a href="https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/tree/master/tests/dro"><img src="https://github.com/jacobwilliams/Fortran-Astrodynamics-Toolkit/blob/master/tests/dro/dros.png" align="center" height="400"></a>

## Building

The Fortran Astrodynamics Toolkit and the test programs will build with any modern Fortran compiler. A [Fortran Package Manager](https://github.com/fortran-lang/fpm) manifest file (`fmp.toml`) is included, so that the library and tests cases can be compiled with FPM. For example:

```
fpm build --profile release
fpm test --profile release
```

A [FoBiS](https://github.com/szaghi/FoBiS) configuration file (`fortran-astrodynamics-toolkit.fobis`) is also provided that can build the library and examples. Use the `mode` flag to indicate what to build. For example:

* To build all the examples using gfortran: `FoBiS.py build -f fortran-astrodynamics-toolkit.fobis -mode tests-gnu`
* To build all the examples using ifort: `FoBiS.py build -f fortran-astrodynamics-toolkit.fobis -mode tests-intel`
* To build a static library using gfortran: `FoBiS.py build -f fortran-astrodynamics-toolkit.fobis -mode static-gnu`
* To build a static library using ifort: `FoBiS.py build -f fortran-astrodynamics-toolkit.fobis -mode static-intel`

The full set of modes are: `static-gnu`, `static-gnu-debug`, `static-intel`, `static-intel-debug`, `shared-gnu`, `shared-gnu-debug`, `shared-intel`, `shared-intel-debug`, `tests-gnu`, `tests-gnu-debug`, `tests-intel`, `tests-intel-debug`

To generate the documentation using [ford](https://github.com/Fortran-FOSS-Programmers/ford), run: ```FoBis.py rule --execute makedoc -f fortran-astrodynamics-toolkit.fobis```

## Third-Party Requirements

A script `get_third_party.sh` is included to download and build the third-party dependencies on unix-like operating systems.

### Pyplot-Fortran

The plots generated by the examples are done using the [pyplot-fortran](https://github.com/jacobwilliams/pyplot-fortran) module. When compiling with FPM, this will automatically be downloaded and compiled. If using FoBiS, you must obtain this manually.

### Ephemeris files

To use the ephemeris_module, a copy of one of the JPL binary ephemeris files must be present in the ```eph``` directory.  This can be built from the instructions at: ftp://ssd.jpl.nasa.gov/pub/eph/planets/fortran/userguide.txt.  For example (on Linux):
```bash
wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/fortran/*
wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/de405/*
#edit asc2eph.f file to set NRECL = 4:
sed -i '_original' '/^C.*PARAMETER ( NRECL = 4 )/s/^C//' asc2eph.f
gfortran asc2eph.f -o asc2eph
cat header.405 ascp*.405 | ./asc2eph
mkdir Fortran-Astrodynamics-Toolkit/eph
mv JPLEPH Fortran-Astrodynamics-Toolkit/eph/JPLEPH.405
```

### Geopotential files

To use the geopotential_module, you need a geopotential model file (for example ```GGM03C.GEO``` from ftp://ftp.csr.utexas.edu/pub/grace/GGM03/GGM03_Archive.zip). This should be placed in the ```grav``` directory.  For example:
```bash
wget http://download.csr.utexas.edu/pub/grace/GGM03/GGM03_Archive.zip
unzip GGM03_Archive.zip
mkdir Fortran-Astrodynamics-Toolkit/grav
cp GGM03_Archive/GGM03C.GEO Fortran-Astrodynamics-Toolkit/grav
```

## Documentation

The documentation for the latest code in `master` can be found [here](http://jacobwilliams.github.io/Fortran-Astrodynamics-Toolkit/).

## See also

 * [SPICE](http://naif.jpl.nasa.gov/naif/toolkit.html)
 * [NOVAS](http://aa.usno.navy.mil/software/novas/novas_info.php)
 * [SOFA](http://www.iausofa.org)
 * [astro-fortran](https://github.com/jacobwilliams/astro-fortran)
 * [LLEA](https://github.com/helgee/LLEA)
 * [poliastro](https://github.com/poliastro/poliastro)