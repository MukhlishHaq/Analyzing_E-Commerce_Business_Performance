# Analyzing_E-Commerce_Business_Performance

### **Ringkasan :**
Mengukur kinerja bisnis dalam suatu perusahaan sangatlah penting karena dapat dijadikan sebagai bahan evaluasi dan penilaian terhadap perusahaan. Lebih lanjut, dapat membantu kita untuk melihat kondisi pasar saat ini, analisis produk, serta mengembangkan metode bisnis baru yang lebih efektif. Dengan demikian, proyek ini dibuat untuk menganalisis kinerja bisnis dari perusahaan eCommerce dengan meenggunakan beberapa metrik bisnis, yaitu pertumbuhan pelanggan, kualitas produk, dan jenis pembayaran.

Dalam proyek ini, analisis dilakukan dengan menggunakan **PostgreSQL** dan visualisasi hasil menggunakan **PowerBI**.

<img src="https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/postgreesql_icon.png" height="100"/>

<img src="https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/powerBI_icon.png" height="100"/>

### **Datasets :**

Dataset yang digunakan dapat diakses di [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) atau [disini](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/tree/master/dataset). Ini adalah data e-commerce Brazil mengenai pesanan yang dilakukan di Olist Store. Secara keseluruhan, data ini berisi informasi tentang 100 ribu pesanan dari tahun 2016 hingga 2018 yang dilakukan di beberapa pasar di Brasil. Fitur yang disajikan memungkinkan kita untuk melihat pesanan dari berbagai dimensi: mulai dari status pesanan, harga produk, metode pembayaran, kinerja pengiriman, lokasi pelanggan beserta geolokasi dengan kode pos, atribut produk, dan ulasan pelanggan.

## Data Preparation

1. **Membuat Database & Tabel :**

   * **Membuat Database**
  
     Buat database e-commerce dengan menggunakan query CREATE TABLE atau bisa juga dengan menggunakan pgAdmin 4 GUI

   * **Membuat Tabel**
     
     Buat beberapa tabel di dalam e-commerce database dengan menggunakan query CREATE TABLE atau bisa juga dengan menggunakan pgAdmin 4 GUI dengan menentukan nama kolom, tipe data, dan juga primary key.

   * **List of Tables Created :**
     customers_dataset, geolocations_dataset, order_items_dataset, payments_dataset, reviews_dataset, orders_dataset, products_dataset, sellers_dataset

2. **Impor Data :**

   * **Impor Data ke dalam Tabel**
     
     Pastikan nama kolom dan tipe data sudah sesuai. Kemudian, masukkan dataset dengan format .csv ke dalam setiap tabel dengan menggunakan query COPY atau bisa juga dengan menggunakan pgAdmin GUI.

   * **Pre-Cleaning Data**
   
     Khusus untuk geolocations_dataset, perlu dilakukan pembersihan data terlebih dahulu :
     1. Hapus baris yang duplikat
     2. Ubah karakter spesial di kolom City
     3. Masukkan geolocation baru dari customers_dataset dan sellers_dataset

3. **Entity Relationship :**

   Buat ERD 

   ![Entity Relationship Diagram](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/ERD.png)


## **Annual Customer Activity Growth Analysis**

**Overview :**

 Peningkatan jumlah pelanggan menjadi salah satu tujuan utama dari perusahaan e-commerce karena menunjukkan efektifitas penjulan. Selain itu juga bagaimana kita dapat mempertahankan pelanggan kita. Salah satu metrik yang digunakan untuk mengukur kinerja bisnis e-Commerce yaitu aktivitas pelanggan yang berinteraksi di platform e-commerce 
kita. Pada bagian ini kita akan menganalisis beberapa metrik terkait aktivitas pelanggan seperti jumlah pelanggan aktif, jumlah pelanggan baru, jumlah pelanggan yang melakukan pembelian berulang dan rata-rata transaksi yang dilakukan pelanggan di setiap tahunnya. Kita akan menganalisis apakah kinerja bisnis e-commerce kita mengalami pertumbuhan, 
stagnan, atau bahkan mengalami penurunan dalam setahun terakhir.

   ![overview customer activity](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/Overview%201.png)

1. ** Average Monthly Active User (MAU) tiap tahun**
   
   Menunjukkan rata-rata pelanggan aktif bulanan di tiap tahunnya
   
