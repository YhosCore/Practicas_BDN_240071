# Práctica 03: Manipulación de datos, relaciones y rutinas

## Propósito

Documentar la práctica de conexiones remotas a MySQL, manipulación de datos, integridad relacional, procedimientos, funciones, eventos y auditoría mediante triggers.

## Trabajo incluido

- Creación y asignación de usuarios, roles y privilegios de conexión.
- Simulación de tres grupos de usuarios: 500 hombres de Estados Unidos, 2,000 personas de 19 a 35 años de distintos países y 5,000 cuentas con una proporción aproximada de 80 % activas.
- Pruebas de `sp_register_user`, `sp_simulate_users` y de las funciones auxiliares; se incluye un ciclo CRUD de usuario y datos personales.
- Carga y revisión del catálogo de productos, categorías, proveedores y relaciones.
- Auditoría de cambios con triggers y registros en `tb_logs`, además de métricas diarias mediante procedimiento y evento.
- Consultas de verificación de estructura, claves foráneas, datos huérfanos, lotes simulados, catálogo y trazabilidad.

## Resultados esperados

- 7,500 usuarios simulados: grupos de 500, 2,000 y 5,000; los criterios de cada grupo deben marcar `OK` en las verificaciones.
- Al menos 7,000 productos en el catálogo y cobertura de categorías conforme a la consulta de validación.
- Integridad referencial sin filas huérfanas y auditoría CRUD visible en `tb_logs`.
- Procedimientos, funciones, vistas, triggers y el evento de métricas disponibles en la base para ejecutar las pruebas correspondientes.

## Archivos de referencia

- [`backups/07_11__p03.sql`](backups/07_11__p03.sql): respaldo de la base utilizado en la práctica.
- [`Queries/Pruebas_Rutinas_Practica03.sql`](Queries/Pruebas_Rutinas_Practica03.sql): simulación y pruebas de rutinas.
- [`Queries/Verificacion_Seccion08_Practica03.sql`](Queries/Verificacion_Seccion08_Practica03.sql): verificaciones de la sección 8.
- [`Queries/Auditoria_Integridad_Relacional.sql`](Queries/Auditoria_Integridad_Relacional.sql): revisión estructural e integridad.
- [`scripts/remote_users_privileges_creation.sql`](scripts/remote_users_privileges_creation.sql) y [`scripts/triggers_Tabla.sql`](scripts/triggers_Tabla.sql): configuración de permisos y triggers.
