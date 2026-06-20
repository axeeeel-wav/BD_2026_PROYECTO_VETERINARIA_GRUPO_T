--S1: Mascotas mas atendidas por mes (solo citas ATENDIDA)
select 
    m.nombre_mascota,
    extract(month from c.fecha) as mes,
    to_char(c.fecha, 'TMMonth') as nombre_mes,
    count(c.id_cita) as total_atenciones
from mascota m
inner join cita c on m.id_mascota = c.id_mascota
where c.estado = 'ATENDIDA'
group by m.nombre_mascota, extract(month from c.fecha), to_char(c.fecha, 'TMMonth')
order by mes asc, total_atenciones desc;

--S2: Veterinario con mayor numero de citas en el trimestre (ene-mar 2025)
select 
    v.nombre_veterinario,
    count(c.id_cita) as total_citas
from veterinario v
inner join cita c on v.id_empleado = c.id_empleado
where c.fecha between '2025-01-01' and '2025-03-31'
group by v.nombre_veterinario
order by total_citas desc;

--S3: Medicamentos prescritos con mayor frecuencia
select 
    me.nombre_medicamento,
    count(dt.id_tratamiento) as veces_prescrito,
    sum(dt.duracion_dias) as dias_totales_tratamiento
from medicamento me
inner join detalle_tratamiento dt on me.id_medicamento = dt.id_medicamento
group by me.nombre_medicamento
order by veces_prescrito desc;

--S4: Ingresos totales por especialidad veterinaria
select 
    es.nombre_especialidad,
    count(distinct f.id_factura) as total_facturas,
    round(sum(f.total)::numeric, 2) as ingresos_totales
from especialidad es
inner join veterinario_especialidad ve on es.id_especialidad = ve.id_especialidad
inner join cita c on ve.id_empleado = c.id_empleado
inner join factura f on c.id_cita = f.id_cita
group by es.nombre_especialidad
order by ingresos_totales desc;

--S5: Propietarios con mascotas que no han asistido a citas en los ultimos 6 meses
select 
    p.nombre_propietario,
    p.telefono,
    m.nombre_mascota,
    max(c.fecha) as ultima_cita
from propietario p
inner join mascota m on p.id_propietario = m.id_propietario
left join cita c on m.id_mascota = c.id_mascota
group by p.nombre_propietario, p.telefono, m.nombre_mascota
having max(c.fecha) < current_date - interval '6 months'
    or max(c.fecha) is null
order by ultima_cita asc nulls first;

-- S6: Listado completo de mascotas con su especie y propietario
select
    m.nombre_mascota,
    e.nombre_especie,
    e.familia,
    p.nombre_propietario,
    p.telefono
from mascota m
inner join especie e on m.id_especie = e.id_especie
inner join propietario p on m.id_propietario = p.id_propietario
order by p.nombre_propietario asc, m.nombre_mascota asc;

-- S7: Mascotas con alguna alergia registrada y su nivel de gravedad
select
    m.nombre_mascota,
    me.nombre_medicamento,
    a.gravedad
from mascota m
inner join alergia a on m.id_mascota = a.id_mascota
inner join medicamento me on a.id_medicamento = me.id_medicamento
order by
    case a.gravedad
        when 'LEVE' then 1
        when 'MEDIA' then 2
        when 'ALTA' then 3
    end asc,
    m.nombre_mascota asc;

-- S8: Citas pendientes con el veterinario asignado y la mascota
select
    c.id_cita,
    c.fecha,
    c.hora,
    v.nombre_veterinario,
    m.nombre_mascota
from cita c
inner join veterinario v on c.id_empleado = v.id_empleado
inner join mascota m on c.id_mascota = m.id_mascota
where c.estado = 'PENDIENTE'
order by c.fecha asc, c.hora asc;

