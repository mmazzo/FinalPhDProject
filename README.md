# PhDProjects
MATLAB codebase for initial cleaning, alignment and calculations performed on EMG, motor unit and force/torque data for PhD projects. Generated various CSV files for statistical analysis, modeling and data visualization in R.

Data structure
---------------------------------------------
Projects involved collection of EMG (muscle activity) data from three calf muscles (soleus, medial gastrocnemius, and lateral gastrocnemius) for:
- 19 participants
- 2 days of data collection per participant
- 6 trials performed on each day (plantar-flexion/ankle extension/calf muscle contractions); 3 trials at two different force levels (10% and 35% of maximum calf strength)
- Each trial consisted of a ~50 seconds of muscle activity data (10-second gradual ramp up in force to a target line + 30-second steady force production + 10-second gradual ramp down)
- Plantar flexion torque/calf muscle strength was recorded with a force transducer in Spike2
- EMG (muscle activity) was recorded with OTBioelettronica systems in OTBioLab
- Motor neuron/motor unit activity was decomposed from the EMG data frome each muscle for each trial with the DEMUSE program

Project Totals:
- 228 trials recorded
- 684 EMG recordings from human calf muscles (228 trials * 3 muscles each)
- 1486 unique motor neurons/motor units were identified in the EMG recordings (average of ~23 per trial)
- ~75% of the motor neurons/motor units were tracked/matched across multiple trials

Code
---------------------------------------------
- The codebase works only for the specific MATLAB data structures used in this project, for which metrics were calculated and added as the project progressed.
- The custom functions and calculations evolved as I performed exploratory analyses and experimented with different models to estimate neural drive to the calf muscles from the cumulative activity of the motor neurons in individual muscles as well as total motor unit activity in the three main calf muscles.
- The resultant manuscript (to be published soon) only utilized only a small portion of the calculations and techniques that I used to explore the characteristics of neural drive to the calf muscles.
- Some quick scripts are included which were used to visualize the data at various stages of the project to explore the data, verify alignment of different data sources, cross-validate new techniques, and check results against previously published works.
