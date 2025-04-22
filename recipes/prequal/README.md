----------------------------------
## prequal/1.1.0 ##
PreQual is a quality assurance pipeline for diffusion-weighted MRI (DWI) data.

PreQual (formerly dtiQA_v7) is a set of scripts and python tools for quality assurance of diffusion MRI data, including assessments of signal dropouts, excessive motion, and artifacts.

Example:
```
run_dtiQA.sh
```

More documentation can be found here: https://github.com/MASILab/PreQual

To run applications outside of this container: ml prequal/1.1.0

Citation:
```
Schilling KG, Blaber J, Hansen C, Cai L, Rogers B, Anderson AW, Smith S, Kanakaraj P, Rex T, Vorburger RS, Landman BA. Distortion correction of diffusion weighted MRI without reverse phase-encoding scans or field-maps. PLoS One. 2020 Jul 10;15(7):e0236418. doi: 10.1371/journal.pone.0236418. PMID: 32649716; PMCID: PMC7351182.
```

--------------------------------------------------------------------
## prequal/1.1.0 ##
PreQual: Automated Quality Assurance Pipeline for Diffusion MRI

PreQual is an automated quality assurance pipeline for diffusion weighted MRI developed by the MASI Lab at Vanderbilt University. It provides comprehensive preprocessing and quality control, including:

- Susceptibility-induced distortion correction
- Eddy current-induced distortion correction 
- Motion correction
- Gradient nonlinearity correction
- Denoising
- Quality metrics generation
- Extensive visual reports

### Requirements
- Python 3.6 (for synb0)
- Python 3.8 (for dtiQA and gradtensor)
- MRtrix3 (v3.0.3) with OpenMP support
- FSL (v6.0.4)
- ANTs with parallel processing support
- Convert3D (v1.0.0)
- FreeSurfer (v6.0.0)
- Matlab Runtime (R2017a)
- CMake (v3.23.0) with SSL support

### Example Usage
```bash
xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" bash /CODE/run_dtiQA.sh /INPUTS /OUTPUTS
```

### Input/Output
- Input data should be mounted to `/INPUTS`
- Output will be written to `/OUTPUTS`
- Additional files can be placed in `/SUPPLEMENTAL`

### Build Dependencies
The container requires these system libraries:
- Qt5 development tools (for MRtrix3 GUI)
- FFTW3 libraries
- OpenSSL development libraries
- Threading libraries (OpenMP, pthreads)
- OpenGL/Mesa development libraries

### Notes
- Virtual framebuffer (Xvfb) is required for visualization components
- A FreeSurfer license is included for container functionality 
- OpenMP parallelization is enabled for better performance
- CMake is built with SSL support for secure downloads

For detailed usage instructions and documentation, visit:
https://github.com/MASILab/PreQual

### Citation
```
Liu, Z., Zhang, Y., He, B., Yan, H., & Landman, B. A. (2021). PreQual: An automated pipeline for integrated preprocessing and quality assurance of diffusion weighted MRI images. Magnetic Resonance Imaging, 83, 328-340.
```

### License
MIT License
----------------------------------