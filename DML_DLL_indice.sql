create database colonias;

use colonias;


create table habitacion(
numhabitacion int not null primary key,
bano enum('S', 'N') not null,
precio float not null check(precio>0),
tipo enum('I', 'D', 'T', 'C') DEFAULT'D'
);

create table casas(
idcasa int not null primary key,
nombre varchar(30) not null,
direccion tinytext not null,
tel varchar(12) not null,
categoria enum('A', 'B', 'C', 'D','E') NOT NULL,
numhabitacion int not null,
constraint fk_habitacion_casas foreign key (numhabitacion) references habitacion (numhabitacion)
);

create table cliente(
idcliente int not null primary key, 
nombre varchar(30) not null, 
personacontacto varchar(30), 
mail varchar(40), 
nif varchar(9) not null,
tipo enum('escuela', 'particular') default'escuela',
tel int not null
);

create table actividades(
idactividad int not null primary key,
nombre varchar(30) not null,
descripcion varchar(50) not null,
nivel enum('1','2','3','4','5')
);

create table reserva(
idcasa int not null,
idcliente int not null,
f_entrada date not null,
f_salida date not null,
f_reserva date not null,
regimen enum('SA', 'AD', 'MP', 'PC') DEFAULT'PC',
constraint fk_casa_cliente primary key(idcasa, idcliente), 
constraint fk_casa_reserva foreign key(idcasa) references casas (idcasa), 
constraint fk_cliente_reserva foreign key (idcliente) references cliente (idcliente)
);

create table regimen(
idcasa int not null,
idactividad int not null,
dia DATE NOT NULL,
constraint fk_casa_actividad primary key (idcasa, idactividad), 
constraint fk_casa_regimen foreign key (idcasa) references casas (idcasa), 
constraint fk_actividad_regimen foreign key(idactividad) references actividades (idactividad)
);


create index des_act on actividades(descripcion);
create unique index nif_cliente on cliente(nif);
