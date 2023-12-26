drop database if exists productos;
CREATE DATABASE if not exists productos; 
Use productos;
CREATE TABLE categoria (
  codigo_cat INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre_cat VARCHAR(20) NOT NULL
);

CREATE TABLE fabricante (
  codigo_fa INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre_fa VARCHAR(20) NOT NULL
);

CREATE TABLE producto (
  codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio decimal(6,2) NOT NULL,
  codigo_fa INT UNSIGNED NOT NULL,
  codigo_cat INT UNSIGNED NOT NULL,
  stock int unsigned NOT NULL,
  CONSTRAINT fk_productofa FOREIGN KEY (codigo_fa) REFERENCES fabricante(codigo_fa),
  CONSTRAINT fk_productocat FOREIGN KEY (codigo_cat) REFERENCES categoria(codigo_cat)
);

-- añadir datos a fabricante
INSERT INTO fabricante VALUES(1,'LG');
INSERT INTO fabricante VALUES(2,'Lenovo');
INSERT INTO fabricante VALUES(3,'Hewlett-Packard');
INSERT INTO fabricante VALUES(4,'Samsung');
INSERT INTO fabricante VALUES(5,'Seagate');
INSERT INTO fabricante VALUES(6,'Corsair');
INSERT INTO fabricante VALUES(7,'Gigabyte');
INSERT INTO fabricante VALUES(8,'Apple');
INSERT INTO fabricante VALUES(9,'Intel');
INSERT INTO fabricante VALUES(10,'AMD');
-- añadir datos a categorias.
INSERT INTO categoria VALUES(1,'Almacenamiento');
INSERT INTO categoria VALUES(2,'Memorias');
INSERT INTO categoria VALUES(3,'Gráfica');
INSERT INTO categoria VALUES(4,'Monitor');
INSERT INTO categoria VALUES(5,'Portàtil');
INSERT INTO categoria VALUES(6,'Impresoras');
INSERT INTO categoria VALUES(7,'Procesadores');
INSERT INTO categoria VALUES(8,'Tablet');
INSERT INTO categoria VALUES(9,'Telefono');
INSERT INTO categoria VALUES(10,'Placa Base');
-- añadir datos a producto
INSERT INTO producto VALUES(1,'Disco duro SATA3 1TB', 86, 4, 1 ,10);
INSERT INTO producto VALUES(2,'Memoria RAM DDR4 8GB', 120, 6, 2, 20);
INSERT INTO producto VALUES(3,'Disco SSD 1 TB', 150, 4, 1,5);
INSERT INTO producto VALUES(4,'GeForce GTX 1060',185, 7, 3,2);
INSERT INTO producto VALUES(5,'GeForce GTX 3080 Xtreme',755, 6, 3,5);
INSERT INTO producto VALUES(6,'Monitor 24 LED Full HD',202, 1, 4, 7);
INSERT INTO producto VALUES(7,'Monitor 27 LED Full HD',245, 1, 4, 8);
INSERT INTO producto VALUES(8,'Portátil Yoga 720',559, 2, 5,2);
INSERT INTO producto VALUES(9,'Portátil Ideapd 820',444, 2, 5,6);
INSERT INTO producto VALUES(10,'Impresora HP Deskjet 3720',59, 3, 6,1);
INSERT INTO producto VALUES(11,'Impresora HP Laserjet Pro M26nw',180, 3, 6,2);
insert into producto values (12,'Intel Core i5-12400F',199, 9, 7, 5);
insert into producto values (13,'Intel Core i7-13700KF',399,9, 7,10);
insert into producto values (14,'AMD Ryzen 7 5800X', 225, 10, 7, 8);
insert into producto values (15,'AMD Ryzen 9 7950X3D',769, 10, 7, 0);
insert into producto values (16,'Samsung galaxy tab s6 lite',320, 4, 8, 2);
insert into producto values (17,'Apple Ipad 2021 WIFI',407, 8, 8, 3);
insert into producto values (18,'Apple Ipad Pro 128GB',1029, 8, 8, 2);
insert into producto values (19,'Apple Iphone 14 plus 128GB',1109, 8, 9, 2);
INSERT INTO producto VALUES(20,'Lenovo Tab M10 Plus',167, 2, 8,5);
INSERT INTO producto VALUES(21,'MacBook Air M2',1299, 8, 5,2);
INSERT INTO producto VALUES(22,'MacBook Pro M2',1359, 8, 5,2);
insert into producto values(23,'Samsung Galaxy Book2 Pro',1010, 4, 5, 0);
INSERT INTO producto VALUES(24,'Monitor 29 LED Full HD',245, 4, 4, 2);
INSERT INTO producto VALUES(25,'Memoria DDR5 32GB',129, 6, 2, 1);

