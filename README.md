# Nashville Housing Data Cleaning and Transformation
This project involves cleaning and transforming a dataset of Nashville housing records to ensure data consistency and improve data quality. The primary goal was to standardize and preprocess the data for analysis or reporting purposes. Key tasks include handling missing values, breaking down addresses into separate columns, and removing duplicates.

## Key Features:

- Date Standardization: Converted the SaleDate from a text format to a proper DATE type for better analysis.
Address Cleaning: Identified and populated missing property addresses using available data, and then split the full address into separate columns for Address, City, and State.
- Data Transformation: Cleaned up categorical data in the SoldAsVacant field by converting 'Y' and 'N' to 'Yes' and 'No'.
- Duplicate Removal: Identified and removed duplicate records based on key attributes like LegalReference, LandValue, OwnerName, SalePrice, and TotalValue.
- Column Cleanup: Dropped unused columns (SaleDate, OwnerAddress, TaxDistrict, PropertyAddress) to optimize the dataset.
  
## Technologies Used:

- SQL: For querying, updating, and transforming the dataset.
- MySQL: Used to manage and manipulate the housing data in the Nashville_Housing table.

##Approach:

- Standardized date formats to ensure proper handling of sales dates.
- Used COALESCE() and JOIN statements to populate missing addresses.
- Split address fields into discrete columns for easier analysis.
- Cleaned categorical data and transformed 'Y'/'N' values into 'Yes'/'No'.
- Removed duplicate rows based on key attributes using ROW_NUMBER() and CTEs.
- Cleaned up the table by removing unnecessary columns.
