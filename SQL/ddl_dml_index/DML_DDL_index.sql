create database if not exists Roma;
use Roma;

create table casa(
idcasa int not null primary key, 
nombre varchar(20) not null, 
direccion varchar(30) not null, 
telefono int(12),
categoria enum('A', 'B', 'C', 'D', 'E') NOT NULL
);

create table cliente(
idcliente int not null primary key, 
nombre varchar(20) not null, 
personacontacto varchar(20),
tipo enum('escuela', 'particular') default'escuela', 
mail varchar(20), 
NIF varchar(9) not null
);

create table habitacion(
numhabitacion varchar(10) not null primary key, 
bano varchar(1) not null, 
check (bano in ('S', 'N')),
precio float not null check (precio>0), 
tipo enum ('I', 'D', 'T', 'C') DEFAULT'D',
idcasa int not null, 
constraint fk_casa_habitacion foreign key (idcasa) references casa (idcasa)
);

create table actividades(
id_actividad varchar(19) not null primary key, 
nombre varchar(10) not null, 
descripcion varchar(50) not null,
nivel enum ('1', '2', '3', '4', '5') not null
);

create table reserva(
idcasa int not null, 
idcliente int not null,
f_entrada date not null, 
f_reserva date not null, 
f_salida date not null, check (f_salida>f_entrada), 
regimen enum ('SA', 'AD', 'MP', 'PC') DEFAULT 'PC', 
constraint idcasa_idcliente primary key(idcasa, idcliente), 
constraint fk_casa_reserva foreign key (idcasa) references casa(idcasa), 
constraint fk_cliente_reserva foreign key (idcliente) references cliente(idcliente)
);

create table realizar(
id_actividad varchar(19) not null,
idcasa int not null,
dia date not null, 
horarios time not null,
constraint fk_act_casa primary key(id_actividad, idcasa),
constraint fk_act_realizar foreign key (id_actividad) references actividades(id_actividad), 
constraint fk_casa_realizar foreign key (idcasa) references casa(idcasa)
);

create fulltext index act_des on actividades(descripcion);
create unique index cli_nif on cliente(NIF);
