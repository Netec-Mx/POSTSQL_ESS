# Práctica 2.1 Diseño de una base de datos relacional para una tienda de barrio o conveniencia

<br/><br/>

## Duración aproximada
**90 minutos**

<br/><br/>

## Objetivos de Aprendizaje

Al completar este laboratorio, serás capaz de:
- Identificar entidades, atributos y relaciones para el dominio de una tienda de barrio
- Aplicar los pasos formales del diseño de bases de datos relacionales
- Determinar tipos de relaciones (1:1, 1:N, N:M) entre entidades identificadas
- Aplicar normalización hasta **Tercera Forma Normal (3FN)** en el diseño
- Crear un diagrama **Entidad–Relación (ER)** completo con notación estándar
- Definir **claves primarias**, **claves foráneas** y atributos con tipos de datos apropiados

<br/><br/>

## Prerrequisitos

### Conocimientos Requeridos
- Comprensión de conceptos de bases de datos relacionales (tablas, filas, columnas)
- Conocimiento de entidades, atributos y relaciones
- Familiaridad con diagramas ER básicos y notación estándar
- Entendimiento de claves primarias y foráneas
- Conceptos básicos de normalización de bases de datos

<br/><br/>

### Acceso Requerido
- Acceso a una herramienta de diagramación  
  (draw.io, Lucidchart, dbdiagram.io) o papel y lápiz
- Navegador web moderno para herramientas online
- Entorno de laboratorio


<br/><br/>

### Requisitos de Hardware

| Componente             | Especificación                               |
|------------------------|----------------------------------------------|
| Pantalla               | Resolución mínima 1280x720                   |
| Memoria RAM            | Mínimo 2 GB disponibles                     |
| Conexión a internet    | Opcional (para herramientas online)         |

<br/><br/>

### Requisitos de Software

| Software                     | Versión                              | Propósito                                   |
|------------------------------|--------------------------------------|---------------------------------------------|
| draw.io (diagrams.net)       | Web o Desktop                        | Herramienta de diagramación gratuita        |
| Lucidchart                   | Web                                  | Alternativa de diagramación (cuenta gratuita) |
| dbdiagram.io                 | Web                                  | Herramienta especializada en diagramas de BD |
| Navegador web                | Chrome 90+, Firefox 88+, Edge 90+    | Acceso a herramientas online                |
| Editor de texto              | Notepad++, VS Code o similar         | Documentar decisione


<br/><br/>

### Configuración Inicial

#### Para usar draw.io (recomendado):

1. Accede a https://app.diagrams.net/
2. Selecciona **"Create New Diagram"**
3. Elige **"Entity Relation"** como plantilla
4. Nombra tu diagrama: `TiendaBarrio_ER_[TuNombre]`


#### Alternativa offline:
- Prepara hojas de papel cuadriculado o blancas
- Lápiz, borrador y regla
- Utiliza notación estándar **Crow’s Foot** o **Chen**

<br/><br/>


## Instrucciones

<br/><br/>

### Paso 1. Análisis de Requerimientos del Negocio

Comprender el **dominio del negocio** y documentar los **requerimientos funcionales** de la tienda de barrio.


1. **Lee y analiza el siguiente escenario de negocio:**

    **Escenario de la Tienda de Barrio "El Rinconcito":**
    - La tienda vende productos de consumo diario (alimentos, bebidas, artículos de limpieza, etc.)
    - Cada producto pertenece a una categoría específica
    - La tienda maneja un inventario de productos con stock actual
    - Se registran clientes frecuentes con sus datos básicos (nombre, teléfono, dirección)
    - Se realizan ventas diarias que incluyen múltiples productos
    - Cada venta debe registrar: fecha, cliente (si está registrado), total, productos vendidos y cantidades
    - La tienda trabaja con varios proveedores que suministran diferentes productos
    - Se necesita saber qué proveedor suministra cada producto y a qué precio


<br/><br/>

2. **Documenta en tu editor de texto los requerimientos identificados:**

    ### Requerimientos Funcionales – Tienda El Rinconcito
    - **RF1:** Gestionar catálogo de productos con información detallada
    - **RF2:** Organizar productos por categorías
    - **RF3:** Controlar inventario de productos (stock disponible)
    - **RF4:** Registrar información de clientes frecuentes
    - **RF5:** Procesar ventas con múltiples productos
    - **RF6:** Mantener registro histórico de ventas
    - **RF7:** Gestionar información de proveedores
    - **RF8:** Relacionar productos con sus proveedores y precios de compra

<br/><br/>

3. **Identifica las preguntas clave que la base de datos debe responder:**
    - ¿Qué productos tenemos en stock?
    - ¿Cuáles son las ventas de un período específico?
    - ¿Qué productos compra un cliente frecuente?
    - ¿Quién es el proveedor de un producto específico?
    - ¿Cuál es el total de ventas por categoría?



#### Resultado Esperado:
    Documento de texto con requerimientos funcionales claramente identificados y preguntas de negocio documentadas.


#### Verificación:
- [ ] Has identificado al menos **8 requerimientos funcionales**
- [ ] Has documentado al menos **5 preguntas de negocio**
- [ ] Comprendes el **flujo de operación** de la tienda

<br/><br/>


### Paso 2. Identificación de Entidades Principales

Identificar las **entidades principales** del sistema basándose en los requerimientos analizados.

1. **Basándote en los requerimientos, identifica las entidades principales (sustantivos importantes):**


    #### ENTIDADES IDENTIFICADAS

    1. **PRODUCTO**
        - **Representa:** Artículos que se venden en la tienda
        - **Justificación:** RF1, RF2, RF3

    2. **CATEGORIA**
        - **Representa:** Clasificación de productos
        - **Justificación:** RF2

    3. **CLIENTE**
        - **Representa:** Personas que compran en la tienda
        - **Justificación:** RF4

    4. **VENTA**
        - **Representa:** Transacción de compra
        - **Justificación:** RF5, RF6

    5. **DETALLE_VENTA**
        - **Representa:** Línea individual de productos en una venta
        - **Justificación:** RF5 (relación **N:M** entre `VENTA` y `PRODUCTO`)

    6. **PROVEEDOR**
        - **Representa:** Empresas que suministran productos
        - **Justificación:** RF7

    7. **PRODUCTO_PROVEEDOR**
        - **Representa:** Relación entre productos y proveedores con precio
        - **Justificación:** RF8 (relación **N:M** entre `PRODUCTO` y `PROVEEDOR`)

<br/><br/>

2. **Abre tu herramienta de diagramación** (draw.io).

3. **Crea un rectángulo** para cada entidad identificada.

4. **Nombra cada rectángulo** con el nombre de la entidad en **MAYÚSCULAS**.



#### Resultado Esperado:

    Diagrama con 7 rectángulos representando las entidades: PRODUCTO, CATEGORIA, CLIENTE, VENTA, DETALLE_VENTA, PROVEEDOR, PRODUCTO_PROVEEDOR.

#### Verificación:
- [ ] Has identificado al menos **7 entidades**
- [ ] Cada entidad tiene un **propósito claro y justificación**
- [ ] Has incluido **entidades intermedias** para relaciones **N:M**
- [ ] Las entidades están **representadas gráficamente** en tu diagrama


<br/><br/>


### Paso 3. Definición de Atributos para Cada Entidad

Definir los **atributos (columnas)** de cada entidad con sus **tipos de datos apropiados**.

