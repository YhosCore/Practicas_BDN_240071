/* ========================================================= */
/* 0. LIMPIEZA PREVIA (Elimina usuarios y roles anteriores)  */
/* ========================================================= */
DROP USER IF EXISTS 'olaf.garcia.izquierda'@'%';
DROP USER IF EXISTS 'marco.ramirez'@'%';
DROP USER IF EXISTS 'cris.escamilla.derecha'@'%';
DROP USER IF EXISTS 'lalo.amaro'@'%';
DROP USER IF EXISTS 'yhostin.rmz'@'%';
DROP USER IF EXISTS 'uriel.gonzalez.izquierda'@'%';
DROP USER IF EXISTS 'carlos.alberto'@'%';

DROP ROLE IF EXISTS 'superadmin', 'admin', 'seller', 'buyer', 'support', 'common', 'user_not_registered';
FLUSH PRIVILEGES;

/* ========================================================= */
/* 1. CREACIÓN DE LOS 7 USUARIOS REMOTOS                     */
/* ========================================================= */
CREATE USER 'olaf.garcia.izquierda'@'%' IDENTIFIED BY '240508';
CREATE USER 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER 'cris.escamilla.derecha'@'%' IDENTIFIED BY '240687';
CREATE USER 'lalo.amaro'@'%' IDENTIFIED BY '240726';
CREATE USER 'yhostin.rmz'@'%' IDENTIFIED BY '240071';
CREATE USER 'uriel.gonzalez.izquierda'@'%' IDENTIFIED BY '240463';
CREATE USER 'carlos.alberto'@'%' IDENTIFIED BY '240201';

/* ========================================================= */
/* 2. ASIGNACIÓN DE PRIVILEGIOS DIRECTOS                     */
/* ========================================================= */
GRANT ALL PRIVILEGES ON *.* TO 'yhostin.rmz'@'%' WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test.* TO 'marco.ramirez'@'%';

/* ========================================================= */
/* 3. CREACIÓN DE LOS 7 ROLES                                */
/* ========================================================= */
CREATE ROLE 'superadmin';
CREATE ROLE 'admin';
CREATE ROLE 'seller';
CREATE ROLE 'buyer';
CREATE ROLE 'support';
CREATE ROLE 'common';
CREATE ROLE 'user_not_registered';

/* ========================================================= */
/* 4. ASIGNACIÓN DE PRIVILEGIOS A LOS 7 ROLES (SIN DELETE)   */
/* ========================================================= */
-- SUPERADMIN Y ADMIN
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';

-- SUPPORT 
GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'support';

-- SELLER (Sin permiso de borrar)
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'seller';

-- BUYER (Para compradores)
GRANT SELECT ON db_test.tb_products TO 'buyer';

-- COMMON (Para usuarios estándar / comunes)
GRANT SELECT ON db_test.tb_products TO 'common';

-- USER_NOT_REGISTERED (Para visitantes)
GRANT SELECT ON db_test.tb_products TO 'user_not_registered';

/* ========================================================= */
/* 5. ASIGNAR LOS ROLES A LOS 7 USUARIOS                     */
/* ========================================================= */
GRANT 'superadmin' TO 'yhostin.rmz'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'cris.escamilla.derecha'@'%';

-- Los 2 vendedores
GRANT 'seller' TO 'lalo.amaro'@'%';
GRANT 'seller' TO 'uriel.gonzalez.izquierda'@'%';

-- Comprador
GRANT 'buyer' TO 'olaf.garcia.izquierda'@'%';

-- Usuario común
GRANT 'common' TO 'carlos.alberto'@'%';

/* ========================================================= */
/* 6. ACTIVAR ROLES AUTOMÁTICAMENTE AL INICIAR SESIÓN        */
/* ========================================================= */
SET DEFAULT ROLE 'superadmin' TO 'yhostin.rmz'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'support' TO 'cris.escamilla.derecha'@'%';
SET DEFAULT ROLE 'seller' TO 'lalo.amaro'@'%';
SET DEFAULT ROLE 'seller' TO 'uriel.gonzalez.izquierda'@'%';
SET DEFAULT ROLE 'buyer' TO 'olaf.garcia.izquierda'@'%';
SET DEFAULT ROLE 'common' TO 'carlos.alberto'@'%';

/* ========================================================= */
/* 7. ASIGNACIÓN DE PRIVILEGIOS DIRECTOS ADICIONALES         */
/* ========================================================= */
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test.* TO 'yhostin.rmz'@'%';

FLUSH PRIVILEGES;

/* ========================================================= */
/* 8. MENSAJE DE CONFIRMACIÓN                                */
/* ========================================================= */
SELECT '¡Usuarios, roles y privilegios creados correctamente!' AS Mensaje;