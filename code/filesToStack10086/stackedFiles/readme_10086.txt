###################################
########### Disclaimer ############
This is the most recent readme publication based on all site-date combinations used during stackByTable.
Information specific to the query, including sites and dates, has been removed. The remaining content reflects general metadata for the data product.
##################################

This data package been produced by and downloaded from the National Ecological Observatory Network (NEON). NEON is funded by the National Science Foundation (Awards 0653461, 0752017, 1029808, 1138160, 1246537, 1638695, 1638696, 1724433) and managed cooperatively by Battelle. These data are provided under the terms of the NEON data policy at https://www.neonscience.org/data-policy.
DATA PRODUCT INFORMATION
------------------------
ID: NEON.DOM.SITE.DP1.10086.001
Name: Soil physical and chemical properties, periodic
Description: Soil physical and chemical properties from the top 30 cm of the profile from periodic soil core collections. Data are reported by horizon (mineral vs. organic). See initial characterization and megapit products for additional soil data.
NEON Science Team Supplier: Terrestrial Observation System
Abstract: This data product contains the quality-controlled, native sampling resolution data from NEON's periodic soil sampling, as well as measurements of pH, moisture, chemistry, and stable isotopes. Samples collected as part of this product are also used for microbial measurements; those data can be found in associated data products.
Soil is defined as the upper layer of the earth's surface where plants grow and consists of decomposing organic material and inorganic particles such as clay and rock. Soils are sampled by horizon type (organic or mineral) to a maximum depth of 30cm. Following field collection, all soils are measured for moisture and pH, and a subset are also measured for microbial abundance and composition, inorganic nitrogen (N) pools and total soil organic carbon (C) and nitrogen (N) by external laboratories. Frozen soil for the microbial archive is also collected for many samples, and during peak greenness chemistry bouts, excess air-dried soil is archived as well in the NEON Biorepository and available upon request. For additional details, see the user guides, protocols, and science designs listed in the Documentation section below. Queries for this data product will return field collection metadata as well as physical and chemical measurements for the specified sites within the specified date range. Summary tables of external lab precision and accuracy for chemistry and stable isotope analyses are included in the expanded package. This data product also provides field and laboratory metadata that can be associated with soil microbial data products; refer to the documentation for the respective soil microbe data products for more details.
Latency:
The expected time from data and/or sample collection in the field to data publication is as follows, for each of the data tables (in days) in the downloaded data package. See the Data Product User Guides for more information.
sls_bgcSubsampling:  90
sls_metagenomicsPooling:  90
sls_soilCoreCollection:  90
sls_soilMoisture:  90
sls_soilpH:  90
sls_soilChemistry: 270
bgc\_CNiso\_externalSummary: 30 
 
