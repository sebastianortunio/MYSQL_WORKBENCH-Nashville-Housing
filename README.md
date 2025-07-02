# Nashville Housing Data Cleaning and Transformation

This project focuses on cleaning and transforming housing data from Nashville to make it more consistent, accurate, and ready for analysis. The main goal was to prepare the data by fixing common issues like missing values, messy formatting, and duplicate entries.

## What Was Done

- **Fixed Date Format**  
  Converted the `SaleDate` from text to a proper `DATE` format so it’s easier to work with in reports and analysis.

- **Cleaned Up Addresses**  
  Filled in missing property addresses using other data in the table. Then, split full addresses into separate columns: `Address`, `City`, and `State`.

- **Standardized Categories**  
  Made the `SoldAsVacant` field easier to read by changing values from 'Y' and 'N' to 'Yes' and 'No'.

- **Removed Duplicates**  
  Got rid of duplicate rows by checking for repeated values in columns like `LegalReference`, `LandValue`, `OwnerName`, `SalePrice`, and `TotalValue`.

- **Dropped Unused Columns**  
  Removed unnecessary columns like `SaleDate` (original), `OwnerAddress`, `TaxDistrict`, and `PropertyAddress` to keep the dataset clean and focused.

## Tools and Technologies

- **SQL** – Used for querying and transforming the data.
- **MySQL** – Managed the database and performed all operations within the `Nashville_Housing` table.

## How It Was Done

- Standardized the date field to make it usable for filtering and analysis.
- Used `COALESCE()` and `JOIN` techniques to fill in missing address information.
- Separated full addresses into individual columns for better readability.
- Converted confusing 'Y'/'N' values to clear 'Yes'/'No'.
- Removed duplicate records using `ROW_NUMBER()` with `CTE` (Common Table Expressions).
- Dropped columns that weren’t needed after transformation.
