-- Verificacion de la seccion 8 de la Practica 03.
-- Ejecutar despues de las cargas de usuarios y productos. Solo consulta datos.
USE db_test;

-- Los valores predeterminados corresponden a una carga limpia de esta practica.
-- Si CALL sp_simulate_users devolvio otros IDs, reemplazar estos seis valores.
SET @t1_first_id = COALESCE(@t1_first_id, 14);
SET @t1_last_id  = COALESCE(@t1_last_id, 513);
SET @t2_first_id = COALESCE(@t2_first_id, 514);
SET @t2_last_id  = COALESCE(@t2_last_id, 2513);
SET @t3_first_id = COALESCE(@t3_first_id, 2514);
SET @t3_last_id  = COALESCE(@t3_last_id, 7513);

-- 1) Totales de objetos SQL esperados en la base.
SELECT
    (SELECT COUNT(*) FROM information_schema.tables
     WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE') AS tablas,
    (SELECT COUNT(*) FROM information_schema.triggers
     WHERE trigger_schema = DATABASE()) AS triggers_totales,
    (SELECT COUNT(*) FROM information_schema.triggers
     WHERE trigger_schema = DATABASE()
       AND action_timing = 'AFTER'
       AND event_manipulation IN ('INSERT','UPDATE','DELETE')) AS triggers_auditoria,
    (SELECT COUNT(*) FROM information_schema.views
     WHERE table_schema = DATABASE()) AS vistas,
    (SELECT COUNT(*) FROM information_schema.routines
     WHERE routine_schema = DATABASE()) AS rutinas,
    (SELECT COUNT(*) FROM information_schema.events
     WHERE event_schema = DATABASE()) AS eventos;

-- Debe listar 24 tablas con tres triggers AFTER de auditoria por tabla.
SELECT event_object_table AS tabla, COUNT(*) AS triggers_after
FROM information_schema.triggers
WHERE trigger_schema = DATABASE()
  AND action_timing = 'AFTER'
  AND event_manipulation IN ('INSERT','UPDATE','DELETE')
GROUP BY event_object_table
HAVING COUNT(*) <> 3
ORDER BY event_object_table;

-- 1) Conexión e instancia efectivas: guardar el resultado como evidencia.
SELECT DATABASE() AS base_actual, @@hostname AS servidor, @@port AS puerto,
       USER() AS cuenta_conectada, CURRENT_USER() AS cuenta_autorizada;

-- 2) Conteo de tablas y motores.
SELECT COUNT(*) AS total_tablas
FROM information_schema.tables
WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE';

SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 3) Columnas, tipos, nulabilidad, claves y defaults declarados.
SELECT table_name, ordinal_position, column_name, column_type,
       is_nullable, column_key, column_default, extra
FROM information_schema.columns
WHERE table_schema = DATABASE()
ORDER BY table_name, ordinal_position;

-- 4) Claves foráneas declaradas y sus reglas.
SELECT table_name, constraint_name, column_name,
       referenced_table_name, referenced_column_name,
       ordinal_position, position_in_unique_constraint
FROM information_schema.key_column_usage
WHERE table_schema = DATABASE()
  AND referenced_table_name IS NOT NULL
ORDER BY table_name, constraint_name, ordinal_position;

-- 5) Conteo de filas huérfanas para cada FK (debe ser 0 en todas).

