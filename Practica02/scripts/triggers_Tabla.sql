-- ------------------------------------------------------
-- TRIGGER: AFTER INSERT (Al registrar un nuevo producto)
-- ------------------------------------------------------
DELIMITER //
CREATE TRIGGER `trg_after_insert_tb_products` 
AFTER INSERT ON `tb_products` 
FOR EACH ROW 
BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_products',
        'Create',
        USER(),
        CONCAT('Producto creado. ID=', NEW.ID, ', SKU=', NEW.SKU, ', nombre=', NEW.name, ', precio=$', NEW.current_price, ', stock=', NEW.current_stock)
    );
END //
DELIMITER ;

-- ------------------------------------------------------
-- TRIGGER: AFTER UPDATE (Al modificar un producto)
-- ------------------------------------------------------
DELIMITER //
CREATE TRIGGER `trg_after_update_tb_products` 
AFTER UPDATE ON `tb_products` 
FOR EACH ROW 
BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_products',
        'Update',
        USER(),
        CONCAT('Producto actualizado. ID=', NEW.ID, ', SKU=', NEW.SKU, ', nombre=', NEW.name, ', precio=$', NEW.current_price, ', stock=', NEW.current_stock)
    );
END //
DELIMITER ;

-- ------------------------------------------------------
-- TRIGGER: AFTER DELETE (Al eliminar un producto)
-- ------------------------------------------------------
DELIMITER //
CREATE TRIGGER `trg_after_delete_tb_products` 
AFTER DELETE ON `tb_products` 
FOR EACH ROW 
BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_users`,
        `description`
    ) 
    VALUES (
        'tb_products',
        'Delete',
        USER(),
        CONCAT('Producto eliminado. ID=', OLD.ID, ', SKU=', OLD.SKU, ', nombre=', OLD.name, ', precio=$', OLD.current_price, ', stock=', OLD.current_stock)
    );
END //
DELIMITER ;