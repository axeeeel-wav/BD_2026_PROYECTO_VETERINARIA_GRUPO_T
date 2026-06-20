-- PARTE 1: CREACION DE TABLAS (DDL)

-- ==============================================================================================
-- Tablas SIN foreign keys (independientes)
-- ==============================================================================================

-- Tabla veterinario
create table veterinario(
id_empleado bigint generated always as identity not null,
nombre_veterinario varchar(50) not null,
salario numeric(8,2) not null,

constraint pk_id_empleado primary key (id_empleado)
);

-- Tabla especialidad
create table especialidad(
id_especialidad bigint generated always as identity not null,
nombre_especialidad varchar(100) not null,

constraint pk_id_especialidad primary key (id_especialidad)
);

-- Tabla propietario
create table propietario(
id_propietario bigint generated always as identity not null,
nombre_propietario varchar(100) not null,
telefono varchar (20) not null, 
fecha_registro date not null,

constraint pk_id_propietario primary key (id_propietario)
);

-- Tabla especie
create table especie(
id_especie bigint generated always as identity not null,
nombre_especie varchar (50) not null,
familia varchar(50) not null,

constraint pk_id_especie primary key (id_especie)
);

-- Tabla medicamento 
create table medicamento ( 
id_medicamento bigint generated always as identity not null,
nombre_medicamento varchar(60) not null,

constraint pk_id_medicamento primary key (id_medicamento)
); 

-- ==============================================================================================
-- Tablas CON foreign keys (dependientes)
-- ==============================================================================================

-- Tabla mascota
create table mascota(
id_mascota bigint generated always as identity not null,
nombre_mascota varchar(50) not null,
peso numeric(6,2) not null,
fecha_nacimiento date not null,
id_especie bigint not null,
id_propietario bigint not null,

constraint pk_id_mascota primary key (id_mascota),
constraint fk_id_especie foreign key (id_especie) references especie(id_especie)
on update cascade
on delete restrict,
constraint fk_id_propietario foreign key (id_propietario) references propietario(id_propietario)
on update cascade
on delete restrict
);

-- Tabla alergia
create table alergia(
id_mascota bigint not null,
id_medicamento bigint not null,
gravedad varchar(30) not null,

constraint pk_alergia primary key (id_mascota, id_medicamento),
constraint fk_id_mascota foreign key (id_mascota) references mascota(id_mascota)
on update cascade
on delete restrict,
constraint fk_id_medicamento foreign key (id_medicamento) references medicamento(id_medicamento)
on update cascade
on delete restrict,
constraint ck_gravedad check(gravedad in ('LEVE', 'MEDIA', 'ALTA'))
);

-- Tabla cita
create table cita (
id_cita bigint generated always as identity not null,
fecha date not null,
hora time not null,
estado varchar(50) not null,
id_empleado bigint not null,
id_mascota bigint not null,

constraint pk_id_cita primary key (id_cita),
constraint fk_id_empleado foreign key (id_empleado) references veterinario(id_empleado)
on update cascade
on delete restrict,
constraint fk_id_mascota foreign key (id_mascota) references mascota(id_mascota)
on update cascade
on delete restrict,
constraint ck_estado check (estado in ('PERDIDA', 'PENDIENTE', 'ATENDIDA'))
);

-- Tabla factura
create table factura(
id_factura bigint generated always as identity not null,
total numeric (6,2) not null,
metodo_pago varchar (50) not null,
id_cita bigint not null, 

constraint pk_id_factura primary key (id_factura),
constraint fk_id_cita foreign key (id_cita) references cita(id_cita)
on update cascade
on delete restrict,
constraint ck_metodo_pago check (metodo_pago in ('TARJETA', 'TRANSACCION', 'EFECTIVO'))
);

-- Tabla veterinario_especialidad
create table veterinario_especialidad( 
id_especialidad bigint not null,
id_empleado bigint not null,
fecha_obtencion date not null,

constraint pk_veterinario_especialidad primary key (id_especialidad, id_empleado),
constraint fk_id_especialidad foreign key (id_especialidad) references especialidad(id_especialidad)
on update cascade
on delete restrict,
constraint fk_id_empleado foreign key (id_empleado) references veterinario(id_empleado) 
on update cascade
on delete restrict
);

