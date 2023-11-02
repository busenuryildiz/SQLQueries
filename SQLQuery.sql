-- 1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
Select product_name, quantity_per_unit from products;

-- 2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
Select product_id, product_name from products
where discontinued =1;

-- 3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
Select product_id, product_name, discontinued from products
where discontinued =1;

-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
Select product_id, product_name, unit_price from products where unit_price<20;

-- 5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
Select product_id, product_name, unit_price from products where unit_price between 15 AND 25;

-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
Select product_name, units_on_order, units_in_stock from products where units_in_stock < units_on_order;

-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.
Select * from products where lower (product_name) like 'a%';

-- 8. İsmi `i` ile biten ürünleri listeleyeniz.
Select * from products where lower (product_name) like '%i';

-- 9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
Select product_name, unit_price, (unit_price * 1.18) AS UnitPriceKDV from products;

-- 10. Fiyatı 30 dan büyük kaç ürün var?
--select unit_price from products where unit_price>30;
Select count (*) unit_price from products where unit_price>30;

-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
Select lower (product_name) AS productname , unit_price from products  
Order by unit_price DESC;

-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
Select (first_name || ' ' || last_name) AS AdSoyad from employees;

-- 13. Region alanı NULL olan kaç tedarikçim var?
Select Count (*) from suppliers where region is null;

-- 14. a.Null olmayanlar?
Select Count (*) from suppliers where region is not null;

-- 15. Ürün adlarının hepsinin soluna TR koy ve büyük olarak ekrana yazdır.
Select ('TR' || ' '|| UPPER (product_name)) AS TR from products;

-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
Select ('TR' || ' '|| product_name) AS TR , unit_price from products where unit_price<20;

-- 17. En pahalı ürünün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
Select  product_name, unit_price from products 
Where unit_price = (Select MAX (unit_price) from products);

-- 18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
Select product_name, unit_price FROM products 
ORDER BY unit_price DESC LIMIT 10;

-- 19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
Select  product_name, unit_price from products
where unit_price > (select AVG (unit_price) FROM products);

-- 20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
--a.Satıştan kazanılan toplam miktar 
Select SUM (unit_price * units_in_stock) as miktar from products;

--b.Satılan ürün miktarı
Select SUM (units_in_stock) as toplam from products;

-- 21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select product_name,discontinued,units_in_stock from products
where units_in_stock >0 And discontinued =1;

SELECT COUNT(*) AS total_count, product_name FROM products
WHERE units_in_stock > 0 AND discontinued = 1
GROUP BY product_name;

-- Devam eden ve durdurulan ürünler
select discontinued, count(*) from products
group by discontinued;

-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
Select products.product_name ,categories.category_name from products
INNER JOIN categories ON categories. category_id = products.category_id;

SELECT P.CATEGORY_NAME, P.PRODUCT_NAME, 
FROM PRODUCTS P
JOIN CATEGORIES C ON P.CATEGORYID = C.CATEGORYID;

-- 23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT category_id, AVG(unit_price) AS average_price FROM products
GROUP BY category_id;

-- 24. En pahalı ürünümün adı, fiyatı ve kategorisinin adı nedir?
Select  p.product_name, p.unit_price, c.category_name from products p
INNER JOIN categories c ON c. category_id = p.category_id
Where unit_price = (Select MAX (unit_price) from products);

SELECT p.product_name, p.unit_price, c.category_name FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY p.Unit_price DESC LIMIT 1;

-- 25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
Select  p.product_name,  c.category_name, s.company_name from products p
JOIN categories c ON c. category_id = p.category_id 
JOIN suppliers s ON s.supplier_id = p.supplier_id
Where units_on_order = (Select MAX (units_on_order) from products);



