1. Para cada entidad, define sus atributos siguiendo este formato:

    ---

    #### ENTIDAD: CATEGORIA
    **Atributos:**
    - `categoria_id` (`INTEGER`) **[PK]** – Identificador único
    - `nombre` (`VARCHAR(100)`) – Nombre de la categoría
    - `descripcion` (`TEXT`) – Descripción detallada

    ---

    #### ENTIDAD: PRODUCTO
    **Atributos:**
    - `producto_id` (`INTEGER`) **[PK]** – Identificador único
    - `nombre` (`VARCHAR(200)`) – Nombre del producto
    - `descripcion` (`TEXT`) – Descripción del producto
    - `precio_venta` (`DECIMAL(10,2)`) – Precio de venta al público
    - `codigo_barras` (`VARCHAR(50)`) – Código de barras único
    - `stock_actual` (`INTEGER`) – Cantidad en inventario
    - `stock_minimo` (`INTEGER`) – Nivel mínimo de reorden
    - `categoria_id` (`INTEGER`) **[FK]** – Referencia a `CATEGORIA`
    - `fecha_registro` (`TIMESTAMP`) – Fecha de alta del producto
    - `activo` (`BOOLEAN`) – Indica si el producto está activo

    ---

    #### ENTIDAD: CLIENTE
    **Atributos:**
    - `cliente_id` (`INTEGER`) **[PK]** – Identificador único
    - `nombre` (`VARCHAR(100)`) – Nombre completo
    - `telefono` (`VARCHAR(20)`) – Teléfono de contacto
    - `email` (`VARCHAR(100)`) – Correo electrónico
    - `direccion` (`VARCHAR(255)`) – Dirección física
    - `fecha_registro` (`TIMESTAMP`) – Fecha de registro como cliente
    - `activo` (`BOOLEAN`) – Indica si el cliente está activo

    ---

    #### ENTIDAD: VENTA
    **Atributos:**
    - `venta_id` (`INTEGER`) **[PK]** – Identificador único
    - `fecha_venta` (`TIMESTAMP`) – Fecha y hora de la venta
    - `cliente_id` (`INTEGER`) **[FK]** – Referencia a `CLIENTE` (NULL si es venta anónima)
    - `subtotal` (`DECIMAL(10,2)`) – Suma de productos
    - `impuesto` (`DECIMAL(10,2)`) – Impuestos aplicados
    - `total` (`DECIMAL(10,2)`) – Total de la venta
    - `metodo_pago` (`VARCHAR(50)`) – Efectivo, tarjeta, transferencia

    ---

    #### ENTIDAD: DETALLE_VENTA
    **Atributos:**
    - `detalle_venta_id` (`INTEGER`) **[PK]** – Identificador único
    - `venta_id` (`INTEGER`) **[FK]** – Referencia a `VENTA`
    - `producto_id` (`INTEGER`) **[FK]** – Referencia a `PRODUCTO`
    - `cantidad` (`INTEGER`) – Cantidad vendida
    - `precio_unitario` (`DECIMAL(10,2)`) – Precio al momento de la venta
    - `subtotal` (`DECIMAL(10,2)`) – `cantidad × precio_unitario`

    ---

    #### ENTIDAD: PROVEEDOR
    **Atributos:**
    - `proveedor_id` (`INTEGER`) **[PK]** – Identificador único
    - `nombre_empresa` (`VARCHAR(200)`) – Razón social
    - `contacto_nombre` (`VARCHAR(100)`) – Nombre del contacto
    - `contacto_telefono` (`VARCHAR(20)`) – Teléfono del contacto
    - `contacto_email` (`VARCHAR(100)`) – Email del contacto
    - `direccion` (`VARCHAR(255)`) – Dirección del proveedor
    - `activo` (`BOOLEAN`) – Indica si el proveedor está activo

    ---

    #### ENTIDAD: PRODUCTO_PROVEEDOR
    **Atributos:**
    - `producto_proveedor_id` (`INTEGER`) **[PK]** – Identificador único
    - `producto_id` (`INTEGER`) **[FK]** – Referencia a `PRODUCTO`
    - `proveedor_id` (`INTEGER`) **[FK]** – Referencia a `PROVEEDOR`
    - `precio_compra` (`DECIMAL(10,2)`) – Precio de compra al proveedor
    - `tiempo_entrega_dias` (`INTEGER`) – Días de entrega
    - `es_proveedor_principal` (`BOOLEAN`) – Indica proveedor preferido

    ---


2. En tu diagrama
    - Agrega los atributos dentro de cada **rectángulo de entidad**
    - Marca las **claves primarias (PK)** con un símbolo especial o subrayado
    - Marca las **claves foráneas (FK)** con un indicador visual


#### Resultado Esperado:
    Diagrama con todas las entidades mostrando sus atributos completos, con claves primarias y foráneas claramente identificadas.


#### Verificación:
- [ ] Cada entidad tiene al menos una **clave primaria**
- [ ] Los **tipos de datos** son apropiados para cada atributo
- [ ] Las **claves foráneas** están correctamente identificadas
- [ ] Has incluido **atributos de auditoría** (`fecha_registro`, `activo`)
- [ ] Los nombres de atributos siguen la convención **snake_case**

<br/><br/>

## Paso 4. Establecimiento de Relaciones entre Entidades

Definir las relaciones entre entidades y determinar su cardinalidad (1:1, 1:N, N:M).

1.	Identifica y documenta las relaciones:

```txt
   RELACIONES IDENTIFICADAS:

   R1: CATEGORIA ──< PRODUCTO
      Tipo: 1:N (Uno a Muchos).
      Descripción: Una categoría contiene muchos productos.
      Cardinalidad: Una categoría puede tener 0 o más productos.
                    Un producto pertenece a exactamente 1 categoría.
      Implementación: FK categoria_id en PRODUCTO.

   R2: CLIENTE ──< VENTA
      Tipo: 1:N (Uno a Muchos).
      Descripción: Un cliente puede realizar muchas ventas.
      Cardinalidad: Un cliente puede tener 0 o más ventas.
                    Una venta pertenece a 0 o 1 cliente (NULL = anónima).
      Implementación: FK cliente_id en VENTA (NULLABLE).

   R3: VENTA ──< DETALLE_VENTA
      Tipo: 1:N (Uno a Muchos).
      Descripción: Una venta contiene múltiples detalles.
      Cardinalidad: Una venta tiene 1 o más detalles.
                    Un detalle pertenece a exactamente 1 venta.
      Implementación: FK venta_id en DETALLE_VENTA.

   R4: PRODUCTO ──< DETALLE_VENTA
      Tipo: 1:N (Uno a Muchos).
      Descripción: Un producto puede aparecer en muchos detalles de venta.
      Cardinalidad: Un producto puede estar en 0 o más detalles.
                    Un detalle referencia exactamente 1 producto.
      Implementación: FK producto_id en DETALLE_VENTA.

   R5: PRODUCTO >──< PROVEEDOR (a través de PRODUCTO_PROVEEDOR)
      Tipo: N:M (Muchos a Muchos).
      Descripción: Un producto puede ser suministrado por varios proveedores.
                   Un proveedor puede suministrar varios productos.
      Cardinalidad: Un producto puede tener 1 o más proveedores.
                    Un proveedor puede suministrar 1 o más productos.
      Implementación: Tabla intermedia PRODUCTO_PROVEEDOR con:
                      - FK producto_id
                      - FK proveedor_id
                      - Atributos adicionales: precio_compra, tiempo_entrega_dias
```

2.	En tu diagrama, dibuja líneas conectando las entidades relacionadas.

3.	Usa notación Crow's Foot para indicar cardinalidad:
    - Línea simple (|) = Uno
    - Pata de gallo (< o >) = Muchos
    - Círculo (o) = Opcional (0)
    - Línea perpendicular (|) = Obligatorio (1)

4.	Ejemplos de notación:

```txt
   CATEGORIA |──< PRODUCTO
   (Una categoría tiene muchos productos)

   CLIENTE |o──< VENTA
   (Un cliente puede tener cero o muchas ventas)

   PRODUCTO >──< PROVEEDOR
   (Muchos a muchos a través de tabla intermedia)
```

#### Resultado Esperado:
Diagrama completo con todas las entidades conectadas mediante líneas que muestran las relaciones y su cardinalidad usando notación estándar.


#### Verificación:
- [ ] Todas las relaciones están representadas gráficamente
- [ ] La cardinalidad está correctamente indicada (1:1, 1:N, N:M)
- [ ] Las relaciones N:M usan tablas intermedias
- [ ] Las líneas de relación conectan las claves primarias con las foráneas
- [ ] Has documentado la descripción de cada relación


<br/><br/>

## Paso 5: Aplicación de Primera Forma Normal (1FN)

Verificar y aplicar la **Primera Forma Normal (1FN)** para eliminar grupos repetitivos y asegurar la atomicidad de los datos.

1. **Revisa cada entidad para verificar el cumplimiento de 1FN:**

**Reglas de 1FN:**
- Cada columna debe contener **valores atómicos** (indivisibles)
- No debe haber **grupos repetitivos**
- Cada columna debe contener valores de **un solo tipo**
- Cada columna debe tener un **nombre único**
- El **orden de las filas** no debe importar


2.	Analiza posibles violaciones:
```txt
   ANÁLISIS DE 1FN:

   ENTIDAD: CLIENTE
   ❌ Problema potencial: Atributo "nombre" podría contener nombre y apellido
   ✅ Solución: Dividir en nombre y apellido (opcional para tienda de barrio)
   ✅ Decisión: Mantener "nombre" completo por simplicidad del negocio

   ENTIDAD: PRODUCTO
   ✅ Todos los atributos son atómicos
   ✅ No hay grupos repetitivos
   ✅ stock_actual es un valor único, no múltiples ubicaciones

   ENTIDAD: VENTA
   ❌ Problema potencial: Si tuviéramos "productos" como lista en VENTA
   ✅ Solución aplicada: Tabla DETALLE_VENTA separa cada producto
   ✅ Cumple 1FN: Cada venta se relaciona con productos mediante tabla intermedia

   ENTIDAD: DETALLE_VENTA
   ✅ Cada detalle representa un solo producto en una venta
   ✅ Atributos atómicos: cantidad, precio_unitario, subtotal
   ✅ Cumple 1FN completamente

   ENTIDAD: PROVEEDOR
   ✅ Datos de contacto son atómicos
   ✅ Un solo contacto por proveedor

   ENTIDAD: PRODUCTO_PROVEEDOR
   ✅ Representa una relación única producto-proveedor
   ✅ Atributos atómicos
```

3.	Documenta las decisiones de diseño:

```txt
   DECISIONES DE NORMALIZACIÓN 1FN:

   1. CLIENTE.nombre: Se mantiene como campo único (no dividir en nombre/apellido)
      Justificación: Simplicidad para tienda de barrio, no se requiere ordenamiento formal

   2. DETALLE_VENTA: Tabla creada específicamente para cumplir 1FN
      Justificación: Evita almacenar múltiples productos en un solo registro de venta

   3. PRODUCTO_PROVEEDOR: Tabla intermedia con atributos propios
      Justificación: Permite múltiples proveedores por producto sin repetición

   4. Todos los campos de fecha usan TIMESTAMP (atómico)
      Justificación: No se divide fecha y hora en campos separados
```

