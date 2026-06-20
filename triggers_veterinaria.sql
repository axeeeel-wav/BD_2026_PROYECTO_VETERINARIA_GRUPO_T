-- trigger 1: verificar alergia al prescribir un medicamento

	-- paso 1: crear la funcion
	create or replace function fn_verificar_alergia_medicamento()
	returns trigger
	language plpgsql
	as $$
		declare
			v_id_mascota bigint;
			v_gravedad varchar(30);
			v_nombre_med varchar(60);
		begin
			-- obtener la mascota relacionada al tratamiento
			select c.id_mascota
			into v_id_mascota
			from tratamiento t
			inner join diagnostico d on t.id_diagnostico = d.id_diagnostico
			inner join cita c on d.id_cita = c.id_cita
			where t.id_tratamiento = new.id_tratamiento;

			-- buscar si hay alergia registrada
			select a.gravedad, m.nombre_medicamento
			into v_gravedad, v_nombre_med
			from alergia a
			inner join medicamento m on a.id_medicamento = m.id_medicamento
			where a.id_mascota = v_id_mascota
			  and a.id_medicamento = new.id_medicamento;

			-- si hay alergia, bloquear el insert
			if found then
				raise exception 'la mascota (id: %) tiene alergia de gravedad "%" al medicamento "%", no se puede agregar al tratamiento.',
					v_id_mascota, v_gravedad, v_nombre_med;
			end if;

			return new;
		end;
	$$;

	-- paso 2: crear el trigger
	create or replace trigger trg_verificar_alergia_medicamento
	before insert on detalle_tratamiento
	for each row
	execute function fn_verificar_alergia_medicamento();


-- trigger 2: validar que haya diagnostico antes de marcar cita como atendida

	-- paso 1: crear la funcion
	create or replace function fn_validar_diagnostico_en_cita()
	returns trigger
	language plpgsql
	as $$
		declare
			v_total int;
		begin
			-- solo actua cuando el estado cambia a atendida
			if new.estado = 'ATENDIDA' and old.estado <> 'ATENDIDA' then

				select count(*)
				into v_total
				from diagnostico
				where id_cita = new.id_cita;

				-- si no hay diagnostico, bloquear el update
				if v_total = 0 then
					raise exception 'la cita (id: %) no puede marcarse como atendida sin un diagnostico registrado.',
						new.id_cita;
				end if;

			end if;

			return new;
		end;
	$$;

	-- paso 2: crear el trigger
	create or replace trigger trg_validar_diagnostico_en_cita
	before update on cita
	for each row
	execute function fn_validar_diagnostico_en_cita();


-- trigger 3: evitar conflicto de horario para un veterinario

	-- paso 1: crear la funcion
	create or replace function fn_verificar_disponibilidad_veterinario()
	returns trigger
	language plpgsql
	as $$
		declare
			v_conflicto int;
			v_nombre_vet varchar(50);
		begin
			-- verificar si ya tiene cita en esa fecha y hora
			select count(*)
			into v_conflicto
			from cita
			where id_empleado = new.id_empleado
			  and fecha = new.fecha
			  and hora = new.hora
			  and estado <> 'PERDIDA';

			-- obtener nombre del veterinario para el mensaje
			select nombre_veterinario
			into v_nombre_vet
			from veterinario
			where id_empleado = new.id_empleado;

			-- si hay conflicto, bloquear el insert
			if v_conflicto > 0 then
				raise exception 'el veterinario "%" ya tiene una cita el % a las %.',
					v_nombre_vet, new.fecha, new.hora;
			end if;

			return new;
		end;
	$$;

	-- paso 2: crear el trigger
	create or replace trigger trg_verificar_disponibilidad_veterinario
	before insert on cita
	for each row
	execute function fn_verificar_disponibilidad_veterinario();