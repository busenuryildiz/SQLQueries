-- 86. a.Bu ülkeler hangileri..?
SELECT DISTINCT country FROM customers

-- 87. En Pahalı 5 ürün
select product_name, unit_price from products order by unit_price desc limit 5

-- 88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
SELECT COUNT(*) AS Siparis_sayisi FROM orders
WHERE customer_id = 'ALFKI';

select  c.customer_id, p.units_on_order from customers c inner join orders o on o.customer_id=c.customer_id
inner join order_details od on od.order_id=o.order_id 
inner join products p on p.product_id=od.product_id
where c.customer_id='ALFKI' and units_on_order > 0

-- 89. Ürünlerimin toplam maliyeti
select p.product_name, ROUND((o.unit_price*o.quantity)::numeric,2) as maliyet, o.discount from products p
inner join order_details o on o.product_id=p.product_id 

-- 90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select SUM((quantity * unit_price) * (1 - discount)) AS ToplamCiro from order_details

SELECT SUM((quantity * unit_price) - (Unit_price * Quantity * Discount)) AS ToplamCiro FROM Order_details;
 
-- 91. Ortalama Ürün Fiyatım
select AVG(unit_price-(discount*unit_price)) as ortalama_urun_fiyatı from order_details 
select AVG(unit_price*(1-discount)) as ortalama_urun_fiyatı from order_details 

-- 92. En Pahalı Ürünün Adı
select  product_name ,unit_price from products
order by unit_price desc limit 1

-- 93. En az kazandıran sipariş
select unit_price-(discount*unit_price) as urun_fiyatı from order_details order by urun_fiyatı limit 1

select (unit_price*quantity)-(unit_price*quantity*discount) as urun_fiyatı from order_details order by urun_fiyatı limit 1

-- 94. Müşterilerimin içinde en uzun isimli müşteri
SELECT contact_name FROM customers ORDER BY LENGTH(contact_name) DESC LIMIT 1

-- 95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name || ' ' || last_name as fullname, (current_date-birth_date)/365 as yas from employees 
select first_name || ' ' || last_name as fullname,  EXTRACT(YEAR FROM AGE(NOW(), birth_date)) AS Age from employees 

-- 96. Hangi üründen toplam kaç adet alınmış..?
select p.product_name, sum(od.quantity) as toplam_satis from products p 
inner join order_details od on od.product_id=p.product_id
group by p.product_name

-- 97. Hangi siparişte toplam ne kadar kazanmışım..?
select o.order_id, sum(od.quantity*od.unit_price) from orders o 
inner join order_details od on od.order_id=o.order_id
group by o.order_id

-- 98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_name, count(p.product_name) from products p inner join categories c on c.category_id=p.category_id
group by c.category_name

-- 99. 1000 Adetten fazla satılan ürünler?
select p.product_id,p.product_name, sum(od.quantity) as toplam_adet from products p 
inner join order_details od on od.product_id=p.product_id
group by p.product_id
having sum(od.quantity) > 1000

-- 100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.customer_id,c.contact_name from customers c
left join orders o on o.customer_id=c.customer_id
where o.customer_id is null

select c.customer_id,c.contact_name from customers c
left join orders o on o.customer_id=c.customer_id
group by c.customer_id,c.contact_name
having count (o.order_id) = 0	

-- 101. Hangi tedarikçi hangi ürünü sağlıyor ?
select s.company_name, p.product_name from products p 
inner join suppliers s on s.supplier_id=p.supplier_id
group by s.company_name, p.product_name

-- 102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select order_id, ship_name, shipped_date from orders

SELECT o.order_id, s.company_name, o.shipped_date FROM orders o
JOIN shippers s ON o.ship_via = s.shipper_id;

-- 103. Hangi siparişi hangi müşteri verir..?
select c.contact_name, o.order_id from customers c inner join orders o on o.customer_id=c.customer_id

-- 104. Hangi çalışan, toplam kaç sipariş almış..?
select e.employee_id, e.first_name ||' '|| e.last_name as full_name, count (o.order_id) as toplam_Siparis from employees e 
left join orders o on e.employee_id=o.employee_id
group by e.employee_id
order by toplam_Siparis desc 

