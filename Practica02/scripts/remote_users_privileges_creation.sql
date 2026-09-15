/*CREACION DE USUARIOS REMOTOS*/
CREATE USER 'yhostin.rmz'@'%' IDENTIFIED BY '240071';
CREATE USER 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER 'uriel.gonzalez.izquierda'@'%' IDENTIFIED BY '240463';
CREATE USER 'cris.escamilla.derecha'@'%' IDENTIFIED BY '240687';
/* Asignacion de privilegios del super usuario */

GRANT ALL PRIVILEGES ON *.* TO 'yhostin.rmz'@'%' WITH GRANT OPTION;

/*Creacion de roles para los usuarios de la plataforma de ecommerce*/
CREATE ROLE 'admin';
CREATE ROLE 'seller';
CREATE ROLE 'buyer';
CREATE ROLE 'common_user';
CREATE ROLE 'user_not_registered';
CREATE ROLE 'support';

/*Asignacion de privilegios a los roles de la plataforma de ecommerse*/
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';
--support
GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';

/* Asignar el rol al usuario*/
GRANT 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'uriel.gonzalez.izquierda'@'%';