-- S9: Ingresos totales por metodo de pago
select
    f.metodo_pago,
    count(f.id_factura) as cantidad_transacciones,
    round(sum(f.total)::numeric, 2) as ingresos_totales,
    round(avg(f.total)::numeric, 2) as promedio_por_pago
from factura f
group by f.metodo_pago
order by ingresos_totales desc;

-- S10: Veterinarios y todas sus especialidades registradas
select
    v.nombre_veterinario,
    string_agg(e.nombre_especialidad, ', ' order by e.nombre_especialidad) as especialidades,
    count(ve.id_especialidad) as total_especialidades
from veterinario v
inner join veterinario_especialidad ve on v.id_empleado = ve.id_empleado
inner join especialidad e on ve.id_especialidad = e.id_especialidad
group by v.nombre_veterinario
order by total_especialidades desc, v.nombre_veterinario asc;

-- S11: Mascotas con mas de una alergia registrada
select
    m.nombre_mascota,
    p.nombre_propietario,
    count(a.id_medicamento) as total_alergias,
    string_agg(me.nombre_medicamento, ', ' order by a.gravedad desc) as medicamentos_alergicos
from mascota m
inner join propietario p on m.id_propietario = p.id_propietario
inner join alergia a on m.id_mascota = a.id_mascota
inner join medicamento me on a.id_medicamento = me.id_medicamento
group by m.nombre_mascota, p.nombre_propietario
having count(a.id_medicamento) > 1
order by total_alergias desc;

-- S12: Diagnosticos con su tratamiento y estado actual
select
    m.nombre_mascota,
    d.fecha_diagnostico,
    d.descripcion as diagnostico,
    t.descripcion as tratamiento,
    t.estado as estado_tratamiento
from diagnostico d
inner join cita c on d.id_cita = c.id_cita
inner join mascota m on c.id_mascota = m.id_mascota
inner join tratamiento t on d.id_diagnostico = t.id_diagnostico
where t.estado = 'ACTIVO'
order by d.fecha_diagnostico desc;

-- S13: Propietarios con mayor gasto acumulado en facturas
select
    p.nombre_propietario,
    p.telefono,
    count(distinct f.id_factura) as visitas_pagadas,
    round(sum(f.total)::numeric, 2) as gasto_total,
    round(avg(f.total)::numeric, 2) as gasto_promedio
from propietario p
inner join mascota m on p.id_propietario = m.id_propietario
inner join cita c on m.id_mascota = c.id_mascota
inner join factura f on c.id_cita = f.id_cita
group by p.nombre_propietario, p.telefono
order by gasto_total desc;

-- S14: Mascotas que recibieron un medicamento al que son alergicas
select
    m.nombre_mascota,
    p.nombre_propietario,
    me.nombre_medicamento,
    a.gravedad,
    t.descripcion as tratamiento_aplicado
from mascota m
inner join propietario p on m.id_propietario = p.id_propietario
inner join alergia a on m.id_mascota = a.id_mascota
inner join medicamento me on a.id_medicamento = me.id_medicamento
inner join cita c on m.id_mascota = c.id_mascota
inner join diagnostico d on c.id_cita = d.id_cita
inner join tratamiento t on d.id_diagnostico = t.id_diagnostico
inner join detalle_tratamiento dt on t.id_tratamiento = dt.id_tratamiento
    and dt.id_medicamento = a.id_medicamento
order by a.gravedad desc, m.nombre_mascota asc;

-- S15: Ranking de especies mas atendidas con su ingreso total generado
select
    e.nombre_especie,
    count(distinct m.id_mascota) as total_mascotas,
    count(c.id_cita) as total_citas,
    round(sum(f.total)::numeric, 2) as ingresos_generados
from especie e
inner join mascota m on e.id_especie = m.id_especie
inner join cita c on m.id_mascota = c.id_mascota
inner join factura f on c.id_cita = f.id_cita
where c.estado = 'ATENDIDA'
group by e.nombre_especie
order by ingresos_generados desc;