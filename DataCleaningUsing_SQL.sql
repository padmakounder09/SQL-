SELECT * FROM SQLPortfolioProject.dbo.Housing

--Standardize date format

select SaleDateConverted, CONVERT(Date, SaleDate)
from SQLPortfolioProject.dbo.Housing

UPDATE SQLPortfolioProject.dbo.Housing
Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE SQLPortfolioProject.dbo.Housing
Add SaleDateConverted Date;

UPDATE SQLPortfolioProject.dbo.Housing
Set SaleDateConverted = CONVERT(Date, SaleDate)

--Populating property address data

select a.ParcelID,a.PropertyAddress,b.ParcelID, 
b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
from SQLPortfolioProject.dbo.Housing a
join SQLPortfolioProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID]
where a.PropertyAddress is NULL

update a
Set PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
from SQLPortfolioProject.dbo.Housing a
join SQLPortfolioProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID]
where a.PropertyAddress is NULL



--Breaking Address into indivual columns

SELECT 
Substring (propertyAddress, 1, Charindex(',', PropertyAddress)-1)as Address,
Substring (propertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM SQLPortfolioProject.dbo.Housing

ALTER TABLE SQLPortfolioProject.dbo.Housing
Add PropertysplitAddress nvarchar(255);

UPDATE SQLPortfolioProject.dbo.Housing
Set PropertysplitAddress = Substring (propertyAddress, 1, Charindex(',', PropertyAddress)-1)

ALTER TABLE SQLPortfolioProject.dbo.Housing
Add PropertysplitCity nvarchar(255);

UPDATE SQLPortfolioProject.dbo.Housing
Set PropertysplitCity = Substring (propertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress))


select 
PARSEName(REPLACE(OwnerAddress,',','.'),3),
PARSEName(REPLACE(OwnerAddress,',','.'),2),
PARSEName(REPLACE(OwnerAddress,',','.'),1)
FROM SQLPortfolioProject.dbo.Housing

ALTER TABLE SQLPortfolioProject.dbo.Housing
Add OwnersplitAddress nvarchar(255);

UPDATE SQLPortfolioProject.dbo.Housing
Set OwnersplitAddress = PARSEName(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE SQLPortfolioProject.dbo.Housing
Add OwnersplitCity nvarchar(255);

UPDATE SQLPortfolioProject.dbo.Housing
Set OwnersplitCity = PARSEName(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE SQLPortfolioProject.dbo.Housing
Add OwnersplitState nvarchar(255);

UPDATE SQLPortfolioProject.dbo.Housing
Set OwnersplitState = PARSEName(REPLACE(OwnerAddress,',','.'),1)


Select * 
FROM SQLPortfolioProject.dbo.Housing


--Change Y and N to Yes and No in SoldAsVacant Column

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM SQLPortfolioProject.dbo.Housing
Group by SoldAsVacant
order by 2


select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END
FROM SQLPortfolioProject.dbo.Housing

update SQLPortfolioProject.dbo.Housing
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END


--Removing Duplicates
With RowNumCTE AS(
Select *,
ROW_NUMBER() over (
	Partition BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order BY
				UniqueID
				)row_num
FROM SQLPortfolioProject.dbo.Housing
)

--DELETE
Select *
From RowNumCTE
where row_num >1
--order BY PropertyAddress


--Deleting Unused Columns

Select * 
From SQLPortfolioProject.dbo.Housing

Alter Table SQLPortfolioProject.dbo.Housing
DROP column OwnerAddress, PropertyAddress, SaleDate, TaxDistrict 

