-- Tabla diagnostico 
create table diagnostico( 
id_diagnostico bigint generated always as identity not null,
fecha_diagnostico date not null,
descripcion varchar (150) not null,
id_cita bigint not null,

constraint pk_id_diagnostico primary key (id_diagnostico),
constraint fk_id_cita foreign key (id_cita) references cita(id_cita)
on update cascade
on delete restrict
);

-- Tabla tratamiento
create table tratamiento( 
id_tratamiento bigint generated always as identity not null,
descripcion varchar (150) not null,
estado varchar (150) not null,
id_diagnostico bigint not null, 

constraint pk_id_tratamiento primary key (id_tratamiento),
constraint ck_estado_tratamiento check (estado in ('ACTIVO', 'FINALIZADO', 'SUSPENDIDO')),
constraint fk_id_diagnostico foreign key (id_diagnostico) references diagnostico(id_diagnostico)
);

-- Tabla detalle_tratamiento
create table detalle_tratamiento(
id_tratamiento bigint not null,
id_medicamento bigint not null,
duracion_dias int not null,

constraint pk_detalle_tratamiento primary key (id_tratamiento, id_medicamento),
constraint fk_id_tratamiento foreign key (id_tratamiento) references tratamiento(id_tratamiento),
constraint fk_id_medicamento foreign key (id_medicamento) references medicamento(id_medicamento)
);


-- PARTE 2: CARGA DE DATOS (DML)

-- ==============================================================================================
-- Tablas independientes
-- ==============================================================================================

--veterinario
insert into veterinario (nombre_veterinario, salario) values
('Carlos Menjivar', 1250.00),
('Ana Beatriz Rivas', 1400.50),
('Jose Roberto Flores', 1100.00),
('Gabriela Mendoza', 1550.75),
('Luis Alberto Cruz', 980.00),
('Maria Fernanda Lopez', 1320.00),
('Oscar Ramirez', 1180.50),
('Karla Sofia Hernandez', 1450.00),
('Diego Alvarado', 1050.00),
('Patricia Guzman', 1600.00),
('Ernesto Villalta', 1230.00),
('Marta Lorena Pineda', 1380.50),
('Sergio Antonio Bonilla', 1090.00),
('Veronica Estrada', 1470.25),
('Hugo Cesar Marroquin', 1010.00),
('Wendy Carolina Diaz', 1340.75),
('Mauricio Portillo', 1155.00),
('Silvia Eugenia Campos', 1420.00),
('Rodrigo Escobar', 990.50),
('Tatiana Mariela Funes', 1525.00),
('Alvaro Ernesto Quintanilla', 1075.00),
('Beatriz Adriana Salazar', 1490.00);

--especialidad
insert into especialidad (nombre_especialidad) values
('Medicina General'),
('Cirugia'),
('Dermatologia'),
('Cardiologia'),
('Odontologia'),
('Oftalmologia'),
('Animales Exoticos'),
('Nutricion'),
('Traumatologia'),
('Oncologia'),
('Neurologia'),
('Etologia'),
('Medicina Interna'),
('Anestesiologia'),
('Reproduccion Animal');