2. **Total Pelanggan Baru tiap tahun**

   Menunjukkan jumlah pelanggan baru di tiap tahunnya

   ![MAU & New Customer](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/customer_activity%201.png)

   **Insight :**
   * Pengguna Aktif Bulanan meningkat hingga ribuan pelanggan di setiap tahun
   * Terdapat peningkatan yang signifikan pada tahun 2017, kemudian meningkat lagi pada tahun 2018
   * Hal ini menunjukkan bahwa kinerja e-commerce sangat baik karena dapat menarik minat pelanggan yang ditunjukkan dengan peningkatan rata-rata pelanggan aktif. E-commerce melakukan promosi dengan sangat baik sehingga meningkatkan brand awareness yang berdampak pada banyaknya pelanggan baru  yang tertarik untuk memulai pesanan
  
3. **Jumlah pelanggan yang melakukan pembelian berulang tiap tahun**

    Menunjukkan jumlah pelanggan yang melakukan pembelian berulang di setiap tahunnya

4. **Rata-rata frekuensi pemesanan tiap tahun**

    Menunjukkan rata-rata frekuensi pemesanan di tiap tahunnya

   ![Repeat Customer & Num_Orders](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/customer_activity%202.png)
  
   **Insight :**
   * Terjadi peningkatan jumlah pelanggan yang melakukan pembelian berulang secara signifikan pada tahun 2017. Namun terjadi penurunan pada tahun 2018 sebanyak 89 pelanggan
   * Dari nilai rata-rata frekuensi pesanan dapat diketahui bahwa kebanyakan orang hanya memesan sekali dalam kurun waktu 3 tahun terakhir

5. **Ringkasan dan rekomendasi :**
   * Data diatas baru dimulai pada bulan September tahun 2016. Banyak sekali pelanggan
 baru yang membeli produk di e-commerce ini. Hal ini terlihat dari peningkatan pelanggan baru dan pelanggan aktif bulanan dari tahun 2016 hingga 2018. Namun terdapat perbedaan pada jumlah pembelian berulang, yaitu pada tahun 2016 ke 2017 terjadi peningkatan yang signifikan, sedangkan pada tahun 2017 ke 2018 mengalami penurunan. Hal tersebut perlu dianalisa lebih lanjut untuk mengetahui penyebab menurunnya pembelian berulang
   * Kecilnya rata-rata jumlah frekuensi pesanan setiap pelanggan mungkin disebabkan
 oleh kurangnya program atau promosi bisnis yang dapat menarik minat pelanggan. Hal ini dapat ditingkatkan dengan menginisiasi program loyalitas, memperkenalkan produk baru dan menarik calon pelanggan untuk setiap produk baru yang diluncurkan


## **Annual Product Category Quality Analysis**

**Overview :**

Kinerja bisnis E-Commerce berkaitan juga dengan produk-produk yang dimiliki dari e-commerce tersebut. Dengan menganalisis kualitas produk yang ada di e-Commerce dapat djadikan sebagai bahan evaluasi sehingga dapat mengambil keputusan yang akurat untuk dalam mengembangkan bisnis. Produk yang berkualitas berpengaruh terhadap kesuksesan perusahaan dan membantu membangun reputasinya perusahaan. Selain itu juga dapat meningkatkan pendapatan dan laba. 
Pada bagian ini, kami akan menganalisis kategori produk yang berdampak positif (dengan menggunakan metrik total pendapatan) serta kategori produk yang berdampak negatif (dengan metrik jumlah pembatalan pesanan) bagi perusahaan setiap tahunnya.

![overview product category](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/Overview%202.png)

1. **Pendapatan per tahun**

   Menunjukkan total pendapatan perusahaan dari tiap tahunnya
   

2. **Jumlah pesanan yang dibatalkan per 
tahun**

   Create a table that contains information on the total number of canceled orders for each year

   ![total revenue & total canceled](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/category_quality%201.png)

   **Insight :**
   * Terjadi peningkatan pendapatan di tiap tahunnya. Hal ini bisa disebabkan oleh jumlah pelanggan baru yang meningkat signifikan di tiap tahunnya
   * Terjadi peningkatan pesanan yang dibatalkan di tahun 2016 ke 2018. Diperlukan data tambahan untuk mengetahui alasan pembatalan pesanan sehingga dapat menekan jumlah pembatalan di tahun selanjutnya
  
