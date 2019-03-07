# Wine_EEMF

The "training" folder contains code and raw data for building and validating the universal wine PARAFAC model.

* "Global_model.m" : Pipeline for global model training and validation
* "EEMF_505_Wines.zip" : Corrected EEMF raw data of 505 wine samples
* "Sample_List.xlsx": Metadata of 505 wines 
* "Summary": Excel files containing scores and loading spectra of the global and 5 individual models

The "testing" folder contains testing data and projected Fmax scores:

* "EEMF_25_Chardonnay.zip" : Corrected EEMF raw data of Chardonnay test samples
* "EEMF_36_Chasselas.zip" : Corrected EEMF raw data of Chasselas test samples
* "Projected_Fmax.xlsx" : Fmax obtained by projecting test data on global and Chardonnay models