--propietario
insert into propietario (nombre_propietario, telefono, fecha_registro) values
('Roberto Castillo', '7012-3456', '2024-01-15'),
('Sandra Elizabeth Morales', '7823-9087', '2024-02-20'),
('Juan Carlos Perez', '6098-1122', '2024-03-05'),
('Lucia Margarita Vasquez', '7745-6633', '2024-03-18'),
('Manuel Antonio Reyes', '6234-8899', '2024-04-22'),
('Claudia Beatriz Romero', '7890-4567', '2024-05-10'),
('Fernando Aguilar', '6512-7788', '2024-06-01'),
('Daniela Estefania Cruz', '7011-2233', '2024-06-25'),
('Victor Manuel Sosa', '6677-8800', '2024-07-14'),
('Andrea Carolina Mejia', '7355-9911', '2024-08-09'),
('Ricardo Alfonso Garcia', '6090-3344', '2024-09-02'),
('Gloria Maritza Henriquez', '7122-5566', '2024-10-17'),
('Mario Alberto Cardenas', '7233-1190', '2024-11-03'),
('Elena Sofia Marroquin', '6541-7823', '2024-11-20'),
('Jorge Luis Mendez', '7890-1234', '2024-12-05'),
('Carmen Rosa Alvarado', '6677-2211', '2025-01-12'),
('Walter Geovanny Ramos', '7012-9988', '2025-01-28'),
('Ingrid Patricia Solano', '6234-5567', '2025-02-14'),
('Nelson Mauricio Trejo', '7745-3321', '2025-02-25'),
('Rosa Maria Galdamez', '6098-7744', '2025-03-10'),
('Edwin Alexander Lima', '7355-2098', '2025-03-22'),
('Karen Lissette Maldonado', '6512-9087', '2025-04-08'),
('Francisco Javier Mata', '7122-4433', '2025-04-19'),
('Brenda Yamileth Castro', '6090-1166', '2025-05-02'),
('Hector Geovany Aparicio', '7011-8855', '2025-05-15'),
('Lorena Beatriz Sandoval', '6677-3399', '2025-05-29'),
('Carlos Eduardo Velasquez', '7233-6677', '2025-06-08');

--especie
insert into especie (nombre_especie, familia) values
('Perro', 'Canidae'),
('Gato', 'Felidae'),
('Conejo', 'Leporidae'),
('Hamster', 'Cricetidae'),
('Loro', 'Psittacidae'),
('Tortuga', 'Testudinidae'),
('Iguana', 'Iguanidae'),
('Canario', 'Fringillidae'),
('Pez Betta', 'Osphronemidae'),
('Cobaya', 'Caviidae'),
('Huron', 'Mustelidae'),
('Periquito', 'Psittaculidae'),
('Serpiente Maizera', 'Colubridae'),
('Erizo', 'Erinaceidae'),
('Chinchilla', 'Chinchillidae');

--medicamento
insert into medicamento (nombre_medicamento) values
('Amoxicilina'),
('Ibuprofeno Canino'),
('Meloxicam'),
('Doxiciclina'),
('Prednisona'),
('Metronidazol'),
('Enrofloxacina'),
('Ketoprofeno'),
('Furosemida'),
('Dexametasona'),
('Cefalexina'),
('Tramadol'),
('Carprofeno'),
('Gabapentina'),
('Omeprazol Canino'),
('Clindamicina'),
('Fenbendazol'),
('Apoquel'),
('Maropitant'),
('Insulina Caninsulin'),
('Ivermectina'),
('Ranitidina'),
('Azitromicina'),
('Fluconazol');

-- ==============================================================================================
-- Tablas dependientes
-- ==============================================================================================

