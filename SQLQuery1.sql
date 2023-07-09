/*

Cleaning Data in SQL Queries

*/

select * from PortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------

--Standardized Date Format

select SaleDateConverted,convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
set SaleDate = convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaLeDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = convert(Date,SaleDate)


------------------------------------------------------------------------------------

--Populate Property Address Data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID



SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.PropertyAddress
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.ParcelID IS NULL


------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address,City,State)

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing




SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "SoldAsVacant" Field


SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant


SELECT SoldAsVacant,
		CASE 
			WHEN SoldAsVacant = 'Y' THEN 'YES'
			WHEN SoldAsVacant = 'N' THEN 'NO'
			ELSE SoldAsVacant
		END
FROM PortfolioProject.dbo.NashvilleHousing;


UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
						WHEN SoldAsVacant = 'Y' THEN 'YES'
						WHEN SoldAsVacant = 'N' THEN 'NO'
						ELSE SoldAsVacant
				   END

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant


-----------------------------------------------------------------------------------

--Remove Duplicates


WITH RowNumCTE AS
(
SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY ParcelID,
                   PropertyAddress,
                   SalePrice,
                   SaleDate,
                   LegalReference
      ORDER BY UniqueID
    ) AS row_num
FROM PortfolioProject.dbo.NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------

--Delete Unused Column


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,SaleDate

	