#### Resultado Esperado:
Documentación que confirma que todas las entidades cumplen con 1FN, con justificaciones de diseño documentadas.

#### Verificación:
- [ ] No existen atributos multivaluados
- [ ] No hay grupos repetitivos en ninguna entidad
- [ ] Todos los atributos contienen valores atómicos
- [ ] Has documentado decisiones de diseño relacionadas con **1FN**


<br/><br/>

## Paso 6. Aplicación de Segunda Forma Normal (2FN)
Verificar y aplicar la Segunda Forma Normal para eliminar dependencias parciales de claves primarias compuestas.

1.	Identifica entidades con claves primarias compuestas:

```txt
   ANÁLISIS DE 2FN:

   Regla de 2FN: Debe cumplir 1FN Y todos los atributos no-clave deben depender
                 completamente de la clave primaria (no dependencias parciales)

   ENTIDADES CON CLAVE SIMPLE (Cumplen 2FN automáticamente):
   - CATEGORIA (PK: categoria_id)
   - PRODUCTO (PK: producto_id)
   - CLIENTE (PK: cliente_id)
   - VENTA (PK: venta_id)
   - PROVEEDOR (PK: proveedor_id)

   ENTIDADES CON POTENCIAL CLAVE COMPUESTA:

   DETALLE_VENTA:
   ✅ Diseño actual: PK simple (detalle_venta_id)
   🔍 Alternativa: PK compuesta (venta_id, producto_id)

   Análisis con PK compuesta (venta_id, producto_id):
   - cantidad → depende de (venta_id, producto_id) ✅
   - precio_unitario → depende de (venta_id, producto_id) ✅
   - subtotal → depende de (venta_id, producto_id) ✅

   ✅ Cumple 2FN: No hay dependencias parciales
   ✅ Decisión: Mantener PK simple por flexibilidad

   PRODUCTO_PROVEEDOR:
   ✅ Diseño actual: PK simple (producto_proveedor_id)
   🔍 Alternativa: PK compuesta (producto_id, proveedor_id)

   Análisis con PK compuesta (producto_id, proveedor_id):
   - precio_compra → depende de (producto_id, proveedor_id) ✅
   - tiempo_entrega_dias → depende de (producto_id, proveedor_id) ✅
   - es_proveedor_principal → depende de (producto_id, proveedor_id) ✅

   ✅ Cumple 2FN: No hay dependencias parciales
   ✅ Decisión: Mantener PK simple por flexibilidad
```

2.	Verifica dependencias funcionales:

```txt
   VERIFICACIÓN DE DEPENDENCIAS FUNCIONALES:

   PRODUCTO:
   producto_id → nombre, descripcion, precio_venta, codigo_barras,
                 stock_actual, stock_minimo, categoria_id, fecha_registro, activo
   ✅ Todos los atributos dependen completamente de producto_id

   VENTA:
   venta_id → fecha_venta, cliente_id, subtotal, impuesto, total, metodo_pago
   ✅ Todos los atributos dependen completamente de venta_id

   DETALLE_VENTA:
   detalle_venta_id → venta_id, producto_id, cantidad, precio_unitario, subtotal
   ✅ Todos los atributos dependen completamente de detalle_venta_id

   ❌ Nota: precio_unitario podría obtenerse de PRODUCTO, pero se almacena
            para mantener histórico (el precio puede cambiar con el tiempo)
   ✅ Justificación: Es correcto almacenar precio_unitario en DETALLE_VENTA
```

3.	Documenta el cumplimiento de 2FN:

```txt
   CUMPLIMIENTO DE 2FN - RESUMEN:

   ✅ Todas las entidades utilizan claves primarias simples (surrogate keys)
   ✅ No existen dependencias parciales en ninguna entidad
   ✅ Decisión de diseño: Usar INTEGER autoincrementable como PK
      Ventajas:
      - Simplifica relaciones
      - Mejor performance en índices
      - Facilita migraciones y replicación
      - Evita problemas de dependencias parciales

   ✅ El diseño actual cumple completamente con 2FN
```

#### Resultado Esperado:
Documentación que confirma cumplimiento de 2FN en todas las entidades, con análisis de dependencias funcionales.

#### Verificación:
- [ ] Has identificado todas las **claves primarias**
- [ ] Has verificado **dependencias funcionales completas**
- [ ] No existen **dependencias parciales**
- [ ] Has justificado el uso de **claves primarias simples vs. compuestas**
- [ ] El diseño cumple con **Segunda Forma Normal (2FN)**


<br/><br/>

## Paso 7. Aplicación de Tercera Forma Normal (3FN)
Verificar y aplicar la Tercera Forma Normal para eliminar dependencias transitivas.

1.	Analiza dependencias transitivas en cada entidad:

```txt
   ANÁLISIS DE 3FN:

   Regla de 3FN: Debe cumplir 2FN Y no debe haber dependencias transitivas
                 (atributos no-clave que dependan de otros atributos no-clave)

   ENTIDAD: PRODUCTO
   Dependencias:
   - producto_id → categoria_id
   - categoria_id → nombre_categoria, descripcion_categoria

   ✅ CORRECTO: nombre_categoria NO está en PRODUCTO
   ✅ La relación se maneja mediante FK a tabla CATEGORIA separada
   ✅ Cumple 3FN: No hay dependencias transitivas

   ENTIDAD: VENTA
   Análisis de atributos calculados:
   - subtotal, impuesto, total

   🔍 Pregunta: ¿Es "total" dependiente transitivamente?
   - venta_id → subtotal, impuesto
   - subtotal, impuesto → total (total = subtotal + impuesto)

   ❌ Técnicamente es dependencia transitiva
   ✅ DECISIÓN: Mantener "total" por razones de negocio
      Justificación:
      - Histórico: Los cálculos pueden cambiar con el tiempo
      - Performance: Evita recalcular en cada consulta
      - Auditoría: Valor exacto al momento de la venta
      - Integridad: Valor confirmado por el sistema

   ⚠️ Nota: Esta es una excepción justificada por requisitos de negocio

   ENTIDAD: DETALLE_VENTA
   Análisis:
   - detalle_venta_id → cantidad, precio_unitario
   - cantidad, precio_unitario → subtotal

   ✅ DECISIÓN: Mantener "subtotal" (similar justificación que VENTA.total)

   ENTIDAD: CLIENTE
   Dependencias:
   - cliente_id → direccion
   - direccion → ¿ciudad, estado, código_postal?

   ✅ DECISIÓN: Mantener "direccion" como campo único
      Justificación:
      - Tienda de barrio: No requiere análisis geográfico complejo
      - Simplicidad: Evita sobrenormalización
      - Si se requiriera análisis geográfico, se crearía tabla DIRECCION

   ENTIDAD: PROVEEDOR
   Similar a CLIENTE:
   ✅ "direccion" como campo único es aceptable para este contexto
```

<br/><br/>

2.	Identifica y resuelve dependencias transitivas:
```txt
   RESOLUCIÓN DE DEPENDENCIAS TRANSITIVAS:

   CASO 1: Categorías de Productos
   ✅ YA RESUELTO: Tabla CATEGORIA separada

   Antes (hipotético - violación 3FN):
   PRODUCTO (producto_id, nombre, categoria_nombre, categoria_descripcion)
   producto_id → categoria_nombre → categoria_descripcion

   Después (diseño actual - cumple 3FN):
   PRODUCTO (producto_id, nombre, categoria_id)
   CATEGORIA (categoria_id, nombre, descripcion)

   CASO 2: Información de Proveedor en Productos
   ✅ YA RESUELTO: Tabla PRODUCTO_PROVEEDOR

   Antes (hipotético - violación 3FN):
   PRODUCTO (producto_id, proveedor_nombre, proveedor_telefono)
   producto_id → proveedor_id → proveedor_nombre, proveedor_telefono

   Después (diseño actual - cumple 3FN):
   PRODUCTO (producto_id, nombre, ...)
   PRODUCTO_PROVEEDOR (producto_id, proveedor_id, precio_compra)
   PROVEEDOR (proveedor_id, nombre_empresa, contacto_telefono)

   CASO 3: Atributos Calculados (Excepción justificada)
   ⚠️ EXCEPCIÓN ACEPTADA:
   - VENTA.total (calculado de subtotal + impuesto)
   - DETALLE_VENTA.subtotal (calculado de cantidad * precio_unitario)

   Justificación documentada en análisis anterior
```

<br/><br/>

