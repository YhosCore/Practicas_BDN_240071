-- Auditoría de solo lectura para bd_practica03_07.sql
-- Ejecutar en la instancia MySQL que se desea verificar.
USE db_test;

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
UNION ALL SELECT 'tbd_products_categories', COUNT(*) FROM tbd_products_categories
UNION ALL SELECT 'tbd_products_users_providers', COUNT(*) FROM tbd_products_users_providers;
