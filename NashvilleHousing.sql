
/*

Cleaning Data in SQL Queries

*/


-- Populate Property Address data

Select *
From NashvilleHousing.Nashville_House
order by ParcelID;


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing.Nashville_House a
JOIN NashvilleHousing.Nashville_House b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  <> b.UniqueID 
Where a.PropertyAddress is null;


UPDATE NashvilleHousing.Nashville_House a
JOIN NashvilleHousing.Nashville_House b
ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID 
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;


Select PropertyAddress
From NashvilleHousing.Nashville_House
#order by ParcelID;


-- Breaking out Address into Individual Columns (Address, City, State)


SELECT
SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1 , LENGTH(PropertyAddress)) as Address
FROM NashvilleHousing.Nashville_House;


ALTER TABLE Nashville_House
Add PropertySplitAddress VARCHAR(255);

Update Nashville_House
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1 )


ALTER TABLE Nashville_House
Add PropertySplitCity Nvarchar(255);

Update Nashville_House
SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1 , LENGTH(PropertyAddress))

Select *
From NashvilleHousing.Nashville_House

Select OwnerAddress
From NashvilleHousing.Nashville_House


SELECT
SUBSTRING_INDEX(OwnerAddress, ',', 1) as OwnerSplitAddress,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) as OwnerSplitCity,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1) AS OwnerSplitState
FROM NashvilleHousing.Nashville_House;

ALTER TABLE Nashville_House
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_House
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

ALTER TABLE Nashville_House
Add OwnerSplitCity Nvarchar(255);

Update Nashville_House
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);

ALTER TABLE Nashville_House
Add OwnerSplitState Nvarchar(255);

Update Nashville_House
SET OwnerSplitState = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1);

Select *
From NashvilleHousing.Nashville_House



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing.Nashville_House
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
  CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing.Nashville_House


Update Nashville_House
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




-- Remove Duplicates


SELECT FROM NashvilleHousing.Nashville_House
WHERE UniqueID IN (
    SELECT UniqueID
    FROM (
        SELECT UniqueID,
               ROW_NUMBER() OVER (
                   PARTITION BY ParcelID,
                                PropertyAddress,
                                SalePrice,
                                SaleDate,
                                LegalReference
                   ORDER BY UniqueID
               ) AS row_num
        FROM NashvilleHousing.Nashville_House
    ) AS Subquery
    WHERE row_num > 1
);


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing.Nashville_House
-- order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused Columns


Select *
From NashvilleHousing.Nashville_House    
       
ALTER TABLE NashvilleHousing.Nashville_House 
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;
       
            








