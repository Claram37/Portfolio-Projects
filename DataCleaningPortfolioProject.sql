--Cleaning data in SQL Queries

Select* 
From PortfolioProject..NashvileHousing




--Standardize the date format
ALTER TABLE NashvileHousing
Add SaleDateConverted Date;

Update NashvileHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted
From PortfolioProject..NashvileHousing




--Populating the Property Address data

Select *
From PortfolioProject..NashvileHousing
Order by ParcelID

Select PropertyAddress
From PortfolioProject..NashvileHousing

--Updating the property Address for all the null property addresses by checking the parcel ID that is equal but they have a unique ID
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvileHousing a
JOIN PortfolioProject..NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
From PortfolioProject..NashvileHousing a
JOIN PortfolioProject..NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]



--Breaking out the Address into individual columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvileHousing

--Extracts the Address from the Physical Address using SUBSTRING
--This will return a column with the Property Address and another with the City
Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
From PortfolioProject..NashvileHousing

ALTER TABLE NashvileHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvileHousing
Add PropertySplitCIty Nvarchar(255);

Update NashvileHousing
SET PropertySplitCIty = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select * 
from PortfolioProject..NashvileHousing

--Extracting data from a string  using PARSENAME
Select OwnerAddress
from PortfolioProject..NashvileHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3) AS Address
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2) AS City
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1) AS State
from PortfolioProject..NashvileHousing

ALTER TABLE NashvileHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvileHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE NashvileHousing
Add OwnerSplitCIty Nvarchar(255);

Update NashvileHousing
SET OwnerSplitCIty = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE NashvileHousing
Add OwnerSplitState Nvarchar(255);

Update NashvileHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)



--Changing 'Y' and 'N' in the SoldAsVacant column to 'YES' and 'NO' respectively
Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvileHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
	,CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
From PortfolioProject..NashvileHousing

Update NashvileHousing
Set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END



--Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
	ORDER BY UniqueID
	) row_num
From PortfolioProject..NashvileHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--Delete the duplicate rows

--DELETE 
--From RowNumCTE
--Where row_num > 1
----Order by PropertyAddress




--Deleting Unused Columns

Select * 
From PortfolioProject..NashvileHousing

ALTER TABLE PortfolioProject..NashvileHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate