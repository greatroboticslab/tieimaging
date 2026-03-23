# TIE Phase Retrieval (MATLAB)

## Overview
This project reconstructs phase information using the Transport of Intensity Equation (TIE).  
Images are captured at different focus positions and processed in MATLAB.

---

##  Files in This Repository

- `run_TIE.m` → Main script (run this file)
- `TIE_simple.m` → Core TIE equation solver
- `Tie Instructions` → Notes for how the process works

---

## ⚙️ How to Run the Code

1. Open MATLAB  
2. Navigate to this folder  
3. Make sure your images are in the folder  
4. Run:

```matlab
run_TIE
```

---

##  Data Collection (Experiment Steps)

To run this experiment, you must collect **3 images**:

1. **I0 (In Focus Image)**
   - This is the sharpest image (best focus)

2. **I+ (Forward Image)**
   - Move the lens slightly forward from focus  
   - Capture image  

3. **I- (Backward Image)**
   - Move the lens slightly backward from focus  
   - Capture image  

Example in MATLAB:

```matlab
I_plus  = imread('zplus copy.JPG');
I0      = imread('I04 copy.JPG');
I_minus = imread('zminus copy.JPG');
```

---

##  How the Code Works

### run_TIE.m
- Loads images  
- Sets parameters  
- Reduces noise  
- Computes intensity differences  
- Calls the TIE solver  

### TIE_simple.m
- Implements the Transport of Intensity Equation  
- Uses intensity and its derivative  
- Reconstructs the phase  

---

##  Results

(Add your result image here)

---

##  Notes
- Make sure images are aligned  
- Use consistent lighting  
- Small movement between images is important  

---

##  Acknowledgements
Dr. Hongbo Zhang for guidance  
MTSU Department of Physics and Astronomy  