3.	Documenta el estado final de normalización:
```txt
   ESTADO FINAL DE NORMALIZACIÓN:

   ✅ PRIMERA FORMA NORMAL (1FN):
   - Todos los atributos son atómicos
   - No hay grupos repetitivos
   - Cada intersección fila-columna contiene un solo valor

   ✅ SEGUNDA FORMA NORMAL (2FN):
   - Cumple 1FN
   - No hay dependencias parciales
   - Todos los atributos no-clave dependen de la clave primaria completa

   ✅ TERCERA FORMA NORMAL (3FN):
   - Cumple 2FN
   - No hay dependencias transitivas (excepto atributos calculados justificados)
   - Todas las dependencias funcionales son directas a la clave primaria

   EXCEPCIONES DOCUMENTADAS:
   1. VENTA.total - Atributo calculado mantenido por razones de auditoría
   2. DETALLE_VENTA.subtotal - Atributo calculado mantenido por razones históricas
   3. Campos de dirección no normalizados - Simplicidad del negocio

   ✅ El diseño está normalizado hasta 3FN con excepciones justificadas
```


#### Resultado Esperado:
Documentación completa del análisis de 3FN con todas las dependencias transitivas identificadas y resueltas o justificadas.


#### Verificación:
- [ ] Has identificado todas las dependencias transitivas
- [ ] Has resuelto o justificado cada dependencia transitiva
- [ ] El diseño cumple con **3FN** (con excepciones documentadas)
- [ ] Has documentado las razones para mantener atributos calculados
- [ ] Comprendes la diferencia entre normalización teórica y práctica


<br/><br/>

## Paso 8. Creación del Diagrama Entidad-Relación Final

Crear un **diagrama ER completo, profesional y correctamente notado** que represente el diseño final normalizado.

1. **En tu herramienta de diagramación (draw.io), crea el diagrama final con los siguientes elementos:**

### Elementos del diagrama

**Entidades (rectángulos):**
- `CATEGORIA`
- `PRODUCTO`
- `CLIENTE`
- `VENTA`
- `DETALLE_VENTA`
- `PROVEEDOR`
- `PRODUCTO_PROVEEDOR`

**Atributos dentro de cada entidad:**
- Marca la **clave primaria (PK)** con símbolo o en **negrita**
- Indica claramente las **claves foráneas (FK)**
- Incluye el **tipo de dato** entre paréntesis

<br/><br/>


2. **Dibuja las relaciones con notación Crow’s Foot:**

    **RELACIONES A DIBUJAR**

    1. **CATEGORIA |──< PRODUCTO**
    - Línea desde `CATEGORIA.categoria_id`
    - Hasta `PRODUCTO.categoria_id`
    - Lado **CATEGORIA**: línea simple (`|`) = uno
    - Lado **PRODUCTO**: pata de gallo (`<`) = muchos

    2. **CLIENTE |o──< VENTA**
    - Línea desde `CLIENTE.cliente_id`
    - Hasta `VENTA.cliente_id`
    - Lado **CLIENTE**: línea simple (`|`) = uno
    - Lado **VENTA**: círculo + pata de gallo (`o<`) = cero o muchos

    3. **VENTA |──< DETALLE_VENTA**
    - Línea desde `VENTA.venta_id`
    - Hasta `DETALLE_VENTA.venta_id`
    - Lado **VENTA**: línea simple (`|`) = uno
    - Lado **DETALLE_VENTA**: pata de gallo (`<`) = muchos

    4. **PRODUCTO |──< DETALLE_VENTA**
    - Línea desde `PRODUCTO.producto_id`
    - Hasta `DETALLE_VENTA.producto_id`
    - Lado **PRODUCTO**: línea simple (`|`) = uno
    - Lado **DETALLE_VENTA**: pata de gallo (`<`) = muchos

    5. **PRODUCTO |──< PRODUCTO_PROVEEDOR**
    - Línea desde `PRODUCTO.producto_id`
    - Hasta `PRODUCTO_PROVEEDOR.producto_id`
    - Lado **PRODUCTO**: línea simple (`|`) = uno
    - Lado **PRODUCTO_PROVEEDOR**: pata de gallo (`<`) = muchos

    6. **PROVEEDOR |──< PRODUCTO_PROVEEDOR**
    - Línea desde `PROVEEDOR.proveedor_id`
    - Hasta `PRODUCTO_PROVEEDOR.proveedor_id`
    - Lado **PROVEEDOR**: línea simple (`|`) = uno
    - Lado **PRODUCTO_PROVEEDOR**: pata de gallo (`<`) = muchos


<br/><br/>

3. **Agrega elementos de documentación al diagrama:**
- **Título:** *"Base de Datos – Tienda de Barrio El Rinconcito"*
- **Autor y fecha:** Tu nombre y fecha
- **Leyenda de notación:**

```
LEYENDA:
PK = Clave Primaria
FK = Clave Foránea
|  = Uno (obligatorio)
o  = Cero (opcional)
<  = Muchos
```

- **Notas especiales:** Decisiones de diseño relevantes y justificaciones

<br/><br/>

4. **Organiza el diagrama visualmente:**
   - Entidades principales en el centro (`PRODUCTO`, `VENTA`)
   - Entidades relacionadas agrupadas lógicamente
   - Evita cruces innecesarios de líneas
   - Usa colores para agrupar áreas funcionales (opcional):
     - **Área de productos:** `CATEGORIA`, `PRODUCTO`
     - **Área de ventas:** `VENTA`, `DETALLE_VENTA`, `CLIENTE`
     - **Área de proveedores:** `PROVEEDOR`, `PRODUCTO_PROVEEDOR`

5. **Exporta el diagrama:**
   - Formato **PNG** o **PDF** para documentación
   - Nombre de archivo: `TiendaBarrio_ER_Diagrama_[TuNombre].png`
   - Resolución mínima **1920×1080** para claridad

<br/><br/>

#### Resultado Esperado:
Diagrama ER profesional y completo que muestra todas las entidades, atributos, relaciones y cardinalidades correctamente notadas.


#### Verificación:
- [ ] Todas las **7 entidades** están representadas.
- [ ] Todos los atributos están listados con sus **tipos de datos**.
- [ ] Las **claves primarias** están claramente marcadas.
- [ ] Las **claves foráneas** están identificadas.
- [ ] Todas las relaciones están dibujadas con **cardinalidad correcta**.
- [ ] El diagrama usa **notación estándar** (Crow’s Foot o Chen).
- [ ] El diagrama está **organizado y es fácil de leer**.
- [ ] Has incluido **título, nombre, fecha y leyenda**.
- [ ] El diagrama está **exportado en un formato apropiado**.


<br/><br/>

## Paso 9. Documentación de Decisiones de Diseño
Crear documentación complementaria que explique las decisiones de diseño y justifique el modelo propuesto.
 
1.	Crea un documento de texto con las siguientes secciones:

