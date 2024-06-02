--	                         ====================== Annual Customer Activity Growth Analysis	====================== 

--	Created by: Muhammad Mukhlish Haq
--	Email : mukhlishaq22@gmail.com
--	LinkedIn : linkedin.com/in/muhammad-mukhlish-haq-3a090b240
--	Github : github.com/MukhlishHaq

--  -----------------------------------------------------------------------------------------

--	Lakukan analisis terhadap performa bisnis e-Commerce, apakah aktivitas customernya mengalami pertumbuhan, stagnan atau bahkan mengalami penurunan dalam kurun waktu tahunan. 

--	Langkah - langkah :
--	1. Menampilkan rata-rata jumlah customer aktif bulanan (monthly active user) dari tiap tahun
--	Hint: Perhatikan kesesuaian dari format tanggal 
--	2. Menampilkan jumlah customer baru pada tiap tahun
--	Hint: Pelanggan baru adalah pelanggan yang melakukan order pertama kali
--	3. Menampilkan jumlah customer yang melakukan pembelian lebih dari satu kali atau melakukan pembelian berulang (repeat order) pada tiap tahun
--	Hint: Pelanggan yang melakukan repeat order adalah pelanggan yang melakukan order lebih dari sekali atau melakukan pembelian secara berulang
--	4. Menampilkan rata-rata jumlah order yang dilakukan oleh customer pada tiap tahun
--	Hint: Hitung frekuensi pembelian (berapa kali customer melakukan pembelian) untuk masing-masing customer terlebih dahulu
--	5. Menggabungkan keempat metrik yang telah berhasil ditampilkan menjadi satu tampilan tabel
--	Hint: Lakukan pembuatan tabel sementara terhadap subtask-subtask yang sebelumnya telah dikerjakan terlebih dahulu


--	Hasil : 
--	1. Rata-rata Monthly Active User (MAU) per tahun
--	2. Total customer baru per tahun
--	3. Jumlah customer yang melakukan repeat order per tahun
--	3. Rata-rata frekuensi order untuk setiap tahun
--	4. Master tabel yang berisi semua informasi di atas


--	1. Menampilkan rata-rata jumlah customer aktif bulanan (monthly active user) dari tiap tahun
--	Hint: Perhatikan kesesuaian dari format tanggal 

--	- Buat subquery yang menunjukkan jumlah pelanggan bulanan dari tiap tahun
--	- Gunakan fungsi agregasi utnuk mendapatkan rata-rata pelanggan bulanan di tiap tahun

SELECT 
	year, 
	floor(avg(n_customers)) AS avg_monthly_active_user
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		date_part('month', o.order_purchase_timestamp) AS month,
		count(DISTINCT c.customer_unique_id) AS n_customers
	FROM orders_dataset o
	JOIN customers_dataset c 
	ON o.customer_id = c.customer_id 
	GROUP BY 1,2
) monthly
GROUP BY 1
ORDER BY 1;


--	2. Menampilkan jumlah customer baru pada tiap tahun
--	Hint: Pelanggan baru adalah pelanggan yang melakukan order pertama kali

--	- Buat subquery yang menunjukkan tanggal pertama pemesanan dari tiap pelanggan
--	- Gunakan fungsi agregasi untuk mendapatkan jumlah pelanggan baru dari tiap tahun

SELECT 
	date_part('year', first_date_order) AS year,
	count(customer_unique_id) AS total_new_customers
FROM (
	SELECT 
		c.customer_unique_id, 
		min(o.order_purchase_timestamp) AS first_date_order
	FROM orders_dataset o 
	JOIN customers_dataset c 
	ON o.customer_id = c.customer_id 
	GROUP BY 1
) first_order
GROUP BY 1
ORDER BY 1;


--	3. Menampilkan jumlah customer yang melakukan pembelian lebih dari satu kali atau melakukan pembelian berulang (repeat order) pada tiap tahun
--	Hint: Pelanggan yang melakukan repeat order adalah pelanggan yang melakukan order lebih dari sekali atau melakukan pembelian secara berulang

-- - Buat subquery yang menunjukkan jumlah pesanan dari tiap pelanggan
-- - Gunakan filter pada pelanggan yang melakukan pemesanan lebih dari 1
-- - Gunakan fungsi agregasi untuk mendapatkan jumlah pelanggan yang melakukan pembelian berulang