SELECT 'tb_buyer_orders.fk_user_2' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_buyer_orders` c LEFT JOIN `tb_users` p ON c.`User_ID` = p.`ID` WHERE c.`User_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_carts.fk_cart_user' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_carts` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_order_cancellations.fk_cancellations_order' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_order_cancellations` c LEFT JOIN `tb_buyer_orders` p ON c.`buyer_order_ID` = p.`ID` WHERE c.`buyer_order_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_order_cancellations.fk_cancellations_user' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_order_cancellations` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_payment_methods.fk_payment_methods_type' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_payment_methods` c LEFT JOIN `tbc_payment_methods_types` p ON c.`payment_method_type_ID` = p.`ID` WHERE c.`payment_method_type_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_payment_transaction.fk_payment_transaction_payment' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_payment_transaction` c LEFT JOIN `tb_payments` p ON c.`payment_ID` = p.`ID` WHERE c.`payment_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_payments.fk_payments_buyer_order' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_payments` c LEFT JOIN `tb_buyer_orders` p ON c.`buyer_order_ID` = p.`ID` WHERE c.`buyer_order_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_payments.fk_payments_user_method' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_payments` c LEFT JOIN `tbd_user_payment_methods` p ON c.`user_payment_method_ID` = p.`ID` WHERE c.`user_payment_method_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_people.fk_personal_data_user' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_people` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_refunds.fk_refunds_cancellation' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_refunds` c LEFT JOIN `tb_order_cancellations` p ON c.`cancellation_ID` = p.`ID` WHERE c.`cancellation_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_refunds.fk_refunds_payment' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_refunds` c LEFT JOIN `tb_payments` p ON c.`payment_ID` = p.`ID` WHERE c.`payment_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_refunds.fk_refunds_return' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_refunds` c LEFT JOIN `tb_returns` p ON c.`return_ID` = p.`ID` WHERE c.`return_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_returns.fk_returns_order' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_returns` c LEFT JOIN `tb_buyer_orders` p ON c.`buyer_order_ID` = p.`ID` WHERE c.`buyer_order_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_returns.fk_returns_user' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_returns` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_shipments.fk_shipments_address' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_shipments` c LEFT JOIN `tb_user_addresses` p ON c.`address_ID` = p.`ID` WHERE c.`address_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_shipments.fk_shipments_buyer_order' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_shipments` c LEFT JOIN `tb_buyer_orders` p ON c.`buyer_order_ID` = p.`ID` WHERE c.`buyer_order_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tb_user_addresses.fk_addresses_users' AS relacion, COUNT(*) AS filas_huerfanas FROM `tb_user_addresses` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbc_categories.fk_superior_category' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbc_categories` c LEFT JOIN `tbc_categories` p ON c.`sup_id_category` = p.`ID` WHERE c.`sup_id_category` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_address_components.fk_component_address' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_address_components` c LEFT JOIN `tb_user_addresses` p ON c.`address_ID` = p.`ID` WHERE c.`address_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_address_components.fk_component_parent' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_address_components` c LEFT JOIN `tbd_address_components` p ON c.`address_ID` = p.`address_ID` AND c.`address_sup_ID` = p.`ID` WHERE c.`address_ID` IS NOT NULL AND c.`address_sup_ID` IS NOT NULL AND p.`address_ID` IS NULL
UNION ALL
SELECT 'tbd_cancellation_items.fk_cancellation_items_cancellation' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_cancellation_items` c LEFT JOIN `tb_order_cancellations` p ON c.`cancellation_ID` = p.`ID` WHERE c.`cancellation_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_cancellation_items.fk_cancellation_items_order_item' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_cancellation_items` c LEFT JOIN `tbd_order_items` p ON c.`order_item_ID` = p.`ID` WHERE c.`order_item_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_carts_items.fk_cart_items_cart' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_carts_items` c LEFT JOIN `tb_carts` p ON c.`cart_ID` = p.`ID` WHERE c.`cart_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_carts_items.fk_cart_items_offer' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_carts_items` c LEFT JOIN `tbd_products_users_providers` p ON c.`product_offer_ID` = p.`product_offer_ID` WHERE c.`product_offer_ID` IS NOT NULL AND p.`product_offer_ID` IS NULL
UNION ALL
SELECT 'tbd_order_items.fk_order_items_offer' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_order_items` c LEFT JOIN `tbd_products_users_providers` p ON c.`product_offer_ID` = p.`product_offer_ID` WHERE c.`product_offer_ID` IS NOT NULL AND p.`product_offer_ID` IS NULL
UNION ALL
SELECT 'tbd_order_items.fk_order_items_order' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_order_items` c LEFT JOIN `tb_buyer_orders` p ON c.`order_ID` = p.`ID` WHERE c.`order_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_products_categories.fk_category' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_products_categories` c LEFT JOIN `tbc_categories` p ON c.`category_ID` = p.`ID` WHERE c.`category_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_products_categories.fk_product' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_products_categories` c LEFT JOIN `tb_products` p ON c.`product_ID` = p.`ID` WHERE c.`product_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_products_users_providers.fk_product_2' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_products_users_providers` c LEFT JOIN `tb_products` p ON c.`product_ID` = p.`ID` WHERE c.`product_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_products_users_providers.fk_user_1' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_products_users_providers` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_return_items.fk_return_items_order_item' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_return_items` c LEFT JOIN `tbd_order_items` p ON c.`order_item_ID` = p.`ID` WHERE c.`order_item_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_return_items.fk_return_items_return' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_return_items` c LEFT JOIN `tb_returns` p ON c.`return_ID` = p.`ID` WHERE c.`return_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_user_payment_methods.tbd_user_payment_methods_ibfk_1' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_user_payment_methods` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_user_payment_methods.tbd_user_payment_methods_ibfk_2' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_user_payment_methods` c LEFT JOIN `tbc_payment_methods_types` p ON c.`payment_method_type_ID` = p.`ID` WHERE c.`payment_method_type_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_users_wishlist_products.fk_wishlist_product' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_users_wishlist_products` c LEFT JOIN `tb_products` p ON c.`product_ID` = p.`ID` WHERE c.`product_ID` IS NOT NULL AND p.`ID` IS NULL
UNION ALL
SELECT 'tbd_users_wishlist_products.fk_wishlist_user' AS relacion, COUNT(*) AS filas_huerfanas FROM `tbd_users_wishlist_products` c LEFT JOIN `tb_users` p ON c.`user_ID` = p.`ID` WHERE c.`user_ID` IS NOT NULL AND p.`ID` IS NULL;


