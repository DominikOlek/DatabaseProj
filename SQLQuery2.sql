Select * from dbo.Categories where CategoryName = 'Produce'
Select Count(CategoryName),CategoryID from dbo.Categories group by CategoryID
Select Count(CategoryName),CategoryID from dbo.Categories group by CategoryID having CategoryId = 3
Select Count(CategoryName),CategoryID from dbo.Categories group by CategoryID having CategoryId like '%3%'
Select * from (Select TOP 1000 ProductName,SupplierID,CategoryID from dbo.Products order by CategoryID desc) as page where SupplierID > 5 order by SupplierID OFFSET 5 ROWS FETCH FIRST 10 ROWS ONLY