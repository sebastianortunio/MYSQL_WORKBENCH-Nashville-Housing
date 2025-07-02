# Nashville Housing Data Cleaning with SQL

This project is about cleaning a housing dataset from Nashville using SQL. The goal was to make the data easier to read and ready for analysis. I fixed missing information, changed the date format, removed duplicates, and cleaned up the address and other details.

##  Author

**Sebastian Ortuno**

---

##  Tools Used

- **SQL** – To write queries and clean the data
- **MySQL** – The database where the data is stored and changed

---

##  Steps I Followed

### 1. Fix the Date Format
- The `SaleDate` column had text values.
- I created a new column called `Sales_Date_Converted` and changed the text into a real date format.

### 2. Fill in Missing Addresses
- Some properties didn’t have an address.
- I used data from other rows with the same `ParcelID` to fill the missing addresses.

### 3. Split the Address into Parts
- The full address was in one column.
- I separated it into:
  - `Property_Split_Address` – street name
  - `Property_Split_City` – city
  - `Property_Split_State` – state

### 4. Clean the "SoldAsVacant" Column
- This column had four values: `Y`, `Yes`, `N`, `No`.
- I changed `Y` to `Yes`, and `N` to `No`, so the column only has `Yes` or `No`.

### 5. Remove Duplicates
- I found rows with the same values in key columns like `OwnerName`, `SalePrice`, etc.
- I used a technique with `ROW_NUMBER()` and deleted the repeated rows.

### 6. Delete Unused Columns
- I removed columns we no longer needed:
  - `SaleDate` (we made a new one)
  - `PropertyAddress` (now split)
  - `OwnerAddress`, `TaxDistrict`

### 7. Final Table
- The final dataset is clean and ready to use for reports or dashboards.

---

##  Summary of What I Did

- [x] Fixed the date format
- [x] Completed missing addresses
- [x] Split address into smaller parts
- [x] Cleaned Yes/No values
- [x] Removed duplicate rows
- [x] Deleted extra columns
- [x] Checked the final clean table

---

## Final Thoughts

Cleaning data is an important part of any data project. This project shows how we can use SQL to prepare messy data and make it ready for analysis.

