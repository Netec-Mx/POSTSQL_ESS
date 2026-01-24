erDiagram

    USUARIOS {
        int id PK
        string nombre
        string apellido
        string email
        string telefono
        string tipo_usuario
        date fecha_registro
        string password_hash
    }

    UBICACIONES {
        int id PK
        string pais
        string ciudad
        string estado_provincia
        string codigo_postal
        string direccion
    }

    PROPIEDADES {
        int id PK
        int id_anfitrion FK
        int id_ubicacion FK
        string titulo
        string descripcion
        string tipo_propiedad
        decimal precio_noche
        int capacidad_huespedes
        int num_habitaciones
        int num_banos
        date fecha_creacion
    }

    AMENIDADES {
        int id PK
        string nombre
        string descripcion
        string categoria
    }

    PROPIEDADES_AMENIDADES {
        int id_propiedad FK
        int id_amenidad FK
    }

    RESERVAS {
        int id PK
        int id_propiedad FK
        int id_huesped FK
        date fecha_inicio
        date fecha_fin
        int num_huespedes
        decimal precio_total
        string estado
        date fecha_reserva
    }

    PAGOS {
        int id PK
        int id_reserva FK
        decimal monto
        string metodo_pago
        string estado_pago
        date fecha_pago
    }

    RESENAS {
        int id PK
        int id_reserva FK
        int id_usuario FK
        int calificacion
        string comentario
        date fecha_resena
    }

    USUARIOS ||--o{ PROPIEDADES : anfitrion
    UBICACIONES ||--o{ PROPIEDADES : ubicacion
    PROPIEDADES ||--o{ RESERVAS : tiene
    USUARIOS ||--o{ RESERVAS : huesped
    PROPIEDADES ||--o{ PROPIEDADES_AMENIDADES : incluye
    AMENIDADES ||--o{ PROPIEDADES_AMENIDADES : pertenece
    RESERVAS ||--o{ PAGOS : genera
    RESERVAS ||--|| RESENAS : produce