```txt
   ═══════════════════════════════════════════════════════════════
   DOCUMENTACIÓN DE DISEÑO - BASE DE DATOS TIENDA DE BARRIO
   ═══════════════════════════════════════════════════════════════

   Diseñador: [Tu Nombre]
   Fecha: [Fecha Actual]
   Versión: 1.0

   ═══════════════════════════════════════════════════════════════
   1. RESUMEN EJECUTIVO
   ═══════════════════════════════════════════════════════════════

   Este diseño de base de datos soporta las operaciones de una tienda de
   barrio típica, incluyendo gestión de productos, inventario, ventas,
   clientes y proveedores. El modelo está normalizado hasta 3FN con
   excepciones justificadas para atributos calculados que requieren
   persistencia por razones de auditoría y rendimiento.

   Entidades principales: 7
   Relaciones: 6
   Nivel de normalización: 3FN

   ═══════════════════════════════════════════════════════════════
   2. DECISIONES DE DISEÑO CLAVE
   ═══════════════════════════════════════════════════════════════

   2.1 USO DE CLAVES PRIMARIAS SURROGATE (INTEGER AUTO-INCREMENT)

   Decisión: Todas las tablas usan INTEGER auto-incrementable como PK

   Alternativa considerada: Claves primarias naturales o compuestas

   Justificación:
   - Simplifica relaciones entre tablas
   - Mejor rendimiento en índices y JOINs
   - Facilita migraciones y replicación de datos
   - Evita problemas cuando claves naturales cambian
   - Estándar en la industria para aplicaciones modernas

   Impacto: Todas las tablas tienen campo [tabla]_id como PK

   -------------------------------------------------------------------

   2.2 TABLA INTERMEDIA DETALLE_VENTA

   Decisión: Crear tabla DETALLE_VENTA para resolver relación N:M
            entre VENTA y PRODUCTO

   Alternativa considerada: Almacenar productos como array en VENTA

   Justificación:
   - Cumple con 1FN (elimina grupos repetitivos)
   - Permite múltiples productos por venta
   - Captura precio histórico al momento de venta
   - Facilita consultas y reportes de productos vendidos
   - Permite rastrear cantidad vendida por producto

   Atributos adicionales:
   - precio_unitario: Captura precio al momento de venta
   - subtotal: Calculado pero persistido para auditoría

   -------------------------------------------------------------------

   2.3 TABLA INTERMEDIA PRODUCTO_PROVEEDOR

   Decisión: Crear tabla PRODUCTO_PROVEEDOR para resolver relación N:M
            entre PRODUCTO y PROVEEDOR

   Alternativa considerada: FK simple proveedor_id en PRODUCTO

   Justificación:
   - Un producto puede tener múltiples proveedores (backup, mejores precios)
   - Un proveedor suministra múltiples productos
   - Permite almacenar precio_compra específico por proveedor
   - Facilita comparación de precios entre proveedores
   - Soporta información de tiempo_entrega_dias por proveedor
   - Campo es_proveedor_principal identifica proveedor preferido

   -------------------------------------------------------------------

   2.4 CLIENTE_ID NULLABLE EN VENTA

   Decisión: El campo cliente_id en VENTA acepta NULL

   Alternativa considerada: Crear cliente "Anónimo" por defecto

   Justificación:
   - Muchas ventas en tienda de barrio son anónimas (sin registro)
   - NULL es semánticamente correcto (ausencia de información)
   - Evita datos ficticios que contaminen estadísticas de clientes
   - Permite diferenciar ventas registradas vs anónimas en reportes

   Impacto: Las consultas deben manejar cliente_id NULL apropiadamente

   -------------------------------------------------------------------

   2.5 ATRIBUTOS CALCULADOS PERSISTIDOS

   Decisión: Mantener campos calculados (total, subtotal) en la BD

   Alternativa considerada: Calcular valores en tiempo de consulta

   Campos afectados:
   - VENTA.total (= subtotal + impuesto)
   - DETALLE_VENTA.subtotal (= cantidad * precio_unitario)

   Justificación:
   - Auditoría: Valor exacto confirmado al momento de la transacción
   - Histórico: Fórmulas de cálculo pueden cambiar con el tiempo
   - Rendimiento: Evita recalcular en cada consulta
   - Integridad: Valor validado por lógica de negocio
   - Reportes: Simplifica agregaciones y análisis

   Consideración: Requiere validación en capa de aplicación para
                  mantener consistencia

   -------------------------------------------------------------------

   2.6 CAMPOS DE AUDITORÍA Y CONTROL

   Decisión: Incluir campos fecha_registro y activo en entidades principales

   Campos implementados:
   - fecha_registro (TIMESTAMP): Fecha de creación del registro
   - activo (BOOLEAN): Soft delete en lugar de DELETE físico

   Justificación:
   - Trazabilidad: Saber cuándo se creó cada registro
   - Soft delete: Preservar integridad referencial e histórico
   - Reportes: Filtrar registros activos/inactivos
   - Auditoría: Cumplir con requisitos de trazabilidad

   Tablas con estos campos: PRODUCTO, CLIENTE, PROVEEDOR

   -------------------------------------------------------------------

   2.7 NORMALIZACIÓN DE DIRECCIONES

   Decisión: Mantener "direccion" como campo único (VARCHAR(255))

   Alternativa considerada: Normalizar en tabla DIRECCION con
                            (calle, ciudad, estado, codigo_postal)

   Justificación:
   - Simplicidad apropiada para tienda de barrio local
   - No se requieren búsquedas geográficas complejas
   - Evita sobrenormalización para este contexto
   - Reduce complejidad de consultas

   Consideración futura: Si se requiere análisis geográfico, crear
                        tabla DIRECCION normalizada


   ═══════════════════════════════════════════════════════════════
   3. RESTRICCIONES Y REGLAS DE NEGOCIO
   ═══════════════════════════════════════════════════════════════

   3.1 CONSTRAINTS DE INTEGRIDAD

   - Todas las PKs son NOT NULL, UNIQUE, AUTO_INCREMENT
   - Todas las FKs tienen ON DELETE RESTRICT por defecto (protección)
   - Campos de precio: DECIMAL(10,2) con CHECK (precio >= 0)
   - Campos de cantidad: INTEGER con CHECK (cantidad > 0)
   - codigo_barras en PRODUCTO debe ser UNIQUE
   - stock_actual debe ser >= 0

   3.2 REGLAS DE NEGOCIO IMPLEMENTADAS

   RN1: Un producto debe pertenecer a exactamente una categoría
        Implementación: PRODUCTO.categoria_id NOT NULL

   RN2: Una venta puede ser anónima o asociada a un cliente
        Implementación: VENTA.cliente_id NULL permitido

   RN3: Una venta debe tener al menos un detalle
        Implementación: Validación en capa de aplicación

   RN4: El precio de venta debe ser mayor que el precio de compra
        Implementación: Validación en capa de aplicación

   RN5: No se pueden vender productos con stock_actual = 0
        Implementación: Validación en capa de aplicación

   RN6: stock_actual debe actualizarse después de cada venta
        Implementación: Trigger o lógica de aplicación

   ═══════════════════════════════════════════════════════════════
   4. CONSULTAS TÍPICAS SOPORTADAS
   ═══════════════════════════════════════════════════════════════

   Q1: Productos con stock bajo (< stock_minimo)
   Q2: Ventas totales por período
   Q3: Productos más vendidos
   Q4: Historial de compras de un cliente
   Q5: Proveedores de un producto específico
   Q6: Productos por categoría
   Q7: Ventas totales por cliente
   Q8: Productos que necesitan reorden
   Q9: Comparación de precios entre proveedores
   Q10: Total de ventas por método de pago

   ═══════════════════════════════════════════════════════════════
   5. CONSIDERACIONES FUTURAS
   ═══════════════════════════════════════════════════════════════

   5.1 EXTENSIONES POSIBLES

   - Tabla EMPLEADO para registrar quién procesa cada venta
   - Tabla PROMOCION para descuentos y ofertas especiales
   - Tabla ORDEN_COMPRA para pedidos a proveedores
   - Tabla MOVIMIENTO_INVENTARIO para trazabilidad de stock
   - Tabla CATEGORIA_NIVEL2 para categorías jerárquicas
   - Tabla METODO_PAGO normalizada (actualmente VARCHAR)

   5.2 OPTIMIZACIONES FUTURAS

   - Índices en campos de búsqueda frecuente (codigo_barras, nombre)
   - Índices compuestos para consultas comunes
   - Particionamiento de tabla VENTA por fecha (si crece mucho)
   - Vistas materializadas para reportes complejos
   - Triggers para actualización automática de stock
   - Stored procedures para operaciones transaccionales complejas

   ═══════════════════════════════════════════════════════════════
```

2.	Guarda este documento como: "TiendaBarrio_Documentacion_Diseno_[TuNombre].txt"

#### Resultado Esperado:
Documento de texto completo que explica y justifica todas las decisiones de diseño tomadas durante el modelado.


#### Verificación:
- [ ] Has documentado todas las decisiones de diseño importantes.
- [ ] Has justificado alternativas consideradas.
- [ ] Has explicado las reglas de negocio implementadas.
- [ ] Has identificado consultas típicas que el diseño soporta.
- [ ] Has considerado extensiones y optimizaciones futuras.


<br/><br/>

## Paso 10. Revisión Final y Validación del Diseño

Realizar una revisión sistemática del diseño completo para asegurar **calidad, consistencia y completitud.**

1.	Utiliza la siguiente lista de verificación para revisar tu diseño:

#### 1. COMPLETITUD DE ENTIDADES
- [ ] Todas las entidades necesarias están identificadas
- [ ] Cada entidad tiene un propósito claro
- [ ] No hay entidades redundantes
- [ ] Las entidades intermedias para N:M están presentes

#### 2. ATRIBUTOS
- [ ] Cada entidad tiene todos los atributos necesarios
- [ ] Todos los atributos tienen tipos de datos definidos
- [ ] Los tipos de datos son apropiados (`VARCHAR`, `INTEGER`, `DECIMAL`, etc.)
- [ ] No hay atributos multivaluados (violación 1FN)
- [ ] Los atributos calculados están justificados

#### 3. CLAVES PRIMARIAS
- [ ] Cada entidad tiene una clave primaria definida
- [ ] Las PKs son únicas e inmutables
- [ ] Se usa nomenclatura consistente (`[tabla]_id`)
- [ ] Las PKs están marcadas claramente en el diagrama

#### 4. CLAVES FORÁNEAS
- [ ] Todas las relaciones tienen FKs apropiadas
- [ ] Las FKs referencian PKs válidas
- [ ] La nomenclatura de FKs es consistente
- [ ] Las FKs están marcadas en el diagrama

#### 5. RELACIONES
- [ ] Todas las relaciones necesarias están modeladas
- [ ] La cardinalidad está correctamente definida (1:1, 1:N, N:M)
- [ ] Las relaciones N:M usan tablas intermedias
- [ ] La direccionalidad de las relaciones es correcta
- [ ] Las relaciones están claramente dibujadas en el diagrama

#### 6. NORMALIZACIÓN
- [ ] **Primera Forma Normal (1FN)**
  - [ ] No hay grupos repetitivos
  - [ ] Todos los atributos son atómicos
- [ ] **Segunda Forma Normal (2FN)**
  - [ ] No hay dependencias parciales
  - [ ] Todos los atributos dependen de la PK completa
- [ ] **Tercera Forma Normal (3FN)**
  - [ ] No hay dependencias transitivas (o están justificadas)
  - [ ] Atributos no-clave no dependen de otros atributos no-clave

#### 7. NOMENCLATURA Y CONVENCIONES
- [ ] Nombres de tablas en singular o plural consistente
- [ ] Uso de `snake_case` para nombres
- [ ] Nombres descriptivos y claros
- [ ] Convenciones de PK/FK consistentes
- [ ] Idioma consistente (español o inglés)

