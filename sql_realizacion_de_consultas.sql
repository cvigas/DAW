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

-- Lista los productos (codigo, nombre y precio) que su precio es superior a 500€
select codigo, nombre, precio from producto
where precio>500;

-- Lista los productos (codigo, nombre y stock) de los cuales no tenemos stock.
select codigo, nombre, stock from producto
where stock<=0;

-- Lista los productos que en su nombre contienen una palabra que acaba con las letras GB.
select nombre from producto 
where nombre like '%GB';

/*Lista los productos con precio inferior a 300€ y un stock superior a 2 unidades ordenado 
por precio de forma decreciente. */
select nombre, precio, stock from producto
where precio<300 and stock>2
order by precio desc;

-- Lista los productos de la categoría Tablet y fabricante Samsung.
select producto.nombre, categoria.nombre_cat, fabricante.nombre_fa
from producto inner join categoria on producto.codigo_cat=categoria.codigo_cat
inner join fabricante on producto.codigo_fa=fabricante.codigo_fa
where categoria.nombre_cat='Tablet' and fabricante.nombre_fa='Samsung';

/* Muestra cuántos productos tenemos de cada categoría. Las categorías que no tienen productos 
también deben aparecer.*/
select categoria.codigo_cat as 'Codigo', categoria.nombre_cat as 'Categoria', SUM(producto.stock) as 'Suma'
from producto right outer join categoria on categoria.codigo_cat=producto.codigo_cat
group by categoria.codigo_cat;

-- Muestra los fabricantes de los que tenemos 3 o más productos almacenados.
select fabricante.nombre_fa, sum(producto.stock)
from producto inner join fabricante on producto.codigo_fa=fabricante.codigo_fa
where producto.stock>=3
group by fabricante.nombre_fa;

-- Muestra el precio medio de cada categoría (sólo debe aparecer el nombre de la categoría y el precio).
select categoria.nombre_cat, avg(producto.precio)
from producto inner join categoria on producto.codigo_cat=categoria.codigo_cat
group by categoria.nombre_cat; 

-- Lista el nombre, el precio y el precio incrementado en un 10% de todos los productos del fabricante Samsung.
select producto.nombre, producto.precio, producto.precio + (producto.precio * 0.1) as 'Precio incrementado'
from producto inner join fabricante on producto.codigo_fa=fabricante.codigo_fa
where fabricante.nombre_fa in ('Samsung');

-- Muestra cuál es el producto más caro del fabricante Apple con toda la información de ese producto.
select * from producto
where precio=(
select max(producto.precio)
from producto inner join fabricante on producto.codigo_fa=fabricante.codigo_fa
where fabricante.nombre_fa in('Apple'));

-- Lista los productos de los cuales tenemos un stock superior al stock del producto Disco SSD 1 TB.
select nombre, stock from producto
where stock>(
select stock from producto 
where nombre in ('Disco SSD 1 TB'));

-- Lista los procesadores cuyo precio es superior al precio medio de los productos de la categoría de procesadores.
select producto.nombre, producto.precio from 
producto inner join categoria on producto.codigo_cat=categoria.codigo_cat
where categoria.nombre_cat in ('Procesadores') and producto.precio>(select avg(producto.precio) 
	from producto inner join categoria on producto.codigo_cat=categoria.codigo_cat 
	where categoria.nombre_cat in ('Procesadores'));