--mascota
insert into mascota (nombre_mascota, peso, fecha_nacimiento, id_especie, id_propietario) values
('Max', 25.50, '2020-05-10', 1, 1),
('Luna', 4.20, '2021-08-15', 2, 1),
('Rocky', 30.00, '2019-03-22', 1, 1),
('Pelusa', 1.80, '2022-01-30', 4, 3),
('Toby', 12.75, '2020-11-05', 1, 5),
('Mia', 3.90, '2021-06-18', 2, 2),
('Coco', 0.45, '2023-02-14', 5, 6),
('Bruno', 28.30, '2018-09-09', 1, 5),
('Nina', 2.10, '2022-07-25', 3, 8),
('Simba', 5.60, '2020-12-01', 2, 9),
('Pepe', 0.90, '2023-04-19', 8, 10),
('Tortu', 8.40, '2017-05-30', 6, 11),
('Rex', 32.10, '2019-10-12', 1, 12),
('Michi', 4.75, '2021-09-08', 2, 2),
('Draco', 3.30, '2022-03-15', 7, 6),
('Thor', 27.40, '2020-02-18', 1, 13),
('Cleo', 3.80, '2021-11-09', 2, 13),
('Firulais', 18.60, '2019-07-14', 1, 14),
('Bigotes', 4.10, '2022-04-21', 2, 15),
('Lola', 6.30, '2020-09-30', 3, 16),
('Zeus', 33.50, '2018-12-12', 1, 17),
('Manchas', 5.90, '2021-03-08', 2, 18),
('Kira', 22.10, '2020-06-25', 1, 19),
('Bola de Nieve', 1.20, '2023-01-17', 14, 20),
('Tambor', 1.95, '2022-08-03', 3, 21),
('Paco', 0.50, '2023-05-11', 4, 22),
('Roco', 29.80, '2019-04-28', 1, 23),
('Dalia', 4.45, '2021-10-19', 2, 24),
('Spike', 2.70, '2022-02-26', 11, 25),
('Canela', 15.30, '2020-11-14', 1, 26),
('Oreo', 3.60, '2021-07-07', 2, 27),
('Negrita', 4.90, '2020-05-22', 2, 13),
('Duke', 31.20, '2019-09-16', 1, 16),
('Lucky', 12.80, '2021-12-01', 1, 18),
('Maya', 2.30, '2022-06-13', 10, 20),
('Tomas', 0.40, '2023-03-29', 4, 22),
('Pancho', 24.70, '2020-08-08', 1, 24),
('Frida', 3.95, '2021-05-04', 2, 26),
('Bobby', 19.50, '2020-01-20', 1, 17),
('Salem', 4.30, '2021-09-27', 2, 9),
('Rambo', 28.90, '2019-11-11', 1, 19),
('Pelota', 1.10, '2022-12-22', 4, 4),
('Chispa', 5.20, '2021-04-15', 3, 7),
('Goliat', 35.60, '2018-10-05', 1, 23),
('Princesa', 3.70, '2022-07-18', 2, 25);

--alergia 
insert into alergia (id_mascota, id_medicamento, gravedad) values
(1, 2, 'LEVE'),
(1, 5, 'MEDIA'),
(3, 1, 'ALTA'),
(5, 3, 'LEVE'),
(6, 7, 'MEDIA'),
(8, 4, 'ALTA'),
(8, 9, 'LEVE'),
(10, 6, 'MEDIA'),
(13, 1, 'ALTA'),
(14, 8, 'LEVE'),
(16, 1, 'MEDIA'),
(17, 13, 'LEVE'),
(18, 4, 'ALTA'),
(20, 16, 'MEDIA'),
(21, 1, 'LEVE'),
(23, 7, 'ALTA'),
(24, 5, 'MEDIA'),
(26, 18, 'LEVE'),
(28, 2, 'ALTA'),
(30, 14, 'MEDIA'),
(33, 1, 'LEVE'),
(35, 9, 'ALTA'),
(38, 6, 'MEDIA'),
(40, 21, 'LEVE'),
(43, 4, 'ALTA');

