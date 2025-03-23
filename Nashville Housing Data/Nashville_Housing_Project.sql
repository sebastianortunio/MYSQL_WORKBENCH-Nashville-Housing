use Nashville_Project;
SELECT * FROM Nashville_Housing;

--------------------------------------------------------------------
#Standarized Date Format
#Converting SalesDate from text to Date Creating a new column named Sales_Date_Converted

set sql_safe_updates=0;

alter table Nashville_Housing
add column `Sales_Date_Converted` date;

update Nashville_Housing 
set Sales_Date_Converted=str_to_date(SaleDate,"%Y-%m-%d");

select Sales_Date_Converted  from Nashville_Housing;
Select * from Nashville_Housing;

--------------------------------------------------------------------
# Propulate properly Addres Data

select a.PropertyAddress, a.ParcelID, b.PropertyAddress,b.ParcelID, coalesce(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress is null;

#Update Property Address

UPDATE Nashville_Housing a
JOIN Nashville_Housing b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;




---------------------------------------------------------------------
--------------------------------------------------------------------
# Breaking out into Individual columns(Address,City,State)

select PropertyAddress from Nashville_Housing;


#Getting the Address First
select left(PropertyAddress,locate(',',PropertyAddress)-1) as Address
from Nashville_Housing;

alter table Nashville_Housing
add column Property_Split_Address varchar(200);

update Nashville_Housing
set Property_Split_Address= left(PropertyAddress,locate(',',PropertyAddress)-1) ;

#Getting the City 

select right(PropertyAddress,length(PropertyAddress)-locate(',',PropertyAddress))as City
from Nashville_Housing;

alter table Nashville_Housing
add column Property_Split_City varchar(200);

update Nashville_Housing
set Property_Split_City=right(PropertyAddress,length(PropertyAddress)-locate(',',PropertyAddress));


# Getting State
SELECT OwnerAddress from Nashville_Housing;

select right(OwnerAddress,length(OwnerAddress)-locate(", T", OwnerAddress))
from Nashville_Housing;

alter table Nashville_Housing
add column Property_Split_State varchar(200);

update Nashville_Housing 
set Property_Split_State=right(OwnerAddress,length(OwnerAddress)-locate(", T", OwnerAddress));

---------------------------------------------------------------------
--------------------------------------------------------------------
#Change Y and N TO Yes and No in "SoldAsVacant" field

select distinct SoldAsVacant, count(SoldAsVacant) AS Count
 from Nashville_Housing
 group by SoldAsVacant
 order by Count;
 

select SoldAsVacant, 
	case when SoldAsVacant='Y' then 'Yes'
		when SoldAsVacant='N' then 'No'
		else SoldAsVacant
	end
from Nashville_Housing;

update Nashville_Housing
set SoldAsVacant=case when SoldAsVacant="Y" then "Yes"
	when SoldAsVacant="N" then "No"
    else SoldAsVacant
    end;

---------------------------------------------------------------------
--------------------------------------------------------------------
# Remove Duplicates

with RowNumCTE AS ( 
Select *, row_number() over(
partition by LegalReference, LandValue, OwnerName,SalePrice,TotalValue )AS ROWNUMB 
from Nashville_Housing)
SELECT * from RowNumCTE 
WHERE ROWNUMB>1;

with RowNumCTE AS ( 
Select UniqueID, row_number() over(
partition by LegalReference, LandValue, OwnerName,SalePrice,TotalValue )AS ROWNUMB 
from Nashville_Housing)
delete from Nashville_Housing
WHERE UniqueID IN (select UniqueID from RowNumCTE
						WHERE ROWNUMB>1);




---------------------------------------------------------------------
--------------------------------------------------------------------
#Delete unused coulmn 

alter table Nashville_Housing
drop column SaleDate, 
Drop column OwnerAddress,
Drop column TaxDistrict,
Drop column PropertyAddress;



---------------------------------------------------------------------
