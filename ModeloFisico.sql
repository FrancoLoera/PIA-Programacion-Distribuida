-------------------------------------------------------------
-- PRODUCTO INTEGRADOR DE APRENDIZAJE: GESTIÓN DE GIMNASIOS
-- BASE DE DATOS: PIA_GIMNASIO (Microsoft SQL Server)
-- SCRIPT COMPLETO: MODELO FÍSICO, DATOS SEMILLA Y PROCEDIMIENTOS ALMACENADOS
-------------------------------------------------------------

IF DB_ID('PIA_GIMNASIO') IS NULL
BEGIN
    CREATE DATABASE PIA_GIMNASIO;
END;
GO

USE PIA_GIMNASIO;
GO

-------------------------------------------------------------
-- 1. ELIMINACIÓN PREVIA DE PROCEDIMIENTOS ALMACENADOS Y TABLAS
-------------------------------------------------------------

-- Procedimientos Almacenados
DROP PROCEDURE IF EXISTS dbo.SP_REPORTE_RUTINAS;
DROP PROCEDURE IF EXISTS dbo.SP_REPORTE_CLASES;
DROP PROCEDURE IF EXISTS dbo.SP_REPORTE_CONTROL_ACCESO;
DROP PROCEDURE IF EXISTS dbo.SP_REPORTE_SOCIOS;
DROP PROCEDURE IF EXISTS dbo.SP_REPORTE_EMPLEADOS;
DROP PROCEDURE IF EXISTS dbo.SP_AUDITORIA;
DROP PROCEDURE IF EXISTS dbo.SP_RUTINA;
DROP PROCEDURE IF EXISTS dbo.SP_RESERVA;
DROP PROCEDURE IF EXISTS dbo.SP_CLASE;
DROP PROCEDURE IF EXISTS dbo.SP_CONTROL_ACCESO;
DROP PROCEDURE IF EXISTS dbo.SP_SUSCRIPCION;
DROP PROCEDURE IF EXISTS dbo.SP_EJERCICIO;
DROP PROCEDURE IF EXISTS dbo.SP_EXPEDIENTE;
DROP PROCEDURE IF EXISTS dbo.SP_CLIENTE;
DROP PROCEDURE IF EXISTS dbo.SP_USUARIO;
DROP PROCEDURE IF EXISTS dbo.SP_EMPLEADO;
DROP PROCEDURE IF EXISTS dbo.SP_SALON;
DROP PROCEDURE IF EXISTS dbo.SP_SUCURSAL;
DROP PROCEDURE IF EXISTS dbo.SP_MEMBRESIA;
DROP PROCEDURE IF EXISTS dbo.SP_CONDICION;
DROP PROCEDURE IF EXISTS dbo.SP_ESPECIALIDAD;
DROP PROCEDURE IF EXISTS dbo.SP_PUESTO;
DROP PROCEDURE IF EXISTS dbo.SP_DIFICULTAD;
DROP PROCEDURE IF EXISTS dbo.SP_GRUPO_MUSCULAR;
GO

-- Tablas dependientes (orden inverso de llaves foráneas)
DROP TABLE IF EXISTS dbo.AUDITORIA;
DROP TABLE IF EXISTS dbo.USUARIO;
DROP TABLE IF EXISTS dbo.DETALLE_RUTINA;
DROP TABLE IF EXISTS dbo.RUTINA;
DROP TABLE IF EXISTS dbo.EJERCICIO_CONTRAINDICACION;
DROP TABLE IF EXISTS dbo.EJERCICIO;
DROP TABLE IF EXISTS dbo.RESERVA;
DROP TABLE IF EXISTS dbo.CLASE;
DROP TABLE IF EXISTS dbo.SALON;
DROP TABLE IF EXISTS dbo.CONTROL_ACCESO;
DROP TABLE IF EXISTS dbo.SUSCRIPCION;
DROP TABLE IF EXISTS dbo.EXPEDIENTE_CONDICION;
DROP TABLE IF EXISTS dbo.EXPEDIENTE;
DROP TABLE IF EXISTS dbo.CLIENTE;
DROP TABLE IF EXISTS dbo.EMPLEADO_ESPECIALIDAD;
DROP TABLE IF EXISTS dbo.EMPLEADO;
DROP TABLE IF EXISTS dbo.SUCURSAL;
DROP TABLE IF EXISTS dbo.MEMBRESIA;
DROP TABLE IF EXISTS dbo.CONDICION;
DROP TABLE IF EXISTS dbo.ROL;
DROP TABLE IF EXISTS dbo.DIFICULTAD;
DROP TABLE IF EXISTS dbo.GRUPO_MUSCULAR;
DROP TABLE IF EXISTS dbo.ESPECIALIDAD;
DROP TABLE IF EXISTS dbo.PUESTO;
DROP TABLE IF EXISTS dbo.ESTATUS_USUARIO;
DROP TABLE IF EXISTS dbo.ESTATUS_RUTINA;
DROP TABLE IF EXISTS dbo.ESTATUS_RESERVA;
DROP TABLE IF EXISTS dbo.ESTATUS_CLASE;
DROP TABLE IF EXISTS dbo.ESTATUS_SALON;
DROP TABLE IF EXISTS dbo.ESTATUS_SUSCRIPCION;
DROP TABLE IF EXISTS dbo.ESTATUS_CLIENTE;
DROP TABLE IF EXISTS dbo.ESTATUS_SUCURSAL;
DROP TABLE IF EXISTS dbo.ESTATUS_EMPLEADO;
GO

-------------------------------------------------------------
-- 2. CREACIÓN DE TABLAS DE CATÁLOGO Y ESTATUS
-------------------------------------------------------------