ntr_internalLab: 90 
ntr_internalLabBlanks: 90
ntr_externalLab: 180 
ntr_externalSummary: 30
Brief Design Description: Three pre-determined, randomly assigned locations are selected for each sampling event at each of 10 plots distributed throughout a site; sampling locations within a plot are not re-sampled. Soil sampling occurs 1-3 times per year depending on length of growing season, with each site always sampled during the historic peak in vegetation greenness. Soil samples are collected to a maximum depth of 30 cm, with organic and mineral soils sampled separately. The type of device used to collect soils varies based on local soil types and seasonal conditions and is recorded for each sample. In-situ soil temperature is measured, soil samples are homogenized in the field, and subsamples destined for microbial archive and/or analyses are immediately frozen on dry ice. Gravimetric soil moisture and soil pH analyses are conducted at NEON regional laboratories. Every five years, inorganic N pools (NH4+ and NO3-) are measured on fresh and field-incubated soil cores using KCl extractions, during all bouts of that year. The difference in N concentration between initial and incubated samples can be used to estimate net N transformation rates, see https://github.com/NEONScience/NEON-Nitrogen-Transformations. Every five years, peak greenness subsamples are analyzed for total organic carbon and total nitrogen concentrations and stable isotopes.
Brief Study Area Description: These data are collected at all NEON terrestrial sites with sufficient soil depths to enable sampling.
Sensor(s): 
Keywords: nitrogen (N), moisture, biogeochemistry, pH, temperature, carbon (C), water, stable isotopes, microbial biomass, soil, microbes
Domain: D17
DATA PACKAGE CONTENTS
---------------------
This folder contains the following documentation files:
This data product contains up to 11 data tables:
- Term descriptions, data types, and units: NEON.D17.TEAK.DP1.10086.001.variables.20220516T160452Z.csv
sls_soilMoisture - Soil moisture data for microbial and biogeochemical samples
sls_soilChemistry - External lab analysis of carbon and nitrogen concentrations in soil
sls_bgcSubsampling - Processing data for soil subsamples for biogeochemical analysis and archiving
sls_metagenomicsPooling - Sample information for soil subsamples collected for metagenomics analysis
sls_soilCoreCollection - Field data of soils collected for microbial or biogeochemistry sampling
sls_soilpH - Soil pH data for microbial and biogeochemical samples
ntr_externalLab - External lab analysis of inorganic nitrogen concentrations in kcl extracts
bgc_CNiso_externalSummary - Long-term uncertainty values for analysis of carbon and nitrogen concentrations and stable isotopes
ntr_internalLab - NEON domain lab potassium chloride extraction data for initial and final soil cores
-----------------------
NEON data files are named using a series of component abbreviations separated by periods. File naming conventions for NEON data files differ between NEON science teams. A file will have the same name whether it is accessed via NEON's data portal or API. Please visit https://www.neonscience.org/data-formats-conventions for a full description of the naming conventions.
ISSUE LOG
----------
This log provides a list of issues that were identified during data collection or processing, prior to publication of this data package. For a more recent log, please visit this data product's detail page at https://data.neonscience.org/data-products/DP1.10086.001.
Issue Date: 2020-09-16
Issue: Nitrite in blanks: In some nitrogen transformation data, blank-corrected sample concentration values appear significantly negative, meaning more inorganic N was detected in procedural blanks compared to samples. Extensive troubleshooting has revealed that certain batches of potassium chloride (KCl) used by NEON for extractions have high levels of nitrite, which is chemodenitrified (abiotically converted to nitrogen gas and lost) in the presence of acidic soil, but not in blanks (Homyak et al. 2015). This artifact is what causes the significant negative values and greatly reduces sensitivity of the method for low-concentration sites. NEON has tried to solve this issue but has not yet been able to find a reliable solution.
       Date Range: 2017-01-01 to 2022-02-23
       Location(s) Affected: DEJU, DELA, DSNY, GRSM, HARV, JERC, LENO, MLBS, NIWO, PUUM, SERC, SOAP, STEI, TALL, TEAK, UNDE, WREF
Resolution Date: 
Resolution: Either find a reliable source of nitrite-free KCl to use for extractions, or spin up a method to purify the KCl ourselves. This is an ongoing issue that will be updated when more details are available. Any samples with concentration values that blank-correct to < -0.02 mgN/L are flagged with 'blanks exceed sample value' in the nitrateNitriteNQF field, and end users can decide how to treat these data.
Issue Date: 2021-01-06
Issue: Safety measures to protect personnel during the COVID-19 pandemic resulted in reduced or eliminated sampling activities for extended periods at NEON sites. Data availability may be reduced during this time.
       Date Range: 2020-03-23 to 2021-06-01
       Location(s) Affected: All
Resolution Date: 
Resolution: 
Issue Date: 2021-03-17
Issue: A publication error resulted in empty data files for a single site and month of data. These data will be restored in RELEASE-2022.
       Date Range: 2019-06-01 to 2019-06-30
       Location(s) Affected: TALL
Resolution Date: 
Resolution: 
Issue Date: 2022-02-18
Issue: sampleID format change: The unique sampling location for each soil core had been included in the primary sample identifier (sampleID) for soil samples and all downstream subsample IDs. Specifically, sampleIDs included the distance east and north of the southwest corner of a plot (in meters). However, including high resolution spatial information in sampleIDs proved problematic when the location was mis-transcribed in the field. Such errors are difficult to detect and very time-consuming to correct.
       Date Range: 2013-01-01 to 2022-02-01
       Location(s) Affected: All
Resolution Date: 2022-02-01
Resolution: To improve data accuracy and data QAQC efficiency, the precise sampling locations are no longer included in the sampleID, and the subplot number is used instead (a choice of 21, 23, 39, and 41). The remainder of the sampleID is unchanged, including the plot, soil horizon, and collect date components. Soil core sampling coordinates are still available in the `sls_soilCoreCollection` table in the `coreCoordinateX` and `coreCoordinateY` fields.
Issue Date: 2020-12-01
Issue: Due to a miscommunication, samples analyzed for carbon (C) and nitrogen (N) concentrations and stable isotopes were not re-dried prior to weighing and analysis at the external lab. While all NEON soil samples are dried at 65C in the domain labs, they are often then stored for weeks to months before being shipped to or analyzed by external labs. During this time they may accumulate moisture, especially in humid areas. Subsequent testing revealed that for organic horizons, %C data are likely underestimated by 1.5-2.5% due to this lack of re-drying prior to analysis. As organic horizon soil samples tend to have high %C (> 20%), this bias may have only minor impacts on many analyses, but is something for end users to keep in mind. For the other parameters (%N, C:N, d15N, d13C) as well as all parameters in mineral horizons, testing suggests there were no detectable differences between re-dried samples and originals.
       Date Range: 2014-01-01 to 2020-07-10
       Location(s) Affected: All sites with organic horizon soil chemistry measurements in this date range, with the exception of PUUM whose tissues were re-dried for permitting/quarantine reasons.
