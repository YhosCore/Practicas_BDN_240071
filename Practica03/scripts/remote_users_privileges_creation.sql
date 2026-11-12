
/* ==============================================================================
   1. CREACIÓN DE LOS 9 USUARIOS REMOTOS
   ============================================================================== */

CREATE USER IF NOT EXISTS 'olaf.garcia'@'%' IDENTIFIED BY '240508';
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'cris.escamilla'@'%' IDENTIFIED BY '240687';
CREATE USER IF NOT EXISTS 'lalo.amaro'@'%' IDENTIFIED BY '240726';
CREATE USER IF NOT EXISTS 'yhostin.rmz'@'%' IDENTIFIED BY '240071';
CREATE USER IF NOT EXISTS 'carlos.alberto'@'%' IDENTIFIED BY '240201';
CREATE USER IF NOT EXISTS 'app_web'@'%' IDENTIFIED BY 'Web123';
CREATE USER IF NOT EXISTS 'app_movil'@'%' IDENTIFIED BY 'Mobile890';


/* ==============================================================================
   2. CREACIÓN DE ROLES
   ============================================================================== */

CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'common_user';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'user_not_registered';


/* ==============================================================================
   3. PRIVILEGIOS ASIGNADOS A LOS ROLES
   ============================================================================== */

/* SUPERADMIN: acceso total a todos los esquemas y objetos */
GRANT ALL PRIVILEGES ON *.* TO 'superadmin' WITH GRANT OPTION;

/* ADMIN: administración completa de db_test */
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';

/* SUPPORT: gestión de usuarios y atención de incidencias */
GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';
GRANT SELECT, UPDATE ON db_test.tb_products TO 'support';
-- sp_soft_delete_user no existe en el respaldo 07_11__p03.sql; quitar este permiso hasta crear la rutina.
GRANT SELECT, INSERT, UPDATE ON db_test.tbc_categories TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_products_categories TO 'support';

GRANT SELECT ON db_test.tb_logs TO 'support';
GRANT SELECT ON db_test.tb_order_cancellations TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_shipments TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_returns TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_refunds TO 'support';
GRANT SELECT ON db_test.tb_payments TO 'support';
GRANT SELECT ON db_test.tb_payment_transaction TO 'support';
GRANT SELECT ON db_test.tb_payment_methods TO 'support';
GRANT SELECT ON db_test.tbc_payment_methods_types TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_cancellation_items TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_return_items TO 'support';
GRANT SELECT ON db_test.tbd_order_items TO 'support';
GRANT SELECT ON db_test.tbd_user_payment_methods TO 'support';
GRANT SELECT ON db_test.tb_user_addresses TO 'support';
GRANT SELECT ON db_test.tbd_address_components TO 'support';
GRANT SELECT ON db_test.tbd_products_users_providers TO 'support';

/* SELLER: administración de productos, proveedores y consulta de pedidos */
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'seller';
GRANT SELECT ON db_test.tbc_categories TO 'seller';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_products_users_providers TO 'seller';
GRANT SELECT ON db_test.tbd_order_items TO 'seller';
GRANT SELECT ON db_test.tb_buyer_orders TO 'seller';
GRANT SELECT ON db_test.tb_shipments TO 'seller';

/* BUYER: carrito, pedidos, direcciones y pagos */
GRANT SELECT, INSERT, UPDATE ON db_test.tb_carts TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_carts_items TO 'buyer';
GRANT SELECT, INSERT ON db_test.tb_buyer_orders TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_users_wishlist_products TO 'buyer';
GRANT SELECT, INSERT ON db_test.tbd_order_items TO 'buyer';
GRANT SELECT ON db_test.tb_payment_methods TO 'buyer';
GRANT SELECT ON db_test.tbc_payment_methods_types TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_user_addresses TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tbd_user_payment_methods TO 'buyer';
GRANT SELECT, INSERT ON db_test.tb_payments TO 'buyer';
GRANT SELECT ON db_test.tb_payment_transaction TO 'buyer';
GRANT SELECT ON db_test.tb_shipments TO 'buyer';
GRANT SELECT, INSERT ON db_test.tb_order_cancellations TO 'buyer';
GRANT SELECT, INSERT ON db_test.tbd_cancellation_items TO 'buyer';
GRANT SELECT, INSERT ON db_test.tb_returns TO 'buyer';
GRANT SELECT, INSERT ON db_test.tbd_return_items TO 'buyer';
GRANT SELECT ON db_test.tb_refunds TO 'buyer';

