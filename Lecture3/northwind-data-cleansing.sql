update stage.[DimCustomer]
set PostalCode='UNKNOWN'
where PostalCode is null

update stage.[DimCustomer]
set Region='UNKNOWN'
where Region is null

update stage.FactSale
set ShippedDate='2100-01-01 00:00:00.000'
where ShippedDate is null

update stage.[DimEmployee]
set Region='UNKNOWN'
where Region is null