-- 6) Diagnósticos de cobertura de relaciones. No son errores de FK:
-- muestran filas que carecen de una relación opcional/esperada por la práctica.
SELECT COUNT(*) AS usuarios_sin_persona
FROM tb_users u
LEFT JOIN tb_people p ON p.user_ID = u.ID
WHERE p.user_ID IS NULL;

SELECT COUNT(*) AS productos_sin_categoria
FROM tb_products p
LEFT JOIN tbd_products_categories pc ON pc.product_ID = p.ID
WHERE pc.product_ID IS NULL;

SELECT COUNT(*) AS productos_sin_proveedor
FROM tb_products p
LEFT JOIN tbd_products_users_providers pp ON pp.product_ID = p.ID
WHERE pp.product_ID IS NULL;

-- Conteos básicos para comparar con los criterios de la práctica.
SELECT 'tb_users' AS tabla, COUNT(*) AS filas FROM tb_users
UNION ALL SELECT 'tb_people', COUNT(*) FROM tb_people
UNION ALL SELECT 'tb_products', COUNT(*) FROM tb_products
UNION ALL SELECT 'tb_logs', COUNT(*) FROM tb_logs
UNION ALL SELECT 'tbd_products_categories', COUNT(*) FROM tbd_products_categories
UNION ALL SELECT 'tbd_products_users_providers', COUNT(*) FROM tbd_products_users_providers;

-- 7) Cantidad y criterios del lote de 7,500 usuarios simulados.
SELECT 'T1: 500 hombres de US' AS escenario,
       COUNT(u.ID) AS usuarios,
       SUM(p.gender_ID = 1) AS genero_masculino,
       SUM(p.country_code = 'US') AS pais_US,
       CASE WHEN COUNT(u.ID) = 500
                  AND SUM(p.gender_ID = 1) = 500
                  AND SUM(p.country_code = 'US') = 500
            THEN 'OK' ELSE 'REVISAR' END AS resultado
FROM tb_users u
LEFT JOIN tb_people p ON p.user_ID = u.ID
WHERE u.ID BETWEEN @t1_first_id AND @t1_last_id
UNION ALL
SELECT 'T2: 2,000 personas, edades 19-35',
       COUNT(u.ID), NULL, NULL,
       CASE WHEN COUNT(u.ID) = 2000
                  AND MIN(TIMESTAMPDIFF(YEAR,p.birth_date,CURDATE())) >= 19
                  AND MAX(TIMESTAMPDIFF(YEAR,p.birth_date,CURDATE())) <= 35
                  AND COUNT(DISTINCT p.country_code) > 1
            THEN 'OK' ELSE 'REVISAR' END
FROM tb_users u
LEFT JOIN tb_people p ON p.user_ID = u.ID
WHERE u.ID BETWEEN @t2_first_id AND @t2_last_id
UNION ALL
SELECT 'T3: 5,000 cuentas, 80% activas',
       COUNT(u.ID), SUM(u.status = b'1'), SUM(u.status = b'0'),
       CASE WHEN COUNT(u.ID) = 5000
                  AND AVG(u.status = b'1') BETWEEN 0.78 AND 0.82
            THEN 'OK' ELSE 'REVISAR' END
FROM tb_users u
WHERE u.ID BETWEEN @t3_first_id AND @t3_last_id;

SELECT COUNT(*) AS usuarios_simulados_total,
       CASE WHEN COUNT(*) = 7500 THEN 'OK' ELSE 'REVISAR' END AS resultado
FROM tb_users
WHERE ID BETWEEN @t1_first_id AND @t3_last_id;

SELECT COUNT(*) AS usuarios_sin_datos_personales
FROM tb_users u
LEFT JOIN tb_people p ON p.user_ID = u.ID
WHERE (u.ID BETWEEN @t1_first_id AND @t1_last_id
    OR u.ID BETWEEN @t2_first_id AND @t2_last_id
    OR u.ID BETWEEN @t3_first_id AND @t3_last_id)
  AND p.user_ID IS NULL;

