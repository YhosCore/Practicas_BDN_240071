/*consulta de verificacion*/
Create DATABASE db_test;
use db_test;
Show tables;
show triggers from db_test;
select * from tb_users;
select * from tb_log;

select user,host from mysql.user where host="%";

Select 
	FROM_USER AS ROL, 
    FROM_HOST AS Host_Rol,
    TO_USER AS Usuario,
    TO_HOST AS HOST_USUARIO
from mysql.role_edges
order by FROM_USER, TO_USER;