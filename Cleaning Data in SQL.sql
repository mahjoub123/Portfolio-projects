--Cleaning Data in SQL Queries
select *
from PortfolioProject.dbo.[NashvilleHousing ]

-------------------------------------------------------------------------------------------------------------

--standrize date formate

select saledate,CONVERT(Date, saledate)
from PortfolioProject.dbo.[NashvilleHousing ]

update PortfolioProject.dbo.[NashvilleHousing ]
set saledate = CONVERT(Date,saledate)

------------------------------------------------------------------------------------------------------------

--Populate property adress data


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) 
from PortfolioProject.dbo.[NashvilleHousing ] a
join PortfolioProject.dbo.[NashvilleHousing ] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a 
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.[NashvilleHousing ] a
join PortfolioProject.dbo.[NashvilleHousing ] b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------

--Breaking out adress into columns (Adress, City, State)

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Adress, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyaddress)) as city

from PortfolioProject.dbo.[NashvilleHousing ]

Alter table PortfolioProject.dbo.[NashvilleHousing ]
add properitysplitaddress nvarchar(255);

update PortfolioProject.dbo.[NashvilleHousing ]
set properitysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table PortfolioProject.dbo.[NashvilleHousing ]
add properitysplitcity nvarchar(255);

update PortfolioProject.dbo.[NashvilleHousing ]
set properitysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyaddress))

select 
PARSENAME(replace(owneraddress,',', '.'), 3) adress1,
PARSENAME(replace(owneraddress,',', '.'), 2),
PARSENAME(replace(owneraddress,',', '.'), 1)
from PortfolioProject.dbo.[NashvilleHousing ]

Alter table PortfolioProject.dbo.[NashvilleHousing ]
add ownersplitaddress nvarchar(255);

update PortfolioProject.dbo.[NashvilleHousing ]
set ownersplitaddress = PARSENAME(replace(owneraddress,',', '.'), 3)

Alter table PortfolioProject.dbo.[NashvilleHousing ]
add ownersplitcity nvarchar(255);

update PortfolioProject.dbo.[NashvilleHousing ]
set ownersplitcity = PARSENAME(replace(owneraddress,',', '.'), 2)


Alter table PortfolioProject.dbo.[NashvilleHousing ]
add ownersplitstate nvarchar(255);

update PortfolioProject.dbo.[NashvilleHousing ]
set ownersplitstate = PARSENAME(replace(owneraddress,',', '.'), 1)

-----------------------------------------------------------------------------------------------------------------


--change 'Y' & 'N' in sold/Vaccant

update Portfolioproject.dbo.[NashvilleHousing ]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
            when SoldAsVacant = 'N' then 'No'
	        else SoldAsVacant
			end

------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

with RowNumCTE AS(
select  *, 
ROW_NUMBER() over(
partition by
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by uniqueid
) row_num
from Portfolioproject.dbo.[NashvilleHousing ])

DELETE 
from RowNumCTE
WHERE row_num > 1

-------------------------------------------------------------------------------------------------

--Delete unused Column

ALTER TABLE Portfolioproject.dbo.[NashvilleHousing ]
DROP COLUMN owneraddress, taxdistrict, propertyaddress