-- 8) Cantidad de productos y distribucion por perfil vendedor.
SELECT COUNT(*) AS productos_en_catalogo,
       CASE WHEN COUNT(*) >= 7000 THEN 'OK' ELSE 'REVISAR' END AS minimo_7000
FROM tb_products;

SELECT u.email AS vendedor,
       COUNT(DISTINCT pp.product_ID) AS productos,
       SUM(p.status = b'0') AS descontinuados
FROM tb_users u
JOIN tbd_products_users_providers pp ON pp.user_ID = u.ID
JOIN tb_products p ON p.ID = pp.product_ID
WHERE u.email IN ('olaf.garcia@PC-14', 'lalo.amaro@PC-21')
GROUP BY u.email
ORDER BY u.email;

-- 9) Categorias/subcategorias con menos de cinco productos; debe devolver cero filas.
SELECT c.ID AS category_ID, c.name AS categoria,
       c.sup_id_category AS categoria_superior,
       COUNT(DISTINCT pc.product_ID) AS productos
FROM tbc_categories c
LEFT JOIN tbd_products_categories pc ON pc.category_ID = c.ID
GROUP BY c.ID, c.name, c.sup_id_category
HAVING COUNT(DISTINCT pc.product_ID) < 5
ORDER BY c.sup_id_category, c.ID;

-- Distribucion consultada mediante la vista de trazabilidad de productos/categorias.
SELECT category_ID, category_path,
       COUNT(DISTINCT product_ID) AS productos,
       SUM(availability_status = b'1') AS disponibles,
       SUM(availability_status = b'0') AS no_disponibles
FROM vw_trazabilidad_de_productos_categorias
GROUP BY category_ID, category_path
ORDER BY category_path;

-- 10) Descontinuados y representacion en la vista de categoria.
SELECT status, COUNT(*) AS productos
FROM tb_products
GROUP BY status
ORDER BY status;

SELECT availability_label, COUNT(DISTINCT product_ID) AS productos
FROM vw_trazabilidad_de_productos_categorias
GROUP BY availability_label
ORDER BY availability_label;

-- 11) Trazabilidad de usuarios superadmin y de vendedores seller.
SELECT affected_table, operation_type, connection_user,
       COUNT(*) AS operaciones,
       MIN(operation_date) AS primera_operacion,
       MAX(operation_date) AS ultima_operacion
FROM vw_trazabilidad_usuarios_creados
WHERE connection_user LIKE 'yhostin.rmz@%'
   OR connection_user LIKE 'olaf.garcia@%'
   OR connection_user LIKE 'lalo.amaro@%'
GROUP BY affected_table, operation_type, connection_user
ORDER BY connection_user, affected_table, operation_type;

SELECT affected_table, operation_type, connection_user,
       COUNT(*) AS operaciones,
       MIN(operation_date) AS primera_operacion,
       MAX(operation_date) AS ultima_operacion
FROM vw_trazabilidad_productos
WHERE connection_user LIKE 'yhostin.rmz@%'
   OR connection_user LIKE 'olaf.garcia@%'
   OR connection_user LIKE 'lalo.amaro@%'
GROUP BY affected_table, operation_type, connection_user
ORDER BY connection_user, affected_table, operation_type;

-- Los roles se consultan en asignaciones actuales; la bitacora no conserva
-- CURRENT_ROLE() historico, solo USER() capturado al ejecutarse el trigger.
SELECT FROM_USER AS rol, TO_USER AS cuenta, WITH_ADMIN_OPTION
FROM mysql.role_edges
WHERE FROM_USER IN ('superadmin', 'seller')
  AND TO_USER IN ('yhostin.rmz', 'olaf.garcia', 'lalo.amaro')
ORDER BY rol, cuenta;

-- 12) Restricciones declaradas y reglas de cascada/restriccion.
SELECT tc.table_name, tc.constraint_name, tc.constraint_type,
       rc.update_rule, rc.delete_rule
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.referential_constraints rc
  ON rc.constraint_schema = tc.constraint_schema
 AND rc.table_name = tc.table_name
 AND rc.constraint_name = tc.constraint_name
WHERE tc.constraint_schema = DATABASE()
  AND tc.constraint_type IN ('FOREIGN KEY', 'CHECK', 'UNIQUE', 'PRIMARY KEY')
ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;

-- 13) Evidencia: guardar/exportar los grids de resultados y anotar la fecha,
-- servidor, cuenta conectada y cuenta autorizada obtenidos en la seccion 1.