--cita 
insert into cita (fecha, hora, estado, id_empleado, id_mascota) values
('2025-01-10', '09:00:00', 'ATENDIDA', 1, 1),
('2025-05-05', '12:00:00', 'ATENDIDA', 1, 1),
('2025-09-15', '10:00:00', 'ATENDIDA', 3, 1),
('2026-02-20', '11:00:00', 'ATENDIDA', 6, 1),
('2025-02-14', '10:30:00', 'ATENDIDA', 2, 2),
('2025-08-20', '14:00:00', 'ATENDIDA', 4, 2),
('2026-01-30', '09:30:00', 'ATENDIDA', 2, 2),
('2025-01-12', '11:00:00', 'ATENDIDA', 2, 3),
('2025-07-18', '15:30:00', 'ATENDIDA', 5, 3),
('2025-01-15', '11:00:00', 'PERDIDA', 1, 4),
('2025-02-08', '14:00:00', 'ATENDIDA', 4, 5),
('2025-10-10', '09:00:00', 'ATENDIDA', 7, 5),
('2025-03-05', '09:45:00', 'ATENDIDA', 5, 6),
('2025-11-12', '13:00:00', 'ATENDIDA', 2, 6),
('2025-02-20', '15:30:00', 'PENDIENTE', 2, 7),
('2025-02-08', '14:30:00', 'ATENDIDA', 4, 8),
('2025-09-22', '10:15:00', 'ATENDIDA', 3, 8),
('2025-03-18', '13:00:00', 'PERDIDA', 6, 9),
('2025-03-05', '09:45:00', 'ATENDIDA', 5, 10),
('2026-03-10', '11:30:00', 'ATENDIDA', 8, 10),
('2025-04-22', '08:00:00', 'PENDIENTE', 8, 11),
('2025-06-18', '15:00:00', 'ATENDIDA', 9, 12),
('2025-03-12', '10:15:00', 'ATENDIDA', 1, 13),
('2025-12-05', '14:00:00', 'ATENDIDA', 10, 13),
('2025-05-14', '09:30:00', 'ATENDIDA', 4, 14),
('2025-06-01', '10:00:00', 'PENDIENTE', 5, 15),
('2025-06-25', '09:00:00', 'ATENDIDA', 11, 16),
('2025-10-13', '10:30:00', 'ATENDIDA', 12, 16),
('2026-02-11', '10:15:00', 'ATENDIDA', 15, 16),
('2025-07-02', '10:00:00', 'ATENDIDA', 12, 17),
('2025-07-08', '11:30:00', 'ATENDIDA', 3, 18),
('2025-11-22', '13:00:00', 'ATENDIDA', 8, 18),
('2025-07-15', '08:45:00', 'PERDIDA', 13, 19),
('2025-07-22', '14:15:00', 'ATENDIDA', 14, 20),
('2026-04-14', '14:00:00', 'ATENDIDA', 20, 20),
('2025-09-12', '16:15:00', 'PERDIDA', 18, 21),
('2025-08-03', '15:00:00', 'ATENDIDA', 2, 22),
('2025-09-20', '08:00:00', 'ATENDIDA', 1, 23),
('2026-03-09', '08:45:00', 'ATENDIDA', 17, 23),
('2025-08-10', '09:30:00', 'PENDIENTE', 15, 24),
('2025-09-28', '12:30:00', 'ATENDIDA', 19, 25),
('2025-08-26', '13:30:00', 'ATENDIDA', 5, 26),
('2025-10-05', '09:15:00', 'ATENDIDA', 20, 27),
('2025-10-21', '14:45:00', 'ATENDIDA', 21, 28),
('2025-09-04', '11:00:00', 'ATENDIDA', 17, 29),
('2025-10-29', '15:30:00', 'ATENDIDA', 22, 30),
('2025-11-06', '08:30:00', 'ATENDIDA', 6, 31),
('2025-11-14', '11:15:00', 'PERDIDA', 7, 32),
('2025-12-01', '09:45:00', 'ATENDIDA', 9, 33),
('2025-12-09', '10:00:00', 'ATENDIDA', 10, 34),
('2025-12-17', '16:00:00', 'PENDIENTE', 11, 35),
('2026-01-08', '08:15:00', 'ATENDIDA', 12, 36),
('2026-01-16', '12:00:00', 'ATENDIDA', 1, 37),
('2026-01-24', '14:30:00', 'ATENDIDA', 13, 38),
('2026-02-03', '09:00:00', 'PERDIDA', 14, 39),
('2026-02-19', '11:45:00', 'ATENDIDA', 2, 40),
('2026-02-27', '15:15:00', 'ATENDIDA', 16, 41),
('2026-03-17', '13:45:00', 'PENDIENTE', 18, 42),
('2026-03-25', '09:30:00', 'ATENDIDA', 5, 43),
('2026-04-06', '10:30:00', 'ATENDIDA', 19, 44),
('2026-04-22', '11:00:00', 'PERDIDA', 21, 45),
('2026-05-08', '08:00:00', 'ATENDIDA', 1, 5),
('2026-05-16', '12:15:00', 'ATENDIDA', 6, 16),
('2026-05-24', '09:15:00', 'PENDIENTE', 7, 2),
('2026-06-02', '10:45:00', 'ATENDIDA', 8, 8),
('2026-06-10', '13:15:00', 'ATENDIDA', 9, 23),
('2026-06-15', '15:00:00', 'ATENDIDA', 10, 1),
('2026-06-16', '11:30:00', 'ATENDIDA', 11, 13);

