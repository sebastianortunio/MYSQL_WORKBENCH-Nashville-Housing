/*

Cleaning data in SQL

Sebastian Ortuno
*/

-- In this project, I will be using SQL to clean a dataset relating to Nashville housing sales.

------------------------------------------------------------------------------------------------------
Create database Nashville_Project;
use Nashville_Project;

SELECT *
FROM Nashville_Housing;

-- Viewing data set, there are several things that need to be cleaned:
-- 1) Standardize date format in SaleDate variable.
-- 2) Clean Null Values in PropertyAddress.
-- 3) Take components of "PropertyAddress" and put them into their own columns (Address & City).
-- 5) "SoldAsVacant" has 4 values; Y, Yes, N, and NO. Convert Y to Yes, and N to No.
-- 6) Remove duplicate values from the data.
-- 7) Delete unused coulmn.
-- 8) View final data set.

-------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------
-- 1) Standardize date format in SaleDate variable


-- Note: As we will make significant changes to our database, we need to disable sql_safe_updates.

set sql_safe_updates=0;

-- Adding a new column 'Sales_Date_Converted' with DATE data type

alter table Nashville_Housing
add column `Sales_Date_Converted` date;

-- Updating the new column by converting 'SaleDate' (text) to proper DATE format

update Nashville_Housing 
set Sales_Date_Converted=str_to_date(SaleDate,"%M %d, %Y");

-- Verifying the converted date values

select Sales_Date_Converted  from Nashville_Housing;

-- Viewing the full table to check the updated results

Select * from Nashville_Housing;

-- The process of converting the SaleDate column to a proper DATE format was successfully completed.	

--------------------------------------------------------------------
-- 2) NULL values in "PropertyAddress"


-- Identify records that share the same ParcelID and where the PropertyAddress is missing

-- Perform a self-join on the Nashville_Housing table
-- Match rows where ParcelIDs are equal but UniqueIDs are different
-- Focus only on entries where PropertyAddress in the first instance is NULL
-- Pull the PropertyAddress from the matching entry

select a.PropertyAddress, a.ParcelID, b.PropertyAddress,b.ParcelID, coalesce(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress is null;

-- The above query shows which PropertyAddress values can be filled using other entries with the same ParcelID

-- Execute an update to assign missing PropertyAddress values
-- Use the address from another record with the same ParcelID when available

UPDATE Nashville_Housing a
JOIN Nashville_Housing b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Viewing the full table to check the updated results

Select * from Nashville_Housing;


-- The update was completed successfully, filling in the missing PropertyAddress entries.


---------------------------------------------------------------------
--------------------------------------------------------------------
-- 3) Take components of "PropertyAddress" and put them into their own columns.

-- Breaking out into Individual columns(Address,City,State)

-- Preview the full PropertyAddress column

select PropertyAddress from Nashville_Housing;

-- Extract the street address portion (everything before the comma)

select left(PropertyAddress,locate(',',PropertyAddress)-1) as Address
from Nashville_Housing;

-- Add a new column to store the extracted street address

alter table Nashville_Housing
add column Property_Split_Address varchar(200);

-- Populate the new Property_Split_Address column with the extracted street address

update Nashville_Housing
set Property_Split_Address= left(PropertyAddress,locate(',',PropertyAddress)-1) ;

-- Extract the city portion from the PropertyAddress (everything after the comma)

select right(PropertyAddress,length(PropertyAddress)-locate(',',PropertyAddress))as City
from Nashville_Housing;

-- Add a new column to store the extracted city name

alter table Nashville_Housing
add column Property_Split_City varchar(200);

-- Fill in the Property_Split_City column with city values

update Nashville_Housing
set Property_Split_City=right(PropertyAddress,length(PropertyAddress)-locate(',',PropertyAddress));

-- Preview OwnerAddress column to analyze state extraction

SELECT OwnerAddress from Nashville_Housing;

