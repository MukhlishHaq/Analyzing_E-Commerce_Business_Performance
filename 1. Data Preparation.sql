--	                                  ==================== Data Preparation ==================== 

--	Created by: Muhammad Mukhlish Haq
--	Email : mukhlishaq22@gmail.com
--	LinkedIn : linkedin.com/in/muhammad-mukhlish-haq-3a090b240
--	Github : github.com/MukhlishHaq

--  -----------------------------------------------------------------------------------------

--	1. Persiapkan data mentah menjadi data terstruktur sehingga siap untuk diolah. 
--	2. Masukkan data dengan format csv ke dalam database menggunakan PostgreSQL.
--  3. Buat hubungan entitas antar tabel.


-- =============== Step 1 : Membuat Database =============== 

-- Databases > Create > Database...  e-commerce


-- =============== Step 2 : Membuat Tabel =============== 

-- === products_dataset === 

CREATE TABLE products_dataset (
	product_id varchar,
  	product_category_name varchar,
  	product_name_lenght int,
  	product_description_lenght int,
  	product_photos_qty int,
  	product_weight_g decimal,
  	product_length_cm decimal,
  	product_height_cm decimal,
  	product_width_cm decimal,
	CONSTRAINT products_pk PRIMARY KEY (product_id)
);

-- === payments_dataset ==== 

CREATE TABLE payments_dataset (
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installments int,
	payment_value decimal
);

-- === reviews_dataset === 

CREATE TABLE reviews_dataset (
	review_id varchar,
	order_id varchar,
	review_score int,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
);

-- === orders_dataset ==== 

CREATE TABLE orders_dataset (
	order_id varchar,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp,
	CONSTRAINT orders_pk PRIMARY KEY (order_id)
);

-- === customers_dataset === 

CREATE TABLE customers_dataset (
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix varchar,
	customer_city varchar,
	customer_state varchar,
	CONSTRAINT customers_pk PRIMARY KEY (customer_id)
);

-- === geolocation (dirty) === 

CREATE TABLE geolocation_dirty (
	geolocation_zip_code_prefix varchar,
	geolocation_lat decimal,
	geolocation_lng decimal,
	geolocation_city varchar,
	geolocation_state varchar
);

-- === sellers_dataset === 

CREATE TABLE sellers_dataset (
	seller_id varchar,
	seller_zip_code_prefix varchar,
	seller_city varchar,
	seller_state varchar,
	CONSTRAINT sellers_pk PRIMARY KEY (seller_id)
);

-- === order_items_dataset ==== 

CREATE TABLE order_items_dataset (
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price decimal,
	freight_value decimal
);


-- =============== Step 3 : Import Dataset =============== 

--we have to clean the geolocation data first 

-- === geolocation (clean) === 

--	select string_agg(c,'')
--	from (
--	  select distinct regexp_split_to_table(lower(geolocation_city),'') as c
--	  from geolocations_dataset g 
--	) t

-- create geolocation clean

CREATE TABLE geolocation_dirty2 AS
SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, 
REPLACE(REPLACE(REPLACE(
TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(
TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(
    geolocation_city, '£,³,´,.', ''), '`', ''''), 
    'é,ê', 'e,e'), 'á,â,ã', 'a,a,a'), 'ô,ó,õ', 'o,o,o'),
	'ç', 'c'), 'ú,ü', 'u,u'), 'í', 'i'), 
	'4o', '4º'), '* ', ''), '%26apos%3b', ''''
) AS geolocation_city, geolocation_state
from geolocation_dirty gd;

CREATE TABLE geolocations_dataset AS
WITH geolocation AS (
	SELECT geolocation_zip_code_prefix,
	geolocation_lat, 
	geolocation_lng, 
	geolocation_city, 
	geolocation_state FROM (
		SELECT *,
			ROW_NUMBER() OVER (
				PARTITION BY geolocation_zip_code_prefix
			) AS ROW_NUMBER
		FROM geolocation_dirty2 
	) TEMP
	WHERE ROW_NUMBER = 1
),
custgeo AS (
	SELECT customer_zip_code_prefix, geolocation_lat, 
	geolocation_lng, customer_city, customer_state 
	FROM (
		SELECT *,
			ROW_NUMBER() OVER (
				PARTITION BY customer_zip_code_prefix
			) AS ROW_NUMBER
		FROM (
			SELECT customer_zip_code_prefix, geolocation_lat, 
			geolocation_lng, customer_city, customer_state
			FROM customers_dataset cd 
			LEFT JOIN geolocation_dirty gdd 
			ON customer_city = geolocation_city
			AND customer_state = geolocation_state
			WHERE customer_zip_code_prefix NOT IN (
				SELECT geolocation_zip_code_prefix
				FROM geolocation gd 
			)
		) geo
	) TEMP
	WHERE ROW_NUMBER = 1
),
sellgeo AS (
	SELECT seller_zip_code_prefix, geolocation_lat, 
	geolocation_lng, seller_city, seller_state 
	FROM (
		SELECT *,
			ROW_NUMBER() OVER (
				PARTITION BY seller_zip_code_prefix
			) AS ROW_NUMBER
		FROM (
			SELECT seller_zip_code_prefix, geolocation_lat, 
			geolocation_lng, seller_city, seller_state
			FROM sellers_dataset cd 
			LEFT JOIN geolocation_dirty gdd 
			ON seller_city = geolocation_city
			AND seller_state = geolocation_state
			WHERE seller_zip_code_prefix NOT IN (
				SELECT geolocation_zip_code_prefix
				FROM geolocation gd 
				UNION
				SELECT customer_zip_code_prefix
				FROM custgeo cd 
			)
		) geo
	) TEMP
	WHERE ROW_NUMBER = 1
)
SELECT * 
FROM geolocation
UNION
SELECT * 
FROM custgeo
UNION
SELECT * 
FROM sellgeo;

ALTER TABLE geolocations_dataset ADD CONSTRAINT geolocations_dataset_pk PRIMARY KEY (geolocation_zip_code_prefix);


-- =============== Step 4 : Menentukan Constraint & Foreign Key =============== 


--  products_dataset -> order_items_dataset

ALTER TABLE order_items_dataset 
ADD CONSTRAINT order_items_dataset_fk_product 
FOREIGN KEY (product_id) REFERENCES products_dataset(product_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- sellers_dataset -> order_items_dataset

ALTER TABLE order_items_dataset 
ADD CONSTRAINT order_items_dataset_fk_seller 
FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- orders_dataset -> order_items_dataset

ALTER TABLE order_items_dataset 
ADD CONSTRAINT order_items_dataset_fk_order 
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

--  orders_dataset -> payments_dataset

ALTER TABLE payments_dataset 
ADD CONSTRAINT payments_dataset_fk 
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- orders_dataset -> reviews_dataset

ALTER TABLE reviews_dataset 
ADD CONSTRAINT reviews_dataset_fk 
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- customers_dataset -> orders_dataset

ALTER TABLE orders_dataset 
ADD CONSTRAINT orders_dataset_fk 
FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- geolocations_dataset -> customers_dataset

ALTER TABLE customers_dataset 
ADD CONSTRAINT customers_dataset_fk 
FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocations_dataset(geolocation_zip_code_prefix) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- geolocations_dataset -> sellers_dataset

ALTER TABLE sellers_dataset 
ADD CONSTRAINT sellers_dataset_fk 
FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocations_dataset(geolocation_zip_code_prefix) 
ON DELETE CASCADE ON UPDATE CASCADE;