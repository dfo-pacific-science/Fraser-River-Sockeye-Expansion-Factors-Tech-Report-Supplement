# Fraser Sockeye Calibration

This repository accompanies the Canadian Technical Report:



Arbeider, M … 2026. Assessment and redevelopment of visual survey expansion factors and a summary of current interpolation methods for estimating Fraser River Sockeye (*Oncorhynchus nerka*) spawner estimates. Can. Tech. Rep. Fish. Aquat. Sci. 3767: vi + 119 p.



## Context

The report provides a systematic reassessment and update of expansion factors for estimating Fraser River Sockeye (*Oncorhynchus nerka*) spawning abundance (escapements). Accurate and precise spawner abundance data are fundamental for Pacific salmon management and conservation, impacting implementation the Wild Salmon Policy, Fish Stock Provisions of the Fisheries Act, and the Pacific Salmon Treaty. Historically, lower-cost visual survey methods have been prone to bias and uncertain accuracy, primarily due to application of an overgeneralized expansion factor of 1.8 for Fraser River Sockeye. Escapement estimates have been altered post-hoc to account for expected biases through a Run-Size-Adjustment process facilitated by the Fraser River Panel Technical Committee; which originally identified a need for this reassessment. This report introduces a methodical approach to select more appropriate, system-characteristic-specific expansion methods, using a paired-estimates database and multiple statistical models. The updated approach reduced bias and minorly improved accuracy, offering more reliable estimates for conservation and management. Test application to the 2024 data revealed several caveats and limitation of the updated expansion framework and resulted in the creation of application decision rules.



The code is designed to reproduce the analysis steps, results, tables and figures, and not the report itself.

File 04-03-Calibration-Application-Tool.Rmd, along with several of the r\_objects created by this analysis are what are required to created visual-based expanded estimates based on a standardized input template, of which 2024 was used as the example.



## Folders \& Files

* data: contains original datasets created by area staff and published to the government Open Data Portal:
* r\_objects: contains RDS files that are created throughout the analysis and recalled at later steps of the analysis. RDS preserves the structure and attributes of the R ecosystem. The models subfolder contains the models that are recalled to apply to data in subsetquent steps.
* figures: contain summary figures and subfolders associated with each step with their associated figures.
* tables: contains tables used to populate tables in the report and appendices. CSV files are R outputs and XLSX are formatted versions of CSV files.



## Code

Code is organized into four major sections:

* 00: Functions, Data Wrangling, and Exploration. Functions are later called throughout the code. Wrangled data is saved as an RDS that is called throughout the code.
* 01: Model development and the creation of Leave-One-Out outputs that are saved in the r\_objects folder as "01\_Model\_Ranks\_from\_\[Model Descriptive Name].rds"

  * Each "class" of model has a sub-designated script as well as each "specialized" model denoted by 01-##-\[Model Class]. This sub-designation aligns with tables and figures produced by each script.

* 02: Calculation and creation of Rank-Sets that align with equations 2-4 of the report. Appendix figures saved in 02\_Rank\_Summaries and 02\_Out\_of\_Range\_Rank\_Summaries for each subscript, respectively.
* 03: Code associated with the application and summary of the updated expansion methods to the training data.

  * 03-01 aggregates all of the model RDS files and associated model-specific data treatments to apply each model.
  * 03-02 is the application of the model application decision tree (see Figure 2 in the report) to the training data.
  * 03-03 creates the summary statistics reported in sections 3.1.1 and 3.1.2 of the Report.

* 04: Code associated with testing the updated methods to the 2024 data reported in section 3.1.3.

  * 04-01: Application of the methods without consideration for "out-of-range" data points.
  * 04-02: Summary of 04-01 results, reported at the top of section 3.1.3.
  * 04-03: Main "product" of the report that contains the finalized decision tree script that can be adapted for application to all future or historical data once formated into the appropriate data input file. This script applies it to the 2024 data.
  * 04-04: Summary of 04-03 results, reported at the end of section 3.1.3.
