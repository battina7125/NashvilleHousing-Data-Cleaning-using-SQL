/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------

--Populate Property Address data

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address


From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



select*
From PortfolioProject.dbo.NashvilleHousing




select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState NVarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

select*
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

--------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE as(
Select *,
   ROW_NUMBER() over (
   Partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by
				 UniqueID
				 )row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select*
from RowNumCTE
where row_num>1
order by PropertyAddress

--In this part we are deleting the duplicates

WITH RowNumCTE as(
Select *,
   ROW_NUMBER() over (
   Partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by
				 UniqueID
				 )row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Delete
from RowNumCTE
where row_num>1
--order by PropertyAddress


--Here after deleting the duplicates 

WITH RowNumCTE as(
Select *,
   ROW_NUMBER() over (
   Partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by
				 UniqueID
				 )row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select*
from RowNumCTE
where row_num>1
order by PropertyAddress

--------------------------------------------------------------------------------------------------------------------------------

select *
From PortfolioProject.dbo.NashvilleHousing
 
 Alter Table PortfolioProject.dbo.NashvilleHousing
 Drop column OwnerAddress, TaxDistrict, PropertyAddress

 Alter Table PortfolioProject.dbo.NashvilleHousing
 Drop column SaleDate