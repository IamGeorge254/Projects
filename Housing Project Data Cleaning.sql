/*

  Data Cleaning

*/ 

select *
from House_Data..[NashvilleHousing]


--# Stadardizing Date formart

select Sale_Date, CONVERT(DATE, SaleDate)
from NashvilleHousing

UPDATE NashvilleHousing
SET Sale_Date = CONVERT(DATE, SaleDate)

ALTER TABLE NashvilleHousing
ADD Sale_Date DATE


--# Breaking out Address into individual columns

select 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
from NashvilleHousing

ALTER TABLE NashvilleHousing
ADD Property_Address nvarchar(200)

UPDATE NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD Property_City nvarchar(200)

UPDATE NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
ADD Owner_Address nvarchar(200)

UPDATE NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD Owner_City nvarchar(200)

UPDATE NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD Owner_State nvarchar(200)

UPDATE NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 


--# Changing Y and N to Yes and No

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant

select SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No' 
	ELSE SoldAsVacant
END
from NashvilleHousing 

UPDATE NashvilleHousing 
SET SoldAsVacant = CASE
					  WHEN SoldAsVacant = 'Y' THEN 'Yes'
					  WHEN SoldAsVacant = 'N' THEN 'No' 
					  ELSE SoldAsVacant
				   END


--# Checking to see if there is any duplicate values

select UniqueID, ParcelID, SaleDate, LegalReference, COUNT(*) as Duplicate
from NashvilleHousing 
group by UniqueID, ParcelID, SaleDate, LegalReference


--# Removing unwanted Columns

ALTER TABLE NashvilleHousing 
DROP COLUMN PropertyAddress,
            SaleDate,
			OwnerAddress,
			TaxDistrict

select *
from House_Data..[NashvilleHousing]