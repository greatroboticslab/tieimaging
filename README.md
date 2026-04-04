# TIE Phase Retrieval (MATLAB)

## Table of Contents
- [Overview](#overview)
- [Methods](#methods)
  - [Data Collection](#data-collection)
  - [Equipment](#equipment)
  - [Procedure](#procedure)
- [MATLAB Reconstruction](#matlab-reconstruction)
  - [Files](#files)
  - [How It Works](#how-it-works)
- [How to Run](#how-to-run)
- [Results Output](#-results-output)
- [Repository Contents](#-repository-contents)
- [Notes](#-notes)
- [Future Work](#-future-work)
- [Acknowledgements](#-acknowledgements)

---

## Overview

This project implements the Transport of Intensity Equation (TIE) to reconstruct phase information from intensity-only measurements.
The experiment characterizes a low-cost LCD-based spatial light modulator (SLM). By analyzing intensity changes across slightly defocused images, the algorithm reconstructs a 3D phase map of the LCD surface.

### The phase reconstruction reveals:
- Surface texture and non-uniformities of the LCD
- Intensity variations from Arduino-controlled patterns
- Optical behavior of a low-cost SLM system

---

## Methods

### Data Collection

To perform TIE reconstruction, capture three intensity images using an optical setup.

#### Equipment
- Light source (laser or LED)
- LCD (used as SLM)
- Lens
- Camera
- Optical rail (for precise positioning)

#### Procedure

1. Align the system:
   **Light → LCD → Lens → Camera**

2.  Display a pattern on the LCD using Arduino

3. Capture the following images:

| Image | Description | Action |
|-------|-------------|--------|
| **I₀** | In-Focus Image | Sharpest image (best focus) |
| **I⁺** | Forward Defocus | Move lens +5 mm forward, capture image |
| **I⁻** | Backward Defocus | Move lens –5 mm backward, capture image |

> **Important:**
> - Keep lighting constant
> - Ensure images are aligned
> - Use small, controlled movements

---

## MATLAB Reconstruction

### Files

| File | Purpose |
|------|---------|
| `run_TIE.m` | Main script |
| `TIE_simple.m` | Core TIE solver |

### How It Works

1. Loads intensity images
2. Applies preprocessing (noise reduction)
3. Computes intensity derivative ∂I/∂z
4. Solves the TIE
5. Outputs a 2D phase map and 3D surface

---

## How to Run

1. Open MATLAB
2. Navigate to the project folder
3. Place your images in the folder
4. Update filenames in `run_TIE.m`:
```matlab
I_plus  = imread('zplus.JPG');
I0      = imread('I0.JPG');
I_minus = imread('zminus.JPG');
```

---

## Results Output

### Includes:
- Phase map of the LCD
- 3D surface reconstruction
- Visualization of intensity variations

### Applications:
- Analyze surface irregularities
- Study optical distortions
- Evaluate LCD pattern response

---

##  Notes

- Ensure images are well-aligned
- Use consistent illumination
- Keep defocus distance small (~5 mm)
- Avoid vibrations during capture
- Normalize intensity if needed

---

##  Future Work

- Test additional LCD patterns and voltages
- Improve noise filtering and stability
- Compare with interferometric methods
- Automate alignment and preprocessing

---

##  Acknowledgements

- **Dr. Hongbo Zhang** — Mentorship and guidance
- **Middle Tennessee State University (MTSU)**, Department of Physics and Astronomy
