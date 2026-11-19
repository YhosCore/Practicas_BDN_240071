# Práctica 04: Procesos de simulación de compra

## Propósito

Simular el ciclo de compra de la tienda en línea en `db_test`, usando usuarios y productos existentes, métodos de pago simulados y las cuentas de conexión con sus roles. Las operaciones de creación, actualización y eliminación generan evidencia en `tb_logs`; las consultas de lectura no se registran.

## Casos realizados

1. **Compra exitosa:** registro de usuario, carrito con cinco productos, domicilio, pago con débito y entrega confirmada.
2. **Último pago rechazado y reclamación:** compra de diez productos a meses; cinco pagos autorizados y el último rechazado por límite de crédito. Se registra el reclamo por daño y el reenvío.
3. **Cancelación parcial y reembolso:** compra de tres productos de una categoría; se cancela una línea, se ajusta el pedido y se procesa el reembolso parcial antes de la entrega.
4. **Mismo proveedor y punto de recolección:** compra de tres productos de un proveedor, pagada por SPEI; tras un intento de entrega fallido, se recoge en un punto de entrega.
5. **Falta de inventario:** se solicitan cuatro unidades cuando solo hay dos disponibles. Se cancela la orden, no se realiza el cargo y el cupón queda activo para reutilizarse.

## Resultados esperados

- Las órdenes, partidas, pagos, direcciones, envíos, cancelaciones y reembolsos mantienen sus relaciones y estados correspondientes.
- Los cambios de inventario solo ocurren cuando corresponde; el caso 5 conserva el stock disponible.
- Los cambios CRUD del flujo de compra aparecen en `tb_logs` con la cuenta de base de datos que los ejecutó.
- El caso 5 termina con la orden y el pago cancelados, y el cupón `GIFT-C5-2026-3002-84K7` activo.

## Respaldo

El estado acumulado de los casos 1 a 5 está en [`backups/07_11__p03.sql`](backups/07_11__p03.sql). Se conserva el nombre histórico del archivo y no se agregan archivos independientes de consultas para los casos.