--factura 
insert into factura (total, metodo_pago, id_cita) values
(153.29, 'EFECTIVO', 1),
(39.63, 'TARJETA', 2),
(85.88, 'TRANSACCION', 3),
(76.29, 'EFECTIVO', 4),
(171.25, 'TARJETA', 5),
(160.19, 'TRANSACCION', 6),
(200.05, 'EFECTIVO', 7),
(51.08, 'TARJETA', 8),
(113.06, 'TRANSACCION', 9),
(40.51, 'EFECTIVO', 11),
(75.45, 'TARJETA', 12),
(128.49, 'TRANSACCION', 13),
(39.91, 'EFECTIVO', 14),
(71.78, 'TARJETA', 16),
(155.23, 'TRANSACCION', 17),
(135.81, 'EFECTIVO', 19),
(75.78, 'TARJETA', 20),
(144.01, 'TRANSACCION', 22),
(184.74, 'EFECTIVO', 23),
(36.20, 'TARJETA', 24),
(184.08, 'TRANSACCION', 25),
(164.16, 'EFECTIVO', 27),
(97.95, 'TARJETA', 28),
(63.76, 'TRANSACCION', 29),
(212.08, 'EFECTIVO', 30),
(97.27, 'TARJETA', 31),
(52.16, 'TRANSACCION', 32),
(52.89, 'EFECTIVO', 34),
(191.79, 'TARJETA', 35),
(146.69, 'TRANSACCION', 37),
(184.32, 'EFECTIVO', 38),
(170.00, 'TARJETA', 39),
(134.20, 'TRANSACCION', 41),
(215.03, 'EFECTIVO', 42),
(105.03, 'TARJETA', 43),
(137.13, 'TRANSACCION', 44),
(188.44, 'EFECTIVO', 45),
(149.43, 'TARJETA', 46),
(194.42, 'TRANSACCION', 47),
(141.81, 'EFECTIVO', 49),
(165.35, 'TARJETA', 50),
(43.48, 'TRANSACCION', 52),
(77.16, 'EFECTIVO', 53),
(88.54, 'TARJETA', 54),
(49.76, 'TRANSACCION', 56),
(78.07, 'EFECTIVO', 57),
(53.69, 'TARJETA', 59),
(86.43, 'TRANSACCION', 60),
(152.60, 'EFECTIVO', 62),
(102.49, 'TARJETA', 63),
(103.48, 'TRANSACCION', 65),
(73.76, 'EFECTIVO', 66),
(84.39, 'TARJETA', 67),
(208.28, 'TRANSACCION', 68);

--veterinario_especialidad
insert into veterinario_especialidad (id_especialidad, id_empleado, fecha_obtencion) values
(1, 1, '2018-06-15'),
(2, 1, '2020-03-10'),
(1, 2, '2019-07-20'),
(4, 2, '2021-09-05'),
(3, 3, '2017-11-30'),
(1, 4, '2020-01-25'),
(2, 4, '2022-04-18'),
(5, 5, '2019-05-12'),
(1, 6, '2021-08-08'),
(6, 7, '2018-10-22'),
(7, 8, '2020-12-01'),
(8, 9, '2022-02-14'),
(1, 10, '2019-03-19'),
(1, 11, '2019-05-10'),
(9, 11, '2021-06-15'),
(3, 12, '2018-08-20'),
(1, 13, '2020-02-12'),
(10, 14, '2021-11-08'),
(2, 14, '2022-03-15'),
(11, 15, '2019-07-22'),
(1, 16, '2020-09-30'),
(5, 17, '2018-04-18'),
(12, 18, '2021-01-25'),
(13, 19, '2019-10-14'),
(1, 20, '2020-06-08'),
(14, 21, '2022-05-19'),
(15, 22, '2019-12-03'),
(4, 12, '2023-02-10'),
(6, 17, '2022-08-27');

