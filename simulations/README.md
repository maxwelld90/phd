# PhD Thesis Code and Results
This directory contains all of the scripts used to generate simulation configurations, analyse simulation results, and code for generating summary tables/graphs. Some scripts used MATLAB as I was short for time, and knew how to do what I needed in MATLAB. With more time, I would have reimplemented everything in a Jupyter Notebook.

## Running the Simulations
Simulations were all run using the SimIIR framework, available on my [supervisor's GitHub page](https://github.com/leifos/simiir). Commit number `c6f5b48cc9916c29f109d5ef74876ff8c073a44c` was used for all experiments reported in my thesis. The [ifind framework](https://github.com/leifos/ifind/) is also required; commit number `d604f1a5d78a9ccd36c57bd03861b1a115df9ab0` was used for that repository.

These experiments were run over 100 cores simultaneously; total compute time was approximately six weeks for all experiments. They require significant computational resources.

## Producing Summary Files
This section of the README is kept for reference. It outlines the pipeline for producing summary files from the simulation output.

### For Chapter 7
`summary_generator_comparisons.py` produces a per query file. This needs to be averaged over to get session data.
This is what the matlab script is for.

### For Chapter 8
* Produce a summary file, containing a clear click depth field. this would be the mean over all queries in a session.
* Run the summary MAT script over that file, to mean over the different trials.
* From there, filter the RW queries using a non-session based results file (i.e. query-based).
* Use the filtered RW file to produce a session-based RW file.
* Use the session summary file and the RW summary file to produce the MSE comp file for sessions.
* This file should also have MSE, cg, number saved, number saved with new.

Use the scripts from chapter 7, session-based ones, to do the plots and tables.