/* COMMON_USER: consulta solo del catálogo disponible */
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW db_test.vw_catalogo_productos_disponibles AS
SELECT
    o.product_offer_ID,
    p.ID AS product_ID,
    p.SKU,
    p.name,
    p.description,
    p.current_price,
    p.current_stock,
    o.available_stok AS offer_stock
FROM db_test.tb_products AS p
INNER JOIN db_test.tbd_products_users_providers AS o
    ON o.product_ID = p.ID
WHERE p.status = b'1'
  AND p.current_stock > 0
  AND o.status = b'1'
  AND o.available_stok > 0;

REVOKE SELECT ON db_test.tb_products FROM 'common_user';
GRANT SELECT ON db_test.vw_catalogo_productos_disponibles TO 'common_user';
GRANT SELECT ON db_test.vw_catalogo_productos_disponibles TO 'user_not_registered';
GRANT SELECT ON db_test.vw_catalogo_productos_disponibles TO 'buyer';
GRANT SELECT ON db_test.tbc_categories TO 'common_user';
GRANT SELECT ON db_test.tbd_products_categories TO 'common_user';
GRANT SELECT ON db_test.tb_payment_methods TO 'common_user';
GRANT SELECT ON db_test.tbc_payment_methods_types TO 'common_user';

/* USER_NOT_REGISTERED: alta inicial de usuarios */
GRANT INSERT ON db_test.tb_people TO 'user_not_registered';
GRANT INSERT ON db_test.tb_users TO 'user_not_registered';

/* PROCEDIMIENTOS para las aplicaciones web y móvil:
   los permisos EXECUTE se asignan directamente a cada usuario de aplicación. */


/* ==============================================================================
   4. PRIVILEGIOS DIRECTOS ESPECÍFICOS
   ============================================================================== */

/* Marco conserva permisos de lectura y modificación en toda la base db_test. */
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test.* TO 'marco.ramirez'@'%';

/* Aplicaciones: solo pueden ejecutar el procedimiento de registro. */
GRANT EXECUTE ON PROCEDURE db_test.sp_registrar_usuario TO 'app_web'@'%';
GRANT EXECUTE ON PROCEDURE db_test.sp_registrar_usuario TO 'app_movil'@'%';


/* ==============================================================================
   5. ASIGNACIÓN DE LOS ROLES A LOS 9 USUARIOS
   ============================================================================== */

/* Olaf: vendedor */
GRANT 'seller' TO 'olaf.garcia'@'%';

/* Marco: administrador */
GRANT 'admin' TO 'marco.ramirez'@'%';

/* Cristopher: soporte */
GRANT 'support' TO 'cris.escamilla'@'%';

/* Lalo: vendedor */
GRANT 'seller' TO 'lalo.amaro'@'%';

/* Yhostin: superadministrador */
GRANT 'superadmin' TO 'yhostin.rmz'@'%';

/* Carlos: usuario no registrado */
GRANT 'user_not_registered' TO 'app_web'@'%';
GRANT 'user_not_registered' TO 'app_movil'@'%';
/* Aplicaciones web y móvil: ejecutan el procedimiento de registro.
   No se les asigna user_not_registered porque ese rol permite INSERT directo
   en tablas; las aplicaciones reciben únicamente EXECUTE en el procedimiento. */


/* ==============================================================================
   6. ACTIVACIÓN DE ROLES POR DEFECTO
   ============================================================================== */
SET DEFAULT ROLE 'seller' TO 'olaf.garcia'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'support' TO 'cris.escamilla'@'%';
SET DEFAULT ROLE 'seller' TO 'lalo.amaro'@'%';
SET DEFAULT ROLE 'superadmin' TO 'yhostin.rmz'@'%';
SET DEFAULT ROLE 'buyer' TO 'uriel.gonzalez'@'%';
SET DEFAULT ROLE 'user_not_registered' TO 'carlos.alberto'@'%';


/* ==============================================================================
   7. VERIFICACIÓN
   ============================================================================== */

FLUSH PRIVILEGES;

SELECT 'Los users y sus roles/privilegios han sido configurados correctamente'
AS mensaje;


