## Fortran NDVI Calculation in GIS & Remote Sensing

This is a project I created in the field of **GIS & Remote Sensing**, focusing specifically on **vegetation index analysis**. The goal of the project is to demonstrate how to process raster data (satellite image bands) using **Fortran** and calculate the **NDVI (Normalized Difference Vegetation Index)**.

## Project Topic

- **Domain:** GIS & Remote Sensing
- **Specific Topic:** Vegetation index analysis from satellite imagery
- **Main Focus:** Computing **NDVI** from Red and NIR bands

## What It Does

- Reads **two ESRI ASCII grid files** (Red and Near Infrared bands).
- Calculates **NDVI (Normalized Difference Vegetation Index)** per cell:
  ```
  NDVI = (NIR - RED) / (NIR + RED)
  ```
- Handles **NODATA values** properly.
- Saves the result as a new ESRI ASCII grid in the `output/` folder.

## Example Data

I included sample `red_band.asc` and `nir_band.asc` inside `sample_data/`.
They are **5x4 test rasters** so you can quickly run and see NDVI output.


## Next Steps

- Replace sample data with **real remote sensing bands** (e.g., Landsat Red & NIR).
- Convert GeoTIFF to ASCII using `gdal_translate` if needed:
  ```bash
  gdal_translate -of AAIGrid input.tif output.asc
  ```
- Extend the program to compute more indices (EVI, SAVI, etc.)
- Parallelize loops with **OpenMP** for large rasters.

© mdkhademali