#### 8. INTEGRIDAD
- [ ] Constraints `NOT NULL` apropiados
- [ ] Constraints `UNIQUE` donde sea necesario
- [ ] Constraints `CHECK` para validaciones
- [ ] Consideración de `ON DELETE` / `ON UPDATE` para FKs

#### 9. DIAGRAMA ER
- [ ] Usa notación estándar (Crow’s Foot o Chen)
- [ ] Todas las entidades están representadas
- [ ] Todas las relaciones están dibujadas
- [ ] La cardinalidad está indicada correctamente
- [ ] El diagrama es legible y organizado
- [ ] Incluye título, autor y fecha
- [ ] Incluye leyenda de notación

#### 10. DOCUMENTACIÓN
- [ ] Las decisiones de diseño están documentadas
- [ ] Las alternativas consideradas están explicadas
- [ ] Las reglas de negocio están identificadas
- [ ] Las excepciones a la normalización están justificadas
- [ ] Las consideraciones futuras están documentadas


<br/><br/>

2.	Realiza una validación cruzada contra los requerimientos originales:

#### Validación contra Requerimientos

- **RF1: Gestionar catálogo de productos con información detallada**  
  ✅ Soportado por: Entidad `PRODUCTO` con todos los atributos necesarios

- **RF2: Organizar productos por categorías**  
  ✅ Soportado por: Entidad `CATEGORIA`, relación **1:N** con `PRODUCTO`

- **RF3: Controlar inventario de productos (stock disponible)**  
  ✅ Soportado por: `PRODUCTO.stock_actual`, `PRODUCTO.stock_minimo`

- **RF4: Registrar información de clientes frecuentes**  
  ✅ Soportado por: Entidad `CLIENTE` con datos de contacto

- **RF5: Procesar ventas con múltiples productos**  
  ✅ Soportado por: Entidades `VENTA` y `DETALLE_VENTA`

- **RF6: Mantener registro histórico de ventas**  
  ✅ Soportado por: `VENTA.fecha_venta` y persistencia de precios históricos

- **RF7: Gestionar información de proveedores**  
  ✅ Soportado por: Entidad `PROVEEDOR`

- **RF8: Relacionar productos con sus proveedores y precios de compra**  
  ✅ Soportado por: Entidad `PRODUCTO_PROVEEDOR` con `precio_compra`


<br/>

#### Resultado
✅ **Todos los requerimientos funcionales están cubiertos**


<br/><br/>

3.	Simula consultas típicas para verificar que el diseño las soporta:

### Simulación de Consultas

#### Q1. ¿Qué productos están por debajo del stock mínimo?
- **Tablas necesarias:** `PRODUCTO`
- **Validación:** ✅ Posible
```sql
SELECT * FROM PRODUCTO WHERE stock_actual < stock_minimo;
```

#### Q2. ¿Cuál es el total de ventas del mes actual?

* **Tablas necesarias:** `VENTA`
* **Validación:** ✅ Posible

```sql
SELECT SUM(total) FROM VENTA WHERE fecha_venta >= [inicio_mes];
```

#### Q3. ¿Qué productos ha comprado el cliente Juan Pérez?

* **Tablas necesarias:** `CLIENTE`, `VENTA`, `DETALLE_VENTA`, `PRODUCTO`
* **Validación:** ✅ Posible

```sql
-- JOIN entre CLIENTE → VENTA → DETALLE_VENTA → PRODUCTO usando las FKs
```

#### Q4. ¿Cuáles son los proveedores del producto "Leche"?

* **Tablas necesarias:** `PRODUCTO`, `PRODUCTO_PROVEEDOR`, `PROVEEDOR`
* **Validación:** ✅ Posible

```sql
-- JOIN entre PRODUCTO → PRODUCTO_PROVEEDOR → PROVEEDOR
```

#### Q5. ¿Cuántos productos se vendieron por categoría este mes?

* **Tablas necesarias:** `CATEGORIA`, `PRODUCTO`, `DETALLE_VENTA`, `VENTA`
* **Validación:** ✅ Posible

```sql
-- JOIN y GROUP BY por categoría
```

#### Resultado

✅ **Todas las consultas típicas del negocio están soportadas por el diseño**


4.	Identifica posibles mejoras o ajustes finales:

**MEJORAS IDENTIFICADAS:**

- ✅ **Considerado:** Agregar índice en `PRODUCTO.codigo_barras`  
  **Justificación:** Búsquedas frecuentes por código de barras  
  **Acción:** Documentar para fase de implementación

- ✅ **Considerado:** Agregar campo `VENTA.notas` (`TEXT`)  
  **Justificación:** Permitir comentarios adicionales en ventas  
  **Acción:** Campo opcional, agregar si es necesario

- ✅ **Considerado:** Agregar `CHECK` constraint en `DETALLE_VENTA.cantidad`  
  **Justificación:** Asegurar `cantidad > 0`  
  **Acción:** Documentar para fase de implementación DDL

- ✅ **Considerado:** Agregar campo `PRODUCTO.imagen_url`  
  **Justificación:** Referencia a imagen del producto  
  **Acción:** Extensión futura, no crítico para MVP


#### Resultado Esperado:
Lista de verificación completa con todos los ítems revisados y validados, con identificación de cualquier ajuste necesario.

#### Verificación:
- [ ] Has completado toda la lista de verificación
- [ ] Has validado el diseño contra todos los requerimientos
- [ ] Has simulado consultas típicas exitosamente
- [ ] Has identificado mejoras potenciales
- [ ] El diseño está listo para implementación física


<br/><br/>


## Validación y Pruebas

### Criterios de Éxito

- [ ] Has identificado correctamente las **7 entidades principales** del dominio
- [ ] Todas las entidades tienen atributos completos con **tipos de datos apropiados**
- [ ] Has definido correctamente **claves primarias y foráneas**
- [ ] Las relaciones entre entidades están correctamente identificadas con **cardinalidad apropiada**
- [ ] El diseño cumple con **Primera Forma Normal (1FN)**
- [ ] El diseño cumple con **Segunda Forma Normal (2FN)**
- [ ] El diseño cumple con **Tercera Forma Normal (3FN)** con excepciones justificadas
- [ ] Has creado un **diagrama ER completo y profesional** con notación estándar
- [ ] Has documentado todas las **decisiones de diseño importantes**
- [ ] El diseño soporta **todos los requerimientos funcionales** identificados



<br/><br/>

## Procedimiento de Prueba

### Prueba 1: Validación de Entidades

Revisa tu diseño y confirma:

```txt
Entidades requeridas presentes:
✅ CATEGORIA
✅ PRODUCTO
✅ CLIENTE
✅ VENTA
✅ DETALLE_VENTA
✅ PROVEEDOR
✅ PRODUCTO_PROVEEDOR
```txt

Total: 7 entidades

#### Resultado Esperado: 
Las 7 entidades están presentes en tu diagrama.

### Prueba 2: Validación de Relaciones
Verifica que estas relaciones existan en tu diagrama:

```txt
Relaciones requeridas:
✅ CATEGORIA (1) ──< (N) PRODUCTO
✅ CLIENTE (1) ──< (N) VENTA [cliente_id puede ser NULL]
✅ VENTA (1) ──< (N) DETALLE_VENTA
✅ PRODUCTO (1) ──< (N) DETALLE_VENTA
✅ PRODUCTO (1) ──< (N) PRODUCTO_PROVEEDOR
✅ PROVEEDOR (1) ──< (N) PRODUCTO_PROVEEDOR
```txt

Total: 6 relaciones
#### Resultado Esperado: 
Las 6 relaciones están correctamente dibujadas con cardinalidad apropiada.


### Prueba 3: Validación de Normalización
Confirma cumplimiento de formas normales:

```txt
Primera Forma Normal (1FN):
✅ No hay atributos multivaluados
✅ No hay grupos repetitivos
✅ Todos los atributos son atómicos

Segunda Forma Normal (2FN):
✅ Todas las entidades tienen PKs simples (surrogate keys)
✅ No hay dependencias parciales

Tercera Forma Normal (3FN):
✅ No hay dependencias transitivas no justificadas
✅ Categorías están en tabla separada
✅ Proveedores están en tabla separada
✅ Atributos calculados persistidos están justificados
```

#### Resultado Esperado: 
Tu diseño cumple con todas las formas normales hasta 3FN.


### Prueba 4: Simulación de Consulta Compleja

Verifica que tu diseño soporta esta consulta:

Consulta: "Obtener el nombre del cliente, productos comprados, cantidades y total gastado para todas las ventas del último mes, ordenado por total descendente."

Tablas necesarias:
- CLIENTE (nombre del cliente)
- VENTA (fecha, total)
- DETALLE_VENTA (cantidad, precio_unitario)
- PRODUCTO (nombre del producto)

#### Validación:
```txt
✅ Existe relación CLIENTE → VENTA (via cliente_id)
✅ Existe relación VENTA → DETALLE_VENTA (via venta_id)
✅ Existe relación DETALLE_VENTA → PRODUCTO (via producto_id)
✅ Todos los atributos necesarios existen en las tablas
✅ La consulta es posible mediante JOINs
```

#### Resultado Esperado: 
Tu diseño soporta esta consulta compleja.


<br/><br/>

## Solución de Problemas

