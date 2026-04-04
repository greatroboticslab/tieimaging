# TIE Phase Retrieval (MATLAB)

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
   Light → LCD → Lens → Camera  
2. (Optional) Display a pattern on the LCD using Arduino  
3. Capture the following images:

- I₀ (In-Focus Image)  
  - Sharpest image (best focus)

- I⁺ (Forward Defocus)  
  - Move lens +5 mm forward  
  - Capture image  

- I⁻ (Backward Defocus)  
  - Move lens –5 mm backward  
  - Capture image  

Important:
- Keep lighting constant  
- Ensure images are aligned  
- Use small, controlled movements  

---

## MATLAB Reconstruction

### Files
- run_TIE.m → Main script  
- TIE_simple.m → Core TIE solver  

### How It Works
- Loads intensity images  
- Applies preprocessing (noise reduction)  
- Computes intensity derivative ∂I/∂z  
- Solves the TIE  
- Outputs a 2D phase map and 3D surface  

---

## How to Run

1. Open MATLAB  
2. Navigate to the project folder  
3. Place your images in the folder  
4. Update filenames in run_TIE.m:

```matlab
I_plus  = imread('zplus.JPG');
I0      = imread('I0.JPG');
I_minus = imread('zminus.JPG');
