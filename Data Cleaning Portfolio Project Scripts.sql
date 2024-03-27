/*
Cleaning Data in SQL Queries
*/

select *
from PortfolioProject.dbo.NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format
select SaleDateCoverted, convert(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update PortfolioProject..NashvilleHousing
set SaleDate = convert(Date,SaleDate)

alter table  PortfolioProject.dbo.NashvilleHousing
add SaleDateCoverted date;

update  PortfolioProject.dbo.NashvilleHousing
set SaleDateCoverted = convert(date,SaleDate)

---------------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address data

select *
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
---------------------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into individual columns (Address, City, State)

--Spliting the property address
select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Address
--CHARINDEX(',', PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing


alter table  PortfolioProject.dbo.NashvilleHousing
add PropertySplitAddress nvarchar(255);

update  PortfolioProject.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)



alter table  PortfolioProject.dbo.NashvilleHousing
add PropertySplitCity nvarchar(255);

update  PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))


select *
from PortfolioProject.dbo.NashvilleHousing


--Spliting the owner address

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing


alter table  PortfolioProject.dbo.NashvilleHousing
add OwnerSplitAddress  nvarchar(255);

update  PortfolioProject.dbo.NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



alter table  PortfolioProject.dbo.NashvilleHousing
add OwnerSplitCity nvarchar(255);

update  PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



alter table  PortfolioProject.dbo.NashvilleHousing
add OwnerSplitState nvarchar(255);

update  PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


select *
from PortfolioProject.dbo.NashvilleHousing



--Change N and y to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing


update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end




---------------------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicate

with RowNumCTE as (
select *,
	ROW_NUMBER() over(
		partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
		order by UniqueID
	) row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select * --delete
from RowNumCTE
where row_num > 1
order by PropertyAddress


select *
from PortfolioProject.dbo.NashvilleHousing



-----------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete unused columns


select *
from PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column owneraddress, taxdistrict, saledate, propertyaddress






