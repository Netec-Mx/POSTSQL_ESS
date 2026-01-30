
---
**REQUERIMIENTOS DEL NEGOCIO**
**BASE DE DATOS – TIENDA DE BARRIO “EL RINCONCITO”**
---

**Autor:** Blanca Leticia Escamilla Islas

**Fecha:** 27 Enero 2021

**Versión:** 1.0

---

## 1. CONTEXTO DEL NEGOCIO

La tienda de barrio **“El Rinconcito”** es un establecimiento de venta minorista que comercializa productos de consumo diario como alimentos, bebidas y artículos de limpieza.
El negocio requiere un sistema de base de datos que permita **gestionar productos, inventario, clientes, ventas y proveedores**, asegurando integridad de la información y soporte para consultas operativas y de análisis.

La base de datos será utilizada como soporte para:

* Registro de operaciones diarias
* Control de inventario
* Seguimiento de clientes frecuentes
* Análisis de ventas y proveedores

---

## 2. ALCANCE DEL SISTEMA

El sistema de base de datos cubrirá:

* Gestión del catálogo de productos
* Organización de productos por categorías
* Control de inventario disponible
* Registro de clientes frecuentes
* Registro histórico de ventas
* Detalle de productos vendidos en cada venta
* Gestión de proveedores
* Relación entre productos y proveedores con precios de compra

Quedan fuera del alcance:

* Facturación electrónica
* Control de empleados
* Múltiples sucursales
* Gestión contable avanzada

---

## 3. REQUERIMIENTOS FUNCIONALES

### RF1. Gestión de productos

El sistema debe permitir registrar y consultar productos con información detallada como nombre, descripción, precio de venta, código de barras y estado (activo/inactivo).

### RF2. Organización por categorías

El sistema debe permitir clasificar los productos en categorías para facilitar su organización y consulta.

### RF3. Control de inventario

El sistema debe mantener el stock actual de cada producto y permitir identificar productos con inventario bajo.

### RF4. Registro de clientes frecuentes

El sistema debe permitir registrar clientes frecuentes con sus datos básicos: nombre, teléfono, correo electrónico y dirección.

### RF5. Registro de ventas con múltiples productos

El sistema debe permitir registrar ventas que incluyan uno o más productos, indicando cantidad y precio unitario de cada uno.

### RF6. Historial de ventas

El sistema debe conservar el historial completo de ventas, incluyendo fecha, cliente (si aplica), subtotal, impuestos y total.

### RF7. Gestión de proveedores

El sistema debe permitir registrar proveedores con su información de contacto y estado.

### RF8. Relación productos–proveedores

El sistema debe permitir asociar productos con uno o varios proveedores, registrando el precio de compra y condiciones de suministro.

---

## 4. PREGUNTAS DE NEGOCIO QUE LA BASE DE DATOS DEBE RESPONDER

1. ¿Qué productos tenemos actualmente en stock y cuál es su cantidad disponible?
2. ¿Cuáles fueron las ventas realizadas en un período específico (día, mes o rango de fechas)?
3. ¿Qué productos ha comprado un cliente frecuente determinado?
4. ¿Quién es el proveedor o proveedores de un producto específico?
5. ¿Cuál es el total de ventas por categoría de producto?
6. ¿Qué productos están por debajo del stock mínimo?
7. ¿Cuáles son los productos más vendidos?
8. ¿Cuánto se ha vendido por método de pago?

---

## 5. FLUJO GENERAL DE OPERACIÓN DE LA TIENDA

1. Se registran las **categorías** de productos.
2. Se registran los **productos**, asignándolos a una categoría y definiendo su stock inicial.
3. Se registran los **proveedores** y se relacionan con los productos que suministran.
4. Se registran los **clientes frecuentes** (opcional).
5. Se procesan **ventas**, que pueden:

   * Estar asociadas a un cliente o ser anónimas.
   * Incluir múltiples productos con diferentes cantidades.
6. Al registrarse una venta:

   * Se guarda el detalle de los productos vendidos.
   * Se conserva el precio histórico de venta.
   * Se actualiza el inventario.
7. La información queda disponible para consultas y reportes posteriores.

---

## 6. CRITERIOS DE ÉXITO DEL ANÁLISIS

* Se han identificado **al menos 8 requerimientos funcionales**.
* Se han documentado **más de 5 preguntas de negocio**.
* El flujo de operación del negocio es claro y coherente.
* La información es suficiente para continuar con:

  * Identificación de entidades
  * Diseño del modelo ER
  * Normalización hasta 3FN

---

## 7. CONCLUSIÓN

Este documento define de manera clara los requerimientos funcionales y las necesidades de información de la tienda de barrio “El Rinconcito”.
Sirve como base para el **diseño conceptual y lógico de la base de datos**, garantizando que el modelo final soporte correctamente las operaciones del negocio y las consultas requeridas.