--diagnostico
insert into diagnostico (fecha_diagnostico, descripcion, id_cita) values
('2025-01-10', 'Otitis externa en oido izquierdo', 1),
('2025-05-05', 'Control de vacunacion anual', 2),
('2025-09-15', 'Revision post operatoria', 3),
('2026-02-20', 'Dermatitis alergica por pulgas', 4),
('2025-02-14', 'Chequeo geriatrico', 5),
('2025-08-20', 'Infeccion gastrointestinal', 6),
('2026-01-30', 'Limpieza dental y sarro', 7),
('2025-01-12', 'Cuadro respiratorio leve', 8),
('2025-07-18', 'Fractura leve en pata', 9),
('2025-02-08', 'Parasitos intestinales', 11),
('2025-10-10', 'Chequeo general', 12),
('2025-03-05', 'Insuficiencia cardiaca leve', 13),
('2025-11-12', 'Gingivitis dental', 14),
('2025-02-08', 'Conjuntivitis bacteriana', 16),
('2025-09-22', 'Control de peso y nutricion', 17),
('2025-03-05', 'Cuadro diarreico agudo', 19),
('2026-03-10', 'Dermatitis por contacto', 20),
('2025-06-18', 'Infeccion urinaria', 22),
('2025-03-12', 'Otitis bilateral', 23),
('2025-12-05', 'Control de diabetes felina', 24),
('2025-05-14', 'Esguince miembro posterior', 25),
('2025-06-25', 'Gastritis aguda', 27),
('2025-10-13', 'Limpieza dental programada', 28),
('2026-02-11', 'Conjuntivitis viral', 29),
('2025-07-02', 'Cuadro alergico estacional', 30),
('2025-07-08', 'Herida por mordedura', 31),
('2025-11-22', 'Control post quirurgico', 32),
('2025-07-22', 'Parasitosis externa', 34),
('2026-04-14', 'Insuficiencia renal leve', 35),
('2025-08-03', 'Bronquitis canina', 37),
('2025-09-20', 'Fractura en cola', 38),
('2026-03-09', 'Revision geriatrica', 39),
('2025-09-28', 'Vomito persistente', 41),
('2025-08-26', 'Chequeo nutricional', 42),
('2025-10-05', 'Dermatomicosis', 43),
('2025-10-21', 'Control de peso', 44),
('2025-09-04', 'Otitis externa recurrente', 45),
('2025-10-29', 'Vacunacion antirrabica', 46),
('2025-11-06', 'Gingivoestomatitis', 47),
('2025-12-01', 'Cojera leve', 49),
('2025-12-09', 'Cuadro respiratorio', 50),
('2026-01-08', 'Control reproductivo', 52),
('2026-01-16', 'Dermatitis alergica', 53),
('2026-01-24', 'Revision general anual', 54),
('2026-02-19', 'Infeccion ocular', 56),
('2026-02-27', 'Chequeo preventivo', 57),
('2026-03-25', 'Control de seguimiento', 59),
('2026-04-06', 'Revacunacion programada', 60),
('2026-05-08', 'Desparasitacion de control', 62),
('2026-05-16', 'Chequeo de rutina', 63),
('2026-06-02', 'Control post tratamiento', 65),
('2026-06-10', 'Examen fisico completo', 66),
('2026-06-15', 'Seguimiento nutricional', 67),
('2026-06-16', 'Control anual de salud', 68);

