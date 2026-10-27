-- Practica de bases de datos en VPS: esquema MySQL creado desde cero.
-- Ejecutar en MySQL Workbench conectado a la instancia aislada dbnube-240071.
-- No importa ni restaura respaldos.

CREATE DATABASE IF NOT EXISTS db_test
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE db_test;

CREATE TABLE IF NOT EXISTS tb_logs (
  ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  table_name VARCHAR(100) NOT NULL,
  operation ENUM('Create','Read','Update','Delete') NOT NULL,
  db_users VARCHAR(128) NOT NULL,
  description TEXT NOT NULL,
  operation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  operation_status BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (ID),
  KEY idx_logs_table_operation_date (table_name, operation, operation_date)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tb_users (
  ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
  email VARCHAR(120) NOT NULL,
  nickname VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL COMMENT 'Guardar hash de practica, nunca contrasena en claro',
  creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_login DATETIME NULL,
  PRIMARY KEY (ID),
  UNIQUE KEY uq_users_email (email),
  UNIQUE KEY uq_users_nickname (nickname)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tb_products (
  ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
  SKU VARCHAR(50) NOT NULL,
  name VARCHAR(250) NOT NULL,
  description TEXT NULL,
  current_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  current_stock INT UNSIGNED NOT NULL DEFAULT 0,
  status TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1 activo, 0 inactivo',
  creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ID),
  UNIQUE KEY uq_products_sku (SKU),
  KEY idx_products_status (status)
) ENGINE=InnoDB;

-- Roles del contexto e-commerce, siguiendo la matriz base de la guía.
-- `common` se interpreta como el permiso base de consulta de productos.
CREATE ROLE IF NOT EXISTS
  'superadmin', 'admin', 'seller', 'buyer', 'support', 'common', 'not_registered';

GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';

GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';
GRANT SELECT, UPDATE ON db_test.tb_products TO 'support';

GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'seller';
GRANT SELECT ON db_test.tb_products TO 'buyer';
GRANT SELECT ON db_test.tb_products TO 'common';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'not_registered';

DROP TRIGGER IF EXISTS trg_after_insert_tb_products;
DROP TRIGGER IF EXISTS trg_after_update_tb_products;
DROP TRIGGER IF EXISTS trg_after_delete_tb_products;
DROP TRIGGER IF EXISTS trg_after_insert_tb_users;
DROP TRIGGER IF EXISTS trg_after_update_tb_users;
DROP TRIGGER IF EXISTS trg_after_delete_tb_users;
DROP VIEW IF EXISTS vw_trazabilidad_productos;
DROP VIEW IF EXISTS vw_trazabilidad_usuarios_creados;
DROP PROCEDURE IF EXISTS sp_restore_product;

DELIMITER $$
CREATE TRIGGER trg_after_insert_tb_products
AFTER INSERT ON tb_products FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, operation, db_users, description)
  VALUES ('tb_products', 'Create', USER(),
    CONCAT('Producto creado. ID=', NEW.ID, ', SKU=', NEW.SKU,
           ', nombre=', NEW.name, ', precio=$', NEW.current_price,
           ', stock=', NEW.current_stock));
END$$

CREATE TRIGGER trg_after_update_tb_products
AFTER UPDATE ON tb_products FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, operation, db_users, description)
  VALUES ('tb_products', 'Update', USER(),
    CONCAT('Producto actualizado. ID=', NEW.ID, ', SKU=', NEW.SKU,
           ', nombre=', NEW.name, ', precio=$', NEW.current_price,
           ', stock=', NEW.current_stock, ', estado=', NEW.status));
END$$

CREATE TRIGGER trg_after_delete_tb_products
AFTER DELETE ON tb_products FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, operation, db_users, description)
  VALUES ('tb_products', 'Delete', USER(),
    CONCAT('Producto eliminado. ID=', OLD.ID, ', SKU=', OLD.SKU,
           ', nombre=', OLD.name, ', precio=$', OLD.current_price,
           ', stock=', OLD.current_stock));
END$$

CREATE TRIGGER trg_after_insert_tb_users
AFTER INSERT ON tb_users FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, operation, db_users, description)
  VALUES ('tb_users', 'Create', USER(),
    CONCAT('Usuario creado. nickname=', NEW.nickname, ', email=', NEW.email));
END$$

CREATE TRIGGER trg_after_update_tb_users
AFTER UPDATE ON tb_users FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, operation, db_users, description)
  VALUES ('tb_users', 'Update', USER(),
    CONCAT('Usuario actualizado. ID=', NEW.ID, ', nickname=', NEW.nickname,
           ', email=', NEW.email));
END$$

CREATE TRIGGER trg_after_delete_tb_users
AFTER DELETE ON tb_users FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, operation, db_users, description)
  VALUES ('tb_users', 'Delete', USER(),
    CONCAT('Usuario eliminado. ID=', OLD.ID, ', nickname=', OLD.nickname,
           ', email=', OLD.email));
END$$

CREATE PROCEDURE sp_restore_product(IN p_product_id INT UNSIGNED)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM tb_products WHERE ID = p_product_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto especificado no existe';
  END IF;
  IF EXISTS (SELECT 1 FROM tb_products WHERE ID = p_product_id AND status = 1) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto ya se encuentra activo';
  END IF;
  UPDATE tb_products SET status = 1 WHERE ID = p_product_id;
END$$
DELIMITER ;

CREATE OR REPLACE VIEW vw_trazabilidad_productos AS
SELECT p.ID AS id, p.name, p.description AS product_description,
       l.db_users AS inserted_by,
       COALESCE(GROUP_CONCAT(DISTINCT re.FROM_USER ORDER BY re.FROM_USER SEPARATOR ', '), 'Sin rol') AS roles,
       l.description AS operation_description, l.operation_date
FROM tb_products AS p
JOIN tb_logs AS l
  ON l.description LIKE CONCAT('%ID=', p.ID, '%')
LEFT JOIN mysql.role_edges AS re
  ON re.TO_USER = SUBSTRING_INDEX(l.db_users, '@', 1)
WHERE l.operation = 'Create' AND l.table_name = 'tb_products'
GROUP BY p.ID, p.name, p.description, l.db_users, l.description, l.operation_date;

CREATE OR REPLACE VIEW vw_trazabilidad_usuarios_creados AS
SELECT u.nickname, u.email, l.db_users AS inserted_by,
       COALESCE((
         SELECT GROUP_CONCAT(DISTINCT re.FROM_USER ORDER BY re.FROM_USER SEPARATOR ', ')
         FROM mysql.role_edges AS re
         WHERE re.TO_USER = SUBSTRING_INDEX(l.db_users, '@', 1)
       ), 'Sin roles') AS roles,
       l.description AS operation_description, l.operation_date
FROM tb_logs AS l
JOIN tb_users AS u
  ON l.description LIKE CONCAT('%', u.nickname, '%')
 AND l.description LIKE CONCAT('%', u.email, '%')
WHERE l.table_name = 'tb_users' AND l.operation = 'Create';

-- Comprobacion inicial despues de ejecutar el script:
SHOW TABLES;
SHOW TRIGGERS;
SHOW PROCEDURE STATUS WHERE Db = 'db_test';
SHOW FULL TABLES WHERE Table_type = 'VIEW';
