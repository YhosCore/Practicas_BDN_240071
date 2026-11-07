-- Ejecucion de poblacion y validacion de la Practica 03.
-- Ejecutar una vez en la base de practica, conectado con la cuenta remota
-- que tenga el rol superadmin activo. Inserta 7,500 cuentas sinteticas.
-- El CRUD final crea, actualiza y elimina un registro personal separado; sus
-- operaciones quedan en tb_logs y no altera los 7,500 usuarios de los lotes.
-- Los escenarios T2 y T3 no especifican genero; esos registros quedan como
-- "Sin especificar". El usuario CRUD permite elegir una opcion explicitamente.
USE db_test;

-- Traduce el codigo guardado en gender_ID a una etiqueta legible, sin agregar
-- otra tabla al modelo ni modificar los registros historicos.
CREATE OR REPLACE VIEW vw_people_with_gender AS
SELECT
    p.person_ID,
    p.user_ID,
    p.given_names,
    p.family_names,
    p.birth_date,
    p.gender_ID,
    CASE p.gender_ID
        WHEN 1 THEN 'Masculino'
        WHEN 2 THEN 'Femenino'
        WHEN 3 THEN 'No binario'
        WHEN 4 THEN 'Prefiero no decir'
        ELSE 'Sin especificar'
    END AS gender_name,
    p.country_code,
    p.status,
    p.creation_date,
    p.last_update
FROM tb_people AS p;

SELECT USER() AS cuenta_conexion, CURRENT_USER() AS cuenta_autorizada,
       CURRENT_ROLE() AS roles_activos, DATABASE() AS base_actual;

-- Codigos disponibles para registrar una persona mediante sp_register_user.
-- Se conserva la equivalencia usada en los datos existentes: 1 = Masculino.
SET @gender_male_id = 1;
SET @gender_female_id = 2;
SET @gender_nonbinary_id = 3;
SET @gender_undisclosed_id = 4;

-- Caso 1: 500 hombres de Estados Unidos.
CALL sp_simulate_users(
    500, @gender_male_id, 'US', NULL, NULL, 1.0000,
    @t1_first_id, @t1_last_id
);

-- Caso 2: 2,000 personas de distintos paises, edades de 19 a 35.
CALL sp_simulate_users(
    2000, NULL, '*', 19, 35, 1.0000,
    @t2_first_id, @t2_last_id
);

-- Caso 3: 5,000 cuentas con probabilidad de 80% activas.
CALL sp_simulate_users(
    5000, NULL, '*', NULL, NULL, 0.8000,
    @t3_first_id, @t3_last_id
);

-- Totales por rango de IDs devuelto por el procedimiento.
SELECT 'T1' AS escenario, COUNT(*) AS usuarios
FROM tb_users WHERE ID BETWEEN @t1_first_id AND @t1_last_id
UNION ALL
SELECT 'T2', COUNT(*) FROM tb_users
WHERE ID BETWEEN @t2_first_id AND @t2_last_id
UNION ALL
SELECT 'T3', COUNT(*) FROM tb_users
WHERE ID BETWEEN @t3_first_id AND @t3_last_id
UNION ALL
SELECT 'TOTAL',
       (SELECT COUNT(*) FROM tb_users WHERE ID BETWEEN @t1_first_id AND @t1_last_id)
     + (SELECT COUNT(*) FROM tb_users WHERE ID BETWEEN @t2_first_id AND @t2_last_id)
     + (SELECT COUNT(*) FROM tb_users WHERE ID BETWEEN @t3_first_id AND @t3_last_id);

-- Caso 1: 500 usuarios con el genero indicado y pais US.
SELECT COUNT(*) AS total,
       SUM(p.gender_ID = @gender_male_id) AS genero_correcto,
       SUM(p.country_code = 'US') AS pais_correcto,
       MAX(CASE p.gender_ID
           WHEN 1 THEN 'Masculino'
           WHEN 2 THEN 'Femenino'
           WHEN 3 THEN 'No binario'
           WHEN 4 THEN 'Prefiero no decir'
           ELSE 'Sin especificar'
       END) AS genero_mostrado,
       CASE WHEN COUNT(*) = 500
                  AND SUM(p.gender_ID = @gender_male_id) = 500
                  AND SUM(p.country_code = 'US') = 500
            THEN 'OK' ELSE 'REVISAR' END AS resultado
FROM tb_users u
JOIN tb_people p ON p.user_ID = u.ID
WHERE u.ID BETWEEN @t1_first_id AND @t1_last_id;

-- Caso 2: edad de 19 a 35 y mas de un pais distinto.
SELECT COUNT(*) AS total,
       COUNT(DISTINCT p.country_code) AS paises_distintos,
       MIN(TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE())) AS edad_minima,
       MAX(TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE())) AS edad_maxima,
       CASE WHEN COUNT(*) = 2000
                  AND COUNT(DISTINCT p.country_code) > 1
                  AND MIN(TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE())) >= 19
                  AND MAX(TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE())) <= 35
            THEN 'OK' ELSE 'REVISAR' END AS resultado
FROM tb_users u
JOIN tb_people p ON p.user_ID = u.ID
WHERE u.ID BETWEEN @t2_first_id AND @t2_last_id;

