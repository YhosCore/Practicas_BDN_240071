# Manual de bases de datos en la nube — Unidad 1

**Estudiante:** Yhostin Manuel Ramirez Gonzalez  
**Matrícula:** 240071  
**Grupo:** A  
**Equipo:** 2413  
**Rama de trabajo:** `Manual_VPS_BDs_Relacionales`

## Entregables

- `Reporte_Unidad1_240071.pdf`: reporte técnico individual con el avance y las evidencias disponibles.
- `docker-compose.yml`: despliegue aislado de PostgreSQL, MySQL y pgAdmin.
- `sql/postgresql.sql`: base, tablas, roles, privilegios, triggers y vistas para PostgreSQL.
- `sql/mysql.sql`: base, tablas, roles, privilegios, triggers, procedimiento y vistas para MySQL.

## Entorno registrado

- VPS con Ubuntu 24.04.5 LTS.
- Git 2.43.0, Docker Engine 29.9.1 y Docker Compose v5.6.0.
- PostgreSQL 17 y MySQL 8.4.
- Proyecto Compose `dbnube-240071`, con red y volúmenes propios.
- Puertos del VPS: PostgreSQL `40071`, MySQL `40072` y pgAdmin `54071`.

El archivo Compose toma contraseñas y puertos desde variables de entorno. Copia `.env.example` como `.env`, configura valores secretos propios y no subas `.env`. El ejemplo enlaza los servicios a `127.0.0.1` por seguridad. Para conexiones directas desde clientes externos, configura la dirección de enlace del VPS y mantén las reglas de firewall con una lista de IP autorizadas para los puertos 40071 y 40072. Actualiza esa lista cuando cambie la IP pública del cliente.

## Inicio y administración

```bash
cp .env.example .env
chmod 600 .env
# Edita .env y reemplaza los valores CHANGE_THIS_* por secretos propios.
docker compose config -q
docker compose up -d
docker compose ps -a
docker compose logs --tail=50
```

Para detener los servicios y conservar los datos: `docker compose down`. No uses `docker compose down -v` durante la práctica porque elimina los volúmenes persistentes.

## Scripts SQL

Ejecuta cada script con la cuenta administradora correspondiente al motor. Los scripts inicializan la estructura y los objetos desde cero; no restauran los respaldos de la Práctica 02. Las cuentas personales y sus contraseñas se administran de forma separada y segura; no se guardan secretos en este repositorio.

## Estado de evidencias

El PDF distingue las operaciones comprobadas de las que siguen pendientes. Antes de presentar, completa la autenticación y evidencia de las operaciones de `support`, confirma la importación de las 5,000 filas del CSV y agrega evidencia real de la rama, commits y fusión. No declares esos puntos como concluidos hasta contar con sus resultados.

## Control de versiones

Sube los archivos de esta carpeta a la rama `Manual_VPS_BDs_Relacionales`. Revisa que `.env` no esté incluido, registra los commits de los entregables y, cuando corresponda, fusiona la rama con `main` o `master` sin conflictos pendientes.