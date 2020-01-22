--Progress 2

--Query create table--

create table merk(
	idMerk varchar(5) primary key not null,
	namaMerk varchar(25) not null
);

create table jenisMobil(
	idJenisMobil varchar(5) primary key not null,
	namaJenisMobil varchar(25),
	idMerk varchar(5) not null references merk(idMerk)
);

create table jenisSparePart(
	idJenisSparePart varchar(45) primary key not null,
	jenisSukuCadang varchar(45)
);

create table SparePart(
	idSparePart varchar(10) primary key not null,
	namaSparePart varchar(50),
	stock int not null,
	--limit int not null,
	harga int not null,
	idJenisSparePart varchar(45) not null references jenisSparePart(idJenisSparePart)
);

create table SKMobil(
	idJenisMobil varchar(5) not null references jenismobil(idJenisMobil),
	idSparePart varchar(10) not null references SparePart(idSparePart)
);

create table pelanggan(
	idPelanggan varchar(20) primary key not null,
	namaPelanggan varchar(45),
	Telephone varchar(13),
	alamat varchar(45) not null
);

create table mobil(
	idMobil varchar(10) primary key not null,
	noRangka varchar(20) not null,
	noMesin varchar(20) not null,
	idJenisMobil varchar(5) not null references jenisMobil(idJenisMobil),
	idPelanggan varchar(20) not null references pelanggan(idPelanggan)
);

create table detailJasa(
	idJasa varchar(5) primary key not null,
	jenisJasa varchar(20) not null,
	biayaJasa real not null
);

create table service(
	noNota varchar(5) primary key not null,
	kilometer int not null,
	tanggal date not null,
	keluhan varchar(50),
	idMobil varchar(10) not null references mobil(idMobil)
);

create table jasaService(
	keterangan varchar(50),
	discount real,
	biaya real not null,
	noNota varchar(5) not null references service(noNota),
	idJasa varchar(5) not null references detailJasa(idJasa)
);

create table pemesanan(
	noNota varchar(5) not null references service(noNota),
	idSparePart varchar(10) not null references SparePart(idSparePart),
	jumlah real not null,
	totalHarga real not null
);


--Query insert data--

--table merk
insert into merk values ('M001','Jeep'),('M002','Lamborghini'),('M003','Toyota'),('M004','Ferrari'),('M005','Mercedes-Benz');

--table jenisMobil
insert into jenisMobil values ('J001','Jeep Cherokee','M001'),('J002','Jeep Renegade','M001'),('J003','Lamborghini 350 JT','M002'),
('J004','Lamborghini Miura','M002'),('J005','Toyota Alphard','M003'),('J006','Toyota Fortuner','M003'),('J007','Ferrari Fortofino','M004'),
('J008','Ferrari 488 Spider','M004'),('J009','Marchedes-Benz Hathback','M005'),('J010','Marchedes-Benz MPV','M005');

--table jenisSparePart
insert into jenisSparePart values ('JSP01','Busi'),('JSP02','Aki'),('JSP03','Filter'),('JSP04','Kanvas rem'),('JSP05','Kanvas kopling');

--table SparePart
insert into SparePart values ('SP001','Busi Jeep ABC',100,50000,'JSP01'),('SP002','Busi Jeep DEF',50,50000,'JSP01'),('SP003','Busi Lamborghini ABC',10,150000,'JSP01'),
('SP004','Aki Lambhorghini XYZ',5,500000,'JSP02'),('SP005','Filter Toyota',15,100000,'JSP03'),('SP006','Kanvas rem Toyota',20,150000,'JSP04'),('SP007','Kanvas kopling Toyota',10,120000,'JSP05'),
('SP008','Kanvas rem Ferrari',8,250000,'JSP04'),('SP009','Busi Mercedes-Benz ABC',20,200000,'JSP01');

--table SKMobil
insert into SKMobil values ('J001','SP001'),('J002','SP001'),('J003','SP003'),('J004','SP004'),('J005','SP005'),('J005','SP007'),('J006','SP005'),('J006','SP006'),
('J007','SP007'),('J007','SP008'),('J008','SP008'),('J009','SP009'),('J010','SP009');

--table pelanggan
insert into pelanggan values('P001','Zulkifli','0895802640170','Situ Indah'),('P002','Joko Anwar','0895802640172','Gorong-gorong'),
('P003','Jaenuddin','0895802640173','Pasar Malam'),
('P004','Dimas','0895802640174','Cilengsi'),('P005','Abdul Malik','0895802640175','Jonggol');

