-- 26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id, p.product_name,s.company_name, s.phone from products p
inner join suppliers s on s.supplier_id =p.supplier_id
where units_in_stock = 0

-- 27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.ship_address, o.order_date, e.first_name, e.last_name
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE o.order_date >= '1998-02-28' AND o.order_date <= '1998-04-01';

-- 28. 1997 yılı şubat ayında kaç siparişim var?
select SUM(quantity) as "1997 Siparis" from orders o
inner join order_details od on od.order_id = o.order_id
where date_part('year', order_date) = 1997 and date_part('month', order_date) = 2

-- 29. London şehrinden 1998 yılında kaç siparişim var?
select ship_city, SUM(quantity) as "1998 Siparis" from orders o
inner join order_details od on od.order_id = o.order_id
where date_part('year', order_date) = 1998 AND ship_city = 'London'
group by o.ship_city 

-- 30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.contact_name, c.phone, o.order_date from orders o
inner join customers c on c.customer_id = o.customer_id
inner join order_details od on o.order_id = od.order_id
where date_part('year', order_date) = 1997 
group by c.contact_name, c.phone, o.order_date

-- 31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders
where freight >40;

-- 32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select o.ship_city, c.contact_name,o.freight from orders o
inner join customers c on c.customer_id = o.customer_id
where freight >40;

-- 33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select o.order_date, o.ship_city, UPPER(e.first_name || ' ' || e.last_name) AS "Ad Soyad" from orders o
inner join employees e on e.employee_id = o.employee_id
where date_part('year', order_date) = 1997 

-- 34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
Select c.contact_name,regexp_replace(c.phone, '[^0-9]', '', 'g')  AS TELEFON  From orders o
inner join customers c ON c.customer_id = o.customer_id
Where date_part('year',o.order_date) = 1997 
Group By c.contact_name, c.phone

-- 35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
Select o.order_date, c.contact_name, e.first_name, e.last_name from orders o
inner join employees e on e.employee_id = o.employee_id
inner join customers c on c.customer_id = o.customer_id

-- 36. Geciken siparişlerim?
select * from orders
where required_date < shipped_date

-- 37. Geciken siparişlerimin tarihi, müşterisinin adı
select o.order_date, c.contact_name from orders o
inner join customers c on c.customer_id = o.customer_id
where required_date < shipped_date

-- 38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select od.order_id, p.product_name, c.category_name, od.quantity  from order_details od
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
where od.order_id = 10248;

-- 39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select od.order_id, p.product_name, s.contact_name as "Tedarikçi Adı" from order_details od
inner join products p on p.product_id =od.product_id
inner join suppliers s on s.supplier_id = p.supplier_id
where od.order_id = 10248;

-- 40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select o.employee_id, o.order_date, p.product_name, od.quantity from products p
inner join order_details od on od.product_id =p.product_id
inner join orders o ON od.order_id = o.order_id
Where date_part('year',o.order_date) = 1997 and employee_id =3

-- 41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select o.employee_id, e.first_name, e.last_name, max(quantity) from employees e
inner join orders o on o.employee_id =e.employee_id
inner join order_details od ON od.order_id = o.order_id
Where date_part('year',o.order_date) = 1997 
group by o.employee_id, e.first_name, e.last_name
order by max(quantity) DESC limit 1

-- 42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select o.employee_id, e.first_name, e.last_name, sum(quantity) as "Toplam Satış" from employees e
inner join orders o on o.employee_id =e.employee_id
inner join order_details od ON od.order_id = o.order_id
Where date_part('year',o.order_date) = 1997 
group by o.employee_id, e.first_name, e.last_name
order by sum(quantity) DESC limit 1

-- 43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name, max(unit_price) as "Fiyat" from products p
inner join categories c on c.category_id =p.category_id
group by p.product_name, p.unit_price, c.category_name
order by max(unit_price) DESC limit 1

-- 44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_id, o.order_date from orders o
inner join employees e on o.employee_id =e.employee_id
order by order_date

-- 45. SON 5 siparişimin ortalama fiyatı ve order_id nedir?
select o.order_id, avg(od.unit_price*od.quantity) as Ortalama from orders o
inner join order_details od on od.order_id =o.order_id
group by o.order_id
order by order_date DESC limit 5

-- 46. Ocak ayında satılan ürünlerimin adı, kategorisinin adı ve toplam satış miktarı nedir?
SELECT o.order_date, p.product_name, c.category_name, sum(od.unit_price*od.quantity) as "Toplam Satış Miktarı" FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON p.category_id = p.category_id
inner join orders o ON od.order_id = o.order_id
where date_part('month', order_date) = 1
group by p.product_name, c.category_name,o.order_date

-- 47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id, quantity, round(ortalama_satis,3) as "Ortalama Satış" FROM order_details,
(SELECT AVG(quantity) as ortalama_satis FROM order_details)
WHERE quantity > ortalama_satis;

-- 48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.company_name from order_details od
inner join products p on p.product_id =od.product_id
inner join categories c on c.category_id =p.category_id
inner join suppliers s on p.supplier_id =s.supplier_id
group by c.category_name, s.company_name,p.product_name
order by max(quantity) DESC limit 1

-- 49. Kaç ülkeden müşterim var
select count(DISTINCT country)from customers