### **Problema 1.** No puedo identificar todas las entidades necesarias

#### Síntomas:
- Solo identificas 3–4 entidades.
- No estás seguro si necesitas más entidades.
- Las entidades identificadas son muy generales.

#### Causa:
Análisis insuficiente de requerimientos o falta de identificación de relaciones N:M.

#### Solución:
1. Revisa el escenario de negocio línea por línea.
2. Identifica todos los sustantivos importantes (candidatos a entidades).
3. Pregúntate: “¿Necesito almacenar información sobre esto?”.
4. Identifica relaciones muchos-a-muchos que requieren tablas intermedias:
   - **VENTA ↔ PRODUCTO** → Necesita **DETALLE_VENTA**
   - **PRODUCTO ↔ PROVEEDOR** → Necesita **PRODUCTO_PROVEEDOR**

#### Checklist de entidades mínimas:

- [ ] ¿Tengo una entidad para productos?
- [ ] ¿Tengo una entidad para categorías de productos?
- [ ] ¿Tengo una entidad para clientes?
- [ ] ¿Tengo una entidad para ventas?
- [ ] ¿Tengo una entidad para detalles de venta?
- [ ] ¿Tengo una entidad para proveedores?
- [ ] ¿Tengo una entidad intermedia producto-proveedor?


<br/><br/>

### Problema 2: No sé qué tipo de dato asignar a los atributos

#### Síntomas:
- Usas `VARCHAR` para todo
- No estás seguro entre `INTEGER` y `DECIMAL`
- No sabes cuándo usar `TEXT` vs `VARCHAR`

#### Causa:
Falta de comprensión de tipos de datos SQL y sus casos de uso.

#### Solución:
Usa esta guía de tipos de datos:

**GUÍA DE TIPOS DE DATOS**

**Identificadores (IDs):**
- `INTEGER` o `BIGINT` → Para claves primarias y foráneas

**Nombres y textos cortos:**
- `VARCHAR(longitud)` → Para textos con longitud máxima definida  
  Ejemplos:
  - `VARCHAR(100)` para nombres  
  - `VARCHAR(50)` para códigos

**Textos largos sin límite:**
- `TEXT` → Para descripciones, comentarios, notas

**Precios y montos:**
- `DECIMAL(10,2)` → Para valores monetarios (10 dígitos, 2 decimales)  
  Ejemplo:
  - `DECIMAL(10,2)` puede almacenar hasta **99,999,999.99**

**Cantidades enteras:**
- `INTEGER` → Para stock, cantidades, contadores.

**Fechas y horas:**
- `DATE` → Solo fecha (`YYYY-MM-DD`).
- `TIME` → Solo hora (`HH:MM:SS`).
- `TIMESTAMP` → Fecha y hora completa.

**Valores verdadero/falso:**
- `BOOLEAN` → Para flags (`activo`, `es_principal`, etc.).

**Emails:**
- `VARCHAR(100)` → Longitud suficiente para direcciones de correo.

**Teléfonos:**
- `VARCHAR(20)` → Permite formatos internacionales y caracteres especiales.


#### Ejemplo aplicado:

**PRODUCTO**
- `producto_id` → `INTEGER` (identificador)
- `nombre` → `VARCHAR(200)` (texto corto con límite)
- `descripcion` → `TEXT` (texto largo sin límite)
- `precio_venta` → `DECIMAL(10,2)` (moneda)
- `stock_actual` → `INTEGER` (cantidad entera)
- `activo` → `BOOLEAN` (flag verdadero/falso)


<br/><br/>

### Problema 3: No entiendo cuándo usar una tabla intermedia

#### Síntomas:
- Intentas poner múltiples FKs en una sola tabla
- No sabes cómo representar relaciones N:M
- Tu diseño tiene atributos multivaluados


#### Causa:
Confusión sobre relaciones muchos-a-muchos (N:M).

#### Solución:
**Regla simple:** Usa una tabla intermedia cuando ambas direcciones de la relación son “muchos”.

#### Pregunta clave:
- ¿Un A puede tener múltiples B?  
- ¿Un B puede tener múltiples A?  

Si **ambas respuestas son SÍ** → **Necesitas una tabla intermedia**.

#### Ejemplos:

**CASO 1: VENTA y PRODUCTO**

**Preguntas:**
- ¿Una venta puede incluir múltiples productos? → **SÍ**
- ¿Un producto puede estar en múltiples ventas? → **SÍ**

**Conclusión:**  
Relación **N:M** → Necesita tabla intermedia **DETALLE_VENTA**

**Diseño:**
- `VENTA` (`venta_id`, `fecha`, `total`)
- `DETALLE_VENTA` (`detalle_id`, `venta_id` [FK], `producto_id` [FK], `cantidad`)
- `PRODUCTO` (`producto_id`, `nombre`, `precio`)

---

**CASO 2: PRODUCTO y PROVEEDOR**

**Preguntas:**
- ¿Un producto puede ser suministrado por múltiples proveedores? → **SÍ**
- ¿Un proveedor puede suministrar múltiples productos? → **SÍ**

**Conclusión:**  
Relación **N:M** → Necesita tabla intermedia **PRODUCTO_PROVEEDOR**

**Diseño:**
- `PRODUCTO` (`producto_id`, `nombre`)
- `PRODUCTO_PROVEEDOR` (`id`, `producto_id` [FK], `proveedor_id` [FK], `precio_compra`)
- `PROVEEDOR` (`proveedor_id`, `nombre_empresa`)

---

**CASO 3: PRODUCTO y CATEGORIA**

**Preguntas:**
- ¿Un producto puede pertenecer a múltiples categorías? → **NO** (en este diseño)
- ¿Una categoría puede tener múltiples productos? → **SÍ**

**Conclusión:**  
Relación **1:N** → **NO** necesita tabla intermedia

**Diseño:**
- `CATEGORIA` (`categoria_id`, `nombre`)
- `PRODUCTO` (`producto_id`, `nombre`, `categoria_id` [FK])

---

**Señales de que necesitas una tabla intermedia:**
- Intentas crear un campo que almacena múltiples valores (violación de **1FN**)
- Necesitas almacenar información adicional sobre la relación
- Ambas entidades pueden tener “muchos” de la otra


<br/><br/>

### Problema 4: Mi diagrama no cumple con 3FN

#### Síntomas:
- Has identificado dependencias transitivas
- Tienes atributos que dependen de otros atributos no-clave
- No sabes cómo reorganizar las tablas

#### Causa:
Atributos que deberían estar en tablas separadas están mezclados.

#### Solución:
**Proceso de normalización a 3FN:**


1. **Identifica dependencias transitivas:**

   **Ejemplo de VIOLACIÓN:**

```
PRODUCTO (producto_id, nombre, categoria_nombre, categoria_descripcion)

Dependencia transitiva:
producto_id → categoria_nombre → categoria_descripcion
(categoria_descripcion depende de categoria_nombre, no de producto_id)

```

2. **Crea tabla separada para el atributo intermedio:**

   **CORRECCIÓN:**

```
CATEGORIA (categoria_id, nombre, descripcion)
PRODUCTO (producto_id, nombre, categoria_id [FK])
```

```
**Ahora:**
- `producto_id` → `categoria_id` (directo)
- `categoria_id` → `nombre`, `descripcion` (en tabla separada)
```

#### Casos comunes en tienda de barrio:


**✅ CORRECTO: Categorías en tabla separada**

```
CATEGORIA (categoria_id, nombre, descripcion)
PRODUCTO (producto_id, nombre, categoria_id)
```

**❌ INCORRECTO: Datos de categoría en PRODUCTO**

```
PRODUCTO (producto_id, nombre, categoria_nombre, categoria_descripcion)
```

**✅ CORRECTO: Proveedores en tabla separada**

```
PROVEEDOR (proveedor_id, nombre_empresa, telefono)
PRODUCTO_PROVEEDOR (producto_id, proveedor_id, precio_compra)
```

**❌ INCORRECTO: Datos de proveedor repetidos**

```
PRODUCTO (producto_id, nombre, proveedor_nombre, proveedor_telefono)
```

#### Excepciones aceptables:
- Atributos calculados con justificación de negocio (`total`, `subtotal`)
- Campos de auditoría (`fecha_registro`)
- Direcciones no normalizadas por simplicidad


<br/><br/>

### Problema 5: No sé cómo usar la herramienta de diagramación

#### Síntomas:
- No encuentras las formas adecuadas en draw.io
- No sabes cómo conectar entidades
- El diagrama se ve desorganizado

#### Causa:
Falta de familiaridad con la herramienta de diagramación.

#### Solución para draw.io:

1. **Crear entidades (rectángulos):**
   - Barra lateral izquierda → **"Entity Relation"** o **"General"**
   - Arrastra **"Rectangle"** al canvas
   - Doble clic para editar texto
   - Escribe el nombre de la entidad en **MAYÚSCULAS**

2. **Agregar atributos:**
   - Doble clic dentro del rectángulo
   - Lista los atributos uno por línea:

```
PRODUCTO
────────────────
PK producto_id (INTEGER)
nombre (VARCHAR(200))
precio_venta (DECIMAL(10,2))
FK categoria_id (INTEGER)

```