-- Inserta un nuevo registro en cada tabla.
insert into categoria values(11, 'Camera');
insert into fabricante values(11, 'Logitech'); 
insert into producto values(26, 'Logitech HD Pro C920 Webcam FullHD', 87.99, 11, 11, 8);  

/* Crea una nueva tabla llamada temporal que almacene para cada producto: el código, 
el nombre, el precio, el stock, el nombre del fabricante y la categoría. */
create table temporal as
select producto.codigo, producto.nombre, producto.precio, producto.stock, fabricante.nombre_fa, categoria.nombre_cat
from producto inner join fabricante on producto.codigo_fa=fabricante.codigo_fa 
inner join categoria on producto.codigo_cat=categoria.codigo_cat; 

/* Crea una base de datos nueva llamada backupproducto. Guarda en esta base de datos una copia de cada tabla de la 
base de datos productos. */
create database backupproducto; 
use backupproducto;

CREATE TABLE categoria as
select * from productos.categoria;
alter table categoria add constraint bup_db_codigo_cat primary key (codigo_cat);

create table fabricante as 
select * from productos.fabricante;
alter table fabricante add constraint bup_db_codigo_fa primary key (codigo_fa); 

create table producto as 
select * from productos.producto;
alter table producto add constraint bup_db_codigo primary key (codigo);

use productos;

/* Añade un nuevo campo a la tabla productos llamado oferta de tipo decimal (6,2). 
Actualiza este campo con precio menos un 10% para todos los productos del fabricante Samsung. */
alter table producto add column oferta decimal(6,2);

update producto
set oferta=precio - (precio * 0.1)
where codigo_fa=(
select codigo_fa from fabricante 
where nombre_fa in ('Samsung'));

/* Incrementa el stock en 2 unidades de todos los productos de la categoría Monitor que tengan un stock 
menor de 4 unidades. */
update producto
set stock=stock + 2 
where codigo_cat=(select codigo_cat from categoria
where nombre_cat in ('Monitor')) and stock<4;

-- Incrementa el precio un 5% de todos los productos de Apple.
update producto
set precio = precio + (precio * 0.05)
where codigo_fa=(select codigo_fa from fabricante 
where nombre_fa in('Apple')
);

/* Añade un nuevo campo a la tabla productos llamado stockmin de tipo entero sin signo. 
El valor de este campo será 5 para todos los productos de la categoría Procesador y de 2 para 
el resto de los productos.*/

alter table producto add column stockmin tinyint; 

update producto
set stockmin=5 where codigo_cat=(select codigo_cat from categoria
where nombre_cat in ('Procesadores'));

update producto
set stockmin=2 where codigo_cat in (select codigo_cat from categoria
where nombre_cat !='Procesadores');

-- Aumenta la longitud del campo nombre fabricante a 30 letras.
alter table fabricante modify nombre_fa varchar(30);

-- Queremos borrar al fabricante Lenovo y todos sus productos. Modifica la tabla para permitir borrar en cascada.
alter table producto drop foreign key fk_productofa;
alter table producto add constraint fk_productofa foreign key (codigo_fa) references fabricante(codigo_fa) on delete cascade;

alter table producto drop foreign key fk_productocat;
alter table producto add constraint fk_productocat foreign key (codigo_cat) REFERENCES categoria(codigo_cat) on delete cascade;

delete from fabricante where nombre_fa in ('Lenovo');

-- Borra todos aquellos productos del fabricante AMD los cuales no tenemos stock.
delete from producto 
where codigo_fa = (select codigo_fa from fabricante where nombre_fa ='AMD')
and stock = 0;