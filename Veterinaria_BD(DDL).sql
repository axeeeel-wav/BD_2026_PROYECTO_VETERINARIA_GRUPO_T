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