3. **Top kategori yang memilki pendaptan terbesar per tahun**

   Menunjukkan kategori produk yang memiliki total pendapatan di tiap tahunnya

4. **Top kategori dengan memiliki pembatalan pesanan paling banyak**

   Menunjukkan kategori produk yang memiliki total pembatalan pesanan paling banyak
   
   ![top product revenue & canceled](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/category_quality%202.png)

   Observation :
   * Kategori produk yang memiliki top revenue maupun top cancaled, semuanya memiliki jenis berbeda dari tiap tahunnya
   * Di tahun 2018 ada hal menarik yaitu kategori kesehatan kecantikan berada pada posisi pertama untuk top revenue dan top canceled. Hal ini terjadi karena pesanan terbanyak ada pada kategori kesehatan dan kecantikan


## **Analysis of Annual Payment Type Usage**

**Overview :**

Analisis pendapatan yang efektif memerlukan pertimbangan metode pembayaran dan dampaknya terhadap perilaku pelanggan. Dari hasil analisis menunjukkan bahwa pelanggan cenderung membatalkan pembelian mereka jika opsi pembayaran yang mereka inginkan tidak tersedia. Dalam e-commerce, menawarkan sistem pembayaran terbuka dengan beragam pilihan sangatlah penting. Menganalisis kinerja dari masing-masing tipe pembayaran dapat menciptakan strategic partnership dengan penyedia jasa pembayaran, meningkatkan kepuasan pelanggan dan mengoptimalkan pendapatan.

![total usage](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/Overview%203.png)

![usage each year](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/Overview%204.png)

1. ** Total penggunaan tiap jenis pembayaran secara keseluruhan tahun**

    Menunjukkan total penggunaan dari setiap jenis pembayaran secara keseluruhan tahun dan diurutkan berdasarkan yang paling banyak diminati

   ![total usage visual](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/annual_payment%201.png)

   **Observation :**
   * Credit Card menjadi metode pembayaran paling diminati oleh pelanggan. Sehingga perusahaan dapat bekerja sama dengan penyedia kartu kredit bankuntuk memberikan promo yang lebih menarik. Lebih lanjut, dapat dilakukan analisis untuk mengetahui kategori produk apa yang sering dibeli oleh pelanggan menggunakan kartu credit
  
2. **Jumlah penggunaan dari setiap jenis metode pembayaran per tahunnya**

   Menunjukkan total penggunaan dari setiap jenis metode pembayaran di setiap tahunnya
   
    ![usage each year visual](https://github.com/MukhlishHaq/Analyzing_E-Commerce_Business_Performance/blob/master/visualization/annual_payment%202.png)

   **Insight :**
   * Setiap jenis pembayaran cenderung meningkat di setiap tahunnya
   * Pembayaran menggunakan voucher mengalami penurunan pada tahun 2018. Hal ini bisa jadi disebabkan karena kurangnya promosi terhadap pengguna voucher

## **Kesimpulan**

* Terjadi pertumbuhan pelanggan di setiap metrik dari tahun 2016 hingga 2018, termasuk peningkatan jumlah pelanggan baru dan Pengguna Aktif Bulanan (MAU). Namun, pelanggan yang melakukan pembelian berulang terlihat cenderung stagnan selama periode ini.
* Berdasarkan dari hasil analisis kualitas kategori produk menunjukkan bahwa pertumbuhan total pendapatan perusahaan konsisten di setiap tahunnya. Menariknya, kategori produk yang menghasilkan pendapatan terbanyak dan juga ketegori produk dengan pembatalan pesanan terbanyak di setiap tahunnya mengalami perubahan. Berdasarkan data yang ada juga menunjukkan bahwa kategori kesehatan dan kecantikan menjadi kategori produk yang paling banyak terjual dan paling banyak dibatalkan.
* Penggunaan setiap metode pembayaran mengalami peningkatan yang signifikan dari tahun ke tahun. Hal tersebut sejalan dengan adanya peningkatan penjualan. Kartu kredit merupakan metode pembayaran yang paling umum digunakan pada tahun 2016 hingga 2018. Berbanding terbalik dengan metode pembayaran voucher mengalami penurunan pada tahun 2018.