-- Extract the state abbreviation (assuming it follows ', T')

select right(OwnerAddress,length(OwnerAddress)-locate(", T", OwnerAddress))
from Nashville_Housing;

-- Add a new column to store the extracted state.

alter table Nashville_Housing
add column Property_Split_State varchar(200);

-- Populate the Property_Split_State column with the state abbreviation

update Nashville_Housing 
set Property_Split_State=right(OwnerAddress,length(OwnerAddress)-locate(", T", OwnerAddress));

-- Viewing the full table to check the updated results

Select * from Nashville_Housing;

-- All address components (street, city, state) have been successfully extracted and stored in separate columns.

---------------------------------------------------------------------
--------------------------------------------------------------------

-- 4) Clean "SoldAsVacant" column
-- Currently, the column has 4 values, Y, N, Yes & No. As shown below:

-- Check the different values in the SoldAsVacant column and count how many times each appears


select distinct SoldAsVacant, count(SoldAsVacant) AS Count
 from Nashville_Housing
 group by SoldAsVacant
 order by Count;
 
 -- Preview how SoldAsVacant values will be standardized: convert 'Y' to 'Yes' and 'N' to 'No'

select SoldAsVacant, 
	case when SoldAsVacant='Y' then 'Yes'
		when SoldAsVacant='N' then 'No'
		else SoldAsVacant
	end
from Nashville_Housing;

-- Apply the transformation to update the SoldAsVacant column with standardized values

update Nashville_Housing
set SoldAsVacant=case when SoldAsVacant="Y" then "Yes"
	when SoldAsVacant="N" then "No"
    else SoldAsVacant
    end;

-- Viewing the full table to check the updated results

Select * from Nashville_Housing;
    
-- SoldAsVacant column successfully standardized with 'Yes' and 'No' values.

---------------------------------------------------------------------
--------------------------------------------------------------------
-- 5) Remove duplicate values in data.

-- Identify duplicate records based on a combination of key columns.
-- Assign a row number to each record within the duplicate groups.
-- Duplicates will have ROWNUMB greater than 1.

with RowNumCTE AS ( 
Select *, row_number() over(
partition by LegalReference, LandValue, OwnerName,SalePrice,TotalValue )AS ROWNUMB 
from Nashville_Housing)
SELECT * from RowNumCTE 
WHERE ROWNUMB>1;

-- The above query returns all duplicate rows that we intend to delete

-- Prepare a CTE that assigns row numbers using the same duplicate-identifying logic
-- This time, select only the UniqueID (for deletion)

with RowNumCTE AS ( 
Select UniqueID, row_number() over(
partition by LegalReference, LandValue, OwnerName,SalePrice,TotalValue )AS ROWNUMB 
from Nashville_Housing)
delete from Nashville_Housing
WHERE UniqueID IN (select UniqueID from RowNumCTE
						WHERE ROWNUMB>1);




---------------------------------------------------------------------
--------------------------------------------------------------------
-- 6) Delete unused coulmn 

alter table Nashville_Housing
drop column SaleDate, 
Drop column OwnerAddress,
Drop column TaxDistrict,
Drop column PropertyAddress;

---------------------------------------------------------------------
---------------------------------------------------------------------
-- 7) View final data set

SELECT *
FROM Nashville_Housing;

-- We have successfully:
-- Viewing data set, there are several things needing to be cleaned:
-- 1) Standardized date format in "SaleDate" column. Created "CorrectDate" column with correct data format. 
-- 2) Clean Null Values in PropertyAddress
-- 3) Take components of "PropertyAddress" and put them into their own columns (Address & City)
-- 4) "SoldAsVacant" has 4 values; Y, Yes, N, and NO. Convert Y to Yes, and N to No
-- 5) Remove duplicate values from the data using a CTE
-- 6) Delete unused coulmn  ("SaleDate", "PropertyAddress", "OwnerAddress")
-- 7) View final data set
