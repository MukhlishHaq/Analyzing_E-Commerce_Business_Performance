--	                          =================== Annual Payment Type Usage Analysis =================== 

--	Created by: Muhammad Mukhlish Haq
--	Email : mukhlishaq22@gmail.com
--	Linkedin : linkedin.com/in/muhammad-mukhlish-haq-3a090b240
--	Github : github.com/MukhlishHaq 

--  -----------------------------------------------------------------------------------------

--	Analisis terhadap tipe-tipe pembayaran yang tersedia dan melihat performanya dalam beberapa tahun terakhir.

--	Langkah - langkah :
--	1. Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit 
--	Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan
--	2. Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun
--	Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan


--	Hasil : 
--	1. Jumlah penggunaan dari masing-masing tipe pembayaran secara keseluruhan
--	2. Detail jumlah penggunaan dari masing-masing tipe pembayaran untuk setiap tahun
--	3. Tabel ringkasan dari jumlah penggunaan tipe-tipe pembayaran per tahun.




--	1. Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit 
--	Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan

-- - Buat tabel yang menunjukkan jumlah penggunaan dari setiap tipe pembayaran secara keseluruhan
-- - Urutkan jumlah penggunaan tipe pembayaran dari yang terbanyak hingga terkecil

SELECT 
	p.payment_type,
	count(*) AS total_usage
FROM orders_dataset o 
JOIN payments_dataset p 
ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 2 DESC; 


--	2. Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun
--	Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan

-- - Buat tabel yang menunjukkan jumlah dari setiap tipe pembayaran di tiap tahunnya
-- - Urutkan jumlah penggunaan tipe pembayaran dari yang terbanyak hingga terkecil

SELECT 
	date_part('year', o.order_purchase_timestamp) as year,
	p.payment_type,
	count(*) AS total_usage 
FROM orders_dataset o 
JOIN payments_dataset p 
ON o.order_id = p.order_id
GROUP BY 1,2
ORDER BY 1 ASC, 3 DESC;


--	3. Satu tabel summary jumlah penggunaan tipe-tipe pembayaran untuk masing-masing tahun.

-- - Gunakan fungsi CASE WHEN untuk pivot data (rows : payment_type, columns : year)
-- - Gabungkan fungsi CASE WHEN dengan fungsi agregasi untuk membagi nilai dalam kolom
-- - urutkan jumlah penggunaan tipe pembayaran dari yang terbanyak hingga terkecil

-- Cara 1
WITH type_payments AS (
	SELECT 
		date_part('year', o.order_purchase_timestamp) as year,
		p.payment_type,
		count(*) AS num_of_usage 
	FROM orders_dataset o 
	JOIN payments_dataset p 
	ON o.order_id = p.order_id
	GROUP BY 1,2
)
select 
  payment_type,
  sum(case when year = '2016' then num_of_usage else 0 end) as year_2016,
  sum(case when year = '2017' then num_of_usage else 0 end) as year_2017,
  sum(case when year = '2018' then num_of_usage else 0 end) as year_2018
from type_payments
GROUP BY 1
ORDER BY 4 DESC;


-- Cara 2
SELECT
	payment_type,
	count(CASE WHEN date_part('year', order_purchase_timestamp) = '2016' THEN o.order_id END) AS tahun_2016,
	count(CASE WHEN date_part('year', order_purchase_timestamp) = '2017' THEN o.order_id END) AS tahun_2017,
	count(CASE WHEN date_part('year', order_purchase_timestamp) = '2018' THEN o.order_id END) AS tahun_2018
FROM orders_dataset o
JOIN payments_dataset p 
ON o.order_id = p.order_id 
GROUP BY 1
ORDER BY 4 DESC;