select count(o.order_id) as toplam_siparis
,(select (e.first_name ||' '|| e.last_name) as full_name from employees e where e.employee_id=o.employee_id) from orders o 
group by full_name order by toplam_siparis DESC

-- 105. En fazla siparişi kim almış..?
select count(o.order_id) 
,(select (e.first_name ||' '|| e.last_name) as full_name from employees e where e.employee_id=o.employee_id) from orders o 
group by full_name  order by count(o.order_id) desc limit 1

-- 106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id, (e.first_name ||' '|| e.last_name) as Calisan_Ad_Soyad , c.contact_name from orders o 
inner join customers c on c.customer_id=o.customer_id 
inner join employees e on e.employee_id=o.employee_id

-- 107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_name,c.category_name, s.company_name from products p 
inner join categories c on c.category_id=p.category_id
inner join suppliers s on s.supplier_id=p.supplier_id

-- 108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id, c.contact_name as müsteri, (e.first_name ||' '|| e.last_name) as Calisan_Ad_Soyad, 
o.order_date,sh.company_name as kargo_sirketi, p.product_name, od.quantity, od.unit_price, ca.category_name from orders o 
inner join customers c on c.customer_id=o.customer_id 
inner join employees e on e.employee_id=o.employee_id
inner join shippers sh on sh.shipper_id=o.ship_via
inner join order_details od on od.order_id=o.order_id
inner join products p on p.product_id=od.product_id
inner join categories ca on ca.category_id=p.category_id
inner join suppliers s on s.supplier_id=p.supplier_id

-- 109. Altında ürün bulunmayan kategoriler
SELECT c.category_id, c.category_name, p.product_name FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
WHERE p.product_id IS null;

select c.category_name, p.units_in_stock from products p inner join categories c on c.category_id=p.category_id where units_in_stock=0
group by c.category_name,p.units_in_stock

-- 110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select contact_name, contact_title from customers  where contact_title  ilike '%Manager%'

-- 111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select customer_id,company_name,contact_name from customers where customer_id ilike 'Fr___'

-- 112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select company_name,phone from customers where regexp_replace(phone, '[^0-9]', '', 'g') like '171%'

-- 113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select product_name,quantity_per_unit from products where quantity_per_unit ilike '%boxes%'

-- 114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select contact_name, contact_title,phone, country from customers where country in ('France','Germany') and contact_title ilike '%Manager%'

-- 115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select product_name,unit_price from products order by unit_price desc limit 10 

-- 116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select company_name,city,country from customers 
order by country,city 

-- 117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select (first_name ||' '|| last_name) as full_name,
EXTRACT(YEAR FROM AGE(NOW(), birth_date)) as age from employees 

-- 118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select order_id,required_date,shipped_date, (required_date - shipped_date) as sevk from orders
where (required_date - shipped_date) > 35

select order_id, (shipped_date - order_date) as sevk from orders
where (shipped_date - order_date) > 35

-- 119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select c.category_name,p.unit_price from products p inner join categories c on c.category_id=p.category_id 
order by p.unit_price desc limit 1

select c.category_name,p.unit_price from categories c 
inner join products p on p.category_id=c.category_id
where p.unit_price =(select max (unit_price) from products)

-- 120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
Select product_name, category_name from products p
INNER JOIN categories c on p.category_id=c.category_id
where exists (Select category_name from categories c
             where p.category_id=c.category_id
             AND category_name ilike '%on%' );
	 
-- 121. Konbu adlı üründen kaç adet satılmıştır.
select p.product_name, sum(od.quantity) from products p 
inner join order_details od on od.product_id=p.product_id where p.product_name='Konbu'
group by  p.product_name

-- 122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select  s.country, count(distinct p.product_name) as ürün from products p 
inner join suppliers s on s.supplier_id=p.supplier_id where s.country='Japan'
group by s.country

-- 123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight) as en_yuksek , min(freight) as en_dusuk, round(avg(freight)::numeric,2) as ortalama from orders  
WHERE EXTRACT(YEAR FROM order_date) = 1997

-- 124. Faks numarası olan tüm müşterileri listeleyiniz.
select company_name, fax  from customers where fax is not null

-- 125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
Select order_id, shipped_date from orders 
WHERE shipped_date >= '1996-07-16' AND shipped_date<='1996-07-30'