3. **Crear relaciones (líneas):**
   - Selecciona la herramienta **"Connector"** (flecha con línea)
   - Haz clic en la entidad origen
   - Arrastra hasta la entidad destino
   - Suelta para crear la conexión

4. **Agregar cardinalidad:**
   - Selecciona la línea de la relación
   - Panel derecho → **"Style"**
   - Cambia **"Line start"** y **"Line end"** para usar símbolos de cardinalidad
   - O agrega texto manualmente cerca de los extremos:


```
CATEGORIA ──────1────────< PRODUCTO
               uno       muchos
```


5. **Organizar el diagrama:**
   - Arrastra las entidades para reorganizarlas
   - Usa **"Arrange"** → **"Layout"** para auto-organizar
   - Mantén entidades relacionadas cerca
   - Evita cruces de líneas innecesarios

**Alternativa offline (papel):**
- Dibuja rectángulos para las entidades
- Lista los atributos dentro de cada rectángulo
- Dibuja líneas conectando entidades relacionadas
- Usa símbolos de cardinalidad:
  - `|` = uno
  - `<` = muchos
  - `o` = cero (opcional)


<br/><br/>


## Limpieza

Este laboratorio es principalmente de diseño conceptual y no requiere limpieza de sistemas o software. Sin embargo:

1. **Guarda todos tus archivos de trabajo:**

```
* TiendaBarrio_ER_Diagrama_[TuNombre].png (o .pdf)
* TiendaBarrio_Documentacion_Diseno_[TuNombre].txt
* TiendaBarrio_Notas_[TuNombre].txt (si creaste notas adicionales)
```

2. **Organiza tus archivos en una carpeta:**

```
Crear carpeta: Lab02_Diseño_BD_TiendaBarrio/
Mover todos los archivos relacionados a esta carpeta
```

3. **Haz backup de tu trabajo:**
- Guarda una copia en la nube (Google Drive, OneDrive)
- O envía por email a ti mismo
- Necesitarás estos diseños para laboratorios futuros

> **Importante:** NO borres estos archivos. Los utilizarás en el **Lab 03** para implementar este diseño en **PostgreSQL** usando **DDL**.



<br/><br/>

## Resumen

### Lo que lograste

En este laboratorio has completado exitosamente:

- ✅ Análisis de requerimientos de negocio para una tienda de barrio.
- ✅ Identificación de **7 entidades principales** del dominio.
- ✅ Definición completa de atributos con **tipos de datos apropiados**.
- ✅ Establecimiento de **relaciones con cardinalidad correcta** (1:1, 1:N, N:M).
- ✅ Aplicación de **Primera Forma Normal (1FN)** eliminando grupos repetitivos.
- ✅ Aplicación de **Segunda Forma Normal (2FN)** eliminando dependencias parciales.
- ✅ Aplicación de **Tercera Forma Normal (3FN)** eliminando dependencias transitivas.
- ✅ Creación de un **diagrama entidad–relación profesional** con notación estándar.
- ✅ Documentación completa de **decisiones de diseño y justificaciones**.
- ✅ Validación del diseño contra **requerimientos funcionales**.


## Conceptos Clave Aprendidos

### Modelado de Datos
- Las entidades representan objetos o conceptos del mundo real que necesitan ser almacenados
- Los atributos describen las características de las entidades
- Las relaciones conectan entidades y tienen cardinalidad específica
- Las tablas intermedias resuelven relaciones muchos-a-muchos (N:M)

### Normalización
- **1FN:** Elimina grupos repetitivos y asegura atomicidad
- **2FN:** Elimina dependencias parciales de claves compuestas
- **3FN:** Elimina dependencias transitivas entre atributos no-clave
- La normalización reduce la redundancia y mejora la integridad de los datos
- Algunas excepciones están justificadas por razones de negocio

### Diseño de Bases de Datos
- El diseño conceptual precede a la implementación física
- Las decisiones de diseño deben estar documentadas y justificadas
- Un buen diseño soporta consultas eficientes y mantiene la integridad
- El diseño debe balancear la normalización teórica con necesidades prácticas

### Claves y Relaciones
- Las claves primarias (**PK**) identifican de forma única cada registro
- Las claves foráneas (**FK**) implementan relaciones entre tablas
- Las claves *surrogate* (`INTEGER` auto-incrementable


<br/><br/>

## Próximos Pasos

1. **Lab 03:** Implementarás este diseño en **PostgreSQL** usando **DDL** (`CREATE TABLE`)
2. **Lab 04:** Poblarás las tablas con datos de prueba usando **DML** (`INSERT`)
3. **Lab 05:** Realizarás consultas complejas sobre los datos (**SELECT**, **JOIN**)


<br/><br/>

## Preparación para el siguiente lab:

- Asegúrate de tener **PostgreSQL 18** y **pgAdmin** instalados.
- Revisa tu **diagrama ER** antes de la siguiente sesión.
- Familiarízate con la sintaxis básica de **`CREATE TABLE`** en PostgreSQL.

<br/><br/>

## Reflexión

Considera estas preguntas para consolidar tu aprendizaje:

1. ¿Por qué es importante normalizar una base de datos?
2. ¿Cuándo es apropiado denormalizar (violar 3FN) intencionalmente?
3. ¿Cómo afecta el diseño de la BD a las consultas que podrás hacer después?
4. ¿Qué pasaría si no usaras tablas intermedias para relaciones N:M?
5. ¿Cómo cambiaría el diseño si la tienda tuviera múltiples sucursales?


<br/><br/>

## Recursos Adicionales

### Documentación Oficial
- **PostgreSQL Documentation – Data Definition**  
  https://www.postgresql.org/docs/18/ddl.html  
  Guía oficial sobre definición de datos en PostgreSQL

- **PostgreSQL Data Types**  
  https://www.postgresql.org/docs/18/datatype.html  
  Referencia completa de tipos de datos disponibles

---
<br/><br/>

### Herramientas de Diagramación
- **draw.io (diagrams.net)**  
  https://app.diagrams.net/  
  Herramienta gratuita de diagramación, no requiere registro

- **dbdiagram.io**  
  https://dbdiagram.io/  
  Herramienta especializada en diagramas de bases de datos con sintaxis simple

- **Lucidchart**  
  https://www.lucidchart.com/  
  Herramienta profesional de diagramación (plan gratuito disponible)

- **ERDPlus**  
  https://erdplus.com/  
  Herramienta educativa gratuita para diagramas ER


---
<br/><br/>

### Tutoriales y Guías
- **Database Normalization Explained**  
  https://www.guru99.com/database-normalization.html  
  Tutorial completo sobre normalización con ejemplos prácticos

- **Entity Relationship Diagram Tutorial**  
  https://www.lucidchart.com/pages/er-diagrams  
  Guía visual sobre creación de diagramas ER

- **Crow’s Foot Notation**  
  https://www.vertabelo.com/blog/crow-s-foot-notation/  
  Explicación detallada de la notación Crow’s Foot


---
<br/><br/>

### Videos Educativos
- **Database Design Course (freeCodeCamp)**  
  https://www.youtube.com/watch?v=ztHopE5Wnpc  
  Curso completo de diseño de bases de datos (inglés)

- **Normalización de Bases de Datos**  
  Buscar en YouTube tutoriales en español sobre normalización

---
<br/><br/>

### Libros Recomendados
- **"Database Design for Mere Mortals" – Michael J. Hernandez**  
  Excelente introducción al diseño de bases de datos relacionales

- **"SQL and Relational Theory" – C. J. Date**  
  Fundamentos teóricos profundos de bases de datos relacionales

---
<br/><br/>

### Comunidades y Foros

- **Stack Overflow – Database Design**  
  https://stackoverflow.com/questions/tagged/database-design  
  Preguntas y respuestas sobre diseño de bases de datos

- **Reddit – r/Database**  
  https://www.reddit.com/r/Database/  
  Comunidad para discusión de temas de bases de datos

- **PostgreSQL Mailing Lists**  
  https://www.postgresql.org/list/  
  Listas de correo oficiales de PostgreSQL para soporte

<br/><br/>

## Práctica Adicional

### Ejercicios sugeridos para reforzar conceptos:

1. **Diseña una base de datos para una biblioteca:**
   - Entidades: `LIBROS`, `AUTORES`, `USUARIOS`, `PRESTAMOS`
   - Considera relaciones **N:M** (libro–autor)
   - Aplica normalización hasta **3FN**

2. **Diseña una base de datos para un restaurante:**
   - Entidades: `MENU`, `INGREDIENTES`, `PEDIDOS`, `MESAS`, `MESEROS`
   - Considera inventario de ingredientes
   - Modela relaciones complejas

3. **Extiende el diseño de la tienda de barrio:**
   - Agrega la tabla `EMPLEADO` para registrar quién procesa ventas
   - Agrega la tabla `PROMOCION` para descuentos
   - Agrega la tabla `ORDEN_COMPRA` para pedidos a proveedores


<br/><br/>

---

<br/><br/>


¡Felicitaciones por completar este laboratorio de diseño de bases de datos relacionales!

Has dado un paso fundamental en tu camino como profesional de bases de datos.  
El diseño que creaste hoy es la base sobre la cual construirás una base de datos funcional en los próximos laboratorios.