SELECT 
	year,
	count(DISTINCT customer_unique_id) AS total_repeat_customers
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		c.customer_unique_id,
		count(c.customer_unique_id) AS n_customer,
		count(o.order_id) AS n_order
	FROM orders_dataset o 
	JOIN customers_dataset c 
	ON o.customer_id = c.customer_id 
	GROUP BY 1,2
	HAVING count(o.order_id) > 1
) repeat_order
GROUP BY 1
ORDER BY 1;


--	4. Menampilkan rata-rata jumlah order yang dilakukan oleh customer pada tiap tahun
--	Hint: Hitung frekuensi pembelian (berapa kali customer melakukan pembelian) untuk masing-masing customer terlebih dahulu

-- - Buat subquery yang menunjukkan jumlah pembelian dari tiap pelanggan
-- - Gunakan fungsi agregasi untuk mendapatkan rata-rata pembelian dari tiap tahun

SELECT 
	year,
	round(avg(n_order), 2) AS avg_num_orders
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		c.customer_unique_id,
		count(c.customer_unique_id) AS n_customer,
		count(o.order_id) AS n_order
	FROM orders_dataset o 
	JOIN customers_dataset c 
	ON o.customer_id = c.customer_id 
	GROUP BY 1,2
) order_customer
GROUP BY 1
ORDER BY 1;


--	5. Menggabungkan keempat metrik yang telah berhasil ditampilkan menjadi satu tampilan tabel
--	Hint: Lakukan pembuatan tabel sementara terhadap subtask-subtask yang sebelumnya telah dikerjakan terlebih dahulu

WITH tbl_mau AS (
	SELECT 
		year, 
		floor(avg(n_customers)) AS avg_monthly_active_user
	FROM (
		SELECT 
			date_part('year', o.order_purchase_timestamp) AS year,
			date_part('month', o.order_purchase_timestamp) AS month,
			count(DISTINCT c.customer_unique_id) AS n_customers
		FROM orders_dataset o
		JOIN customers_dataset c 
		ON o.customer_id = c.customer_id 
		GROUP BY 1,2
	) monthly
	GROUP BY 1
),
tbl_newcust AS (
	SELECT 
		date_part('year', first_date_order) AS year,
		count(customer_unique_id) AS new_customers
	FROM (
		SELECT 
			c.customer_unique_id, 
			min(o.order_purchase_timestamp) AS first_date_order
		FROM orders_dataset o 
		JOIN customers_dataset c 
		ON o.customer_id = c.customer_id 
		GROUP BY 1
	) first_order
	GROUP BY 1
),
tbl_repcust AS (
	SELECT 
		year,
		count(DISTINCT customer_unique_id) AS repeat_customers
	FROM (
		SELECT 
			date_part('year', o.order_purchase_timestamp) AS year,
			c.customer_unique_id,
			count(c.customer_unique_id) AS n_customer,
			count(o.order_id) AS n_order
		FROM orders_dataset o 
		JOIN customers_dataset c 
		ON o.customer_id = c.customer_id 
		GROUP BY 1,2
		HAVING count(o.order_id) > 1
	) repeat_order
	GROUP BY 1
),
tbl_avgorder AS (
	SELECT 
		year,
		round(avg(n_order), 2) AS avg_num_orders
	FROM (
		SELECT 
			date_part('year', o.order_purchase_timestamp) AS year,
			c.customer_unique_id,
			count(c.customer_unique_id) AS n_customer,
			count(o.order_id) AS n_order
		FROM orders_dataset o 
		JOIN customers_dataset c 
		ON o.customer_id = c.customer_id 
		GROUP BY 1,2
	) order_customer
	GROUP BY 1
)
SELECT 
	tm.year, 
	tm.avg_monthly_active_user, 
	tnc.new_customers, 
	trc.repeat_customers, 
	tao.avg_num_orders
FROM tbl_mau tm
JOIN tbl_newcust tnc
ON tm.year = tnc.year 
JOIN tbl_repcust trc
ON tm.year = trc.year 
JOIN tbl_avgorder tao
ON tm.year = tao.year 
ORDER BY 1;