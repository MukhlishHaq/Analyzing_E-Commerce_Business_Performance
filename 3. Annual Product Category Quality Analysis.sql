--	                         =================== Annual Product Category Quality Analysis	=================== 

--	Created by: Muhammad Mukhlish Haq
--	Email : mukhlishaq22@gmail.com
--	Linkedin : linkedin.com/in/muhammad-mukhlish-haq-3a090b240
--	Github : github.com/MukhlishHaq

--  -----------------------------------------------------------------------------------------

--	Menganalisis performa dari masing-masing kategori produk yang ada dan bagaimana kaitannya dengan pendapatan perusahaan.

--	Langkah - langkah	:
--	1. Membuat tabel yang berisi informasi pendapatan total perusahaan untuk tiap tahun
--	Hint: Revenue adalah harga barang dan juga biaya kirim. Pastikan juga melakukan filtering terhadap order status yang tepat untuk menghitung pendapatan
--	2. Membuat tabel yang berisi informasi jumlah cancel order total dari tahun
--	Hint: Perhatikan filtering terhadap order status yang tepat untuk menghitung jumlah cancel order
--	3. Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun
--	Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan
--	4. Membuat tabel yang berisi nama kategori produk yang memiliki jumlah cancel order terbanyak untuk masing-masing tahun
--	Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan
--	5. Menggabungkan informasi-informasi yang telah didapatkan ke dalam satu tampilan tabel
--	Hint: Perhatikan teknik join yang dilakukan serta kolom-kolom yang dipilih

--	Hasil : 
--	1. Tabel revenue per tahun
--	2. Tabel jumlah cancel order per tahun
--	3. Tabel top kategori yang menghasilkan revenue terbesar per tahun
--	4. Tabel kategori yang mengalami cancel order terbanyak per tahun
--	5. Master tabel yang berisi informasi-informasi di atas


-- RESET TABLE

-- Untuk memastikan hasil tidak bertambah atau berbeda dengan input awal

DROP TABLE IF EXISTS total_revenue_year; 
DROP TABLE IF EXISTS total_canceled_orders_year;
DROP TABLE IF EXISTS top_product_category_revenue_year; 
DROP TABLE IF EXISTS top_product_category_canceled_year; 


--	1. Membuat tabel yang berisi informasi pendapatan total perusahaan untuk masing-masing tahun
--	Hint: Revenue adalah harga barang dan juga biaya kirim. Pastikan juga melakukan filtering terhadap order status yang tepat untuk menghitung pendapatan

-- - Buat CTE revenue_orders untuk menampilkan jumlah revenue setiap pesanan, sehingga dapat mengurangi komputasi pada saat penggabungan nantinya
-- - Pendapatan diperoleh dengan menjumlahkan price dan freight value
-- - Menggunakan fungsi agregasi untuk menjumlahkan revenue dari setiap tahunnya
-- - Setting filter = 'delivered' karena perlu persetujuan agar transaksi selesai sepenuhnya

CREATE TABLE total_revenue_year AS 
WITH revenue_orders AS (
	SELECT 
		order_id,
		sum(price + oi.freight_value) AS revenue
	FROM order_items_dataset oi
	GROUP BY 1
)
SELECT 
	date_part('year', o.order_purchase_timestamp) AS year,
	sum(po.revenue) AS revenue
FROM orders_dataset o 
JOIN revenue_orders po
ON o.order_id = po.order_id 
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;


--	2. Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun
--	Hint: Perhatikan filtering terhadap order status yang tepat untuk menghitung jumlah cancel order

-- - Gunakan fungsi agregasi untuk menjumlahkan orders dari pesanan tiap tahunnya
-- - Setting filter = 'canceled' karena diperlukan untuk menentukan transaksi yang dibatalkan

CREATE TABLE total_canceled_orders_year AS 
SELECT 
	date_part('year', order_purchase_timestamp) AS year,
	count(order_id) AS total_cancel
FROM orders_dataset o
WHERE order_status = 'canceled'
GROUP BY 1
ORDER BY 1;


--	3. Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun
--	Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan

-- - Buat CTE untuk mendapatkan total revenue tiap kategori produk di tiap tahunnya
-- - Gunakan fungsi Row_number()untuk mengurutkan pendapatan
-- - Gunakan fungsi filter rank = 1 untuk mendapatkan kategori produk teratas di tiap tahunnya

CREATE TABLE top_product_category_revenue_year AS 
WITH revenue_category_orders AS (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		p.product_category_name,
		sum(oi.price + oi.freight_value) AS revenue,
		ROW_NUMBER() OVER(
			PARTITION BY date_part('year', o.order_purchase_timestamp) 
			ORDER BY sum(oi.price + oi.freight_value) desc
		) AS rank
	FROM orders_dataset o 
	JOIN order_items_dataset oi
	ON o.order_id = oi.order_id 
	JOIN products_dataset p 
	ON oi.product_id = p.product_id 
	WHERE order_status = 'delivered'
	GROUP BY 1, 2
)
SELECT 
	year, 
	product_category_name,
	revenue
FROM revenue_category_orders
WHERE rank = 1;


--	4. Membuat tabel yang berisi nama kategori produk yang memiliki jumlah cancel order terbanyak untuk masing-masing tahun
--	Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan

-- - Gunakan CTE untuk mendapatkan jumlah orders canceled tiap kategori di setiap tahunnya
-- - Gunakan fungsi ROW_NUMBER() untuk mengurutkan jumlah canceled
-- - Setting filter rank = 1 untuk mendapatkan canceled product teratas di tiap tahunnya

CREATE TABLE top_product_category_canceled_year AS 
WITH canceled_category_orders AS (
	SELECT 
		date_part('year', o.order_purchase_timestamp) AS year,
		p.product_category_name,
		count(*) AS total_cancel,
		ROW_NUMBER() OVER(
			PARTITION BY date_part('year', o.order_purchase_timestamp) 
			ORDER BY count(*) desc
		) AS rank
	FROM orders_dataset o 
	JOIN order_items_dataset oi
	ON o.order_id = oi.order_id 
	JOIN products_dataset p 
	ON oi.product_id = p.product_id 
	WHERE order_status = 'canceled'
	GROUP BY 1, 2
)
SELECT 
	year, 
	product_category_name,
	total_cancel
FROM canceled_category_orders
WHERE rank = 1;


--	5. Menggabungkan informasi-informasi yang telah didapatkan ke dalam satu tampilan tabel
--	Hint: Perhatikan teknik join yang dilakukan serta kolom-kolom yang dipilih

SELECT 
	tpr.year, 
	tpr.product_category_name AS top_product_category_revenue, 
	tpr.revenue AS top_category_revenue, 
	try.revenue AS total_revenue_year,
	tpc.product_category_name AS top_product_category_canceled,
	tpc.total_cancel AS top_category_num_canceled,
	tco.total_cancel AS total_canceled_orders_year
FROM top_product_category_revenue_year tpr
JOIN total_revenue_year try 
ON tpr.year = try.year
JOIN top_product_category_canceled_year tpc
ON tpr.year = tpc.year
JOIN total_canceled_orders_year tco 
ON tpr.year = tco.YEAR;