--table mobil
insert into mobil values ('MB001','R123456','M1996','J001','P005'),('MB002','R789012','M1997','J004','P004'),('MB003','R050498','M1998','J010','P001'),
('MB004','R984050','M1995','J006','P003'),('MB005','R890054','M1991','J008','P002');

--table detailJasa
insert into detailJasa values ('JS001','Ganti Busi',100000),('JS002','Cuci Busi',50000),('JS003','Ganti Aki',200000),('JS004','Perawatan Aki',250000),
('JS005','Ganti Kanvas rem',150000),('JS006','Ganti Kanvas kopling',100000);

--table service
insert into service values ('N0001',500,'2019-12-01','Suara mobil kurang halus','MB001'),('N0002',700,'2019-12-06','Mobil kurang nyaman','MB002'),
('N0003',900,'2019-12-11','Bensin mobil cepat habis','MB003'),('N0004',600,'2019-12-16','Oli mobil tumpah-tumpah','MB004'),
('N0005',1000,'2019-12-21','Stir mobil gerak-gerak','MB005');

--table jasaService
insert into jasaService values ('Busi mobil sudah berkarat',null,100000,'N0001','JS001'),('Aki sudah melemah',null,200000,'N0002','JS003'),
('Ada busi yang hilang',null,100000,'N0003','JS001'),('Ada busi yang kurang rapat',null,50000,'N0004','JS002'),
('Kampas rem mengakibatkan kehilangan fokus',null,150000,'N0005','JS005'),('Kampas kopling mengakibatkan gagal fokus',null,100000,'N0005','JS006');

--table pemesanan
insert into pemesanan values ('N0001','SP001',5,250000),('N0002','SP004',1,500000),('N0003','SP009',2,400000);


--function(1) untuk mengupdate stok sparepart--
create or replace function update_stock_sparepart(varchar,varchar,int)
returns int as
$$
	declare
		id_SparePart alias for $1;
		jenis_SparePart alias for $2;
		tambahStock alias for $3;
		stockSparePart int;

	begin
		select into stockSparePart stock from SparePart where idSparePart = id_SparePart and idJenisSparePart = jenis_SparePart;

		if stockSparePart >= 100
		then
			return 'Jumlah stock tidak boleh lebih dari 100 stock';
		else
			stockSparePart := stockSparePart + tambahStock;
		end if;

		update SparePart set stock = stockSparePart where idSparePart = id_SparePart and idJenisSparePart = jenis_SparePart;

		return stockSparePart;
end
$$ language plpgsql;

--update stock sparepart menggunakan function
select update_stock_sparepart('SP004','JSP02',10);

select * from SparePart;


--Progress 3

--tambah column utk melihat kapan penambahan data dilakukan jika menggunakan function
alter table SparePart add column insert_function timestamp;

--function(2) untuk menambah data stock pada table sparepart
create or replace function insert_stock_sparepart(varchar,varchar,int,real,varchar)
returns timestamp as
$$
	declare
		id_SparePart alias for $1;
		nama_SparePart alias for $2;
		stock_SparePart alias for $3;
		harga_SparePart alias for $4;
		id_jenisSparePart alias for $5;
		waktuInsertData timestamp;
	
	begin
		waktuInsertData := 'now';
		
		insert into SparePart values (id_SparePart,nama_SparePart,stock_SparePart,harga_SparePart,id_jenisSparePart, waktuInsertData);
		
		return waktuInsertData;
end
$$ language plpgsql;

select insert_stock_sparepart('testing','testing',1,1000,'JSP01');
select update_stock_sparepart('testing','JSP01',99);

select * from SparePart;


--function untuk trigger(1)
create or replace function beli_stock_sparepart()
returns trigger as
$$
	declare
		banyakStock int;
	
	begin
		select into banyakStock stock from SparePart where idSparePart = new.idSparePart;
		
		if banyakStock >= new.jumlah
			then
			update SparePart set stock = banyakStock - new.jumlah where idSparePart = new.idSparePart;
		end if;
	
		return new;
end
$$ language plpgsql;	

--penggunaan trigger pada table pemesanan utk mengurangi stock pada table SparePart
create trigger sisa_stock_sparepart before insert on pemesanan
for each row
execute procedure beli_stock_sparepart();

--tes trigger
insert into pemesanan values('N0004','SP005',5,5000);

select * from pemesanan;

select * from sparepart;



