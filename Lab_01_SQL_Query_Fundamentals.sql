-- ------------------------------------------------------------------
-- 0). First, How Many Rows are in the Products Table?
-- ------------------------------------------------------------------
SELECT count('id') AS Num_Products FROM northwind.products;

-- ------------------------------------------------------------------
-- 1). Product Name and Unit/Quantity
-- ------------------------------------------------------------------
Select product_name
	, quantity_per_unit 
from northwind.products;

-- ------------------------------------------------------------------
-- 2). Product ID and Name of Current Products
-- ------------------------------------------------------------------
Select id AS product_id
	, product_name
from northwind.products
where discontinued <> 1;

-- ------------------------------------------------------------------
-- 3). Product ID and Name of Discontinued Products
-- ------------------------------------------------------------------
Select id AS product_id
	, product_name
from northwind.products
where discontinued <> 0;

-- ------------------------------------------------------------------
-- 4). Name & List Price of Most & Least Expensive Products
-- ------------------------------------------------------------------
select product_name
	, list_price 
from northwind.products
where list_price = (select min(list_price) from northwind.products)
Or list_price = (select max(list_price) from northwind.products);

-- ------------------------------------------------------------------
-- 5). Product ID, Name & List Price Costing Less Than $20
-- ------------------------------------------------------------------
select product_name
	, list_price 
    , id
from northwind.products
where list_price <20.00
order by list_price DESC;

-- ------------------------------------------------------------------
-- 6). Product ID, Name & List Price Costing Between $15 and $20
-- ------------------------------------------------------------------
select id
	, product_name
    , list_price
from northwind.products
where 15.00 <= list_price
and list_price <= 20
order by list_price DESC;




-- ------------------------------------------------------------------
-- 7). Product Name & List Price Costing Above Average List Price
-- ------------------------------------------------------------------
select product_name
    , list_price
from northwind.products
where list_price > (select avg(list_price) from northwind.products)
order by list_price DESC;

-- ------------------------------------------------------------------
-- 8). Product Name & List Price of 10 Most Expensive Products 
-- ------------------------------------------------------------------
select product_name
    , list_price
from northwind.products
order by list_price desc 
limit 10;

-- ------------------------------------------------------------------ 
-- 9). Count of Current and Discontinued Products 
-- ------------------------------------------------------------------

update northwind.products set discontinued = 1 where id = 95;
select case discontinued
		when 1 then 'yes'
        else 'no'
	end as is_discontinued
    , count(*) as product_count
from northwind.products
group by discontinued;

UPDATE northwind.products set discontinued = 0 where id = 95;
-- ------------------------------------------------------------------
-- 10). Product Name, Units on Order and Units in Stock
--      Where Quantity In-Stock is Less Than the Quantity On-Order. 
-- ------------------------------------------------------------------
select product_name
, reorder_level as units_in_stock
, target_level as units_on_order
from northwind.products
where reorder_level < target_level;

-- ------------------------------------------------------------------
-- EXTRA CREDIT -----------------------------------------------------
-- ------------------------------------------------------------------


-- ------------------------------------------------------------------
-- 11). Products with Supplier Company & Address Info
-- ------------------------------------------------------------------
select * from northwind.suppliers;
select p.product_name 
	, p.list_price as product_list_price
	, p.category as product_category
	, s.company as supplier_company
	, s.address as supplier_address
	, s.city as supplier_city
	, s.state_province as supplier_state_province
, s.zip_postal_code as supplier_zip_postal_code
from northwind.suppliers s
inner join northwind.products p
on s.id = p.supplier_ids;



-- ------------------------------------------------------------------
-- 12). Number of Products per Category With Less Than 5 Units
-- ------------------------------------------------------------------

select category
	, count(*) as units_in_stock
from northwind.products
group by category
having units_in_stock < 5; 

-- ------------------------------------------------------------------
-- 13). Number of Products per Category Priced Less Than $20.00
-- ------------------------------------------------------------------
select   category
	, count(*) as product_count
from     northwind.products 
where    list_price <20.00
group by category
order by category;
