# NEON metadata from pilot study with JGI

This folder contains metadata tables for the samples sequenced and analyzed by JGI for a pilot study in 2023. Additional metadata will be added soon. For each new set of data, tables at both the plot and subplot levels will be added, where possible. General site level information will also be added soon. Also included are descriptions of each of the fields in the respective tables 

**Plot and subplot level data**

As NEON metagenomic samples are combined from 1-3 individual samples in a plot (per horizon), the metagenomic sample is presented as a plot-level sample. Most soil measurements are taken from individual samples, therefore to assign a soil measure to the metagenomic sample requires averaging across the measurements of the individual soil samples. Also included in this folder are individual soil measurements for every sample that is used in a composite sample (with the corresponding plot-level composite sample included in the table for reference). For some NEON data products, information is only available at the plot level, and for these only the plot table will be included. 

## Data sets included

Following are brief descriptions of each of the data sets that are being added, along with links for more information. To search for any data products, visit the [NEON Data Portal](https://data.neonscience.org/data-products/explore).

### Soil physical and chemical properties, periodic (DP1.10086.001)

Soil physical and chemical properties from the top 30 cm of the profile from periodic soil core collections. Data are reported by horizon (mineral vs. organic). See initial characterization and megapit products for additional soil data.

For more information: [https://data.neonscience.org/data-products/DP1.10086.001](https://data.neonscience.org/data-products/DP1.10086.001)

Tables included:

- neon_soilChem1_metadata_descriptions.tsv *descriptions of all fields used in the tables*
- neon_plot_soilChem1_metadata.tsv *soil measurements for composite metagenomic samples, measures averaged across all individual samples*
- neon_subplot_soilChem1_metadata.tsv *soil measurements for individual samples that compose each metagenomic composite sample* 

Notes: to average pH measurements, the R `mean_pH` function from the `respirometry` package was used. 