Resolution Date: 2020-11-10
Resolution: Affected O-horizon data have been flagged with dataQF = dryingProtocolError in the `sls_soilChemistry` table. For sample analysis dates starting in November 2020, all carbon-nitrogen samples (both mineral and organic horizons) are re-dried at 65C prior to analysis to drive out any residual moisture and improve data accuracy for % C. Samples collected in 2020 may have been analyzed before or after the change; check dataQF to determine which individual samples are affected.
Issue Date: 2020-10-02
Issue: Until October 2020, soil physical and chemical properties were published as separate data products.
       Date Range: 2013-01-01 to 2020-10-02
       Location(s) Affected: All terrestrial sites.
Resolution Date: 2020-10-06
Resolution: In October 2020, data tables for physical and chemical properties were bundled together in a single data product for improved usability. This applies to all existing and future data.
Issue Date: 2020-10-12
Issue: Prior to the 2020 field season, there was no mechanism to indicate when and why a scheduled sampling event may have been missed.
       Date Range: 2013-01-01 to 2020-02-06
       Location(s) Affected: All terrestrial sites
Resolution Date: 2020-02-06
Resolution: Starting in the 2020 field season, NEON added the field samplingImpractical to the `sls_soilCoreCollection` table of this data product to assist users in understanding when data for this product are temporarily missing versus permanently unavailable. If field collection of soil from a specific subplot within an assigned soil plot was not possible, samplingImpractical is populated with a value other than 'OK' (e.g., 'location flooded' or 'logistical') and only minimal metadata are recorded.
Issue Date: 2020-09-16
Issue: In 2017, the first year nitrogen transformation data were collected, Type II (1 Mohm) water was used to create 2M KCl solutions and conduct extractions. However, this purity is not sufficient and Type I water (18.2 Mohm) has been used for all bouts conducted from 2018 onward. 2017 data was thus collected using a deprecated method and has been flagged accordingly. Moreover, 2 sites extracted in 2017 (JORN AND MOAB) had extremely high ammonium concentrations in both samples and blanks (> 1 mg/L) due to this use of less purified water. These data were deemed unusable, thus values were removed and the records have an additional flag.
       Date Range: 2017-01-01 to 2018-01-01
       Location(s) Affected: KONZ, JORN, MOAB, ORNL, SCBI, STEI, STER, TOOL, TALL
Resolution Date: 2018-01-01
Resolution: Type I water (18.2 Mohm) has been used for all nitrogen transformation bouts conducted from 2018 onward, and 2017 records have been flagged.
ADDITIONAL INFORMATION
----------------------
A record from `sls_soilCoreCollection` may have zero or one child records in `sls_soilpH` and `sls_soilMoisture`; a given `sls_soilCoreCollection.sampleID` is expected to be sampled one time per collectDate (local time). Depending on the type of bout and time of year, a record from `sls_soilCoreCollection` may have zero or one child records in `sls_metagenomicsPooling`, `sls_bgcSubsampling`, and `ntr_internalLab`. Each child record from `ntr_internalLab` may appear from zero to two times in the `ntr_externalLab` table, and each child record from `sls_bgcSubsampling` may appear from one to four times in `sls_soilChemistry` (depending on analytical replicates and sample pretreatment for bulk C and N). The information needed to link procedural blanks with sample KCl extracts is provided in `ntr_externalLabBlanks`, and paired fresh/incubated samples can be linked through the `ntr_internalLab.incubationPairID`. Duplicates may exist where protocol and/or data entry aberrations have occurred; users should check data carefully for anomalies before joining tables.
NEON DATA POLICY AND CITATION GUIDELINES
----------------------------------------
A citation statement is available in this data product's detail page at https://data.neonscience.org/data-products/DP1.10086.001. Please visit https://www.neonscience.org/data-policy for more information about NEON's data policy and citation guidelines.
DATA QUALITY AND VERSIONING
---------------------------
NEON data are initially published with a status of Provisional, in which updates to data and/or processing algorithms will occur on an as-needed basis, and query reproducibility cannot be guaranteed. Once data are published as part of a Data Release, they are no longer provisional, and are associated with a stable DOI. 
To learn more about provisional versus released data, please visit https://www.neonscience.org/data-revisions-releases.