-- Caso 3: la proporcion observada debe acercarse a 80%; se usa tolerancia 78-82%.
SELECT COUNT(*) AS total,
       SUM(status = b'1') AS activas,
       SUM(status = b'0') AS inactivas,
       ROUND(100 * AVG(status = b'1'), 2) AS porcentaje_activas,
       CASE WHEN COUNT(*) = 5000
                  AND AVG(status = b'1') BETWEEN 0.78 AND 0.82
            THEN 'OK' ELSE 'REVISAR' END AS resultado
FROM tb_users
WHERE ID BETWEEN @t3_first_id AND @t3_last_id;

-- Todas las filas de tb_users de los lotes deben tener su tb_people.
SELECT COUNT(*) AS usuarios_sin_persona
FROM tb_users u
LEFT JOIN tb_people p ON p.user_ID = u.ID
WHERE (u.ID BETWEEN @t1_first_id AND @t1_last_id
    OR u.ID BETWEEN @t2_first_id AND @t2_last_id
    OR u.ID BETWEEN @t3_first_id AND @t3_last_id)
  AND p.user_ID IS NULL;

-- Inserciones en bitacora con la identidad real de la conexion superadmin.
SELECT operation_type, connection_user, COUNT(*) AS eventos
FROM vw_trazabilidad_usuarios_creados
WHERE record_id BETWEEN @t1_first_id AND @t3_last_id
GROUP BY operation_type, connection_user;

SELECT operation_type, connection_user, COUNT(*) AS eventos
FROM vw_trazabilidad_people
WHERE user_ID BETWEEN @t1_first_id AND @t3_last_id
GROUP BY operation_type, connection_user;

-- CRUD de un registro personal con nombre y correo sinteticos realistas.
-- El registro temporal se elimina al final; sus logs permanecen para revisar
-- Create, Update y Delete. No se etiqueta el registro en sus datos.
SET @crud_given_name = fn_random_given_name(@gender_male_id);
SET @crud_family_names = CONCAT(fn_random_family_name(), ' ', fn_random_family_name());
SET @crud_suffix = LPAD(FLOOR(RAND() * 100000000), 8, '0');
SET @crud_email = CONCAT(
    LOWER(@crud_given_name), '.',
    LOWER(SUBSTRING_INDEX(@crud_family_names, ' ', 1)),
    @crud_suffix, '@', fn_random_email_domain()
);
SET @crud_nickname = CONCAT(
    LOWER(@crud_given_name), '.',
    LOWER(SUBSTRING_INDEX(@crud_family_names, ' ', 1)),
    @crud_suffix
);

-- Elegir el genero para esta cuenta: 1 Masculino, 2 Femenino,
-- 3 No binario o 4 Prefiero no decir.
SET @crud_gender_id = @gender_female_id;

CALL sp_register_user(
    @crud_email, @crud_nickname, SHA2(UUID(), 256), NULL,
    @crud_given_name, @crud_family_names,
    fn_random_birth_date(18, 80), @crud_gender_id, NULL, 'US'
);

SET @crud_user_id = (SELECT ID FROM tb_users WHERE email = @crud_email);
SET @crud_person_id = (SELECT person_ID FROM tb_people WHERE user_ID = @crud_user_id);

-- Confirma que la opcion elegida se guarda y se reconoce con su etiqueta.
SELECT person_ID, user_ID, given_names, family_names,
       gender_ID, gender_name, country_code
FROM vw_people_with_gender
WHERE person_ID = @crud_person_id;

UPDATE tb_users
SET nickname = CONCAT(nickname, '8')
WHERE ID = @crud_user_id;

UPDATE tb_people
SET phone = '5550100'
WHERE person_ID = @crud_person_id;

-- La FK usa RESTRICT: borrar primero la persona y luego su usuario.
DELETE FROM tb_people WHERE person_ID = @crud_person_id;
DELETE FROM tb_users WHERE ID = @crud_user_id;

-- La vista debe mostrar las seis acciones de tb_users/tb_people y su usuario.
SELECT 'tb_users' AS entidad, operation_type, connection_user,
       record_id, change_description, operation_date
FROM vw_trazabilidad_usuarios_creados
WHERE record_id = @crud_user_id
UNION ALL
SELECT 'tb_people', operation_type, connection_user,
       record_id, change_description, operation_date
FROM vw_trazabilidad_people
WHERE record_id = @crud_person_id
ORDER BY entidad, operation_date;

-- Confirmar que quedaron exactamente 3 tipos de operacion para el usuario CRUD.
SELECT table_name, operation, db_users, COUNT(*) AS eventos
FROM tb_logs
WHERE (table_name = 'tb_users' AND description LIKE CONCAT('%ID=', @crud_user_id, ',%'))
   OR (table_name = 'tb_people' AND description LIKE CONCAT('%ID=', @crud_person_id, ',%'))
GROUP BY table_name, operation, db_users
ORDER BY table_name, operation;

-- Comprobar el evento y requisitos del servidor.
SHOW VARIABLES LIKE 'event_scheduler';
SHOW VARIABLES LIKE 'log_bin';
SHOW VARIABLES LIKE 'log_bin_trust_function_creators';
SHOW EVENTS FROM db_test LIKE 'ev_daily_database_metrics';
CALL sp_log_daily_metrics();
SELECT ID, table_name, operation, db_users, description, operation_date
FROM tb_logs WHERE table_name = 'system_metrics'
ORDER BY ID DESC LIMIT 5;

-- Prueba negativa opcional, ejecutar por separado: el parametro debe rechazarse.
-- CALL sp_simulate_users(6000, NULL, '*', NULL, NULL, 0.8000, @first_id, @last_id);