CREATE TABLE dbo.ESTATUS_EMPLEADO
(
    IdEstatusEmpleado   TINYINT     IDENTITY(1,1),
    Nombre              VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ESTATUS_EMPLEADO PRIMARY KEY (IdEstatusEmpleado),
    CONSTRAINT UQ_ESTATUS_EMPLEADO_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESTATUS_SUCURSAL
(
    IdEstatusSucursal   TINYINT     IDENTITY(1,1),
    Nombre              VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ESTATUS_SUCURSAL PRIMARY KEY (IdEstatusSucursal),
    CONSTRAINT UQ_ESTATUS_SUCURSAL_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESTATUS_CLIENTE
(
    IdEstatusCliente    TINYINT     IDENTITY(1,1),
    Nombre              VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ESTATUS_CLIENTE PRIMARY KEY (IdEstatusCliente),
    CONSTRAINT UQ_ESTATUS_CLIENTE_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESTATUS_SUSCRIPCION
(
    IdEstatusSuscripcion TINYINT     IDENTITY(1,1),
    Nombre               VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ESTATUS_SUSCRIPCION PRIMARY KEY (IdEstatusSuscripcion),
    CONSTRAINT UQ_ESTATUS_SUSCRIPCION_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESTATUS_SALON
(
    IdEstatusSalon  TINYINT     IDENTITY(1,1),
    Nombre          VARCHAR(30) NOT NULL,
    CONSTRAINT PK_ESTATUS_SALON PRIMARY KEY (IdEstatusSalon),
    CONSTRAINT UQ_ESTATUS_SALON_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESTATUS_CLASE
(
    IdEstatusClase  TINYINT     IDENTITY(1,1),
    Nombre          VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ESTATUS_CLASE PRIMARY KEY (IdEstatusClase),
    CONSTRAINT UQ_ESTATUS_CLASE_Nombre UNIQUE (Nombre)
);
GO

-- ESTATUS_RESERVA: 1=Confirmada, 2=Cancelada, 3=Asistió, 4=No asistió
CREATE TABLE dbo.ESTATUS_RESERVA
(
    IdEstatusReserva    TINYINT     IDENTITY(1,1),
    Nombre              VARCHAR(30) NOT NULL,
    CONSTRAINT PK_ESTATUS_RESERVA PRIMARY KEY (IdEstatusReserva),
    CONSTRAINT UQ_ESTATUS_RESERVA_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESTATUS_RUTINA
(
    IdEstatusRutina TINYINT     IDENTITY(1,1),
    Nombre          VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ESTATUS_RUTINA PRIMARY KEY (IdEstatusRutina),
    CONSTRAINT UQ_ESTATUS_RUTINA_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESTATUS_USUARIO
(
    IdEstatusUsuario    TINYINT     IDENTITY(1,1),
    Nombre              VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ESTATUS_USUARIO PRIMARY KEY (IdEstatusUsuario),
    CONSTRAINT UQ_ESTATUS_USUARIO_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.PUESTO
(
    IdPuesto    TINYINT         IDENTITY(1,1),
    Nombre      VARCHAR(30)     NOT NULL,
    Descripcion VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_PUESTO PRIMARY KEY (IdPuesto),
    CONSTRAINT UQ_PUESTO_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ESPECIALIDAD
(
    IdEspecialidad  TINYINT         IDENTITY(1,1),
    Nombre          VARCHAR(30)     NOT NULL,
    Descripcion     VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (IdEspecialidad),
    CONSTRAINT UQ_ESPECIALIDAD_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.GRUPO_MUSCULAR
(
    IdGrupoMuscular SMALLINT        IDENTITY(1,1),
    Nombre          VARCHAR(30)     NOT NULL,
    Descripcion     VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_GRUPO_MUSCULAR PRIMARY KEY (IdGrupoMuscular),
    CONSTRAINT UQ_GRUPO_MUSCULAR_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.DIFICULTAD
(
    IdDificultad    TINYINT         IDENTITY(1,1),
    Nombre          VARCHAR(30)     NOT NULL,
    Descripcion     VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_DIFICULTAD PRIMARY KEY (IdDificultad),
    CONSTRAINT UQ_DIFICULTAD_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.ROL
(
    IdRol       TINYINT         IDENTITY(1,1),
    Nombre      VARCHAR(20)     NOT NULL,
    Descripcion VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_ROL PRIMARY KEY (IdRol),
    CONSTRAINT UQ_ROL_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.CONDICION
(
    IdCondicion    TINYINT         IDENTITY(1,1),
    Nombre         VARCHAR(50)     NOT NULL,
    Tipo           VARCHAR(20)     NOT NULL,
    Descripcion    VARCHAR(300)    NOT NULL,
    CONSTRAINT PK_CONDICION PRIMARY KEY (IdCondicion),
    CONSTRAINT UQ_CONDICION_Nombre UNIQUE (Nombre),
    CONSTRAINT CK_CONDICION_Tipo CHECK (Tipo IN ('Padecimiento', 'Lesión', 'Alergia', 'Riesgo'))
);
GO

CREATE TABLE dbo.MEMBRESIA
(
    IdMembresia       TINYINT         IDENTITY(1,1),
    Nombre            VARCHAR(30)     NOT NULL,
    Precio            DECIMAL(7,2)    NOT NULL,
    Descripcion       VARCHAR(300)    NOT NULL,
    PermiteClases     BIT             NOT NULL,
    MaxClasesSemana   TINYINT         NOT NULL,
    SujetaAforo       BIT             NOT NULL,
    CONSTRAINT PK_MEMBRESIA PRIMARY KEY (IdMembresia),
    CONSTRAINT UQ_MEMBRESIA_Nombre UNIQUE (Nombre),
    CONSTRAINT CK_MEMBRESIA_Precio CHECK (Precio >= 0),
    CONSTRAINT CK_MEMBRESIA_MaxClases CHECK (
        (PermiteClases = 1 AND MaxClasesSemana > 0)
        OR
        (PermiteClases = 0 AND MaxClasesSemana = 0)
    )
);
GO

-------------------------------------------------------------
-- 3. CREACIÓN DE TABLAS OPERATIVAS Y DE NEGOCIO
-------------------------------------------------------------

CREATE TABLE dbo.SUCURSAL
(
    IdSucursal      SMALLINT        IDENTITY(1,1),
    Nombre          VARCHAR(80)     NOT NULL,
    Telefono        VARCHAR(20)     NOT NULL,
    NumeroExterior  VARCHAR(20)     NOT NULL,
    NumeroInterior  VARCHAR(20)     NULL,
    Calle           VARCHAR(100)    NOT NULL,
    Colonia         VARCHAR(100)    NOT NULL,
    Ciudad          VARCHAR(100)    NOT NULL,
    Estado          VARCHAR(100)    NOT NULL,
    AforoMaximo     SMALLINT        NOT NULL,
    HoraApertura    TIME            NOT NULL,
    HoraCierre      TIME            NOT NULL,
    IdEstatus       TINYINT         NOT NULL,
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (IdSucursal),
    CONSTRAINT FK_SUCURSAL_ESTATUS_SUCURSAL FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_SUCURSAL(IdEstatusSucursal),
    CONSTRAINT UQ_SUCURSAL_Telefono UNIQUE (Telefono),
    CONSTRAINT CK_SUCURSAL_AforoMaximo CHECK (AforoMaximo > 0),
    CONSTRAINT CK_SUCURSAL_HoraCierre CHECK (HoraCierre > HoraApertura)
);
GO

CREATE TABLE dbo.EMPLEADO
(
    IdEmpleado          INT             IDENTITY(1,1),
    Nombres             VARCHAR(50)     NOT NULL,
    PrimerApellido      VARCHAR(50)     NOT NULL,
    SegundoApellido     VARCHAR(50)     NULL,
    CURP                CHAR(18)        NOT NULL,
    Telefono            VARCHAR(20)     NOT NULL,
    Correo              VARCHAR(254)    NOT NULL,
    FechaNacimiento     DATE            NOT NULL,
    FechaContratacion   DATE            NOT NULL CONSTRAINT DF_EMPLEADO_FechaContratacion DEFAULT (CAST(GETDATE() AS DATE)),
    IdPuesto            TINYINT         NOT NULL,
    IdSucursal          SMALLINT        NOT NULL,
    IdEstatus           TINYINT         NOT NULL,
    CONSTRAINT PK_EMPLEADO PRIMARY KEY (IdEmpleado),
    CONSTRAINT FK_EMPLEADO_PUESTO FOREIGN KEY (IdPuesto) REFERENCES dbo.PUESTO(IdPuesto),
    CONSTRAINT FK_EMPLEADO_SUCURSAL FOREIGN KEY (IdSucursal) REFERENCES dbo.SUCURSAL(IdSucursal),
    CONSTRAINT FK_EMPLEADO_ESTATUS_EMPLEADO FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_EMPLEADO(IdEstatusEmpleado),
    CONSTRAINT UQ_EMPLEADO_CURP UNIQUE (CURP),
    CONSTRAINT UQ_EMPLEADO_Telefono UNIQUE (Telefono),
    CONSTRAINT UQ_EMPLEADO_Correo UNIQUE (Correo)
);
GO

CREATE TABLE dbo.EMPLEADO_ESPECIALIDAD
(
    IdEmpleado      INT     NOT NULL,
    IdEspecialidad  TINYINT NOT NULL,
    CONSTRAINT PK_EMPLEADO_ESPECIALIDAD PRIMARY KEY (IdEmpleado, IdEspecialidad),
    CONSTRAINT FK_EMPLEADO_ESPECIALIDAD_EMPLEADO FOREIGN KEY (IdEmpleado) REFERENCES dbo.EMPLEADO(IdEmpleado),
    CONSTRAINT FK_EMPLEADO_ESPECIALIDAD_ESPECIALIDAD FOREIGN KEY (IdEspecialidad) REFERENCES dbo.ESPECIALIDAD(IdEspecialidad)
);
GO

CREATE TABLE dbo.CLIENTE
(
    IdCliente           INT             IDENTITY(1,1),
    Folio               AS (
                            CONVERT(CHAR(4), YEAR(FechaInscripcion)) +
                            RIGHT('0000' + CONVERT(VARCHAR(10), IdCliente), 4)
                        ) PERSISTED,
    Nombres             VARCHAR(50)     NOT NULL,
    PrimerApellido      VARCHAR(50)     NOT NULL,
    SegundoApellido     VARCHAR(50)     NULL,
    Telefono            VARCHAR(20)     NOT NULL,
    Correo              VARCHAR(254)    NOT NULL,
    FechaNacimiento     DATE            NOT NULL,
    FechaInscripcion    DATE            NOT NULL CONSTRAINT DF_CLIENTE_FechaInscripcion DEFAULT (CAST(GETDATE() AS DATE)),
    IdSucursal          SMALLINT        NOT NULL,
    IdEstatus           TINYINT         NOT NULL,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (IdCliente),
    CONSTRAINT FK_CLIENTE_SUCURSAL FOREIGN KEY (IdSucursal) REFERENCES dbo.SUCURSAL(IdSucursal),
    CONSTRAINT FK_CLIENTE_ESTATUS_CLIENTE FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_CLIENTE(IdEstatusCliente),
    CONSTRAINT UQ_CLIENTE_Folio UNIQUE (Folio)
);
GO

CREATE TABLE dbo.EXPEDIENTE
(
    IdExpediente    INT             IDENTITY(1,1),
    IdCliente       INT             NOT NULL,
    TipoSangre      VARCHAR(3)      NOT NULL,
    CONSTRAINT PK_EXPEDIENTE PRIMARY KEY (IdExpediente),
    CONSTRAINT FK_EXPEDIENTE_CLIENTE FOREIGN KEY (IdCliente) REFERENCES dbo.CLIENTE(IdCliente),
    CONSTRAINT UQ_EXPEDIENTE_Cliente UNIQUE (IdCliente),
    CONSTRAINT CK_EXPEDIENTE_TipoSangre CHECK (TipoSangre IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);
GO

CREATE TABLE dbo.EXPEDIENTE_CONDICION
(
    IdExpediente    INT             NOT NULL,
    IdCondicion     TINYINT         NOT NULL,
    Observaciones   VARCHAR(300)    NULL,
    CONSTRAINT PK_EXPEDIENTE_CONDICION PRIMARY KEY (IdExpediente, IdCondicion),
    CONSTRAINT FK_EXPEDIENTE_CONDICION_EXPEDIENTE FOREIGN KEY (IdExpediente) REFERENCES dbo.EXPEDIENTE(IdExpediente),
    CONSTRAINT FK_EXPEDIENTE_CONDICION_CONDICION FOREIGN KEY (IdCondicion) REFERENCES dbo.CONDICION(IdCondicion)
);
GO

CREATE TABLE dbo.SUSCRIPCION
(
    IdSuscripcion       INT             IDENTITY(1,1),
    FechaInicio         DATE            NOT NULL CONSTRAINT DF_SUSCRIPCION_FechaInicio DEFAULT (CAST(GETDATE() AS DATE)),
    FechaVencimiento    AS (DATEADD(MONTH, 1, FechaInicio)) PERSISTED,
    IdCliente           INT             NOT NULL,
    IdMembresia         TINYINT         NOT NULL,
    IdEstatus           TINYINT         NOT NULL,
    CONSTRAINT PK_SUSCRIPCION PRIMARY KEY (IdSuscripcion),
    CONSTRAINT FK_SUSCRIPCION_CLIENTE FOREIGN KEY (IdCliente) REFERENCES dbo.CLIENTE(IdCliente),
    CONSTRAINT FK_SUSCRIPCION_MEMBRESIA FOREIGN KEY (IdMembresia) REFERENCES dbo.MEMBRESIA(IdMembresia),
    CONSTRAINT FK_SUSCRIPCION_ESTATUS_SUSCRIPCION FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_SUSCRIPCION(IdEstatusSuscripcion),
    CONSTRAINT CK_FechaVencimiento_SUSCRIPCION CHECK (FechaVencimiento > FechaInicio)
);
GO

-- Un socio solamente puede tener una suscripción activa a la vez
CREATE UNIQUE INDEX UX_SUSCRIPCION_Cliente_Activa
ON dbo.SUSCRIPCION (IdCliente)
WHERE IdEstatus = 2;
GO

CREATE TABLE dbo.CONTROL_ACCESO
(
    IdControlAcceso     INT             IDENTITY(1,1),
    FechaHoraEntrada    DATETIME2       NOT NULL,
    FechaHoraSalida     DATETIME2       NULL,
    IdCliente           INT             NOT NULL,
    IdSucursal          SMALLINT        NOT NULL,
    CONSTRAINT PK_CONTROL_ACCESO PRIMARY KEY (IdControlAcceso),
    CONSTRAINT FK_CONTROL_ACCESO_CLIENTE FOREIGN KEY (IdCliente) REFERENCES dbo.CLIENTE(IdCliente),
    CONSTRAINT FK_CONTROL_ACCESO_SUCURSAL FOREIGN KEY (IdSucursal) REFERENCES dbo.SUCURSAL(IdSucursal),
    CONSTRAINT CK_CONTROL_ACCESO_FechaHoraSalida CHECK (FechaHoraSalida IS NULL OR FechaHoraSalida >= FechaHoraEntrada)
);
GO

CREATE TABLE dbo.SALON
(
    IdSalon       INT             IDENTITY(1,1),
    NombreNumero  VARCHAR(20)     NOT NULL,
    IdSucursal    SMALLINT        NOT NULL,
    IdEstatus     TINYINT         NOT NULL,
    CONSTRAINT PK_SALON PRIMARY KEY (IdSalon),
    CONSTRAINT FK_SALON_SUCURSAL FOREIGN KEY (IdSucursal) REFERENCES dbo.SUCURSAL(IdSucursal),
    CONSTRAINT FK_SALON_ESTATUS_SALON FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_SALON(IdEstatusSalon),
    CONSTRAINT UQ_SALON_Sucursal_NombreNumero UNIQUE (IdSucursal, NombreNumero)
);
GO

-- CLASE: Incluye columna IdEspecialidad y su llave foránea correspondiente
CREATE TABLE dbo.CLASE
(
    IdClase         INT             IDENTITY(1,1),
    Nombre          VARCHAR(80)     NOT NULL,
    Fecha           DATE            NOT NULL,
    HoraInicio      TIME            NOT NULL,
    HoraFin         TIME            NOT NULL,
    CupoMaximo      SMALLINT        NOT NULL,
    IdSalon         INT             NOT NULL,
    IdEmpleado      INT             NOT NULL,
    IdEspecialidad  TINYINT         NULL,
    IdEstatus       TINYINT         NOT NULL,
    CONSTRAINT PK_CLASE PRIMARY KEY (IdClase),
    CONSTRAINT FK_CLASE_SALON FOREIGN KEY (IdSalon) REFERENCES dbo.SALON(IdSalon),
    CONSTRAINT FK_CLASE_EMPLEADO FOREIGN KEY (IdEmpleado) REFERENCES dbo.EMPLEADO(IdEmpleado),
    CONSTRAINT FK_CLASE_ESPECIALIDAD FOREIGN KEY (IdEspecialidad) REFERENCES dbo.ESPECIALIDAD(IdEspecialidad),
    CONSTRAINT FK_CLASE_ESTATUS_CLASE FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_CLASE(IdEstatusClase),
    CONSTRAINT CK_CLASE_HoraFin CHECK (HoraFin > HoraInicio),
    CONSTRAINT CK_CLASE_CupoMaximo CHECK (CupoMaximo > 0)
);
GO

CREATE TABLE dbo.RESERVA
(
    IdReserva       INT             IDENTITY(1,1),
    FechaHora       DATETIME2       NOT NULL,
    IdClase         INT             NOT NULL,
    IdCliente       INT             NOT NULL,
    IdEmpleado      INT             NOT NULL,
    IdEstatus       TINYINT         NOT NULL,
    CONSTRAINT PK_RESERVA PRIMARY KEY (IdReserva),
    CONSTRAINT FK_RESERVA_CLASE FOREIGN KEY (IdClase) REFERENCES dbo.CLASE(IdClase),
    CONSTRAINT FK_RESERVA_CLIENTE FOREIGN KEY (IdCliente) REFERENCES dbo.CLIENTE(IdCliente),
    CONSTRAINT FK_RESERVA_EMPLEADO FOREIGN KEY (IdEmpleado) REFERENCES dbo.EMPLEADO(IdEmpleado),
    CONSTRAINT FK_RESERVA_ESTATUS_RESERVA FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_RESERVA(IdEstatusReserva)
);
GO

CREATE TABLE dbo.EJERCICIO
(
    IdEjercicio       INT             IDENTITY(1,1),
    Nombre            VARCHAR(80)     NOT NULL,
    Descripcion       VARCHAR(300)    NOT NULL,
    IdGrupoMuscular   SMALLINT        NOT NULL,
    IdDificultad      TINYINT         NOT NULL,
    CONSTRAINT PK_EJERCICIO PRIMARY KEY (IdEjercicio),
    CONSTRAINT FK_EJERCICIO_GRUPO_MUSCULAR FOREIGN KEY (IdGrupoMuscular) REFERENCES dbo.GRUPO_MUSCULAR(IdGrupoMuscular),
    CONSTRAINT FK_EJERCICIO_DIFICULTAD FOREIGN KEY (IdDificultad) REFERENCES dbo.DIFICULTAD(IdDificultad)
);
GO

CREATE TABLE dbo.EJERCICIO_CONTRAINDICACION
(
    IdEjercicio    INT             NOT NULL,
    IdCondicion    TINYINT         NOT NULL,
    CONSTRAINT PK_EJERCICIO_CONTRAINDICACION PRIMARY KEY (IdEjercicio, IdCondicion),
    CONSTRAINT FK_EJERCICIO_CONTRAINDICACION_EJERCICIO FOREIGN KEY (IdEjercicio) REFERENCES dbo.EJERCICIO(IdEjercicio),
    CONSTRAINT FK_EJERCICIO_CONTRAINDICACION_CONDICION FOREIGN KEY (IdCondicion) REFERENCES dbo.CONDICION(IdCondicion)
);
GO

CREATE TABLE dbo.RUTINA
(
    IdRutina            INT             IDENTITY(1,1),
    Nombre              VARCHAR(50)     NOT NULL,
    FechaAsignacion     DATE            NOT NULL CONSTRAINT DF_RUTINA_FechaAsignacion DEFAULT (CAST(GETDATE() AS DATE)),
    Objetivo            VARCHAR(300)    NOT NULL,
    IdCliente           INT             NOT NULL,
    IdEmpleado          INT             NOT NULL,
    IdEstatus           TINYINT         NOT NULL,
    CONSTRAINT PK_RUTINA PRIMARY KEY (IdRutina),
    CONSTRAINT FK_RUTINA_CLIENTE FOREIGN KEY (IdCliente) REFERENCES dbo.CLIENTE(IdCliente),
    CONSTRAINT FK_RUTINA_EMPLEADO FOREIGN KEY (IdEmpleado) REFERENCES dbo.EMPLEADO(IdEmpleado),
    CONSTRAINT FK_RUTINA_ESTATUS_RUTINA FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_RUTINA(IdEstatusRutina)
);
GO

CREATE TABLE dbo.DETALLE_RUTINA
(
    IdDetalleRutina  INT             IDENTITY(1,1),
    DiaSemana        TINYINT         NOT NULL,
    Series           TINYINT         NOT NULL,
    Repeticiones     VARCHAR(30)     NOT NULL,
    TiempoDescanso   SMALLINT        NOT NULL,
    IdRutina         INT             NOT NULL,
    IdEjercicio      INT             NOT NULL,
    CONSTRAINT PK_DETALLE_RUTINA PRIMARY KEY (IdDetalleRutina),
    CONSTRAINT FK_DETALLE_RUTINA_RUTINA FOREIGN KEY (IdRutina) REFERENCES dbo.RUTINA(IdRutina),
    CONSTRAINT FK_DETALLE_RUTINA_EJERCICIO FOREIGN KEY (IdEjercicio) REFERENCES dbo.EJERCICIO(IdEjercicio),
    CONSTRAINT CK_DETALLE_RUTINA_DiaSemana CHECK (DiaSemana BETWEEN 1 AND 7),
    CONSTRAINT CK_DETALLE_RUTINA_Series CHECK (Series > 0),
    CONSTRAINT CK_DETALLE_RUTINA_TiempoDescanso CHECK (TiempoDescanso >= 0)
);
GO

-------------------------------------------------------------
-- 4. SEGURIDAD Y AUDITORÍA
-------------------------------------------------------------

CREATE TABLE dbo.USUARIO
(
    IdUsuario       INT             IDENTITY(1,1),
    NombreCuenta    VARCHAR(160)    NOT NULL,
    Contrasena      NVARCHAR(255)   NOT NULL,
    FechaRegistro   DATETIME2       NOT NULL CONSTRAINT DF_USUARIO_FechaRegistro DEFAULT (SYSDATETIME()),
    IdRol           TINYINT         NOT NULL,
    IdEmpleado      INT             NOT NULL,
    IdEstatus       TINYINT         NOT NULL,
    CONSTRAINT PK_USUARIO PRIMARY KEY (IdUsuario),
    CONSTRAINT FK_USUARIO_ROL FOREIGN KEY (IdRol) REFERENCES dbo.ROL(IdRol),
    CONSTRAINT FK_USUARIO_EMPLEADO FOREIGN KEY (IdEmpleado) REFERENCES dbo.EMPLEADO(IdEmpleado),
    CONSTRAINT FK_USUARIO_ESTATUS_USUARIO FOREIGN KEY (IdEstatus) REFERENCES dbo.ESTATUS_USUARIO(IdEstatusUsuario),
    CONSTRAINT UQ_USUARIO_NombreCuenta UNIQUE (NombreCuenta),
    CONSTRAINT UQ_USUARIO_IdEmpleado UNIQUE (IdEmpleado)
);
GO

CREATE TABLE dbo.AUDITORIA
(
    IdAuditoria        BIGINT          IDENTITY(1,1),
    NombreTabla        VARCHAR(30)     NOT NULL,
    IdRegistro         INT             NOT NULL,
    TipoOperacion      VARCHAR(10)     NOT NULL,
    FechaOperacion     DATETIME2       NOT NULL CONSTRAINT DF_AUDITORIA_FechaOperacion DEFAULT (SYSDATETIME()),
    ValoresAnteriores  NVARCHAR(MAX)   NULL,
    ValoresNuevos      NVARCHAR(MAX)   NULL,
    IdUsuario          INT             NULL,
    CONSTRAINT PK_AUDITORIA PRIMARY KEY (IdAuditoria),
    CONSTRAINT FK_AUDITORIA_USUARIO FOREIGN KEY (IdUsuario) REFERENCES dbo.USUARIO(IdUsuario),
    CONSTRAINT CK_AUDITORIA_TipoOperacion CHECK (TipoOperacion IN ('INSERT', 'UPDATE', 'DELETE', 'BAJA')),
    CONSTRAINT CK_AUDITORIA_ValoresAnteriores CHECK (ValoresAnteriores IS NULL OR ISJSON(ValoresAnteriores) = 1),
    CONSTRAINT CK_AUDITORIA_ValoresNuevos CHECK (ValoresNuevos IS NULL OR ISJSON(ValoresNuevos) = 1)
);
GO

-------------------------------------------------------------
-- 5. REGISTROS INICIALES Y DATOS SEMILLA
-------------------------------------------------------------

-- ESTATUS_EMPLEADO
INSERT INTO dbo.ESTATUS_EMPLEADO (Nombre) VALUES ('Activo'), ('Inactivo'), ('Baja');

-- ESTATUS_SUCURSAL
INSERT INTO dbo.ESTATUS_SUCURSAL (Nombre) VALUES ('Activa'), ('Inactiva'), ('En remodelación');

-- ESTATUS_CLIENTE
INSERT INTO dbo.ESTATUS_CLIENTE (Nombre) VALUES ('Activo'), ('Inactivo'), ('Suspendido');

-- ESTATUS_SUSCRIPCION
INSERT INTO dbo.ESTATUS_SUSCRIPCION (Nombre) VALUES ('Pendiente'), ('Activa'), ('Vencida'), ('Cancelada');

-- ESTATUS_SALON
INSERT INTO dbo.ESTATUS_SALON (Nombre) VALUES ('Disponible'), ('Mantenimiento'), ('Fuera de servicio');

-- ESTATUS_CLASE
INSERT INTO dbo.ESTATUS_CLASE (Nombre) VALUES ('Programada'), ('Cancelada'), ('Finalizada');

-- ESTATUS_RESERVA: 1=Confirmada, 2=Cancelada, 3=Asistió, 4=No asistió
INSERT INTO dbo.ESTATUS_RESERVA (Nombre)
VALUES
    ('Confirmada'),
    ('Cancelada'),
    ('Asistió'),
    ('No asistió');

-- ESTATUS_RUTINA: 1=Activa, 2=Finalizada, 3=Suspendida
INSERT INTO dbo.ESTATUS_RUTINA (Nombre) VALUES ('Activa'), ('Finalizada'), ('Suspendida');

-- ESTATUS_USUARIO: 1=Activo, 2=Inactivo, 3=Bloqueado
INSERT INTO dbo.ESTATUS_USUARIO (Nombre) VALUES ('Activo'), ('Inactivo'), ('Bloqueado');

-- PUESTO
INSERT INTO dbo.PUESTO (Nombre, Descripcion)
VALUES
    ('Gerente de sucursal', 'Responsable de administrar y supervisar las operaciones de la sucursal.'),
    ('Entrenador', 'Encargado de orientar a los clientes y elaborar sus rutinas de entrenamiento.'),
    ('Personal de limpieza', 'Responsable de mantener limpias e higiénicas las instalaciones.'),
    ('Recepcionista', 'Encargado de atender a los clientes y gestionar registros y reservas.'),
    ('Técnico de mantenimiento', 'Responsable de revisar y mantener los equipos e instalaciones.');

-- ESPECIALIDAD
INSERT INTO dbo.ESPECIALIDAD (Nombre, Descripcion)
VALUES
    ('Pesas', 'Entrenamiento de fuerza mediante el uso de pesas y máquinas de resistencia.'),
    ('CrossFit', 'Entrenamiento funcional de alta intensidad que combina fuerza y resistencia.'),
    ('Yoga', 'Disciplina enfocada en flexibilidad, equilibrio, respiración y control corporal.'),
    ('Spinning', 'Entrenamiento cardiovascular realizado mediante bicicletas estáticas.'),
    ('Pilates', 'Método de entrenamiento enfocado en estabilidad, postura y fortalecimiento muscular.'),
    ('Entrenamiento funcional', 'Entrenamiento basado en movimientos que desarrollan capacidades físicas generales.'),
    ('Acondicionamiento físico', 'Entrenamiento orientado a mejorar la resistencia y condición física general.'),
    ('Calistenia', 'Entrenamiento de fuerza mediante ejercicios que utilizan principalmente el peso corporal.');

-- GRUPO_MUSCULAR
INSERT INTO dbo.GRUPO_MUSCULAR (Nombre, Descripcion)
VALUES
    ('Pecho', 'Grupo muscular del torso anterior involucrado en movimientos de empuje.'),
    ('Espalda', 'Grupo muscular del torso posterior involucrado en movimientos de tracción y estabilidad.'),
    ('Hombros', 'Grupo muscular que permite la movilidad y estabilidad de los brazos.'),
    ('Bíceps', 'Músculos de la parte anterior del brazo que participan en la flexión del codo.'),
    ('Tríceps', 'Músculos de la parte posterior del brazo que participan en la extensión del codo.'),
    ('Abdomen', 'Músculos de la región abdominal que contribuyen a la estabilidad del tronco.'),
    ('Cuádriceps', 'Grupo muscular de la parte anterior del muslo que participa en la extensión de la rodilla.'),
    ('Isquiotibiales', 'Grupo muscular de la parte posterior del muslo que participa en la flexión de la rodilla y extensión de la cadera.'),
    ('Glúteos', 'Grupo muscular de la región posterior de la cadera involucrado en la extensión y estabilización.'),
    ('Pantorrillas', 'Grupo muscular de la parte posterior de la pierna que participa en la flexión plantar del pie.');

-- DIFICULTAD
INSERT INTO dbo.DIFICULTAD (Nombre, Descripcion)
VALUES
    ('Principiante', 'Ejercicios de baja complejidad para personas que comienzan a entrenar.'),
    ('Intermedio', 'Ejercicios que requieren experiencia y una condición física moderada.'),
    ('Avanzado', 'Ejercicios de alta complejidad que requieren experiencia y buena condición física.');

-- ROL: 1=Administrador, 2=Recepcionista, 3=Entrenador
INSERT INTO dbo.ROL (Nombre, Descripcion)
VALUES
    ('Administrador', 'Acceso total a la administración general del sistema.'),
    ('Recepcionista', 'Acceso limitado a sucursal asignada: socios, control de acceso y reservas.'),
    ('Entrenador', 'Acceso limitado: consulta de expediente médico, asistencia de clases y rutinas.');

-- CONDICION
INSERT INTO dbo.CONDICION (Nombre, Tipo, Descripcion)
VALUES
    ('Hipertensión arterial', 'Riesgo', 'Presión sanguínea crónicamente elevada. Evitar esfuerzos isométricos extremos.'),
    ('Lesión de columna lumbar', 'Lesión', 'Hernia o degeneración en discos lumbares. Evitar sobrecarga axial.'),
    ('Lesión de menisco', 'Lesión', 'Afección en la articulación de la rodilla. Evitar impacto y flexiones profundas.'),
    ('Asma bronquial', 'Padecimiento', 'Afección respiratoria reactiva. Cuidar descansos y ventilación.'),
    ('Alergia al látex', 'Alergia', 'Reacción al contacto con bandas de resistencia u otros artículos de goma.'),
    ('Tendinitis de manguito rotador', 'Lesión', 'Inflamación de tendones en hombro. Evitar elevaciones laterales pesadas.');

-- MEMBRESIA
INSERT INTO dbo.MEMBRESIA (Nombre, Precio, Descripcion, PermiteClases, MaxClasesSemana, SujetaAforo)
VALUES
    ('Bronce', 500.00, 'Permite únicamente el acceso a las instalaciones del gimnasio.', 0, 0, 0),
    ('Plata', 1000.00, 'Permite agendar hasta 3 clases por semana, sujeto al aforo disponible.', 1, 3, 1),
    ('Oro', 1500.00, 'Permite agendar hasta 5 clases por semana, sin restricciones de aforo.', 1, 5, 0);

-- SUCURSAL INICIAL
INSERT INTO dbo.SUCURSAL
    (Nombre, Telefono, NumeroExterior, NumeroInterior, Calle, Colonia, Ciudad, Estado, AforoMaximo, HoraApertura, HoraCierre, IdEstatus)
VALUES
    ('Sucursal Central', '8111223344', '100', NULL, 'Av. Universidad', 'Centro', 'Monterrey', 'Nuevo León', 150, '06:00:00', '22:00:00', 1);

-- EMPLEADO INICIAL (Administrador General del Sistema)
INSERT INTO dbo.EMPLEADO
    (Nombres, PrimerApellido, SegundoApellido, CURP, Telefono, Correo, FechaNacimiento, FechaContratacion, IdPuesto, IdSucursal, IdEstatus)
VALUES
    ('Administrador', 'General', 'Sistema', 'ADMI000101HNLXXX01', '8199887766', 'admin@gymsystem.com', '1990-01-01', CAST(GETDATE() AS DATE), 1, 1, 1),
    ('Recepcionista', 'General', 'Sistema', 'RECE000101HNLXXX01', '8199887765', 'recep@gymsystem.com', '1990-01-01', CAST(GETDATE() AS DATE), 4, 1, 1),
    ('Entrenador', 'General', 'Sistema', 'ENTR000101HNLXXX01', '8199887764', 'entre@gymsystem.com', '1990-01-01', CAST(GETDATE() AS DATE), 2, 1, 1);

INSERT INTO dbo.USUARIO
    (NombreCuenta, Contrasena, FechaRegistro, IdRol, IdEmpleado, IdEstatus)
VALUES
    ('admin', 'Admin123!', SYSDATETIME(), 1, 1, 1),
    ('recepcionista', 'Recepcionista123!', SYSDATETIME(), 2, 2, 1),
    ('entrenador', 'Entrenador123!', SYSDATETIME(), 3, 3, 1);
GO

-------------------------------------------------------------
-- 6. DATOS DE DEMOSTRACIÓN (PRUEBA)
-------------------------------------------------------------

-- ============================================================
-- SUCURSALES ADICIONALES
-- ============================================================
INSERT INTO dbo.SUCURSAL
    (Nombre, Telefono, NumeroExterior, NumeroInterior, Calle, Colonia, Ciudad, Estado, AforoMaximo, HoraApertura, HoraCierre, IdEstatus)
VALUES
    ('Sucursal Norte',  '8121334455', '250', 'Local 3', 'Av. Constitución', 'Mitras Norte',  'Monterrey', 'Nuevo León', 100, '05:30:00', '21:30:00', 1),
    ('Sucursal Sur',    '8132445566', '45',  NULL,       'Blvd. Díaz Ordaz', 'Del Valle',     'San Pedro Garza García', 'Nuevo León', 80, '06:00:00', '22:00:00', 1);

-- ============================================================
-- SALONES
-- ============================================================
INSERT INTO dbo.SALON (NombreNumero, IdSucursal, IdEstatus)
VALUES
    ('Salón A',     1, 1),
    ('Salón B',     1, 1),
    ('Salón Spin',  2, 1),
    ('Salón Yoga',  3, 1);

-- ============================================================
-- EMPLEADOS ADICIONALES (Recepcionista, Entrenadores)
-- ============================================================
INSERT INTO dbo.EMPLEADO
    (Nombres, PrimerApellido, SegundoApellido, CURP, Telefono, Correo, FechaNacimiento, FechaContratacion, IdPuesto, IdSucursal, IdEstatus)
VALUES
    -- Recepcionista - Sucursal Central
    ('Laura',    'Martínez', 'Soto',    'MASL950310MNLRTR09', '8111000001', 'laura.martinez@gym.com',  '1995-03-10', '2022-01-15', 4, 1, 1),
    -- Entrenador 1 - Sucursal Central
    ('Carlos',   'Ramírez',  'Flores',  'RAFC880720HNLMLR02', '8111000002', 'carlos.ramirez@gym.com',  '1988-07-20', '2021-06-01', 2, 1, 1),
    -- Entrenador 2 - Sucursal Norte
    ('Sofía',    'González', 'López',   'GOLS910415MNLLPF07', '8111000003', 'sofia.gonzalez@gym.com',  '1991-04-15', '2022-03-10', 2, 2, 1),
    -- Recepcionista - Sucursal Sur
    ('Miguel',   'Torres',   'Herrera', 'TOHM930825HNLRRG05', '8111000004', 'miguel.torres@gym.com',   '1993-08-25', '2023-01-05', 4, 3, 1);

-- Especialidades de los entrenadores
INSERT INTO dbo.EMPLEADO_ESPECIALIDAD (IdEmpleado, IdEspecialidad)
VALUES
    (2, 1), (2, 6),   -- Carlos: Pesas, Entrenamiento funcional
    (3, 4), (3, 7),   -- Sofía: Spinning, Acondicionamiento físico
    (3, 5);           -- Sofía también: Pilates

-- ============================================================
-- CUENTAS DE USUARIO ADICIONALES
-- ============================================================
INSERT INTO dbo.USUARIO
    (NombreCuenta, Contrasena, FechaRegistro, IdRol, IdEmpleado, IdEstatus)
VALUES
    ('recepcion1', 'Recep123!', SYSDATETIME(), 2, 2, 1),  -- Laura (Recepcionista)
    ('carlos.e',   'Train123!', SYSDATETIME(), 3, 3, 1),  -- Carlos (Entrenador)
    ('sofia.e',    'Train456!', SYSDATETIME(), 3, 4, 1);  -- Sofía (Entrenador)

-- ============================================================
-- CLIENTES / SOCIOS
-- ============================================================
INSERT INTO dbo.CLIENTE
    (Nombres, PrimerApellido, SegundoApellido, Telefono, Correo, FechaNacimiento, FechaInscripcion, IdSucursal, IdEstatus)
VALUES
    ('Andrés',    'Vega',      'Morales',  '8190001001', 'andres.vega@mail.com',    '1992-05-14', '2024-01-10', 1, 1),
    ('Mariana',   'Peña',      'Ríos',     '8190001002', 'mariana.pena@mail.com',   '1998-11-22', '2024-02-01', 1, 1),
    ('Roberto',   'Salinas',   'Cruz',     '8190001003', 'roberto.salinas@mail.com','1985-03-30', '2024-03-15', 2, 1),
    ('Fernanda',  'Chávez',    NULL,       '8190001004', 'fernanda.chavez@mail.com','2000-07-08', '2024-04-20', 1, 1),
    ('Diego',     'Moreno',    'Estrada',  '8190001005', 'diego.moreno@mail.com',   '1990-09-01', '2024-05-05', 3, 1),
    ('Valentina', 'Herrero',   'Blanco',   '8190001006', 'valentina.herrero@mail.com','1995-12-19','2024-06-01',2, 1);

-- ============================================================
-- SUSCRIPCIONES (Acción 1 equivalente: INSERT directo con IdEstatus=2 Activa)
-- ============================================================
INSERT INTO dbo.SUSCRIPCION (FechaInicio, IdCliente, IdMembresia, IdEstatus)
VALUES
    ('2025-10-01', 1, 3, 2),  -- Andrés: Oro (Activa)
    ('2025-10-15', 2, 2, 2),  -- Mariana: Plata (Activa)
    ('2025-09-01', 3, 1, 3),  -- Roberto: Bronce (Vencida)
    ('2025-11-01', 4, 2, 2),  -- Fernanda: Plata (Activa)
    ('2025-10-10', 5, 3, 2),  -- Diego: Oro (Activa)
    ('2025-10-20', 6, 1, 2);  -- Valentina: Bronce (Activa)

-- ============================================================
-- EXPEDIENTES MÉDICOS
-- ============================================================
INSERT INTO dbo.EXPEDIENTE (IdCliente, TipoSangre)
VALUES
    (1, 'O+'),   -- Andrés
    (2, 'A+'),   -- Mariana
    (3, 'B-'),   -- Roberto
    (4, 'AB+'),  -- Fernanda
    (5, 'O-'),   -- Diego
    (6, 'A-');   -- Valentina

-- Condiciones médicas asociadas
INSERT INTO dbo.EXPEDIENTE_CONDICION (IdExpediente, IdCondicion, Observaciones)
VALUES
    (3, 1, 'Hipertensión controlada con medicamento. Supervisión en ejercicios isométricos.'),  -- Roberto: Hipertensión
    (3, 2, 'Hernia L4-L5 diagnosticada en 2022. Evitar peso axial.'),                          -- Roberto: Columna lumbar
    (5, 3, 'Lesión de menisco derecho operado en 2021. Sin impacto directo.'),                  -- Diego: Menisco
    (6, 4, 'Asma bronquial leve. Llevar inhalador al entrenamiento.');                          -- Valentina: Asma

-- ============================================================
-- CONTROL DE ACCESO
-- ============================================================
INSERT INTO dbo.CONTROL_ACCESO (FechaHoraEntrada, FechaHoraSalida, IdCliente, IdSucursal)
VALUES
    ('2025-11-01 07:15:00', '2025-11-01 09:00:00', 1, 1),
    ('2025-11-01 08:30:00', '2025-11-01 10:10:00', 2, 1),
    ('2025-11-02 06:45:00', '2025-11-02 08:30:00', 4, 1),
    ('2025-11-03 07:00:00', '2025-11-03 08:50:00', 1, 1),
    ('2025-11-03 09:00:00', NULL,                   5, 3),  -- Diego aún en instalaciones
    ('2025-11-04 07:30:00', '2025-11-04 09:15:00', 2, 1),
    ('2025-11-05 08:00:00', '2025-11-05 09:45:00', 6, 2);

-- ============================================================
-- CLASES GRUPALES
-- ============================================================
INSERT INTO dbo.CLASE (Nombre, Fecha, HoraInicio, HoraFin, CupoMaximo, IdSalon, IdEmpleado, IdEspecialidad, IdEstatus)
VALUES
    ('Pesas Funcional - Mañana',  '2025-11-07', '07:00:00', '08:00:00', 15, 1, 3, 1, 1),  -- Carlos, Salón A, Programada
    ('Spinning Intensivo',         '2025-11-07', '09:00:00', '10:00:00', 20, 3, 4, 4, 1),  -- Sofía, Salón Spin, Programada
    ('Yoga Restaurativo',          '2025-11-08', '10:00:00', '11:00:00', 12, 4, 4, 3, 1),  -- Sofía, Salón Yoga, Programada
    ('Funcional Avanzado',         '2025-11-05', '07:00:00', '08:00:00', 10, 2, 3, 6, 3),  -- Carlos, Salón B, Finalizada
    ('Pilates Core',               '2025-11-10', '08:00:00', '09:00:00', 10, 4, 4, 5, 1);  -- Sofía, Salón Yoga, Programada

-- ============================================================
-- RESERVAS
-- ============================================================
INSERT INTO dbo.RESERVA (FechaHora, IdClase, IdCliente, IdEmpleado, IdEstatus)
VALUES
    ('2025-11-05 06:30:00', 4, 1, 3, 3),  -- Andrés reservó Funcional Avanzado → Asistió
    ('2025-11-05 06:35:00', 4, 2, 3, 3),  -- Mariana reservó Funcional Avanzado → Asistió
    ('2025-11-05 06:40:00', 4, 4, 3, 4),  -- Fernanda reservó Funcional Avanzado → No asistió
    ('2025-11-07 06:50:00', 1, 1, 3, 1),  -- Andrés reservó Pesas Funcional → Confirmada
    ('2025-11-07 06:55:00', 1, 2, 3, 1),  -- Mariana reservó Pesas Funcional → Confirmada
    ('2025-11-07 08:30:00', 2, 5, 3, 1),  -- Diego reservó Spinning → Confirmada
    ('2025-11-08 09:30:00', 3, 6, 3, 1);  -- Valentina reservó Yoga → Confirmada

-- ============================================================
-- EJERCICIOS
-- ============================================================
INSERT INTO dbo.EJERCICIO (Nombre, Descripcion, IdGrupoMuscular, IdDificultad)
VALUES
    ('Press de banca plano',      'Empuje horizontal con barra acostado en banco plano.',          1, 2),  -- Pecho, Intermedio
    ('Sentadilla con barra',      'Sentadilla profunda con barra sobre los hombros.',              7, 2),  -- Cuádriceps, Intermedio
    ('Peso muerto convencional',  'Levantamiento de barra desde el piso con espalda neutral.',     2, 3),  -- Espalda, Avanzado
    ('Curl de bíceps con mancuernas','Flexión de codo con mancuernas, alternada.',                4, 1),  -- Bíceps, Principiante
    ('Extensión de tríceps en polea','Empuje descendente en polea alta para tríceps.',            5, 1),  -- Tríceps, Principiante
    ('Plancha abdominal',         'Posición isométrica en prono para trabajar el core.',           6, 1),  -- Abdomen, Principiante
    ('Hip thrust',                'Empuje de cadera con barra para glúteos.',                      9, 2),  -- Glúteos, Intermedio
    ('Elevación de talones',      'Movimiento de flexión plantar de pie en máquina.',              10, 1), -- Pantorrillas, Principiante
    ('Press militar con barra',   'Empuje vertical de barra sobre la cabeza en posición de pie.',  3, 2),  -- Hombros, Intermedio
    ('Remo con barra',            'Tracción horizontal de barra hacia el abdomen inclinado.',      2, 2);  -- Espalda, Intermedio

-- Contraindicaciones de ejercicios
INSERT INTO dbo.EJERCICIO_CONTRAINDICACION (IdEjercicio, IdCondicion)
VALUES
    (2, 3),  -- Sentadilla → contraindicada con Lesión de menisco
    (3, 2),  -- Peso muerto → contraindicado con Lesión de columna lumbar
    (3, 1),  -- Peso muerto → contraindicado con Hipertensión arterial
    (9, 6),  -- Press militar → contraindicado con Tendinitis de manguito rotador
    (7, 3);  -- Hip thrust → contraindicado con Lesión de menisco

-- ============================================================
-- RUTINAS Y DETALLES
-- ============================================================
INSERT INTO dbo.RUTINA (Nombre, FechaAsignacion, Objetivo, IdCliente, IdEmpleado, IdEstatus)
VALUES
    ('Hipertrofia Torso-Pierna',     '2025-10-20', 'Ganancia de masa muscular en tren superior e inferior alternado, 8 semanas.', 1, 3, 1), -- Andrés, Carlos, Activa
    ('Acondicionamiento Inicial',    '2025-10-25', 'Mejora de condición física general y adaptación al ejercicio para principiante.', 2, 3, 1), -- Mariana, Carlos, Activa
    ('Rehabilitación y Movilidad',   '2025-10-15', 'Plan adaptado con restricciones médicas: sin peso axial ni impacto en rodilla.', 5, 3, 1); -- Diego, Carlos, Activa

-- Detalles de Rutina 1 (Andrés): Lunes Pecho/Tríceps, Miércoles Pierna
INSERT INTO dbo.DETALLE_RUTINA (DiaSemana, Series, Repeticiones, TiempoDescanso, IdRutina, IdEjercicio)
VALUES
    (1, 4, '10-12', 90, 1, 1),  -- Lunes: Press banca
    (1, 3, '12',    60, 1, 5),  -- Lunes: Tríceps polea
    (3, 4, '12',    90, 1, 7),  -- Miércoles: Hip thrust
    (3, 3, '15',    45, 1, 8),  -- Miércoles: Elevación de talones
    (5, 4, '8-10',  90, 1, 9);  -- Viernes: Press militar

-- Detalles de Rutina 2 (Mariana): Lunes y Jueves cuerpo completo
INSERT INTO dbo.DETALLE_RUTINA (DiaSemana, Series, Repeticiones, TiempoDescanso, IdRutina, IdEjercicio)
VALUES
    (1, 3, '12',    60, 2, 4),  -- Lunes: Curl bíceps
    (1, 3, '15',    45, 2, 6),  -- Lunes: Plancha
    (4, 3, '12',    60, 2, 5),  -- Jueves: Tríceps
    (4, 3, '15',    45, 2, 8);  -- Jueves: Pantorrillas

-- Detalles de Rutina 3 (Diego): Martes y Viernes (sin sentadilla ni peso muerto)
INSERT INTO dbo.DETALLE_RUTINA (DiaSemana, Series, Repeticiones, TiempoDescanso, IdRutina, IdEjercicio)
VALUES
    (2, 3, '12',    60, 3, 1),  -- Martes: Press banca
    (2, 3, '15',    45, 3, 6),  -- Martes: Plancha
    (5, 3, '12',    60, 3, 4),  -- Viernes: Curl bíceps
    (5, 3, '12',    60, 3, 10); -- Viernes: Remo con barra

-------------------------------------------------------------
-- 7. PROCEDIMIENTOS ALMACENADOS DE CATÁLOGOS BASE
-------------------------------------------------------------

-- SP_GRUPO_MUSCULAR
CREATE OR ALTER PROCEDURE dbo.SP_GRUPO_MUSCULAR
(
    @Accion             INT             = NULL,
    @IdGrupoMuscular    SMALLINT        = NULL,
    @Nombre             VARCHAR(30)     = NULL,
    @Descripcion        VARCHAR(300)    = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        IF @Nombre IS NULL OR TRIM(@Nombre) = '' OR @Descripcion IS NULL OR TRIM(@Descripcion) = ''
        BEGIN
            SELECT 'El nombre y la descripción son obligatorios.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.GRUPO_MUSCULAR WHERE Nombre = TRIM(@Nombre))
        BEGIN
            SELECT 'Ya existe un grupo muscular con ese nombre.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.GRUPO_MUSCULAR (Nombre, Descripcion)
        VALUES (TRIM(@Nombre), TRIM(@Descripcion));

        SET @IdGrupoMuscular = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.GRUPO_MUSCULAR WHERE IdGrupoMuscular = @IdGrupoMuscular FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('GRUPO_MUSCULAR', @IdGrupoMuscular, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Grupo muscular registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Consultar por Id
    BEGIN
        SELECT IdGrupoMuscular, Nombre, Descripcion
        FROM dbo.GRUPO_MUSCULAR
        WHERE IdGrupoMuscular = @IdGrupoMuscular;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT IdGrupoMuscular, Nombre, Descripcion
        FROM dbo.GRUPO_MUSCULAR
        WHERE (@Nombre IS NULL OR Nombre LIKE '%' + TRIM(@Nombre) + '%')
        ORDER BY Nombre;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.GRUPO_MUSCULAR WHERE IdGrupoMuscular = @IdGrupoMuscular)
        BEGIN
            SELECT 'El grupo muscular no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.GRUPO_MUSCULAR WHERE IdGrupoMuscular = @IdGrupoMuscular FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.GRUPO_MUSCULAR
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Descripcion = COALESCE(NULLIF(TRIM(@Descripcion), ''), Descripcion)
        WHERE IdGrupoMuscular = @IdGrupoMuscular;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.GRUPO_MUSCULAR WHERE IdGrupoMuscular = @IdGrupoMuscular FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('GRUPO_MUSCULAR', @IdGrupoMuscular, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Grupo muscular actualizado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Eliminar
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.EJERCICIO WHERE IdGrupoMuscular = @IdGrupoMuscular)
        BEGIN
            SELECT 'No se puede eliminar el grupo muscular porque está asignado a ejercicios.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.GRUPO_MUSCULAR WHERE IdGrupoMuscular = @IdGrupoMuscular FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        DELETE FROM dbo.GRUPO_MUSCULAR WHERE IdGrupoMuscular = @IdGrupoMuscular;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('GRUPO_MUSCULAR', @IdGrupoMuscular, 'DELETE', @ValoresAnteriores, @IdUsuario);

        SELECT 'Grupo muscular eliminado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_DIFICULTAD
CREATE OR ALTER PROCEDURE dbo.SP_DIFICULTAD
(
    @Accion         INT             = NULL,
    @IdDificultad   TINYINT         = NULL,
    @Nombre         VARCHAR(30)     = NULL,
    @Descripcion    VARCHAR(300)    = NULL,
    @IdUsuario      INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        INSERT INTO dbo.DIFICULTAD (Nombre, Descripcion)
        VALUES (TRIM(@Nombre), TRIM(@Descripcion));
        SET @IdDificultad = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.DIFICULTAD WHERE IdDificultad = @IdDificultad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('DIFICULTAD', @IdDificultad, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Dificultad registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Obtener por Id
    BEGIN
        SELECT IdDificultad, Nombre, Descripcion FROM dbo.DIFICULTAD WHERE IdDificultad = @IdDificultad;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT IdDificultad, Nombre, Descripcion FROM dbo.DIFICULTAD ORDER BY IdDificultad;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        SELECT @ValoresAnteriores = (SELECT * FROM dbo.DIFICULTAD WHERE IdDificultad = @IdDificultad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        UPDATE dbo.DIFICULTAD
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Descripcion = COALESCE(NULLIF(TRIM(@Descripcion), ''), Descripcion)
        WHERE IdDificultad = @IdDificultad;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.DIFICULTAD WHERE IdDificultad = @IdDificultad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('DIFICULTAD', @IdDificultad, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Dificultad modificada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_PUESTO
CREATE OR ALTER PROCEDURE dbo.SP_PUESTO
(
    @Accion         INT             = NULL,
    @IdPuesto       TINYINT         = NULL,
    @Nombre         VARCHAR(30)     = NULL,
    @Descripcion    VARCHAR(300)    = NULL,
    @IdUsuario      INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        INSERT INTO dbo.PUESTO (Nombre, Descripcion)
        VALUES (TRIM(@Nombre), TRIM(@Descripcion));
        SET @IdPuesto = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.PUESTO WHERE IdPuesto = @IdPuesto FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('PUESTO', @IdPuesto, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Puesto registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT IdPuesto, Nombre, Descripcion FROM dbo.PUESTO WHERE IdPuesto = @IdPuesto;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT IdPuesto, Nombre, Descripcion FROM dbo.PUESTO ORDER BY IdPuesto;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        SELECT @ValoresAnteriores = (SELECT * FROM dbo.PUESTO WHERE IdPuesto = @IdPuesto FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        UPDATE dbo.PUESTO
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Descripcion = COALESCE(NULLIF(TRIM(@Descripcion), ''), Descripcion)
        WHERE IdPuesto = @IdPuesto;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.PUESTO WHERE IdPuesto = @IdPuesto FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('PUESTO', @IdPuesto, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Puesto modificado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_ESPECIALIDAD
CREATE OR ALTER PROCEDURE dbo.SP_ESPECIALIDAD
(
    @Accion         INT             = NULL,
    @IdEspecialidad TINYINT         = NULL,
    @Nombre         VARCHAR(30)     = NULL,
    @Descripcion    VARCHAR(300)    = NULL,
    @IdUsuario      INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.ESPECIALIDAD WHERE Nombre = TRIM(@Nombre))
        BEGIN
            SELECT 'Ya existe una especialidad con ese nombre.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.ESPECIALIDAD (Nombre, Descripcion)
        VALUES (TRIM(@Nombre), TRIM(@Descripcion));
        SET @IdEspecialidad = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('ESPECIALIDAD', @IdEspecialidad, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Especialidad registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT IdEspecialidad, Nombre, Descripcion FROM dbo.ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT IdEspecialidad, Nombre, Descripcion FROM dbo.ESPECIALIDAD ORDER BY Nombre;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        SELECT @ValoresAnteriores = (SELECT * FROM dbo.ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        UPDATE dbo.ESPECIALIDAD
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Descripcion = COALESCE(NULLIF(TRIM(@Descripcion), ''), Descripcion)
        WHERE IdEspecialidad = @IdEspecialidad;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('ESPECIALIDAD', @IdEspecialidad, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Especialidad modificada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Eliminar
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.EMPLEADO_ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad)
           OR EXISTS (SELECT 1 FROM dbo.CLASE WHERE IdEspecialidad = @IdEspecialidad)
        BEGIN
            SELECT 'No se puede eliminar la especialidad porque está asociada a entrenadores o clases.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        DELETE FROM dbo.ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('ESPECIALIDAD', @IdEspecialidad, 'DELETE', @ValoresAnteriores, @IdUsuario);

        SELECT 'Especialidad eliminada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_CONDICION
CREATE OR ALTER PROCEDURE dbo.SP_CONDICION
(
    @Accion         INT             = NULL,
    @IdCondicion    TINYINT         = NULL,
    @Nombre         VARCHAR(50)     = NULL,
    @Tipo           VARCHAR(20)     = NULL,
    @Descripcion    VARCHAR(300)    = NULL,
    @IdUsuario      INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        IF @Tipo NOT IN ('Padecimiento', 'Lesión', 'Alergia', 'Riesgo')
        BEGIN
            SELECT 'El tipo de condición no es válido.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.CONDICION WHERE Nombre = TRIM(@Nombre))
        BEGIN
            SELECT 'Ya existe una condición con ese nombre.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.CONDICION (Nombre, Tipo, Descripcion)
        VALUES (TRIM(@Nombre), TRIM(@Tipo), TRIM(@Descripcion));
        SET @IdCondicion = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CONDICION WHERE IdCondicion = @IdCondicion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('CONDICION', @IdCondicion, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Condición registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT IdCondicion, Nombre, Tipo, Descripcion FROM dbo.CONDICION WHERE IdCondicion = @IdCondicion;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT IdCondicion, Nombre, Tipo, Descripcion
        FROM dbo.CONDICION
        WHERE (@Nombre IS NULL OR Nombre LIKE '%' + TRIM(@Nombre) + '%')
          AND (@Tipo IS NULL OR Tipo = @Tipo)
        ORDER BY Tipo, Nombre;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        SELECT @ValoresAnteriores = (SELECT * FROM dbo.CONDICION WHERE IdCondicion = @IdCondicion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        UPDATE dbo.CONDICION
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Tipo = COALESCE(NULLIF(TRIM(@Tipo), ''), Tipo),
            Descripcion = COALESCE(NULLIF(TRIM(@Descripcion), ''), Descripcion)
        WHERE IdCondicion = @IdCondicion;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CONDICION WHERE IdCondicion = @IdCondicion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('CONDICION', @IdCondicion, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Condición modificada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Eliminar
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.EXPEDIENTE_CONDICION WHERE IdCondicion = @IdCondicion)
           OR EXISTS (SELECT 1 FROM dbo.EJERCICIO_CONTRAINDICACION WHERE IdCondicion = @IdCondicion)
        BEGIN
            SELECT 'No se puede eliminar la condición porque está asociada a expedientes o contraindicaciones.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.CONDICION WHERE IdCondicion = @IdCondicion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        DELETE FROM dbo.CONDICION WHERE IdCondicion = @IdCondicion;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('CONDICION', @IdCondicion, 'DELETE', @ValoresAnteriores, @IdUsuario);

        SELECT 'Condición eliminada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_MEMBRESIA
CREATE OR ALTER PROCEDURE dbo.SP_MEMBRESIA
(
    @Accion             INT             = NULL,
    @IdMembresia        TINYINT         = NULL,
    @Nombre             VARCHAR(30)     = NULL,
    @Precio             DECIMAL(7,2)    = NULL,
    @Descripcion        VARCHAR(300)    = NULL,
    @PermiteClases      BIT             = NULL,
    @MaxClasesSemana    TINYINT         = NULL,
    @SujetaAforo        BIT             = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        INSERT INTO dbo.MEMBRESIA (Nombre, Precio, Descripcion, PermiteClases, MaxClasesSemana, SujetaAforo)
        VALUES (TRIM(@Nombre), @Precio, TRIM(@Descripcion), @PermiteClases, @MaxClasesSemana, @SujetaAforo);
        SET @IdMembresia = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.MEMBRESIA WHERE IdMembresia = @IdMembresia FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('MEMBRESIA', @IdMembresia, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Membresía registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT IdMembresia, Nombre, Precio, Descripcion, PermiteClases, MaxClasesSemana, SujetaAforo
        FROM dbo.MEMBRESIA
        WHERE IdMembresia = @IdMembresia;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT IdMembresia, Nombre, Precio, Descripcion, PermiteClases, MaxClasesSemana, SujetaAforo
        FROM dbo.MEMBRESIA
        ORDER BY Precio ASC;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        SELECT @ValoresAnteriores = (SELECT * FROM dbo.MEMBRESIA WHERE IdMembresia = @IdMembresia FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.MEMBRESIA
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Precio = COALESCE(@Precio, Precio),
            Descripcion = COALESCE(NULLIF(TRIM(@Descripcion), ''), Descripcion),
            PermiteClases = COALESCE(@PermiteClases, PermiteClases),
            MaxClasesSemana = COALESCE(@MaxClasesSemana, MaxClasesSemana),
            SujetaAforo = COALESCE(@SujetaAforo, SujetaAforo)
        WHERE IdMembresia = @IdMembresia;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.MEMBRESIA WHERE IdMembresia = @IdMembresia FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('MEMBRESIA', @IdMembresia, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Membresía modificada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO


-------------------------------------------------------------
-- 8. PROCEDIMIENTOS ALMACENADOS DE OPERACIÓN Y NEGOCIO (PARTE 1)
-------------------------------------------------------------

-- SP_SUCURSAL (Baja lógica y validación de clases futuras)
CREATE OR ALTER PROCEDURE dbo.SP_SUCURSAL
(
    @Accion             INT             = NULL,
    @IdSucursal         SMALLINT        = NULL,
    @Nombre             VARCHAR(80)     = NULL,
    @Telefono           VARCHAR(20)     = NULL,
    @NumeroExterior     VARCHAR(20)     = NULL,
    @NumeroInterior     VARCHAR(20)     = NULL,
    @Calle              VARCHAR(100)    = NULL,
    @Colonia            VARCHAR(100)    = NULL,
    @Ciudad             VARCHAR(100)    = NULL,
    @Estado             VARCHAR(100)    = NULL,
    @AforoMaximo        SMALLINT        = NULL,
    @HoraApertura       TIME            = NULL,
    @HoraCierre         TIME            = NULL,
    @IdEstatus          TINYINT         = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        IF @Nombre IS NULL OR TRIM(@Nombre) = '' OR @Telefono IS NULL OR TRIM(@Telefono) = ''
           OR @Calle IS NULL OR TRIM(@Calle) = '' OR @AforoMaximo IS NULL OR @AforoMaximo <= 0
        BEGIN
            SELECT 'Verifica los campos obligatorios y el aforo.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.SUCURSAL
            (Nombre, Telefono, NumeroExterior, NumeroInterior, Calle, Colonia, Ciudad, Estado, AforoMaximo, HoraApertura, HoraCierre, IdEstatus)
        VALUES
            (TRIM(@Nombre), TRIM(@Telefono), TRIM(@NumeroExterior), TRIM(@NumeroInterior),
             TRIM(@Calle), TRIM(@Colonia), TRIM(@Ciudad), TRIM(@Estado), @AforoMaximo,
             @HoraApertura, @HoraCierre, ISNULL(@IdEstatus, 1));

        SET @IdSucursal = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('SUCURSAL', @IdSucursal, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Sucursal registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT S.IdSucursal, S.Nombre, S.Telefono, S.NumeroExterior, S.NumeroInterior,
               S.Calle, S.Colonia, S.Ciudad, S.Estado, S.AforoMaximo,
               S.HoraApertura, S.HoraCierre, S.IdEstatus, E.Nombre AS Estatus
        FROM dbo.SUCURSAL S
        INNER JOIN dbo.ESTATUS_SUCURSAL E ON S.IdEstatus = E.IdEstatusSucursal
        WHERE S.IdSucursal = @IdSucursal;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT S.IdSucursal, S.Nombre, S.Telefono, S.NumeroExterior, S.NumeroInterior,
               S.Calle, S.Colonia, S.Ciudad, S.Estado, S.AforoMaximo,
               S.HoraApertura, S.HoraCierre, S.IdEstatus, E.Nombre AS Estatus
        FROM dbo.SUCURSAL S
        INNER JOIN dbo.ESTATUS_SUCURSAL E ON S.IdEstatus = E.IdEstatusSucursal
        WHERE (@Nombre IS NULL OR S.Nombre LIKE '%' + TRIM(@Nombre) + '%')
          AND (@Ciudad IS NULL OR S.Ciudad LIKE '%' + TRIM(@Ciudad) + '%')
          AND (@Estado IS NULL OR S.Estado LIKE '%' + TRIM(@Estado) + '%')
          AND (@IdEstatus IS NULL OR S.IdEstatus = @IdEstatus)
        ORDER BY S.Nombre;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal)
        BEGIN
            SELECT 'La sucursal no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Regla 6.4: Antes de cambiar a Inactiva o En remodelación, deben resolverse clases futuras
        IF @IdEstatus IN (2, 3)
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM dbo.CLASE C
                INNER JOIN dbo.SALON Sa ON C.IdSalon = Sa.IdSalon
                WHERE Sa.IdSucursal = @IdSucursal
                  AND C.IdEstatus = 1
                  AND (C.Fecha > CAST(GETDATE() AS DATE)
                       OR (C.Fecha = CAST(GETDATE() AS DATE) AND C.HoraFin > CAST(GETDATE() AS TIME)))
            )
            BEGIN
                SELECT 'Antes de cambiar la sucursal a Inactiva o En remodelación, deben cancelarse o reubicarse sus clases futuras.' AS Mensaje, 'warning' AS TipoMensaje;
                RETURN;
            END
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.SUCURSAL
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Telefono = COALESCE(NULLIF(TRIM(@Telefono), ''), Telefono),
            NumeroExterior = COALESCE(NULLIF(TRIM(@NumeroExterior), ''), NumeroExterior),
            NumeroInterior = COALESCE(TRIM(@NumeroInterior), NumeroInterior),
            Calle = COALESCE(NULLIF(TRIM(@Calle), ''), Calle),
            Colonia = COALESCE(NULLIF(TRIM(@Colonia), ''), Colonia),
            Ciudad = COALESCE(NULLIF(TRIM(@Ciudad), ''), Ciudad),
            Estado = COALESCE(NULLIF(TRIM(@Estado), ''), Estado),
            AforoMaximo = COALESCE(@AforoMaximo, AforoMaximo),
            HoraApertura = COALESCE(@HoraApertura, HoraApertura),
            HoraCierre = COALESCE(@HoraCierre, HoraCierre),
            IdEstatus = COALESCE(@IdEstatus, IdEstatus)
        WHERE IdSucursal = @IdSucursal;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('SUCURSAL', @IdSucursal, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Sucursal actualizada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Baja lógica / Eliminación
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal)
        BEGIN
            SELECT 'La sucursal no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar si tiene registros asociados
        IF EXISTS (SELECT 1 FROM dbo.SALON WHERE IdSucursal = @IdSucursal)
           OR EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE IdSucursal = @IdSucursal)
           OR EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdSucursal = @IdSucursal)
        BEGIN
            -- Se aplica BAJA LÓGICA (Inactiva = 2) para preservar el historial
            SELECT @ValoresAnteriores = (SELECT * FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

            UPDATE dbo.SUCURSAL
            SET IdEstatus = 2 -- Inactiva
            WHERE IdSucursal = @IdSucursal;

            SELECT @ValoresNuevos = (SELECT * FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
            INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
            VALUES ('SUCURSAL', @IdSucursal, 'BAJA', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

            SELECT 'La sucursal cuenta con historial operativo; se ha marcado como Inactiva (baja lógica).' AS Mensaje, 'success' AS TipoMensaje;
        END
        ELSE
        BEGIN
            -- Si no tiene ningún registro asociado, se permite DELETE físico
            SELECT @ValoresAnteriores = (SELECT * FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
            DELETE FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal;

            INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
            VALUES ('SUCURSAL', @IdSucursal, 'DELETE', @ValoresAnteriores, @IdUsuario);

            SELECT 'Sucursal eliminada físicamente.' AS Mensaje, 'success' AS TipoMensaje;
        END
    END
END;
GO

-- SP_SALON (Baja lógica y validación de clases futuras)
CREATE OR ALTER PROCEDURE dbo.SP_SALON
(
    @Accion         INT             = NULL,
    @IdSalon        INT             = NULL,
    @NombreNumero   VARCHAR(20)     = NULL,
    @IdSucursal     SMALLINT        = NULL,
    @IdEstatus      TINYINT         = NULL,
    @IdUsuario      INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar
    BEGIN
        IF @NombreNumero IS NULL OR TRIM(@NombreNumero) = '' OR @IdSucursal IS NULL
        BEGIN
            SELECT 'Todos los campos son obligatorios.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal)
        BEGIN
            SELECT 'La sucursal seleccionada no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.SALON WHERE IdSucursal = @IdSucursal AND NombreNumero = TRIM(@NombreNumero))
        BEGIN
            SELECT 'Ya existe un salón con ese nombre/número en esta sucursal.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.SALON (NombreNumero, IdSucursal, IdEstatus)
        VALUES (TRIM(@NombreNumero), @IdSucursal, ISNULL(@IdEstatus, 1));
        SET @IdSalon = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SALON WHERE IdSalon = @IdSalon FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('SALON', @IdSalon, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Salón registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT S.IdSalon, S.NombreNumero, S.IdSucursal, Suc.Nombre AS Sucursal, S.IdEstatus, E.Nombre AS Estatus
        FROM dbo.SALON S
        INNER JOIN dbo.SUCURSAL Suc ON S.IdSucursal = Suc.IdSucursal
        INNER JOIN dbo.ESTATUS_SALON E ON S.IdEstatus = E.IdEstatusSalon
        WHERE S.IdSalon = @IdSalon;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT S.IdSalon, S.NombreNumero, S.IdSucursal, Suc.Nombre AS Sucursal, S.IdEstatus, E.Nombre AS Estatus
        FROM dbo.SALON S
        INNER JOIN dbo.SUCURSAL Suc ON S.IdSucursal = Suc.IdSucursal
        INNER JOIN dbo.ESTATUS_SALON E ON S.IdEstatus = E.IdEstatusSalon
        WHERE (@IdSucursal IS NULL OR S.IdSucursal = @IdSucursal)
          AND (@IdEstatus IS NULL OR S.IdEstatus = @IdEstatus)
          AND (@NombreNumero IS NULL OR S.NombreNumero LIKE '%' + TRIM(@NombreNumero) + '%')
        ORDER BY Suc.Nombre, S.NombreNumero;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.SALON WHERE IdSalon = @IdSalon)
        BEGIN
            SELECT 'El salón no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Regla 6.7: Si pasa a Mantenimiento (2) o Fuera de servicio (3), validar que no tenga clases futuras
        IF @IdEstatus IN (2, 3)
        BEGIN
            IF EXISTS (
                SELECT 1 FROM dbo.CLASE
                WHERE IdSalon = @IdSalon AND IdEstatus = 1
                  AND (Fecha > CAST(GETDATE() AS DATE)
                       OR (Fecha = CAST(GETDATE() AS DATE) AND HoraFin > CAST(GETDATE() AS TIME)))
            )
            BEGIN
                SELECT 'El salón tiene clases futuras programadas. Deben reprogramarse o cancelarse antes de cambiar su estatus.' AS Mensaje, 'warning' AS TipoMensaje;
                RETURN;
            END
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.SALON WHERE IdSalon = @IdSalon FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.SALON
        SET NombreNumero = COALESCE(NULLIF(TRIM(@NombreNumero), ''), NombreNumero),
            IdSucursal = COALESCE(@IdSucursal, IdSucursal),
            IdEstatus = COALESCE(@IdEstatus, IdEstatus)
        WHERE IdSalon = @IdSalon;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SALON WHERE IdSalon = @IdSalon FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('SALON', @IdSalon, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Salón actualizado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Baja lógica (Fuera de servicio = 3)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.SALON WHERE IdSalon = @IdSalon)
        BEGIN
            SELECT 'El salón no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE IdSalon = @IdSalon AND IdEstatus = 1
              AND (Fecha > CAST(GETDATE() AS DATE)
                   OR (Fecha = CAST(GETDATE() AS DATE) AND HoraFin > CAST(GETDATE() AS TIME)))
        )
        BEGIN
            SELECT 'El salón tiene clases futuras programadas. Deben reprogramarse o cancelarse antes de darlo de baja.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.SALON WHERE IdSalon = @IdSalon FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.SALON
        SET IdEstatus = 3 -- Fuera de servicio
        WHERE IdSalon = @IdSalon;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SALON WHERE IdSalon = @IdSalon FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('SALON', @IdSalon, 'BAJA', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Salón puesto fuera de servicio (baja lógica).' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_EMPLEADO (Gestión integral, especialidades y sincronización con usuario)
CREATE OR ALTER PROCEDURE dbo.SP_EMPLEADO
(
    @Accion             INT             = NULL,
    @IdEmpleado         INT             = NULL,
    @Nombres            VARCHAR(50)     = NULL,
    @PrimerApellido     VARCHAR(50)     = NULL,
    @SegundoApellido    VARCHAR(50)     = NULL,
    @CURP               CHAR(18)        = NULL,
    @Telefono           VARCHAR(20)     = NULL,
    @Correo             VARCHAR(254)    = NULL,
    @FechaNacimiento    DATE            = NULL,
    @FechaContratacion  DATE            = NULL,
    @IdPuesto           TINYINT         = NULL,
    @IdSucursal         SMALLINT        = NULL,
    @IdEstatus          TINYINT         = NULL,
    @IdEspecialidad     TINYINT         = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar empleado
    BEGIN
        IF @Nombres IS NULL OR TRIM(@Nombres) = '' OR @PrimerApellido IS NULL OR TRIM(@PrimerApellido) = ''
           OR @CURP IS NULL OR TRIM(@CURP) = '' OR @Telefono IS NULL OR TRIM(@Telefono) = ''
           OR @Correo IS NULL OR TRIM(@Correo) = '' OR @FechaNacimiento IS NULL OR @IdPuesto IS NULL OR @IdSucursal IS NULL
        BEGIN
            SELECT 'Todos los campos obligatorios deben ser completados.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar sucursal activa
        IF NOT EXISTS (SELECT 1 FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal AND IdEstatus = 1)
        BEGIN
            SELECT 'La sucursal seleccionada no está activa.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar unicidad
        IF EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE CURP = UPPER(TRIM(@CURP)))
        BEGIN
            SELECT 'Ya existe un empleado registrado con ese CURP.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE Correo = LOWER(TRIM(@Correo)))
        BEGIN
            SELECT 'Ya existe un empleado registrado con ese correo electrónico.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE Telefono = TRIM(@Telefono))
        BEGIN
            SELECT 'Ya existe un empleado registrado con ese teléfono.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.EMPLEADO
            (Nombres, PrimerApellido, SegundoApellido, CURP, Telefono, Correo,
             FechaNacimiento, FechaContratacion, IdPuesto, IdSucursal, IdEstatus)
        VALUES
            (TRIM(@Nombres), TRIM(@PrimerApellido), TRIM(@SegundoApellido), UPPER(TRIM(@CURP)),
             TRIM(@Telefono), LOWER(TRIM(@Correo)), @FechaNacimiento,
             COALESCE(@FechaContratacion, CAST(GETDATE() AS DATE)), @IdPuesto, @IdSucursal, ISNULL(@IdEstatus, 1));

        SET @IdEmpleado = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('EMPLEADO', @IdEmpleado, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Empleado registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Consultar por Id
    BEGIN
        SELECT E.IdEmpleado, E.Nombres, E.PrimerApellido, E.SegundoApellido,
               E.CURP, E.Telefono, E.Correo, E.FechaNacimiento, E.FechaContratacion,
               E.IdPuesto, P.Nombre AS Puesto,
               E.IdSucursal, S.Nombre AS Sucursal,
               E.IdEstatus, EE.Nombre AS Estatus,
               (
                   SELECT STRING_AGG(Esp.Nombre, ', ')
                   FROM dbo.EMPLEADO_ESPECIALIDAD EEsp
                   INNER JOIN dbo.ESPECIALIDAD Esp ON EEsp.IdEspecialidad = Esp.IdEspecialidad
                   WHERE EEsp.IdEmpleado = E.IdEmpleado
               ) AS Especialidades
        FROM dbo.EMPLEADO E
        INNER JOIN dbo.PUESTO P ON E.IdPuesto = P.IdPuesto
        INNER JOIN dbo.SUCURSAL S ON E.IdSucursal = S.IdSucursal
        INNER JOIN dbo.ESTATUS_EMPLEADO EE ON E.IdEstatus = EE.IdEstatusEmpleado
        WHERE E.IdEmpleado = @IdEmpleado;
    END

    IF @Accion = 3 -- Consulta general con filtros
    BEGIN
        SELECT E.IdEmpleado, E.Nombres, E.PrimerApellido, E.SegundoApellido,
               E.CURP, E.Telefono, E.Correo, E.FechaNacimiento, E.FechaContratacion,
               E.IdPuesto, P.Nombre AS Puesto,
               E.IdSucursal, S.Nombre AS Sucursal,
               E.IdEstatus, EE.Nombre AS Estatus,
               (
                   SELECT STRING_AGG(Esp.Nombre, ', ')
                   FROM dbo.EMPLEADO_ESPECIALIDAD EEsp
                   INNER JOIN dbo.ESPECIALIDAD Esp ON EEsp.IdEspecialidad = Esp.IdEspecialidad
                   WHERE EEsp.IdEmpleado = E.IdEmpleado
               ) AS Especialidades
        FROM dbo.EMPLEADO E
        INNER JOIN dbo.PUESTO P ON E.IdPuesto = P.IdPuesto
        INNER JOIN dbo.SUCURSAL S ON E.IdSucursal = S.IdSucursal
        INNER JOIN dbo.ESTATUS_EMPLEADO EE ON E.IdEstatus = EE.IdEstatusEmpleado
        WHERE (@Nombres IS NULL OR E.Nombres LIKE '%' + TRIM(@Nombres) + '%'
               OR E.PrimerApellido LIKE '%' + TRIM(@Nombres) + '%')
          AND (@CURP IS NULL OR E.CURP LIKE '%' + TRIM(@CURP) + '%')
          AND (@IdPuesto IS NULL OR E.IdPuesto = @IdPuesto)
          AND (@IdSucursal IS NULL OR E.IdSucursal = @IdSucursal)
          AND (@IdEstatus IS NULL OR E.IdEstatus = @IdEstatus)
        ORDER BY E.PrimerApellido, E.SegundoApellido, E.Nombres;
    END

    IF @Accion = 4 -- Modificar empleado
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado)
        BEGIN
            SELECT 'El empleado no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Regla 6.5: Al pasar a Baja (3) o Inactivo (2), validar clases futuras
        IF @IdEstatus IN (2, 3)
        BEGIN
            IF EXISTS (
                SELECT 1 FROM dbo.CLASE
                WHERE IdEmpleado = @IdEmpleado AND IdEstatus = 1
                  AND (Fecha > CAST(GETDATE() AS DATE)
                       OR (Fecha = CAST(GETDATE() AS DATE) AND HoraFin > CAST(GETDATE() AS TIME)))
            )
            BEGIN
                SELECT 'El empleado tiene clases futuras asignadas. Deben reasignarse o cancelarse antes de cambiar a Inactivo o Baja.' AS Mensaje, 'warning' AS TipoMensaje;
                RETURN;
            END

            -- Deshabilitar usuario automáticamente (Regla 6.5)
            UPDATE dbo.USUARIO
            SET IdEstatus = 2 -- Inactivo
            WHERE IdEmpleado = @IdEmpleado AND IdEstatus = 1;
        END

        -- Si vuelve a Activo (1), rehabilitar usuario
        IF @IdEstatus = 1
        BEGIN
            UPDATE dbo.USUARIO
            SET IdEstatus = 1 -- Activo
            WHERE IdEmpleado = @IdEmpleado AND IdEstatus = 2;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.EMPLEADO
        SET Nombres = COALESCE(NULLIF(TRIM(@Nombres), ''), Nombres),
            PrimerApellido = COALESCE(NULLIF(TRIM(@PrimerApellido), ''), PrimerApellido),
            SegundoApellido = COALESCE(TRIM(@SegundoApellido), SegundoApellido),
            CURP = COALESCE(NULLIF(UPPER(TRIM(@CURP)), ''), CURP),
            Telefono = COALESCE(NULLIF(TRIM(@Telefono), ''), Telefono),
            Correo = COALESCE(NULLIF(LOWER(TRIM(@Correo)), ''), Correo),
            FechaNacimiento = COALESCE(@FechaNacimiento, FechaNacimiento),
            IdPuesto = COALESCE(@IdPuesto, IdPuesto),
            IdSucursal = COALESCE(@IdSucursal, IdSucursal),
            IdEstatus = COALESCE(@IdEstatus, IdEstatus)
        WHERE IdEmpleado = @IdEmpleado;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('EMPLEADO', @IdEmpleado, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Empleado actualizado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Baja laboral (Baja = 3)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado)
        BEGIN
            SELECT 'El empleado no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE IdEmpleado = @IdEmpleado AND IdEstatus = 1
              AND (Fecha > CAST(GETDATE() AS DATE)
                   OR (Fecha = CAST(GETDATE() AS DATE) AND HoraFin > CAST(GETDATE() AS TIME)))
        )
        BEGIN
            SELECT 'El empleado tiene clases futuras asignadas. Deben reasignarse o cancelarse antes de registrar su baja.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.EMPLEADO
        SET IdEstatus = 3 -- Baja
        WHERE IdEmpleado = @IdEmpleado;

        -- Deshabilitar usuario automáticamente
        UPDATE dbo.USUARIO
        SET IdEstatus = 2 -- Inactivo
        WHERE IdEmpleado = @IdEmpleado;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('EMPLEADO', @IdEmpleado, 'BAJA', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Baja de empleado registrada correctamente. Su usuario ha sido inhabilitado.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 6 -- Asignar especialidad
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado)
           OR NOT EXISTS (SELECT 1 FROM dbo.ESPECIALIDAD WHERE IdEspecialidad = @IdEspecialidad)
        BEGIN
            SELECT 'El empleado o la especialidad no existen.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.EMPLEADO_ESPECIALIDAD WHERE IdEmpleado = @IdEmpleado AND IdEspecialidad = @IdEspecialidad)
        BEGIN
            SELECT 'El empleado ya cuenta con esta especialidad.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.EMPLEADO_ESPECIALIDAD (IdEmpleado, IdEspecialidad)
        VALUES (@IdEmpleado, @IdEspecialidad);

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('EMPLEADO_ESPECIALIDAD', @IdEmpleado, 'INSERT',
                (SELECT @IdEmpleado AS IdEmpleado, @IdEspecialidad AS IdEspecialidad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
                @IdUsuario);

        SELECT 'Especialidad asignada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 7 -- Quitar especialidad
    BEGIN
        -- Validar que no tenga clases futuras que requieran esta especialidad
        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE IdEmpleado = @IdEmpleado AND IdEspecialidad = @IdEspecialidad AND IdEstatus = 1
              AND (Fecha > CAST(GETDATE() AS DATE)
                   OR (Fecha = CAST(GETDATE() AS DATE) AND HoraFin > CAST(GETDATE() AS TIME)))
        )
        BEGIN
            SELECT 'No se puede quitar la especialidad porque el entrenador tiene clases futuras que la requieren.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        DELETE FROM dbo.EMPLEADO_ESPECIALIDAD
        WHERE IdEmpleado = @IdEmpleado AND IdEspecialidad = @IdEspecialidad;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('EMPLEADO_ESPECIALIDAD', @IdEmpleado, 'DELETE',
                (SELECT @IdEmpleado AS IdEmpleado, @IdEspecialidad AS IdEspecialidad FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
                @IdUsuario);

        SELECT 'Especialidad desvinculada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 8 -- Listar especialidades del empleado
    BEGIN
        SELECT Esp.IdEspecialidad, Esp.Nombre, Esp.Descripcion
        FROM dbo.EMPLEADO_ESPECIALIDAD EEsp
        INNER JOIN dbo.ESPECIALIDAD Esp ON EEsp.IdEspecialidad = Esp.IdEspecialidad
        WHERE EEsp.IdEmpleado = @IdEmpleado
        ORDER BY Esp.Nombre;
    END
END;
GO

-- SP_USUARIO (Seguridad, login y sincronización con empleado)
CREATE OR ALTER PROCEDURE dbo.SP_USUARIO
(
    @Accion             INT             = NULL,
    @IdUsuario          INT             = NULL,
    @NombreCuenta       VARCHAR(160)    = NULL,
    @Contrasena         NVARCHAR(255)   = NULL,
    @IdRol              TINYINT         = NULL,
    @IdEmpleado         INT             = NULL,
    @IdEstatus          TINYINT         = NULL,
    @IdUsuarioOperador  INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Crear usuario (solo admin)
    BEGIN
        IF @NombreCuenta IS NULL OR TRIM(@NombreCuenta) = '' OR @Contrasena IS NULL OR TRIM(@Contrasena) = ''
           OR @IdRol IS NULL OR @IdEmpleado IS NULL
        BEGIN
            SELECT 'Todos los campos son obligatorios.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado AND IdEstatus = 1)
        BEGIN
            SELECT 'El empleado seleccionado no existe o no está activo.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.USUARIO WHERE IdEmpleado = @IdEmpleado)
        BEGIN
            SELECT 'El empleado ya cuenta con un usuario registrado en el sistema.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.USUARIO WHERE NombreCuenta = TRIM(@NombreCuenta))
        BEGIN
            SELECT 'El nombre de cuenta ya está en uso.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.USUARIO (NombreCuenta, Contrasena, FechaRegistro, IdRol, IdEmpleado, IdEstatus)
        VALUES (TRIM(@NombreCuenta), TRIM(@Contrasena), SYSDATETIME(), @IdRol, @IdEmpleado, ISNULL(@IdEstatus, 1));

        SET @IdUsuario = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT IdUsuario, NombreCuenta, FechaRegistro, IdRol, IdEmpleado, IdEstatus FROM dbo.USUARIO WHERE IdUsuario = @IdUsuario FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('USUARIO', @IdUsuario, 'INSERT', @ValoresNuevos, @IdUsuarioOperador);

        SELECT 'Usuario creado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT U.IdUsuario, U.NombreCuenta, U.FechaRegistro, U.IdRol, R.Nombre AS Rol,
               U.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Empleado,
               E.IdSucursal, S.Nombre AS Sucursal,
               U.IdEstatus, EU.Nombre AS Estatus
        FROM dbo.USUARIO U
        INNER JOIN dbo.ROL R ON U.IdRol = R.IdRol
        INNER JOIN dbo.EMPLEADO E ON U.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.SUCURSAL S ON E.IdSucursal = S.IdSucursal
        INNER JOIN dbo.ESTATUS_USUARIO EU ON U.IdEstatus = EU.IdEstatusUsuario
        WHERE U.IdUsuario = @IdUsuario;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT U.IdUsuario, U.NombreCuenta, U.FechaRegistro, U.IdRol, R.Nombre AS Rol,
               U.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Empleado,
               E.IdSucursal, S.Nombre AS Sucursal,
               U.IdEstatus, EU.Nombre AS Estatus
        FROM dbo.USUARIO U
        INNER JOIN dbo.ROL R ON U.IdRol = R.IdRol
        INNER JOIN dbo.EMPLEADO E ON U.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.SUCURSAL S ON E.IdSucursal = S.IdSucursal
        INNER JOIN dbo.ESTATUS_USUARIO EU ON U.IdEstatus = EU.IdEstatusUsuario
        WHERE (@NombreCuenta IS NULL OR U.NombreCuenta LIKE '%' + TRIM(@NombreCuenta) + '%')
          AND (@IdRol IS NULL OR U.IdRol = @IdRol)
          AND (@IdEstatus IS NULL OR U.IdEstatus = @IdEstatus)
        ORDER BY U.NombreCuenta;
    END

    IF @Accion = 4 -- Modificar rol o estatus
    BEGIN
        SELECT @ValoresAnteriores = (SELECT IdUsuario, NombreCuenta, FechaRegistro, IdRol, IdEmpleado, IdEstatus FROM dbo.USUARIO WHERE IdUsuario = @IdUsuario FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.USUARIO
        SET IdRol = COALESCE(@IdRol, IdRol),
            IdEstatus = COALESCE(@IdEstatus, IdEstatus)
        WHERE IdUsuario = @IdUsuario;

        SELECT @ValoresNuevos = (SELECT IdUsuario, NombreCuenta, FechaRegistro, IdRol, IdEmpleado, IdEstatus FROM dbo.USUARIO WHERE IdUsuario = @IdUsuario FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('USUARIO', @IdUsuario, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuarioOperador);

        SELECT 'Usuario modificado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Cambiar contraseña
    BEGIN
        UPDATE dbo.USUARIO
        SET Contrasena = TRIM(@Contrasena)
        WHERE IdUsuario = @IdUsuario;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('USUARIO', @IdUsuario, 'UPDATE', '{"Operacion":"Cambio de Contrasena"}', @IdUsuarioOperador);

        SELECT 'Contraseña actualizada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 6 -- Login / Autenticación
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.USUARIO WHERE NombreCuenta = TRIM(@NombreCuenta) AND Contrasena = TRIM(@Contrasena))
        BEGIN
            SELECT 'Credenciales incorrectas.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar si el usuario está activo
        IF EXISTS (SELECT 1 FROM dbo.USUARIO WHERE NombreCuenta = TRIM(@NombreCuenta) AND IdEstatus <> 1)
        BEGIN
            SELECT 'La cuenta de usuario se encuentra inactiva o bloqueada.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar si el empleado asociado está activo
        IF EXISTS (
            SELECT 1 FROM dbo.USUARIO U
            INNER JOIN dbo.EMPLEADO E ON U.IdEmpleado = E.IdEmpleado
            WHERE U.NombreCuenta = TRIM(@NombreCuenta) AND E.IdEstatus <> 1
        )
        BEGIN
            SELECT 'El empleado asociado a esta cuenta se encuentra inactivo o dado de baja.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Retornar datos de sesión exitosa
        SELECT U.IdUsuario, U.NombreCuenta, U.IdRol, R.Nombre AS Rol,
               U.IdEmpleado, E.Nombres, E.PrimerApellido, E.SegundoApellido,
               E.IdSucursal, S.Nombre AS Sucursal,
               'Inicio de sesión exitoso.' AS Mensaje,
               'success' AS TipoMensaje
        FROM dbo.USUARIO U
        INNER JOIN dbo.ROL R ON U.IdRol = R.IdRol
        INNER JOIN dbo.EMPLEADO E ON U.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.SUCURSAL S ON E.IdSucursal = S.IdSucursal
        WHERE U.NombreCuenta = TRIM(@NombreCuenta) AND U.Contrasena = TRIM(@Contrasena);
    END
END;
GO

-- SP_CLIENTE (Socios: baja lógica, reservas futuras canceladas automáticamente y auditoría)
CREATE OR ALTER PROCEDURE dbo.SP_CLIENTE
(
    @Accion             INT             = NULL,
    @IdCliente          INT             = NULL,
    @Nombres            VARCHAR(50)     = NULL,
    @PrimerApellido     VARCHAR(50)     = NULL,
    @SegundoApellido    VARCHAR(50)     = NULL,
    @Telefono           VARCHAR(20)     = NULL,
    @Correo             VARCHAR(254)    = NULL,
    @FechaNacimiento    DATE            = NULL,
    @IdSucursal         SMALLINT        = NULL,
    @IdEstatus          TINYINT         = NULL,
    @IdUsuario          INT             = NULL,
    @Folio              VARCHAR(8)      = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Registrar nuevo socio
    BEGIN
        IF @Nombres IS NULL OR TRIM(@Nombres) = '' OR @PrimerApellido IS NULL OR TRIM(@PrimerApellido) = ''
           OR @Telefono IS NULL OR TRIM(@Telefono) = '' OR @Correo IS NULL OR TRIM(@Correo) = ''
           OR @FechaNacimiento IS NULL OR @IdSucursal IS NULL
        BEGIN
            SELECT 'Todos los campos obligatorios deben ser completados.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar sucursal activa
        IF NOT EXISTS (SELECT 1 FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal AND IdEstatus = 1)
        BEGIN
            SELECT 'La sucursal seleccionada no está activa.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.CLIENTE
            (Nombres, PrimerApellido, SegundoApellido, Telefono, Correo,
             FechaNacimiento, FechaInscripcion, IdSucursal, IdEstatus)
        VALUES
            (TRIM(@Nombres), TRIM(@PrimerApellido), TRIM(@SegundoApellido), TRIM(@Telefono),
             LOWER(TRIM(@Correo)), @FechaNacimiento, CAST(GETDATE() AS DATE), @IdSucursal, ISNULL(@IdEstatus, 1));

        SET @IdCliente = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CLIENTE WHERE IdCliente = @IdCliente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('CLIENTE', @IdCliente, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Socio registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Consultar por Id
    BEGIN
        SELECT C.IdCliente, C.Folio, C.Nombres, C.PrimerApellido, C.SegundoApellido,
               C.Telefono, C.Correo, C.FechaNacimiento, C.FechaInscripcion,
               C.IdSucursal, S.Nombre AS Sucursal,
               C.IdEstatus, E.Nombre AS Estatus
        FROM dbo.CLIENTE C
        INNER JOIN dbo.SUCURSAL S ON C.IdSucursal = S.IdSucursal
        INNER JOIN dbo.ESTATUS_CLIENTE E ON C.IdEstatus = E.IdEstatusCliente
        WHERE C.IdCliente = @IdCliente;
    END

    IF @Accion = 3 -- Consulta general con filtros
    BEGIN
        SELECT C.IdCliente, C.Folio, C.Nombres, C.PrimerApellido, C.SegundoApellido,
               C.Telefono, C.Correo, C.FechaNacimiento, C.FechaInscripcion,
               C.IdSucursal, S.Nombre AS Sucursal,
               C.IdEstatus, E.Nombre AS Estatus
        FROM dbo.CLIENTE C
        INNER JOIN dbo.SUCURSAL S ON C.IdSucursal = S.IdSucursal
        INNER JOIN dbo.ESTATUS_CLIENTE E ON C.IdEstatus = E.IdEstatusCliente
        WHERE (@Nombres IS NULL OR C.Nombres LIKE '%' + TRIM(@Nombres) + '%'
               OR C.PrimerApellido LIKE '%' + TRIM(@Nombres) + '%')
          AND (@Folio IS NULL OR C.Folio LIKE '%' + TRIM(@Folio) + '%')
          AND (@Telefono IS NULL OR C.Telefono LIKE '%' + TRIM(@Telefono) + '%')
          AND (@Correo IS NULL OR C.Correo LIKE '%' + TRIM(@Correo) + '%')
          AND (@IdSucursal IS NULL OR C.IdSucursal = @IdSucursal)
          AND (@IdEstatus IS NULL OR C.IdEstatus = @IdEstatus)
        ORDER BY C.PrimerApellido, C.SegundoApellido, C.Nombres;
    END

    IF @Accion = 4 -- Modificar socio
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente)
        BEGIN
            SELECT 'El socio no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.CLIENTE WHERE IdCliente = @IdCliente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        -- Regla 6.1: Al pasar a Inactivo (2) o Suspendido (3), cancelar automáticamente reservas futuras confirmadas
        IF @IdEstatus IN (2, 3)
        BEGIN
            UPDATE dbo.RESERVA
            SET IdEstatus = 2 -- Cancelada
            WHERE IdCliente = @IdCliente AND IdEstatus = 1
              AND IdClase IN (
                  SELECT IdClase FROM dbo.CLASE
                  WHERE Fecha > CAST(GETDATE() AS DATE)
                     OR (Fecha = CAST(GETDATE() AS DATE) AND HoraInicio > CAST(GETDATE() AS TIME))
              );
        END

        UPDATE dbo.CLIENTE
        SET Nombres = COALESCE(NULLIF(TRIM(@Nombres), ''), Nombres),
            PrimerApellido = COALESCE(NULLIF(TRIM(@PrimerApellido), ''), PrimerApellido),
            SegundoApellido = COALESCE(TRIM(@SegundoApellido), SegundoApellido),
            Telefono = COALESCE(NULLIF(TRIM(@Telefono), ''), Telefono),
            Correo = COALESCE(NULLIF(LOWER(TRIM(@Correo)), ''), Correo),
            FechaNacimiento = COALESCE(@FechaNacimiento, FechaNacimiento),
            IdSucursal = COALESCE(@IdSucursal, IdSucursal),
            IdEstatus = COALESCE(@IdEstatus, IdEstatus)
        WHERE IdCliente = @IdCliente;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CLIENTE WHERE IdCliente = @IdCliente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('CLIENTE', @IdCliente, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Datos del socio actualizados correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Baja lógica (Inactivo = 2) - CERO BORRADO EN CASCADA
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente)
        BEGIN
            SELECT 'El socio no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.CLIENTE WHERE IdCliente = @IdCliente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        -- Cancelar automáticamente reservas futuras confirmadas (Regla 6.1)
        UPDATE dbo.RESERVA
        SET IdEstatus = 2 -- Cancelada
        WHERE IdCliente = @IdCliente AND IdEstatus = 1
          AND IdClase IN (
              SELECT IdClase FROM dbo.CLASE
              WHERE Fecha > CAST(GETDATE() AS DATE)
                 OR (Fecha = CAST(GETDATE() AS DATE) AND HoraInicio > CAST(GETDATE() AS TIME))
          );

        -- Baja lógica cambiando estatus a Inactivo
        UPDATE dbo.CLIENTE
        SET IdEstatus = 2 -- Inactivo
        WHERE IdCliente = @IdCliente;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CLIENTE WHERE IdCliente = @IdCliente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('CLIENTE', @IdCliente, 'BAJA', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Socio dado de baja correctamente (baja lógica). Se cancelaron sus reservas futuras y se conserva su historial.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 6 -- Reactivar socio (Activo = 1)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente)
        BEGIN
            SELECT 'El socio no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.CLIENTE WHERE IdCliente = @IdCliente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.CLIENTE
        SET IdEstatus = 1 -- Activo
        WHERE IdCliente = @IdCliente;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CLIENTE WHERE IdCliente = @IdCliente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('CLIENTE', @IdCliente, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Socio reactivado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO


-------------------------------------------------------------
-- 9. PROCEDIMIENTOS ALMACENADOS DE OPERACIÓN Y NEGOCIO (PARTE 2)
-------------------------------------------------------------

-- SP_EXPEDIENTE (Expedientes, condiciones y alerta de incompatibilidad en rutinas)
CREATE OR ALTER PROCEDURE dbo.SP_EXPEDIENTE
(
    @Accion         INT             = NULL,
    @IdExpediente   INT             = NULL,
    @IdCliente      INT             = NULL,
    @TipoSangre     VARCHAR(3)      = NULL,
    @IdCondicion    TINYINT         = NULL,
    @Observaciones  VARCHAR(300)    = NULL,
    @IdUsuario      INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Crear expediente
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente)
        BEGIN
            SELECT 'El socio no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.EXPEDIENTE WHERE IdCliente = @IdCliente)
        BEGIN
            SELECT 'El socio ya cuenta con un expediente médico registrado.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF @TipoSangre NOT IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
        BEGIN
            SELECT 'El tipo de sangre no es válido.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.EXPEDIENTE (IdCliente, TipoSangre)
        VALUES (@IdCliente, TRIM(@TipoSangre));
        SET @IdExpediente = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.EXPEDIENTE WHERE IdExpediente = @IdExpediente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('EXPEDIENTE', @IdExpediente, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Expediente médico registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Consultar por Id
    BEGIN
        SELECT E.IdExpediente, E.IdCliente, C.Folio,
               C.Nombres, C.PrimerApellido, C.SegundoApellido, E.TipoSangre
        FROM dbo.EXPEDIENTE E
        INNER JOIN dbo.CLIENTE C ON E.IdCliente = C.IdCliente
        WHERE E.IdExpediente = @IdExpediente;
    END

    IF @Accion = 3 -- Consulta general
    BEGIN
        SELECT E.IdExpediente, E.IdCliente, C.Folio,
               C.Nombres, C.PrimerApellido, C.SegundoApellido, E.TipoSangre
        FROM dbo.EXPEDIENTE E
        INNER JOIN dbo.CLIENTE C ON E.IdCliente = C.IdCliente
        WHERE (@IdCliente IS NULL OR E.IdCliente = @IdCliente)
          AND (@TipoSangre IS NULL OR E.TipoSangre = @TipoSangre)
        ORDER BY C.PrimerApellido, C.SegundoApellido, C.Nombres;
    END

    IF @Accion = 4 -- Modificar tipo de sangre
    BEGIN
        IF @TipoSangre NOT IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
        BEGIN
            SELECT 'El tipo de sangre no es válido.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.EXPEDIENTE WHERE IdExpediente = @IdExpediente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.EXPEDIENTE
        SET TipoSangre = TRIM(@TipoSangre)
        WHERE IdExpediente = @IdExpediente;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.EXPEDIENTE WHERE IdExpediente = @IdExpediente FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('EXPEDIENTE', @IdExpediente, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Tipo de sangre actualizado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 6 -- Asociar condición médica (Regla 6.11: Alerta de ejercicios incompatibles en rutinas activas)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.EXPEDIENTE WHERE IdExpediente = @IdExpediente)
           OR NOT EXISTS (SELECT 1 FROM dbo.CONDICION WHERE IdCondicion = @IdCondicion)
        BEGIN
            SELECT 'El expediente o la condición médica no existen.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.EXPEDIENTE_CONDICION WHERE IdExpediente = @IdExpediente AND IdCondicion = @IdCondicion)
        BEGIN
            SELECT 'La condición ya está registrada en el expediente.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.EXPEDIENTE_CONDICION (IdExpediente, IdCondicion, Observaciones)
        VALUES (@IdExpediente, @IdCondicion, TRIM(@Observaciones));

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('EXPEDIENTE_CONDICION', @IdExpediente, 'INSERT',
                (SELECT @IdExpediente AS IdExpediente, @IdCondicion AS IdCondicion, @Observaciones AS Observaciones FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
                @IdUsuario);

        -- Regla 6.11: Verificar si el socio tiene rutinas activas con ejercicios contraindicados para alertar
        DECLARE @RutinasAfectadas INT = 0;
        SELECT @RutinasAfectadas = COUNT(DISTINCT R.IdRutina)
        FROM dbo.EXPEDIENTE E
        INNER JOIN dbo.RUTINA R ON E.IdCliente = R.IdCliente
        INNER JOIN dbo.DETALLE_RUTINA DR ON R.IdRutina = DR.IdRutina
        INNER JOIN dbo.EJERCICIO_CONTRAINDICACION EC ON DR.IdEjercicio = EC.IdEjercicio
        WHERE E.IdExpediente = @IdExpediente
          AND R.IdEstatus = 1 -- Rutina activa
          AND EC.IdCondicion = @IdCondicion;

        IF @RutinasAfectadas > 0
        BEGIN
            SELECT 'Condición asociada correctamente. ADVERTENCIA: El socio tiene rutinas activas con ejercicios contraindicados que requieren revisión del entrenador.' AS Mensaje,
                   'warning' AS TipoMensaje;
        END
        ELSE
        BEGIN
            SELECT 'Condición médica asociada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
        END
    END

    IF @Accion = 7 -- Condición específica
    BEGIN
        SELECT EC.IdExpediente, EC.IdCondicion, C.Nombre, C.Tipo, C.Descripcion, EC.Observaciones
        FROM dbo.EXPEDIENTE_CONDICION EC
        INNER JOIN dbo.CONDICION C ON EC.IdCondicion = C.IdCondicion
        WHERE EC.IdExpediente = @IdExpediente AND EC.IdCondicion = @IdCondicion;
    END

    IF @Accion = 8 -- Todas las condiciones del expediente
    BEGIN
        SELECT EC.IdExpediente, EC.IdCondicion, C.Nombre, C.Tipo, C.Descripcion, EC.Observaciones
        FROM dbo.EXPEDIENTE_CONDICION EC
        INNER JOIN dbo.CONDICION C ON EC.IdCondicion = C.IdCondicion
        WHERE EC.IdExpediente = @IdExpediente
        ORDER BY C.Tipo, C.Nombre;
    END

    IF @Accion = 9 -- Modificar observaciones de condición
    BEGIN
        UPDATE dbo.EXPEDIENTE_CONDICION
        SET Observaciones = TRIM(@Observaciones)
        WHERE IdExpediente = @IdExpediente AND IdCondicion = @IdCondicion;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('EXPEDIENTE_CONDICION', @IdExpediente, 'UPDATE',
                (SELECT @IdExpediente AS IdExpediente, @IdCondicion AS IdCondicion, @Observaciones AS Observaciones FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
                @IdUsuario);

        SELECT 'Observaciones de la condición médica actualizadas.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 10 -- Desvincular condición
    BEGIN
        DELETE FROM dbo.EXPEDIENTE_CONDICION
        WHERE IdExpediente = @IdExpediente AND IdCondicion = @IdCondicion;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('EXPEDIENTE_CONDICION', @IdExpediente, 'DELETE',
                (SELECT @IdExpediente AS IdExpediente, @IdCondicion AS IdCondicion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
                @IdUsuario);

        SELECT 'Condición desvinculada del expediente correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_EJERCICIO (Catálogo de ejercicios y contraindicaciones)
CREATE OR ALTER PROCEDURE dbo.SP_EJERCICIO
(
    @Accion             INT             = NULL,
    @IdEjercicio        INT             = NULL,
    @Nombre             VARCHAR(80)     = NULL,
    @Descripcion        VARCHAR(300)    = NULL,
    @IdGrupoMuscular    SMALLINT        = NULL,
    @IdDificultad       TINYINT         = NULL,
    @IdCondicion        TINYINT         = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Insertar ejercicio
    BEGIN
        IF @Nombre IS NULL OR TRIM(@Nombre) = '' OR @IdGrupoMuscular IS NULL OR @IdDificultad IS NULL
        BEGIN
            SELECT 'El nombre, grupo muscular y dificultad son obligatorios.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.EJERCICIO (Nombre, Descripcion, IdGrupoMuscular, IdDificultad)
        VALUES (TRIM(@Nombre), TRIM(@Descripcion), @IdGrupoMuscular, @IdDificultad);
        SET @IdEjercicio = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('EJERCICIO', @IdEjercicio, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Ejercicio registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Consultar por Id
    BEGIN
        SELECT E.IdEjercicio, E.Nombre, E.Descripcion,
               E.IdGrupoMuscular, GM.Nombre AS GrupoMuscular,
               E.IdDificultad, D.Nombre AS Dificultad
        FROM dbo.EJERCICIO E
        INNER JOIN dbo.GRUPO_MUSCULAR GM ON E.IdGrupoMuscular = GM.IdGrupoMuscular
        INNER JOIN dbo.DIFICULTAD D ON E.IdDificultad = D.IdDificultad
        WHERE E.IdEjercicio = @IdEjercicio;
    END

    IF @Accion = 3 -- Consulta general con filtros
    BEGIN
        SELECT E.IdEjercicio, E.Nombre, E.Descripcion,
               E.IdGrupoMuscular, GM.Nombre AS GrupoMuscular,
               E.IdDificultad, D.Nombre AS Dificultad
        FROM dbo.EJERCICIO E
        INNER JOIN dbo.GRUPO_MUSCULAR GM ON E.IdGrupoMuscular = GM.IdGrupoMuscular
        INNER JOIN dbo.DIFICULTAD D ON E.IdDificultad = D.IdDificultad
        WHERE (@Nombre IS NULL OR E.Nombre LIKE '%' + TRIM(@Nombre) + '%')
          AND (@IdGrupoMuscular IS NULL OR E.IdGrupoMuscular = @IdGrupoMuscular)
          AND (@IdDificultad IS NULL OR E.IdDificultad = @IdDificultad)
        ORDER BY E.Nombre;
    END

    IF @Accion = 4 -- Modificar ejercicio
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio)
        BEGIN
            SELECT 'El ejercicio no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.EJERCICIO
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Descripcion = COALESCE(NULLIF(TRIM(@Descripcion), ''), Descripcion),
            IdGrupoMuscular = COALESCE(@IdGrupoMuscular, IdGrupoMuscular),
            IdDificultad = COALESCE(@IdDificultad, IdDificultad)
        WHERE IdEjercicio = @IdEjercicio;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('EJERCICIO', @IdEjercicio, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Ejercicio actualizado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Eliminar ejercicio (Regla 6.12: elimina contraindicaciones y detalles)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio)
        BEGIN
            SELECT 'El ejercicio no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        DELETE FROM dbo.EJERCICIO_CONTRAINDICACION WHERE IdEjercicio = @IdEjercicio;
        DELETE FROM dbo.DETALLE_RUTINA WHERE IdEjercicio = @IdEjercicio;
        DELETE FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('EJERCICIO', @IdEjercicio, 'DELETE', @ValoresAnteriores, @IdUsuario);

        SELECT 'Ejercicio y sus referencias eliminados correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 6 -- Agregar contraindicación
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.EJERCICIO_CONTRAINDICACION WHERE IdEjercicio = @IdEjercicio AND IdCondicion = @IdCondicion)
        BEGIN
            SELECT 'La contraindicación ya está asociada al ejercicio.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.EJERCICIO_CONTRAINDICACION (IdEjercicio, IdCondicion)
        VALUES (@IdEjercicio, @IdCondicion);

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('EJERCICIO_CONTRAINDICACION', @IdEjercicio, 'INSERT',
                (SELECT @IdEjercicio AS IdEjercicio, @IdCondicion AS IdCondicion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
                @IdUsuario);

        SELECT 'Contraindicación asociada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 7 -- Listar contraindicaciones del ejercicio
    BEGIN
        SELECT EC.IdEjercicio, EC.IdCondicion, C.Nombre AS Condicion, C.Tipo, C.Descripcion
        FROM dbo.EJERCICIO_CONTRAINDICACION EC
        INNER JOIN dbo.CONDICION C ON EC.IdCondicion = C.IdCondicion
        WHERE EC.IdEjercicio = @IdEjercicio
        ORDER BY C.Nombre;
    END

    IF @Accion = 8 -- Quitar contraindicación
    BEGIN
        DELETE FROM dbo.EJERCICIO_CONTRAINDICACION
        WHERE IdEjercicio = @IdEjercicio AND IdCondicion = @IdCondicion;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('EJERCICIO_CONTRAINDICACION', @IdEjercicio, 'DELETE',
                (SELECT @IdEjercicio AS IdEjercicio, @IdCondicion AS IdCondicion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
                @IdUsuario);

        SELECT 'Contraindicación desvinculada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_SUSCRIPCION (Gestión, índice único filtrado y cancelación lógica)
CREATE OR ALTER PROCEDURE dbo.SP_SUSCRIPCION
(
    @Accion             INT             = NULL,
    @IdSuscripcion      INT             = NULL,
    @FechaInicio        DATE            = NULL,
    @IdCliente          INT             = NULL,
    @IdMembresia        TINYINT         = NULL,
    @IdEstatus          TINYINT         = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Contratar suscripción
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente)
        BEGIN
            SELECT 'El socio seleccionado no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.MEMBRESIA WHERE IdMembresia = @IdMembresia)
        BEGIN
            SELECT 'La membresía seleccionada no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Regla 6.2: Un socio solo puede tener una suscripción activa
        IF @IdEstatus = 2 AND EXISTS (
            SELECT 1 FROM dbo.SUSCRIPCION
            WHERE IdCliente = @IdCliente AND IdEstatus = 2
        )
        BEGIN
            SELECT 'El socio ya cuenta con una suscripción activa. Para renovar, finalice o cancele la anterior.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.SUSCRIPCION (FechaInicio, IdCliente, IdMembresia, IdEstatus)
        VALUES (COALESCE(@FechaInicio, CAST(GETDATE() AS DATE)), @IdCliente, @IdMembresia, ISNULL(@IdEstatus, 2));

        SET @IdSuscripcion = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SUSCRIPCION WHERE IdSuscripcion = @IdSuscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('SUSCRIPCION', @IdSuscripcion, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Suscripción registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT S.IdSuscripcion, S.FechaInicio, S.FechaVencimiento,
               S.IdCliente, C.Folio, C.Nombres, C.PrimerApellido, C.SegundoApellido,
               S.IdMembresia, M.Nombre AS Membresia, M.Precio,
               S.IdEstatus, ES.Nombre AS Estatus,
               CASE
                   WHEN S.IdEstatus = 4 THEN 'Cancelada'
                   WHEN S.FechaVencimiento < CAST(GETDATE() AS DATE) THEN 'Vencida'
                   WHEN S.IdEstatus = 2 AND CAST(GETDATE() AS DATE) BETWEEN S.FechaInicio AND S.FechaVencimiento THEN 'Vigente'
                   ELSE ES.Nombre
               END AS EstadoVigencia
        FROM dbo.SUSCRIPCION S
        INNER JOIN dbo.CLIENTE C ON S.IdCliente = C.IdCliente
        INNER JOIN dbo.MEMBRESIA M ON S.IdMembresia = M.IdMembresia
        INNER JOIN dbo.ESTATUS_SUSCRIPCION ES ON S.IdEstatus = ES.IdEstatusSuscripcion
        WHERE S.IdSuscripcion = @IdSuscripcion;
    END

    IF @Accion = 3 -- Consulta general con filtros
    BEGIN
        SELECT S.IdSuscripcion, S.FechaInicio, S.FechaVencimiento,
               S.IdCliente, C.Folio, C.Nombres, C.PrimerApellido, C.SegundoApellido,
               S.IdMembresia, M.Nombre AS Membresia, M.Precio,
               S.IdEstatus, ES.Nombre AS Estatus,
               CASE
                   WHEN S.IdEstatus = 4 THEN 'Cancelada'
                   WHEN S.FechaVencimiento < CAST(GETDATE() AS DATE) THEN 'Vencida'
                   WHEN S.IdEstatus = 2 AND CAST(GETDATE() AS DATE) BETWEEN S.FechaInicio AND S.FechaVencimiento THEN 'Vigente'
                   ELSE ES.Nombre
               END AS EstadoVigencia
        FROM dbo.SUSCRIPCION S
        INNER JOIN dbo.CLIENTE C ON S.IdCliente = C.IdCliente
        INNER JOIN dbo.MEMBRESIA M ON S.IdMembresia = M.IdMembresia
        INNER JOIN dbo.ESTATUS_SUSCRIPCION ES ON S.IdEstatus = ES.IdEstatusSuscripcion
        WHERE (@IdCliente IS NULL OR S.IdCliente = @IdCliente)
          AND (@IdMembresia IS NULL OR S.IdMembresia = @IdMembresia)
          AND (@IdEstatus IS NULL OR S.IdEstatus = @IdEstatus)
        ORDER BY S.FechaInicio DESC, S.IdSuscripcion DESC;
    END

    IF @Accion = 4 -- Modificar
    BEGIN
        IF @IdEstatus = 2 AND EXISTS (
            SELECT 1 FROM dbo.SUSCRIPCION
            WHERE IdCliente = @IdCliente AND IdEstatus = 2 AND IdSuscripcion <> @IdSuscripcion
        )
        BEGIN
            SELECT 'El socio ya cuenta con otra suscripción activa.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.SUSCRIPCION WHERE IdSuscripcion = @IdSuscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.SUSCRIPCION
        SET FechaInicio = COALESCE(@FechaInicio, FechaInicio),
            IdMembresia = COALESCE(@IdMembresia, IdMembresia),
            IdEstatus = COALESCE(@IdEstatus, IdEstatus)
        WHERE IdSuscripcion = @IdSuscripcion;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SUSCRIPCION WHERE IdSuscripcion = @IdSuscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('SUSCRIPCION', @IdSuscripcion, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Suscripción actualizada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Cancelar suscripción (Baja lógica, Regla 6.2)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.SUSCRIPCION WHERE IdSuscripcion = @IdSuscripcion)
        BEGIN
            SELECT 'La suscripción no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.SUSCRIPCION WHERE IdSuscripcion = @IdSuscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.SUSCRIPCION
        SET IdEstatus = 4 -- Cancelada
        WHERE IdSuscripcion = @IdSuscripcion;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.SUSCRIPCION WHERE IdSuscripcion = @IdSuscripcion FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('SUSCRIPCION', @IdSuscripcion, 'BAJA', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Suscripción cancelada correctamente. Se conserva en el historial pero impide acceso inmediato.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_CONTROL_ACCESO (Registro de entrada validando estatus y suscripción, registro de salida)
CREATE OR ALTER PROCEDURE dbo.SP_CONTROL_ACCESO
(
    @Accion             INT             = NULL,
    @IdControlAcceso    INT             = NULL,
    @IdCliente          INT             = NULL,
    @IdSucursal         SMALLINT        = NULL,
    @FechaInicio        DATETIME2       = NULL,
    @FechaFin           DATETIME2       = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresNuevos NVARCHAR(MAX);

    IF @Accion = 1 -- Registrar entrada (Regla 6.3)
    BEGIN
        -- 1. Validar socio activo
        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente AND IdEstatus = 1)
        BEGIN
            SELECT 'El socio no existe o se encuentra inactivo/suspendido. Acceso denegado.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- 2. Validar sucursal activa
        IF NOT EXISTS (SELECT 1 FROM dbo.SUCURSAL WHERE IdSucursal = @IdSucursal AND IdEstatus = 1)
        BEGIN
            SELECT 'La sucursal seleccionada no se encuentra activa para recibir accesos.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- 3. Validar suscripción activa y vigente (Regla 6.2 y 6.3)
        IF NOT EXISTS (
            SELECT 1 FROM dbo.SUSCRIPCION
            WHERE IdCliente = @IdCliente
              AND IdEstatus = 2 -- Activa
              AND CAST(GETDATE() AS DATE) BETWEEN FechaInicio AND FechaVencimiento
        )
        BEGIN
            SELECT 'El socio no cuenta con una suscripción activa y vigente. Acceso denegado.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- 4. Validar que no tenga entrada abierta pendiente de salida (Regla 6.3)
        IF EXISTS (
            SELECT 1 FROM dbo.CONTROL_ACCESO
            WHERE IdCliente = @IdCliente AND FechaHoraSalida IS NULL
        )
        BEGIN
            SELECT 'El socio ya cuenta con una entrada activa pendiente de salida. Debe registrar su salida antes de ingresar nuevamente.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- 5. Registrar entrada
        INSERT INTO dbo.CONTROL_ACCESO (FechaHoraEntrada, FechaHoraSalida, IdCliente, IdSucursal)
        VALUES (SYSDATETIME(), NULL, @IdCliente, @IdSucursal);
        SET @IdControlAcceso = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CONTROL_ACCESO WHERE IdControlAcceso = @IdControlAcceso FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('CONTROL_ACCESO', @IdControlAcceso, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Entrada registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Registrar salida (Regla 6.3)
    BEGIN
        SELECT TOP 1 @IdControlAcceso = IdControlAcceso
        FROM dbo.CONTROL_ACCESO
        WHERE IdCliente = @IdCliente AND FechaHoraSalida IS NULL
        ORDER BY FechaHoraEntrada DESC;

        IF @IdControlAcceso IS NULL
        BEGIN
            SELECT 'No se encontró un registro de entrada pendiente de salida para este socio.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        UPDATE dbo.CONTROL_ACCESO
        SET FechaHoraSalida = SYSDATETIME()
        WHERE IdControlAcceso = @IdControlAcceso;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CONTROL_ACCESO WHERE IdControlAcceso = @IdControlAcceso FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('CONTROL_ACCESO', @IdControlAcceso, 'UPDATE', @ValoresNuevos, @IdUsuario);

        SELECT 'Salida registrada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 3 -- Consulta general con permanencia
    BEGIN
        SELECT CA.IdControlAcceso, CA.IdCliente, C.Folio,
               CONCAT(C.Nombres, ' ', C.PrimerApellido, ' ', C.SegundoApellido) AS Cliente,
               CA.IdSucursal, S.Nombre AS Sucursal,
               CA.FechaHoraEntrada, CA.FechaHoraSalida,
               DATEDIFF(MINUTE, CA.FechaHoraEntrada, COALESCE(CA.FechaHoraSalida, SYSDATETIME())) AS MinutosPermanencia,
               CASE
                   WHEN CA.FechaHoraSalida IS NULL THEN 'Pendiente de salida'
                   ELSE 'Completado'
               END AS EstadoAcceso
        FROM dbo.CONTROL_ACCESO CA
        INNER JOIN dbo.CLIENTE C ON CA.IdCliente = C.IdCliente
        INNER JOIN dbo.SUCURSAL S ON CA.IdSucursal = S.IdSucursal
        WHERE (@IdCliente IS NULL OR CA.IdCliente = @IdCliente)
          AND (@IdSucursal IS NULL OR CA.IdSucursal = @IdSucursal)
          AND (@FechaInicio IS NULL OR CA.FechaHoraEntrada >= @FechaInicio)
          AND (@FechaFin IS NULL OR CA.FechaHoraEntrada <= @FechaFin)
        ORDER BY CA.FechaHoraEntrada DESC;
    END

    IF @Accion = 4 -- Consultar si el socio está actualmente dentro del gimnasio
    BEGIN
        SELECT TOP 1 CA.IdControlAcceso, CA.IdCliente, CA.IdSucursal, S.Nombre AS Sucursal,
               CA.FechaHoraEntrada, DATEDIFF(MINUTE, CA.FechaHoraEntrada, SYSDATETIME()) AS MinutosTranscurridos
        FROM dbo.CONTROL_ACCESO CA
        INNER JOIN dbo.SUCURSAL S ON CA.IdSucursal = S.IdSucursal
        WHERE CA.IdCliente = @IdCliente AND CA.FechaHoraSalida IS NULL;
    END
END;
GO

-- SP_CLASE (Especialidad obligatoria cuando aplica, auto-finalización y cancelación lógica)
CREATE OR ALTER PROCEDURE dbo.SP_CLASE
(
    @Accion             TINYINT,
    @IdClase            INT             = NULL,
    @Nombre             VARCHAR(80)     = NULL,
    @Fecha              DATE            = NULL,
    @HoraInicio         TIME            = NULL,
    @HoraFin            TIME            = NULL,
    @CupoMaximo         SMALLINT        = NULL,
    @IdSalon            INT             = NULL,
    @IdEmpleado         INT             = NULL,
    @IdEspecialidad     TINYINT         = NULL,
    @IdEstatus          TINYINT         = NULL,
    @IdUsuario          INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    -- Auto-finalización de clases cuya hora ya concluyó
    UPDATE dbo.CLASE
    SET IdEstatus = 3 -- Finalizada
    WHERE IdEstatus = 1 -- Programada
      AND (Fecha < CAST(GETDATE() AS DATE)
           OR (Fecha = CAST(GETDATE() AS DATE) AND HoraFin <= CAST(GETDATE() AS TIME)));

    IF @Accion = 1 -- Insertar clase
    BEGIN
        IF @Nombre IS NULL OR TRIM(@Nombre) = '' OR @Fecha IS NULL OR @HoraInicio IS NULL
           OR @HoraFin IS NULL OR @CupoMaximo IS NULL OR @IdSalon IS NULL OR @IdEmpleado IS NULL
        BEGIN
            SELECT 'Todos los campos obligatorios deben ser completados.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF @HoraFin <= @HoraInicio
        BEGIN
            SELECT 'La hora de fin debe ser posterior a la hora de inicio.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF @CupoMaximo <= 0
        BEGIN
            SELECT 'El cupo máximo debe ser mayor a cero.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar salón disponible
        IF NOT EXISTS (SELECT 1 FROM dbo.SALON WHERE IdSalon = @IdSalon AND IdEstatus = 1)
        BEGIN
            SELECT 'El salón seleccionado no está disponible para programar clases.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar entrenador activo
        IF NOT EXISTS (SELECT 1 FROM dbo.EMPLEADO WHERE IdEmpleado = @IdEmpleado AND IdEstatus = 1)
        BEGIN
            SELECT 'El empleado seleccionado no se encuentra activo.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar que no haya traslapes de horario en el salón
        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE Fecha = @Fecha AND IdSalon = @IdSalon AND IdEstatus = 1
              AND HoraInicio < @HoraFin AND HoraFin > @HoraInicio
        )
        BEGIN
            SELECT 'El salón ya cuenta con una clase programada en ese horario.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar que el instructor no tenga otra clase simultánea
        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE Fecha = @Fecha AND IdEmpleado = @IdEmpleado AND IdEstatus = 1
              AND HoraInicio < @HoraFin AND HoraFin > @HoraInicio
        )
        BEGIN
            SELECT 'El entrenador ya cuenta con otra clase asignada en ese horario.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.CLASE
            (Nombre, Fecha, HoraInicio, HoraFin, CupoMaximo, IdSalon, IdEmpleado, IdEspecialidad, IdEstatus)
        VALUES
            (TRIM(@Nombre), @Fecha, @HoraInicio, @HoraFin, @CupoMaximo, @IdSalon, @IdEmpleado, @IdEspecialidad, ISNULL(@IdEstatus, 1));

        SET @IdClase = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CLASE WHERE IdClase = @IdClase FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('CLASE', @IdClase, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Clase programada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Consultar por Id
    BEGIN
        SELECT C.IdClase, C.Nombre, C.Fecha, C.HoraInicio, C.HoraFin, C.CupoMaximo,
               C.IdSalon, S.NombreNumero AS Salon, S.IdSucursal, Suc.Nombre AS Sucursal,
               C.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Empleado,
               C.IdEspecialidad, Esp.Nombre AS EspecialidadRequerida,
               C.IdEstatus, EC.Nombre AS Estatus
        FROM dbo.CLASE C
        INNER JOIN dbo.SALON S ON C.IdSalon = S.IdSalon
        INNER JOIN dbo.SUCURSAL Suc ON S.IdSucursal = Suc.IdSucursal
        INNER JOIN dbo.EMPLEADO E ON C.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.ESTATUS_CLASE EC ON C.IdEstatus = EC.IdEstatusClase
        LEFT JOIN dbo.ESPECIALIDAD Esp ON C.IdEspecialidad = Esp.IdEspecialidad
        WHERE C.IdClase = @IdClase;
    END

    IF @Accion = 3 -- Consulta con filtros
    BEGIN
        SELECT C.IdClase, C.Nombre, C.Fecha, C.HoraInicio, C.HoraFin, C.CupoMaximo,
               C.IdSalon, S.NombreNumero AS Salon, S.IdSucursal, Suc.Nombre AS Sucursal,
               C.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Empleado,
               C.IdEspecialidad, Esp.Nombre AS EspecialidadRequerida,
               C.IdEstatus, EC.Nombre AS Estatus,
               (
                   SELECT COUNT(*) FROM dbo.RESERVA R
                   WHERE R.IdClase = C.IdClase AND R.IdEstatus <> 2
               ) AS LugaresOcupados
        FROM dbo.CLASE C
        INNER JOIN dbo.SALON S ON C.IdSalon = S.IdSalon
        INNER JOIN dbo.SUCURSAL Suc ON S.IdSucursal = Suc.IdSucursal
        INNER JOIN dbo.EMPLEADO E ON C.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.ESTATUS_CLASE EC ON C.IdEstatus = EC.IdEstatusClase
        LEFT JOIN dbo.ESPECIALIDAD Esp ON C.IdEspecialidad = Esp.IdEspecialidad
        WHERE (@Nombre IS NULL OR C.Nombre LIKE '%' + TRIM(@Nombre) + '%')
          AND (@Fecha IS NULL OR C.Fecha = @Fecha)
          AND (@IdSalon IS NULL OR C.IdSalon = @IdSalon)
          AND (@IdEmpleado IS NULL OR C.IdEmpleado = @IdEmpleado)
          AND (@IdEstatus IS NULL OR C.IdEstatus = @IdEstatus)
        ORDER BY C.Fecha DESC, C.HoraInicio ASC;
    END

    IF @Accion = 4 -- Modificar clase
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.CLASE WHERE IdClase = @IdClase)
        BEGIN
            SELECT 'La clase no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE IdClase = @IdClase
              AND (IdEstatus = 3 OR Fecha < CAST(GETDATE() AS DATE)
                   OR (Fecha = CAST(GETDATE() AS DATE) AND HoraInicio <= CAST(GETDATE() AS TIME)))
        )
        BEGIN
            SELECT 'No se pueden modificar clases finalizadas o que ya han iniciado.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        DECLARE @FechaF DATE, @HoraIniF TIME, @HoraFinF TIME, @SalonF INT, @EmpF INT, @EspF TINYINT, @EstF TINYINT;
        SELECT @FechaF = COALESCE(@Fecha, Fecha),
               @HoraIniF = COALESCE(@HoraInicio, HoraInicio),
               @HoraFinF = COALESCE(@HoraFin, HoraFin),
               @SalonF = COALESCE(@IdSalon, IdSalon),
               @EmpF = COALESCE(@IdEmpleado, IdEmpleado),
               @EspF = COALESCE(@IdEspecialidad, IdEspecialidad),
               @EstF = COALESCE(@IdEstatus, IdEstatus)
        FROM dbo.CLASE WHERE IdClase = @IdClase;

        IF @HoraFinF <= @HoraIniF
        BEGIN
            SELECT 'La hora de fin debe ser posterior a la hora de inicio.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE Fecha = @FechaF AND IdSalon = @SalonF AND IdEstatus = 1 AND IdClase <> @IdClase
              AND HoraInicio < @HoraFinF AND HoraFin > @HoraIniF
        )
        BEGIN
            SELECT 'El salón ya cuenta con una clase programada en ese horario.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE Fecha = @FechaF AND IdEmpleado = @EmpF AND IdEstatus = 1 AND IdClase <> @IdClase
              AND HoraInicio < @HoraFinF AND HoraFin > @HoraIniF
        )
        BEGIN
            SELECT 'El entrenador ya cuenta con otra clase asignada en ese horario.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.CLASE WHERE IdClase = @IdClase FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.CLASE
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Fecha = @FechaF,
            HoraInicio = @HoraIniF,
            HoraFin = @HoraFinF,
            CupoMaximo = COALESCE(@CupoMaximo, CupoMaximo),
            IdSalon = @SalonF,
            IdEmpleado = @EmpF,
            IdEspecialidad = @EspF,
            IdEstatus = @EstF
        WHERE IdClase = @IdClase;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CLASE WHERE IdClase = @IdClase FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('CLASE', @IdClase, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Clase actualizada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Cancelar clase
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.CLASE WHERE IdClase = @IdClase)
        BEGIN
            SELECT 'La clase no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.CLASE WHERE IdClase = @IdClase FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.CLASE
        SET IdEstatus = 2 -- Cancelada
        WHERE IdClase = @IdClase;

        UPDATE dbo.RESERVA
        SET IdEstatus = 2 -- Cancelada
        WHERE IdClase = @IdClase AND IdEstatus = 1;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.CLASE WHERE IdClase = @IdClase FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('CLASE', @IdClase, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Clase cancelada correctamente. Las reservas se liberaron.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_RESERVA (Reservas con aforo, membresía Oro y Asistencia con 'Asistió' y 'No asistió')
CREATE OR ALTER PROCEDURE dbo.SP_RESERVA
(
    @Accion                 TINYINT,
    @IdReserva              INT         = NULL,
    @FechaHora              DATETIME2   = NULL,
    @IdClase                INT         = NULL,
    @IdCliente              INT         = NULL,
    @IdEmpleado             INT         = NULL,
    @IdEstatus              TINYINT     = NULL,
    @ResultadoAsistencia    TINYINT     = NULL, -- 3=Asistió, 4=No asistió
    @IdUsuario              INT         = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Crear reserva
    BEGIN
        -- 1. Validar socio activo
        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente AND IdEstatus = 1)
        BEGIN
            SELECT 'El socio no se encuentra activo para reservar clases.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- 2. Validar que la clase esté programada y no haya iniciado (Regla 6.9)
        IF NOT EXISTS (
            SELECT 1 FROM dbo.CLASE
            WHERE IdClase = @IdClase AND IdEstatus = 1
              AND (Fecha > CAST(GETDATE() AS DATE)
                   OR (Fecha = CAST(GETDATE() AS DATE) AND HoraInicio > CAST(GETDATE() AS TIME)))
        )
        BEGIN
            SELECT 'No se pueden generar reservas para clases canceladas, finalizadas o que ya han iniciado.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- 3. Validar no tener ya una reserva activa para esta misma clase (Regla 6.9)
        IF EXISTS (SELECT 1 FROM dbo.RESERVA WHERE IdClase = @IdClase AND IdCliente = @IdCliente AND IdEstatus <> 2)
        BEGIN
            SELECT 'El socio ya cuenta con una reserva activa para esta clase.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- 4. Validar suscripción activa y tipo de membresía (Regla 6.2 y 6.9)
        DECLARE @PermiteClases BIT, @MaxClasesSemana TINYINT, @SujetaAforo BIT, @NombreMembresia VARCHAR(30);
        SELECT @PermiteClases = M.PermiteClases,
               @MaxClasesSemana = M.MaxClasesSemana,
               @SujetaAforo = M.SujetaAforo,
               @NombreMembresia = M.Nombre
        FROM dbo.SUSCRIPCION S
        INNER JOIN dbo.MEMBRESIA M ON S.IdMembresia = M.IdMembresia
        WHERE S.IdCliente = @IdCliente AND S.IdEstatus = 2
          AND CAST(GETDATE() AS DATE) BETWEEN S.FechaInicio AND S.FechaVencimiento;

        IF @PermiteClases IS NULL OR @PermiteClases = 0
        BEGIN
            SELECT 'La membresía actual del socio no incluye acceso a clases grupales.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Validar máximo de clases por semana para membresía Plata
        IF @MaxClasesSemana > 0 AND @NombreMembresia <> 'Oro'
        BEGIN
            DECLARE @FechaClase DATE;
            SELECT @FechaClase = Fecha FROM dbo.CLASE WHERE IdClase = @IdClase;

            DECLARE @InicioSemana DATE = DATEADD(DAY, 1 - DATEPART(WEEKDAY, @FechaClase), @FechaClase);
            DECLARE @FinSemana DATE = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @FechaClase), @FechaClase);

            DECLARE @ClasesReservadasSemana INT;
            SELECT @ClasesReservadasSemana = COUNT(*)
            FROM dbo.RESERVA R
            INNER JOIN dbo.CLASE C ON R.IdClase = C.IdClase
            WHERE R.IdCliente = @IdCliente AND R.IdEstatus <> 2
              AND C.Fecha BETWEEN @InicioSemana AND @FinSemana;

            IF @ClasesReservadasSemana >= @MaxClasesSemana
            BEGIN
                SELECT 'El socio ha alcanzado el límite semanal de clases permitidas por su membresía.' AS Mensaje, 'warning' AS TipoMensaje;
                RETURN;
            END
        END

        -- 5. Validar aforo (excepto membresía Oro que exenta aforo)
        IF @NombreMembresia <> 'Oro' AND @SujetaAforo = 1
        BEGIN
            DECLARE @CupoMaximo SMALLINT, @ReservasActuales INT;
            SELECT @CupoMaximo = CupoMaximo FROM dbo.CLASE WHERE IdClase = @IdClase;

            SELECT @ReservasActuales = COUNT(*)
            FROM dbo.RESERVA WHERE IdClase = @IdClase AND IdEstatus <> 2;

            IF @ReservasActuales >= @CupoMaximo
            BEGIN
                SELECT 'La clase ha alcanzado su cupo máximo.' AS Mensaje, 'warning' AS TipoMensaje;
                RETURN;
            END
        END

        -- 6. Insertar reserva confirmada (IdEstatus = 1)
        INSERT INTO dbo.RESERVA (FechaHora, IdClase, IdCliente, IdEmpleado, IdEstatus)
        VALUES (SYSDATETIME(), @IdClase, @IdCliente, @IdEmpleado, 1);
        SET @IdReserva = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.RESERVA WHERE IdReserva = @IdReserva FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('RESERVA', @IdReserva, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Reserva confirmada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Por Id
    BEGIN
        SELECT R.IdReserva, R.FechaHora, R.IdClase, C.Nombre AS Clase, C.Fecha, C.HoraInicio, C.HoraFin,
               R.IdCliente, CL.Folio, CONCAT(CL.Nombres, ' ', CL.PrimerApellido, ' ', CL.SegundoApellido) AS Cliente,
               R.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Capturo,
               R.IdEstatus, ER.Nombre AS Estatus
        FROM dbo.RESERVA R
        INNER JOIN dbo.CLASE C ON R.IdClase = C.IdClase
        INNER JOIN dbo.CLIENTE CL ON R.IdCliente = CL.IdCliente
        INNER JOIN dbo.EMPLEADO E ON R.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.ESTATUS_RESERVA ER ON R.IdEstatus = ER.IdEstatusReserva
        WHERE R.IdReserva = @IdReserva;
    END

    IF @Accion = 3 -- Consulta general con filtros
    BEGIN
        SELECT R.IdReserva, R.FechaHora, R.IdClase, C.Nombre AS Clase, C.Fecha, C.HoraInicio, C.HoraFin,
               R.IdCliente, CL.Folio, CONCAT(CL.Nombres, ' ', CL.PrimerApellido, ' ', CL.SegundoApellido) AS Cliente,
               R.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Capturo,
               R.IdEstatus, ER.Nombre AS Estatus
        FROM dbo.RESERVA R
        INNER JOIN dbo.CLASE C ON R.IdClase = C.IdClase
        INNER JOIN dbo.CLIENTE CL ON R.IdCliente = CL.IdCliente
        INNER JOIN dbo.EMPLEADO E ON R.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.ESTATUS_RESERVA ER ON R.IdEstatus = ER.IdEstatusReserva
        WHERE (@IdClase IS NULL OR R.IdClase = @IdClase)
          AND (@IdCliente IS NULL OR R.IdCliente = @IdCliente)
          AND (@IdEmpleado IS NULL OR R.IdEmpleado = @IdEmpleado)
          AND (@IdEstatus IS NULL OR R.IdEstatus = @IdEstatus)
        ORDER BY C.Fecha DESC, C.HoraInicio ASC;
    END

    IF @Accion = 5 -- Cancelar reserva (Regla 6.9: libera el cupo, conserva registro)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.RESERVA WHERE IdReserva = @IdReserva)
        BEGIN
            SELECT 'La reserva no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.RESERVA WHERE IdReserva = @IdReserva FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.RESERVA
        SET IdEstatus = 2 -- Cancelada
        WHERE IdReserva = @IdReserva;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.RESERVA WHERE IdReserva = @IdReserva FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('RESERVA', @IdReserva, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Reserva cancelada correctamente. Se liberó el cupo de la clase.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 6 -- Registrar o corregir asistencia (Regla 6.10: Resultados 'Asistió'=3 y 'No asistió'=4)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.RESERVA WHERE IdReserva = @IdReserva)
        BEGIN
            SELECT 'La reserva no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF @ResultadoAsistencia NOT IN (3, 4)
        BEGIN
            SELECT 'El resultado de asistencia debe ser 3 (Asistió) o 4 (No asistió).' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        DECLARE @EstatusActual TINYINT;
        SELECT @EstatusActual = IdEstatus FROM dbo.RESERVA WHERE IdReserva = @IdReserva;

        IF @EstatusActual = 2
        BEGIN
            SELECT 'No se puede registrar asistencia en reservas canceladas.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Regla 6.10: El entrenador no puede modificar el resultado una vez registrado. Solo el administrador puede corregir.
        IF @EstatusActual IN (3, 4)
        BEGIN
            -- Verificar si el usuario que ejecuta es Administrador (Rol 1)
            IF NOT EXISTS (
                SELECT 1 FROM dbo.USUARIO
                WHERE IdUsuario = @IdUsuario AND IdRol = 1
            )
            BEGIN
                SELECT 'El entrenador no puede modificar el resultado una vez registrado. Solo el administrador puede corregir asistencias.' AS Mensaje, 'warning' AS TipoMensaje;
                RETURN;
            END
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.RESERVA WHERE IdReserva = @IdReserva FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.RESERVA
        SET IdEstatus = @ResultadoAsistencia
        WHERE IdReserva = @IdReserva;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.RESERVA WHERE IdReserva = @IdReserva FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('RESERVA', @IdReserva, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Resultado de asistencia registrado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END
END;
GO

-- SP_RUTINA (Rutinas, detalles, validación de contraindicaciones médicas del socio y ciclo de vida)
CREATE OR ALTER PROCEDURE dbo.SP_RUTINA
(
    @Accion                     TINYINT,
    @IdRutina                   INT             = NULL,
    @Nombre                     VARCHAR(50)     = NULL,
    @FechaAsignacion            DATE            = NULL,
    @Objetivo                   VARCHAR(300)    = NULL,
    @IdCliente                  INT             = NULL,
    @IdEmpleado                 INT             = NULL,
    @IdEstatus                  TINYINT         = NULL,
    @IdDetalleRutina            INT             = NULL,
    @DiaSemana                  TINYINT         = NULL,
    @Series                     TINYINT         = NULL,
    @Repeticiones               VARCHAR(30)     = NULL,
    @TiempoDescanso             SMALLINT        = NULL,
    @IdEjercicio                INT             = NULL,
    @IgnorarContraindicacion    BIT             = 0,
    @IdUsuario                  INT             = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ValoresAnteriores NVARCHAR(MAX);
    DECLARE @ValoresNuevos     NVARCHAR(MAX);

    IF @Accion = 1 -- Crear rutina
    BEGIN
        IF @Nombre IS NULL OR TRIM(@Nombre) = '' OR @Objetivo IS NULL OR TRIM(@Objetivo) = ''
           OR @IdCliente IS NULL OR @IdEmpleado IS NULL
        BEGIN
            SELECT 'Todos los campos obligatorios deben ser completados.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.CLIENTE WHERE IdCliente = @IdCliente AND IdEstatus = 1)
        BEGIN
            SELECT 'El socio no existe o no se encuentra activo.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        INSERT INTO dbo.RUTINA (Nombre, FechaAsignacion, Objetivo, IdCliente, IdEmpleado, IdEstatus)
        VALUES (TRIM(@Nombre), COALESCE(@FechaAsignacion, CAST(GETDATE() AS DATE)), TRIM(@Objetivo), @IdCliente, @IdEmpleado, ISNULL(@IdEstatus, 1));
        SET @IdRutina = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.RUTINA WHERE IdRutina = @IdRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('RUTINA', @IdRutina, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Rutina creada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 2 -- Consultar rutina por Id
    BEGIN
        SELECT R.IdRutina, R.Nombre, R.FechaAsignacion, R.Objetivo,
               R.IdCliente, C.Folio, CONCAT(C.Nombres, ' ', C.PrimerApellido, ' ', C.SegundoApellido) AS Cliente,
               R.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Entrenador,
               R.IdEstatus, ER.Nombre AS Estatus
        FROM dbo.RUTINA R
        INNER JOIN dbo.CLIENTE C ON R.IdCliente = C.IdCliente
        INNER JOIN dbo.EMPLEADO E ON R.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.ESTATUS_RUTINA ER ON R.IdEstatus = ER.IdEstatusRutina
        WHERE R.IdRutina = @IdRutina;
    END

    IF @Accion = 3 -- Consulta general de rutinas con filtros
    BEGIN
        SELECT R.IdRutina, R.Nombre, R.FechaAsignacion, R.Objetivo,
               R.IdCliente, C.Folio, CONCAT(C.Nombres, ' ', C.PrimerApellido, ' ', C.SegundoApellido) AS Cliente,
               R.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Entrenador,
               R.IdEstatus, ER.Nombre AS Estatus
        FROM dbo.RUTINA R
        INNER JOIN dbo.CLIENTE C ON R.IdCliente = C.IdCliente
        INNER JOIN dbo.EMPLEADO E ON R.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.ESTATUS_RUTINA ER ON R.IdEstatus = ER.IdEstatusRutina
        WHERE (@IdCliente IS NULL OR R.IdCliente = @IdCliente)
          AND (@IdEmpleado IS NULL OR R.IdEmpleado = @IdEmpleado)
          AND (@IdEstatus IS NULL OR R.IdEstatus = @IdEstatus)
          AND (@Nombre IS NULL OR R.Nombre LIKE '%' + TRIM(@Nombre) + '%')
        ORDER BY R.FechaAsignacion DESC;
    END

    IF @Accion = 4 -- Modificar rutina (Regla 6.13: Solo activas)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.RUTINA WHERE IdRutina = @IdRutina)
        BEGIN
            SELECT 'La rutina no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM dbo.RUTINA WHERE IdRutina = @IdRutina AND IdEstatus <> 1)
        BEGIN
            SELECT 'Solo se pueden modificar rutinas que se encuentren Activas.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.RUTINA WHERE IdRutina = @IdRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.RUTINA
        SET Nombre = COALESCE(NULLIF(TRIM(@Nombre), ''), Nombre),
            Objetivo = COALESCE(NULLIF(TRIM(@Objetivo), ''), Objetivo),
            IdEstatus = COALESCE(@IdEstatus, IdEstatus)
        WHERE IdRutina = @IdRutina;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.RUTINA WHERE IdRutina = @IdRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('RUTINA', @IdRutina, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Rutina actualizada correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 5 -- Cambiar estatus de rutina (Finalizada = 2 o Suspendida = 3)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.RUTINA WHERE IdRutina = @IdRutina)
        BEGIN
            SELECT 'La rutina no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        SELECT @ValoresAnteriores = (SELECT * FROM dbo.RUTINA WHERE IdRutina = @IdRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.RUTINA
        SET IdEstatus = COALESCE(@IdEstatus, 2) -- Por defecto Finalizada
        WHERE IdRutina = @IdRutina;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.RUTINA WHERE IdRutina = @IdRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('RUTINA', @IdRutina, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Estatus de la rutina actualizado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 6 -- Agregar ejercicio a rutina (Regla 6.11: Validación estricta de contraindicaciones)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.RUTINA WHERE IdRutina = @IdRutina AND IdEstatus = 1)
        BEGIN
            SELECT 'La rutina no existe o no está activa.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.EJERCICIO WHERE IdEjercicio = @IdEjercicio)
        BEGIN
            SELECT 'El ejercicio seleccionado no existe.' AS Mensaje, 'warning' AS TipoMensaje;
            RETURN;
        END

        -- Regla 6.11: Comparar contraindicaciones del ejercicio con condiciones médicas del socio
        DECLARE @CondicionIncompatible VARCHAR(50);
        SELECT TOP 1 @CondicionIncompatible = C.Nombre
        FROM dbo.RUTINA R
        INNER JOIN dbo.EXPEDIENTE Exp ON R.IdCliente = Exp.IdCliente
        INNER JOIN dbo.EXPEDIENTE_CONDICION EC ON Exp.IdExpediente = EC.IdExpediente
        INNER JOIN dbo.EJERCICIO_CONTRAINDICACION EJ_C ON EC.IdCondicion = EJ_C.IdCondicion
        INNER JOIN dbo.CONDICION C ON EC.IdCondicion = C.IdCondicion
        WHERE R.IdRutina = @IdRutina AND EJ_C.IdEjercicio = @IdEjercicio;

        IF @CondicionIncompatible IS NOT NULL
        BEGIN
            -- Si existe contraindicación y no se marcó ignorar por administrador
            IF @IgnorarContraindicacion = 0
            BEGIN
                SELECT 'El ejercicio está contraindicado por el expediente médico del socio (' + @CondicionIncompatible + '). Asignación rechazada.' AS Mensaje,
                       'warning' AS TipoMensaje;
                RETURN;
            END
            ELSE
            BEGIN
                -- Validar que solo el administrador pueda ignorar la contraindicación
                IF NOT EXISTS (SELECT 1 FROM dbo.USUARIO WHERE IdUsuario = @IdUsuario AND IdRol = 1)
                BEGIN
                    SELECT 'Solo un administrador tiene autorización para ignorar una contraindicación médica.' AS Mensaje, 'warning' AS TipoMensaje;
                    RETURN;
                END
            END
        END

        INSERT INTO dbo.DETALLE_RUTINA (DiaSemana, Series, Repeticiones, TiempoDescanso, IdRutina, IdEjercicio)
        VALUES (@DiaSemana, @Series, TRIM(@Repeticiones), @TiempoDescanso, @IdRutina, @IdEjercicio);
        SET @IdDetalleRutina = SCOPE_IDENTITY();

        SELECT @ValoresNuevos = (SELECT * FROM dbo.DETALLE_RUTINA WHERE IdDetalleRutina = @IdDetalleRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresNuevos, IdUsuario)
        VALUES ('DETALLE_RUTINA', @IdDetalleRutina, 'INSERT', @ValoresNuevos, @IdUsuario);

        SELECT 'Ejercicio agregado a la rutina correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 7 -- Detalle por Id
    BEGIN
        SELECT DR.IdDetalleRutina, DR.IdRutina, DR.DiaSemana, DR.Series, DR.Repeticiones, DR.TiempoDescanso,
               DR.IdEjercicio, E.Nombre AS Ejercicio, GM.Nombre AS GrupoMuscular, D.Nombre AS Dificultad
        FROM dbo.DETALLE_RUTINA DR
        INNER JOIN dbo.EJERCICIO E ON DR.IdEjercicio = E.IdEjercicio
        INNER JOIN dbo.GRUPO_MUSCULAR GM ON E.IdGrupoMuscular = GM.IdGrupoMuscular
        INNER JOIN dbo.DIFICULTAD D ON E.IdDificultad = D.IdDificultad
        WHERE DR.IdDetalleRutina = @IdDetalleRutina;
    END

    IF @Accion = 8 -- Listar todos los ejercicios de una rutina
    BEGIN
        SELECT DR.IdDetalleRutina, DR.IdRutina, DR.DiaSemana, DR.Series, DR.Repeticiones, DR.TiempoDescanso,
               DR.IdEjercicio, E.Nombre AS Ejercicio, GM.Nombre AS GrupoMuscular, D.Nombre AS Dificultad
        FROM dbo.DETALLE_RUTINA DR
        INNER JOIN dbo.EJERCICIO E ON DR.IdEjercicio = E.IdEjercicio
        INNER JOIN dbo.GRUPO_MUSCULAR GM ON E.IdGrupoMuscular = GM.IdGrupoMuscular
        INNER JOIN dbo.DIFICULTAD D ON E.IdDificultad = D.IdDificultad
        WHERE DR.IdRutina = @IdRutina
        ORDER BY DR.DiaSemana, E.Nombre;
    END

    IF @Accion = 9 -- Modificar detalle de rutina
    BEGIN
        SELECT @ValoresAnteriores = (SELECT * FROM dbo.DETALLE_RUTINA WHERE IdDetalleRutina = @IdDetalleRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        UPDATE dbo.DETALLE_RUTINA
        SET DiaSemana = COALESCE(@DiaSemana, DiaSemana),
            Series = COALESCE(@Series, Series),
            Repeticiones = COALESCE(NULLIF(TRIM(@Repeticiones), ''), Repeticiones),
            TiempoDescanso = COALESCE(@TiempoDescanso, TiempoDescanso)
        WHERE IdDetalleRutina = @IdDetalleRutina;

        SELECT @ValoresNuevos = (SELECT * FROM dbo.DETALLE_RUTINA WHERE IdDetalleRutina = @IdDetalleRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);
        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, ValoresNuevos, IdUsuario)
        VALUES ('DETALLE_RUTINA', @IdDetalleRutina, 'UPDATE', @ValoresAnteriores, @ValoresNuevos, @IdUsuario);

        SELECT 'Detalle de rutina actualizado correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 10 -- Quitar ejercicio de rutina
    BEGIN
        SELECT @ValoresAnteriores = (SELECT * FROM dbo.DETALLE_RUTINA WHERE IdDetalleRutina = @IdDetalleRutina FOR JSON PATH, WITHOUT_ARRAY_WRAPPER);

        DELETE FROM dbo.DETALLE_RUTINA WHERE IdDetalleRutina = @IdDetalleRutina;

        INSERT INTO dbo.AUDITORIA (NombreTabla, IdRegistro, TipoOperacion, ValoresAnteriores, IdUsuario)
        VALUES ('DETALLE_RUTINA', @IdDetalleRutina, 'DELETE', @ValoresAnteriores, @IdUsuario);

        SELECT 'Ejercicio retirado de la rutina correctamente.' AS Mensaje, 'success' AS TipoMensaje;
    END

    IF @Accion = 11 -- Consulta calculada: Rutinas activas que requieren revisión por contraindicaciones médicas (Regla 6.11)
    BEGIN
        SELECT DISTINCT R.IdRutina, R.Nombre AS Rutina, R.IdCliente, C.Folio,
               CONCAT(C.Nombres, ' ', C.PrimerApellido, ' ', C.SegundoApellido) AS Socio,
               R.IdEmpleado, CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Entrenador,
               Ej.Nombre AS EjercicioContraindicado,
               Cond.Nombre AS CondicionMedica
        FROM dbo.RUTINA R
        INNER JOIN dbo.CLIENTE C ON R.IdCliente = C.IdCliente
        INNER JOIN dbo.EMPLEADO E ON R.IdEmpleado = E.IdEmpleado
        INNER JOIN dbo.EXPEDIENTE Exp ON C.IdCliente = Exp.IdCliente
        INNER JOIN dbo.EXPEDIENTE_CONDICION EC ON Exp.IdExpediente = EC.IdExpediente
        INNER JOIN dbo.CONDICION Cond ON EC.IdCondicion = Cond.IdCondicion
        INNER JOIN dbo.EJERCICIO_CONTRAINDICACION EJ_C ON Cond.IdCondicion = EJ_C.IdCondicion
        INNER JOIN dbo.DETALLE_RUTINA DR ON R.IdRutina = DR.IdRutina AND DR.IdEjercicio = EJ_C.IdEjercicio
        INNER JOIN dbo.EJERCICIO Ej ON DR.IdEjercicio = Ej.IdEjercicio
        WHERE R.IdEstatus = 1 -- Rutinas activas
        ORDER BY Socio, Rutina;
    END
END;
GO


-------------------------------------------------------------
-- 10. PROCEDIMIENTOS ALMACENADOS DE AUDITORÍA Y REPORTES
-------------------------------------------------------------

-- SP_AUDITORIA (Consulta con filtros para el Administrador)
CREATE OR ALTER PROCEDURE dbo.SP_AUDITORIA
(
    @NombreTabla        VARCHAR(30)     = NULL,
    @IdRegistro         INT             = NULL,
    @IdUsuario          INT             = NULL,
    @TipoOperacion      VARCHAR(10)     = NULL,
    @FechaInicio        DATETIME2       = NULL,
    @FechaFin           DATETIME2       = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT A.IdAuditoria, A.NombreTabla, A.IdRegistro, A.TipoOperacion, A.FechaOperacion,
           A.ValoresAnteriores, A.ValoresNuevos,
           A.IdUsuario, U.NombreCuenta, R.Nombre AS RolUsuario,
           CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Operador
    FROM dbo.AUDITORIA A
    LEFT JOIN dbo.USUARIO U ON A.IdUsuario = U.IdUsuario
    LEFT JOIN dbo.ROL R ON U.IdRol = R.IdRol
    LEFT JOIN dbo.EMPLEADO E ON U.IdEmpleado = E.IdEmpleado
    WHERE (@NombreTabla IS NULL OR A.NombreTabla = @NombreTabla)
      AND (@IdRegistro IS NULL OR A.IdRegistro = @IdRegistro)
      AND (@IdUsuario IS NULL OR A.IdUsuario = @IdUsuario)
      AND (@TipoOperacion IS NULL OR A.TipoOperacion = @TipoOperacion)
      AND (@FechaInicio IS NULL OR A.FechaOperacion >= @FechaInicio)
      AND (@FechaFin IS NULL OR A.FechaOperacion <= @FechaFin)
    ORDER BY A.FechaOperacion DESC;
END;
GO

-- REPORTE 1: Empleados y distribución por sucursal
CREATE OR ALTER PROCEDURE dbo.SP_REPORTE_EMPLEADOS
(
    @IdSucursal         SMALLINT    = NULL,
    @IdPuesto           TINYINT     = NULL,
    @IdEspecialidad     TINYINT     = NULL,
    @FechaInicio        DATE        = NULL,
    @FechaFin           DATE        = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT E.IdEmpleado,
           CONCAT(E.PrimerApellido, ' ', ISNULL(E.SegundoApellido, ''), ', ', E.Nombres) AS NombreCompleto,
           E.CURP,
           P.Nombre AS Puesto,
           ISNULL((
               SELECT STRING_AGG(Esp.Nombre, ', ')
               FROM dbo.EMPLEADO_ESPECIALIDAD EEsp
               INNER JOIN dbo.ESPECIALIDAD Esp ON EEsp.IdEspecialidad = Esp.IdEspecialidad
               WHERE EEsp.IdEmpleado = E.IdEmpleado
           ), 'N/A') AS Especialidades,
           E.FechaContratacion,
           E.Correo,
           E.Telefono,
           S.Nombre AS Sucursal,
           EE.Nombre AS Estatus,
           COUNT(*) OVER(PARTITION BY E.IdSucursal) AS CantidadEmpleadosSucursal
    FROM dbo.EMPLEADO E
    INNER JOIN dbo.PUESTO P ON E.IdPuesto = P.IdPuesto
    INNER JOIN dbo.SUCURSAL S ON E.IdSucursal = S.IdSucursal
    INNER JOIN dbo.ESTATUS_EMPLEADO EE ON E.IdEstatus = EE.IdEstatusEmpleado
    WHERE (@IdSucursal IS NULL OR E.IdSucursal = @IdSucursal)
      AND (@IdPuesto IS NULL OR E.IdPuesto = @IdPuesto)
      AND (@FechaInicio IS NULL OR E.FechaContratacion >= @FechaInicio)
      AND (@FechaFin IS NULL OR E.FechaContratacion <= @FechaFin)
      AND (
          @IdEspecialidad IS NULL
          OR EXISTS (
              SELECT 1 FROM dbo.EMPLEADO_ESPECIALIDAD EEsp
              WHERE EEsp.IdEmpleado = E.IdEmpleado AND EEsp.IdEspecialidad = @IdEspecialidad
          )
      )
    ORDER BY S.Nombre, E.PrimerApellido, E.SegundoApellido, E.Nombres;
END;
GO

-- REPORTE 2: Socios y estado de membresías
CREATE OR ALTER PROCEDURE dbo.SP_REPORTE_SOCIOS
(
    @IdSucursal             SMALLINT    = NULL,
    @IdMembresia            TINYINT     = NULL,
    @IdEstatusCliente       TINYINT     = NULL,
    @IdEstatusSuscripcion   TINYINT     = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT C.IdCliente,
           C.Folio,
           CONCAT(C.PrimerApellido, ' ', ISNULL(C.SegundoApellido, ''), ', ', C.Nombres) AS NombreCompleto,
           C.FechaNacimiento,
           C.Correo,
           C.Telefono,
           S.Nombre AS Sucursal,
           C.FechaInscripcion,
           EC.Nombre AS EstatusSocio,
           ISNULL(M.Nombre, 'Sin suscripción') AS Membresia,
           Sub.FechaInicio AS InicioSuscripcion,
           Sub.FechaVencimiento AS VencimientoSuscripcion,
           ISNULL(ES.Nombre, 'Sin suscripción') AS EstatusSuscripcion,
           CASE
               WHEN Sub.IdEstatus = 4 THEN 'Cancelada'
               WHEN Sub.FechaVencimiento < CAST(GETDATE() AS DATE) THEN 'Vencida'
               WHEN Sub.IdEstatus = 2 AND CAST(GETDATE() AS DATE) BETWEEN Sub.FechaInicio AND Sub.FechaVencimiento THEN 'Activa'
               WHEN Sub.IdSuscripcion IS NULL THEN 'Sin suscripción'
               ELSE ES.Nombre
           END AS EstadoCalculado,
           Exp.TipoSangre
    FROM dbo.CLIENTE C
    INNER JOIN dbo.SUCURSAL S ON C.IdSucursal = S.IdSucursal
    INNER JOIN dbo.ESTATUS_CLIENTE EC ON C.IdEstatus = EC.IdEstatusCliente
    LEFT JOIN dbo.EXPEDIENTE Exp ON C.IdCliente = Exp.IdCliente
    OUTER APPLY (
        SELECT TOP 1 S2.IdSuscripcion, S2.IdMembresia, S2.FechaInicio, S2.FechaVencimiento, S2.IdEstatus
        FROM dbo.SUSCRIPCION S2
        WHERE S2.IdCliente = C.IdCliente
        ORDER BY S2.FechaInicio DESC, S2.IdSuscripcion DESC
    ) Sub
    LEFT JOIN dbo.MEMBRESIA M ON Sub.IdMembresia = M.IdMembresia
    LEFT JOIN dbo.ESTATUS_SUSCRIPCION ES ON Sub.IdEstatus = ES.IdEstatusSuscripcion
    WHERE (@IdSucursal IS NULL OR C.IdSucursal = @IdSucursal)
      AND (@IdMembresia IS NULL OR Sub.IdMembresia = @IdMembresia)
      AND (@IdEstatusCliente IS NULL OR C.IdEstatus = @IdEstatusCliente)
      AND (@IdEstatusSuscripcion IS NULL OR Sub.IdEstatus = @IdEstatusSuscripcion)
    ORDER BY S.Nombre, C.PrimerApellido, C.SegundoApellido, C.Nombres;
END;
GO

-- REPORTE 3: Control de acceso y uso de las instalaciones
CREATE OR ALTER PROCEDURE dbo.SP_REPORTE_CONTROL_ACCESO
(
    @IdCliente          INT             = NULL,
    @IdSucursal         SMALLINT        = NULL,
    @FechaInicio        DATETIME2       = NULL,
    @FechaFin           DATETIME2       = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CA.IdControlAcceso,
           C.Folio,
           CONCAT(C.PrimerApellido, ' ', ISNULL(C.SegundoApellido, ''), ', ', C.Nombres) AS Socio,
           S.Nombre AS Sucursal,
           CA.FechaHoraEntrada,
           CA.FechaHoraSalida,
           DATEDIFF(MINUTE, CA.FechaHoraEntrada, COALESCE(CA.FechaHoraSalida, SYSDATETIME())) AS MinutosPermanencia,
           CONCAT(
               DATEDIFF(MINUTE, CA.FechaHoraEntrada, COALESCE(CA.FechaHoraSalida, SYSDATETIME())) / 60, 'h ',
               DATEDIFF(MINUTE, CA.FechaHoraEntrada, COALESCE(CA.FechaHoraSalida, SYSDATETIME())) % 60, 'm'
           ) AS TiempoFormateado,
           CASE
               WHEN CA.FechaHoraSalida IS NULL THEN 'Pendiente de salida'
               ELSE 'Completado'
           END AS Estatus
    FROM dbo.CONTROL_ACCESO CA
    INNER JOIN dbo.CLIENTE C ON CA.IdCliente = C.IdCliente
    INNER JOIN dbo.SUCURSAL S ON CA.IdSucursal = S.IdSucursal
    WHERE (@IdCliente IS NULL OR CA.IdCliente = @IdCliente)
      AND (@IdSucursal IS NULL OR CA.IdSucursal = @IdSucursal)
      AND (@FechaInicio IS NULL OR CA.FechaHoraEntrada >= @FechaInicio)
      AND (@FechaFin IS NULL OR CA.FechaHoraEntrada <= @FechaFin)
    ORDER BY CA.FechaHoraEntrada DESC;
END;
GO

-- REPORTE 4: Clases grupales, reservas y asistencia (Incluye 'Asistió' y 'No asistió')
CREATE OR ALTER PROCEDURE dbo.SP_REPORTE_CLASES
(
    @IdSucursal         SMALLINT    = NULL,
    @IdClase            INT         = NULL,
    @IdEmpleado         INT         = NULL,
    @Fecha              DATE        = NULL,
    @IdEstatusReserva   TINYINT     = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT C.IdClase,
           C.Nombre AS Clase,
           Suc.Nombre AS Sucursal,
           C.Fecha,
           C.HoraInicio,
           C.HoraFin,
           Sal.NombreNumero AS Salon,
           C.CupoMaximo,
           CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Entrenador,
           EC.Nombre AS EstatusClase,
           COUNT(R.IdReserva) AS TotalReservas,
           SUM(CASE WHEN R.IdEstatus = 1 THEN 1 ELSE 0 END) AS ReservasConfirmadas,
           SUM(CASE WHEN R.IdEstatus = 2 THEN 1 ELSE 0 END) AS ReservasCanceladas,
           SUM(CASE WHEN R.IdEstatus = 3 THEN 1 ELSE 0 END) AS SociosAsistieron,
           SUM(CASE WHEN R.IdEstatus = 4 THEN 1 ELSE 0 END) AS SociosNoAsistieron
    FROM dbo.CLASE C
    INNER JOIN dbo.SALON Sal ON C.IdSalon = Sal.IdSalon
    INNER JOIN dbo.SUCURSAL Suc ON Sal.IdSucursal = Suc.IdSucursal
    INNER JOIN dbo.EMPLEADO E ON C.IdEmpleado = E.IdEmpleado
    INNER JOIN dbo.ESTATUS_CLASE EC ON C.IdEstatus = EC.IdEstatusClase
    LEFT JOIN dbo.RESERVA R ON C.IdClase = R.IdClase
        AND (@IdEstatusReserva IS NULL OR R.IdEstatus = @IdEstatusReserva)
    WHERE (@IdSucursal IS NULL OR Sal.IdSucursal = @IdSucursal)
      AND (@IdClase IS NULL OR C.IdClase = @IdClase)
      AND (@IdEmpleado IS NULL OR C.IdEmpleado = @IdEmpleado)
      AND (@Fecha IS NULL OR C.Fecha = @Fecha)
    GROUP BY C.IdClase, C.Nombre, Suc.Nombre, C.Fecha, C.HoraInicio, C.HoraFin,
             Sal.NombreNumero, C.CupoMaximo, E.Nombres, E.PrimerApellido, E.SegundoApellido, EC.Nombre
    ORDER BY C.Fecha DESC, C.HoraInicio ASC;
END;
GO

-- REPORTE 5: Rutinas de entrenamiento y ejercicios asignados
CREATE OR ALTER PROCEDURE dbo.SP_REPORTE_RUTINAS
(
    @IdCliente          INT             = NULL,
    @IdEmpleado         INT             = NULL,
    @Objetivo           VARCHAR(300)    = NULL,
    @IdGrupoMuscular    SMALLINT        = NULL,
    @IdDificultad       TINYINT         = NULL,
    @FechaInicio        DATE            = NULL,
    @FechaFin           DATE            = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT R.IdRutina,
           CONCAT(C.PrimerApellido, ' ', ISNULL(C.SegundoApellido, ''), ', ', C.Nombres) AS Socio,
           C.Folio,
           CONCAT(E.Nombres, ' ', E.PrimerApellido, ' ', E.SegundoApellido) AS Entrenador,
           R.Nombre AS NombreRutina,
           R.FechaAsignacion,
           R.Objetivo,
           ER.Nombre AS EstatusRutina,
           DR.DiaSemana,
           CASE DR.DiaSemana
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               WHEN 5 THEN 'Viernes'
               WHEN 6 THEN 'Sábado'
               WHEN 7 THEN 'Domingo'
           END AS NombreDia,
           Ej.Nombre AS Ejercicio,
           GM.Nombre AS GrupoMuscular,
           Dif.Nombre AS Dificultad,
           DR.Series,
           DR.Repeticiones,
           DR.TiempoDescanso AS SegundosDescanso
    FROM dbo.RUTINA R
    INNER JOIN dbo.CLIENTE C ON R.IdCliente = C.IdCliente
    INNER JOIN dbo.EMPLEADO E ON R.IdEmpleado = E.IdEmpleado
    INNER JOIN dbo.ESTATUS_RUTINA ER ON R.IdEstatus = ER.IdEstatusRutina
    LEFT JOIN dbo.DETALLE_RUTINA DR ON R.IdRutina = DR.IdRutina
    LEFT JOIN dbo.EJERCICIO Ej ON DR.IdEjercicio = Ej.IdEjercicio
    LEFT JOIN dbo.GRUPO_MUSCULAR GM ON Ej.IdGrupoMuscular = GM.IdGrupoMuscular
    LEFT JOIN dbo.DIFICULTAD Dif ON Ej.IdDificultad = Dif.IdDificultad
    WHERE (@IdCliente IS NULL OR R.IdCliente = @IdCliente)
      AND (@IdEmpleado IS NULL OR R.IdEmpleado = @IdEmpleado)
      AND (@Objetivo IS NULL OR R.Objetivo LIKE '%' + TRIM(@Objetivo) + '%')
      AND (@IdGrupoMuscular IS NULL OR Ej.IdGrupoMuscular = @IdGrupoMuscular)
      AND (@IdDificultad IS NULL OR Ej.IdDificultad = @IdDificultad)
      AND (@FechaInicio IS NULL OR R.FechaAsignacion >= @FechaInicio)
      AND (@FechaFin IS NULL OR R.FechaAsignacion <= @FechaFin)
    ORDER BY C.PrimerApellido, R.FechaAsignacion DESC, DR.DiaSemana;
END;
GO