--tratamiento
insert into tratamiento (descripcion, estado, id_diagnostico) values
('Aplicacion de antibiotico topico por 7 dias', 'FINALIZADO', 1),
('Aplicacion de vacunas multiples', 'FINALIZADO', 2),
('Control de cicatrizacion semanal', 'FINALIZADO', 3),
('Bano medicado y antialergico', 'ACTIVO', 4),
('Suplementos geriatricos', 'ACTIVO', 5),
('Dieta blanda y antibiotico oral', 'FINALIZADO', 6),
('Profilaxis dental completa', 'FINALIZADO', 7),
('Broncodilatador y reposo', 'FINALIZADO', 8),
('Inmovilizacion y antiinflamatorio', 'FINALIZADO', 9),
('Desparasitante oral dosis unica', 'FINALIZADO', 10),
('Chequeo sin medicacion', 'FINALIZADO', 11),
('Tratamiento diuretico y monitoreo', 'ACTIVO', 12),
('Limpieza dental y enjuague', 'FINALIZADO', 13),
('Gotas oftalmicas por 10 dias', 'ACTIVO', 14),
('Plan nutricional supervisado', 'ACTIVO', 15),
('Suero oral y dieta blanda 5 dias', 'FINALIZADO', 16),
('Crema topica y antihistaminico', 'FINALIZADO', 17),
('Antibiotico urinario por 10 dias', 'FINALIZADO', 18),
('Gotas oticas ambos oidos', 'ACTIVO', 19),
('Aplicacion de insulina diaria', 'ACTIVO', 20),
('Reposo y antiinflamatorio', 'FINALIZADO', 21),
('Protector gastrico por 7 dias', 'FINALIZADO', 22),
('Profilaxis dental programada', 'FINALIZADO', 23),
('Antiviral oftalmico', 'ACTIVO', 24),
('Antialergico y cambio de dieta', 'ACTIVO', 25),
('Limpieza y antibiotico oral', 'FINALIZADO', 26),
('Control de cicatrizacion', 'FINALIZADO', 27),
('Antiparasitario externo mensual', 'ACTIVO', 28),
('Dieta renal y monitoreo', 'ACTIVO', 29),
('Broncodilatador y reposo', 'FINALIZADO', 30),
('Inmovilizacion de cola', 'ACTIVO', 31),
('Suplementos geriatricos', 'ACTIVO', 32),
('Antiemetico y ayuno controlado', 'FINALIZADO', 33),
('Plan nutricional personalizado', 'ACTIVO', 34),
('Antimicotico topico 21 dias', 'ACTIVO', 35),
('Dieta de reduccion supervisada', 'ACTIVO', 36),
('Tratamiento otico prolongado', 'ACTIVO', 37),
('Aplicacion antirrabica', 'FINALIZADO', 38),
('Antiinflamatorio bucal', 'ACTIVO', 39),
('Reposo y analgesico', 'FINALIZADO', 40),
('Antibiotico respiratorio', 'FINALIZADO', 41),
('Evaluacion reproductiva', 'FINALIZADO', 42),
('Bano medicado semanal', 'ACTIVO', 43),
('Chequeo sin medicacion', 'FINALIZADO', 44),
('Colirio antibiotico', 'ACTIVO', 45),
('Control preventivo sin tratamiento', 'FINALIZADO', 46),
('Antibiotico de seguimiento', 'FINALIZADO', 47),
('Revacunacion aplicada', 'FINALIZADO', 48),
('Desparasitante de control', 'FINALIZADO', 49),
('Chequeo de rutina sin medicacion', 'FINALIZADO', 50),
('Ajuste de tratamiento previo', 'ACTIVO', 51),
('Examen sin hallazgos', 'FINALIZADO', 52),
('Seguimiento de dieta', 'ACTIVO', 53),
('Control anual sin novedad', 'FINALIZADO', 54);

--detalle_tratamiento
insert into detalle_tratamiento (id_tratamiento, id_medicamento, duracion_dias) values
(1, 13, 30),
(2, 12, 21),
(3, 2, 5),
(4, 8, 5),
(5, 19, 5),
(7, 19, 21),
(8, 2, 21),
(10, 18, 5),
(11, 4, 21),
(12, 12, 5),
(13, 19, 5),
(14, 22, 14),
(14, 18, 10),
(15, 12, 7),
(15, 10, 7),
(16, 3, 21),
(17, 11, 14),
(17, 24, 10),
(18, 4, 21),
(19, 5, 14),
(20, 18, 21),
(23, 20, 14),
(24, 3, 14),
(24, 9, 30),
(25, 24, 30),
(26, 10, 14),
(26, 23, 30),
(27, 12, 21),
(27, 6, 5),
(28, 10, 7),
(30, 3, 14),
(30, 6, 14),
(31, 14, 21),
(32, 12, 14),
(32, 22, 7),
(33, 5, 7),
(34, 16, 21),
(35, 1, 7),
(36, 20, 21),
(37, 23, 21),
(39, 15, 30),
(41, 13, 14),
(41, 4, 30),
(42, 3, 7),
(43, 11, 21),
(44, 19, 7),
(45, 20, 5),
(46, 20, 14),
(47, 12, 21),
(48, 4, 14),
(50, 10, 7),
(50, 3, 5),
(53, 17, 5),
(54, 5, 30);