-- 50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select o.employee_id, sum(od.quantity*od.unit_price) as satis from orders o
inner join order_details od on od.order_id =o.order_id
Where o.order_date>='1998-01-01' and o.order_date<=CURRENT_DATE and o.employee_id =3
group by o.employee_id

-- 51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select od.order_id, p.product_name, c.category_name, od.quantity  from order_details od
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
where od.order_id = 10248;

-- 52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select od.order_id, p.product_name, s.contact_name as "Tedarikçi Adı" from order_details od
inner join products p on p.product_id =od.product_id
inner join suppliers s on s.supplier_id = p.supplier_id
where od.order_id = 10248;

-- 53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select o.employee_id, o.order_date, p.product_name, od.quantity from products p
inner join order_details od on od.product_id =p.product_id
inner join orders o ON od.order_id = o.order_id
Where date_part('year',o.order_date) = 1997 and employee_id =3

-- 54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select o.employee_id, e.first_name, e.last_name, max(quantity) from employees e
inner join orders o on o.employee_id =e.employee_id
inner join order_details od ON od.order_id = o.order_id
Where date_part('year',o.order_date) = 1997 
group by o.employee_id, e.first_name, e.last_name
order by max(quantity) DESC limit 1

-- 55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select o.employee_id, e.first_name, e.last_name, sum(quantity) as "Toplam Satış" from employees e
inner join orders o on o.employee_id =e.employee_id
inner join order_details od ON od.order_id = o.order_id
Where date_part('year',o.order_date) = 1997 
group by o.employee_id, e.first_name, e.last_name
order by sum(quantity) DESC limit 1

-- 56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name, max(unit_price) as "Fiyat" from products p
inner join categories c on c.category_id =p.category_id
group by p.product_name, p.unit_price, c.category_name
order by max(unit_price) DESC limit 1

-- 57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_id, o.order_date from orders o
inner join employees e on o.employee_id =e.employee_id
order by order_date

-- 58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select o.order_id, avg(od.unit_price*od.quantity) as Ortalama from orders o
inner join order_details od on od.order_id =o.order_id
group by o.order_id
order by order_date DESC limit 5

-- 59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT o.order_date, p.product_name, c.category_name, sum(od.unit_price*od.quantity) as "Toplam Satış Miktarı" FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id
INNER JOIN categories c ON p.category_id = p.category_id
inner join orders o ON od.order_id = o.order_id
where date_part('month', order_date) = 1
group by p.product_name, c.category_name,o.order_date

-- 60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id, quantity, ortalama_satis FROM order_details,
(SELECT AVG(quantity) as ortalama_satis FROM order_details)
WHERE quantity > ortalama_satis;

-- 61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.company_name from products p
inner join categories c on c.category_id =p.category_id
inner join suppliers s on p.supplier_id =s.supplier_id
where p.product_id = (select product_id from order_details group by product_id order by sum(quantity) desc limit 1)

-- 62. Kaç ülkeden müşterim var
select count(DISTINCT country) as "Toplam Ülke" from customers

-- 63. Hangi ülkeden kaç müşterimiz var
select country, count(*) as "Müşteri" from customers
group by country

-- 64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select o.employee_id, sum(od.quantity*od.unit_price) as satis from orders o
inner join order_details od on od.order_id =o.order_id
Where o.order_date>='1998-01-01' and o.order_date<=CURRENT_DATE and o.employee_id =3
group by o.employee_id

-- 65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum(od.quantity*od.unit_price) as toplam_ciro from orders o
inner join order_details od on od.order_id =o.order_id
inner join products p on od.product_id =p.product_id
where o.order_date >= (current_date - INTERVAL '3 months') and p.product_id =10;

-- 66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.employee_id, e.first_name|| ' ' || e.last_name as "Çalışan Ad Soyad", count(order_id) as "Sipariş" from employees e
left join orders o on o.employee_id = e.employee_id
group by e.employee_id,e.first_name, e.last_name;

-- 67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.customer_id,c.contact_name from customers c
left join orders o on o.customer_id=c.customer_id
where o.customer_id is null;

-- 68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name, contact_name, address, city, country from customers
where country = 'Brazil';

-- 69. Brezilya’da olmayan müşteriler
select * from customers
where country <> 'Brazil';

-- 70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers
where country in ('France', 'Germany' , 'Spain');

-- 71. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null or fax = '';

-- 72. Londra’da ya da Paris’de bulunan müşterilerim
select * from customers
where city in ('Londra', 'Paris');

-- 73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers
where city in ('México D.F.') and contact_title ='Owner';

-- 74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where product_name LIKE 'C%';

-- 75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name, last_name, birth_date from employees
where first_name LIKE 'A%';

-- 76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select * from customers
where lower(company_name) LIKE '%restaurant%'

-- 77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price between '50' and '100';

-- 78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date Between '1996-07-01' AND '1996-12-31';

-- 79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select * from customers
where country in ('France', 'Germany' , 'Spain');

-- 80. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null or fax = '';

-- 81. Müşterilerimi ülkeye göre sıralıyorum:
select * from customers
order by country asc;

-- 82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products
order by unit_price DESC;

-- 83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price, units_in_stock from products
order by unit_price DESC, units_in_stock asc;

-- 84. 1 Numaralı kategoride kaç ürün vardır..?
select count(*) as toplam_ürün from products
where category_id=1;

-- 85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct country) as "İhracat yapılan ülke sayısı" from customers;
