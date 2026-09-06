# ANSYS Workbench Automation Via MATLAB

A simple programmatic workflow to automate parametric ANSYS Workbench simulations directly from MATLAB without requiring additional licenses.

## Overview
This script was used as a black-box objective function in an optimization algorithm, where the variables are dynamically injected into the ANSYS Workbench journal, which runs the simulation and the outputs are extracted from a CSV file.

## Workflow setup
1. Record Journal: Start recording the script in ANSYS Workbench from loading file -> inputting parameters -> Extracting csv table
2. Template parameters: Save the base journal and replace the target numerical values with placeholder strings ("Inner" and "Outer" in my case)
3.  Run the script: Call the function in MATLAB with desired inputs.

