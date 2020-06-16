create database coppel_ar; -- Se crea la base de datos

use coppel_ar; -- Para ingresar a la  base de datos creada

-- Se crea la tabla donde se va a cargar el archivo
-- Vuelvan a checar los nombres que deben tener los campos,
-- diganle a Ramón Romero que les pase el archivo drive sobre el estándar de DOMO, ahí viene lo de los nombres que deben tener los campos, los datasets, etc.
-- Ramón Romero tiene que revisar/aprobar el dataset antes de que lo suban  a DOMO, se ponen de acuerdo con él.

create table ventas(
des_NumeroDeOrden varchar (30) default NULL,
des_Email varchar (50) default NULL,
fec_Fecha DATE default NULL,
des_EstadoDeLaOrden varchar (30) default NULL,
des_EstadoDelPago varchar (30) default NULL,
des_EstadoDelEnvio varchar (50) default NULL,
des_Moneda varchar (15) default NULL,
imp_SubtotalDeProductos decimal(11,3) default NULL,
imp_Descuento decimal(11,3) default NULL,
imp_CostoDeEnvio decimal(11,3) default NULL,
imp_Total decimal(11,3) default NULL,
nom_NombreDelComprador varchar (60) default NULL,
num_DNICUIT varchar (30) default NULL,
num_Telefono varchar (30) default NULL,
nom_NombreParaElEnvio varchar (100) default NULL,
num_TelefonoParaElEnvio varchar (30) default NULL,
des_Direccion varchar (100) default NULL,
des_Numero varchar (30) default NULL,
des_Piso varchar (100) default NULL,
nom_Localidad varchar (100) default NULL,
nom_Ciudad varchar (100) default NULL,
des_CodigoPostal varchar (30) default NULL,
nom_ProvinciaoEstado varchar (30) default NULL,
nom_Pais varchar (30) default NULL,
des_MedioDeEnvio varchar (300) default NULL,
des_MedioDePago varchar (30) default NULL,
des_CuponDeDescuento varchar (30) default NULL,
des_NotasDelComprador varchar (500) default NULL,
des_NotasDelVendedor varchar (500) default NULL,
fec_FechaDePago DATE default NULL,
fec_FechaDeEnvio DATE default NULL,
nom_NombreDelProducto varchar (100) default NULL,
imp_PrecioDelProducto decimal(11,3) default NULL,
num_CantidadDelProducto integer default NULL,
des_SKU varchar (30) default NULL,
des_Canal varchar (30) default NULL,
des_Codigodetrackingdelenvio varchar (30) default NULL,
des_Identificadordelatransaccionenelmediodepago varchar (30) default NULL,
des_Identificadordelaorden varchar (30) default NULL);

-- A continuación se carga el archivo a la tabla creada anteriormente
-- Se necesita compilar la función  que viene al final del archivo antes de hacer la  carga.

LOAD DATA INFILE '/var/lib/mysql-files/ventas_2.csv' -- Chequen bien cual es la ruta que corresponde en su máquina
into table ventas
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
enclosed by '"'
LINES terminated by '\n'
IGNORE 1 ROWS

(des_NumeroDeOrden, -- Puede que sea sec_NumeroDeOrden, chequenlo
des_Email,
@fec_Fecha,
des_EstadoDeLaOrden,
des_EstadoDelPago,
des_EstadoDelEnvio,
des_Moneda,
@imp_SubtotalDeProductos,
@imp_Descuento,
@imp_CostoDeEnvio,
@imp_Total,
nom_NombreDelComprador,
num_DNICUIT,
num_Telefono,
nom_NombreParaElEnvio,
num_TelefonoParaElEnvio,
des_Direccion,
des_Numero,
des_Piso,
nom_Localidad,
nom_Ciudad,
des_CodigoPostal,
nom_ProvinciaoEstado,
nom_Pais,
des_MedioDeEnvio,
des_MedioDePago,
des_CuponDeDescuento,
des_NotasDelComprador,
des_NotasDelVendedor,
@fec_FechaDePago,
@fec_FechaDeEnvio,
nom_NombreDelProducto,
imp_PrecioDelProducto,
@num_CantidadDelProducto,
des_SKU,
des_Canal,
des_Codigodetrackingdelenvio,
des_Identificadordelatransaccionenelmediodepago,
des_Identificadordelaorden)

SET

imp_SubtotalDeProductos=NULLIF(@imp_SubtotalDeProductos,''),
imp_Descuento=NULLIF(@imp_Descuento,''),
imp_CostoDeEnvio=NULLIF(@imp_CostoDeEnvio,''),
imp_Total=NULLIF(@imp_Total,''),
fec_Fecha= STR_TO_DATE(TRIM(NULLIF(TRIM(FECHAVALIDA(@fec_Fecha)),'')),"%d/%m/%Y"),
fec_FechaDePago=STR_TO_DATE(TRIM(NULLIF(TRIM(FECHAVALIDA(@fec_FechaDePago)),'')),"%d/%m/%Y"),
fec_FechaDeEnvio=STR_TO_DATE(TRIM(NULLIF(TRIM(FECHAVALIDA(@fec_FechaDeEnvio)),'')),"%d/%m/%Y");


-- Con lo siguiente se rellenan los campos vacíos que tienen el mismo des_NumeroDeOrden que uno que tiene todos los campos llenos
-- que comentó Jaime y que les mostré en la videollamada
-- Checar algunos comentarios que vienen más a abajo 
update ventas as t1 join
ventas as t2 on 
t1.des_NumeroDeOrden = t2.des_NumeroDeOrden
set t1.fec_Fecha=t2.fec_Fecha,
t1.des_EstadoDeLaOrden=t2.des_EstadoDeLaOrden,
t1.des_EstadoDelPago =t2.des_EstadoDelPago,
t1.des_EstadoDelEnvio=t2.des_EstadoDelEnvio,
t1.des_Moneda=t2.des_Moneda,
t1.imp_SubtotalDeProductos=t2.imp_SubtotalDeProductos,
t1.imp_Descuento=t2.imp_Descuento,
t1.imp_CostoDeEnvio=t2.imp_CostoDeEnvio,
t1.imp_Total=t2.imp_Total, -- Consideren si necesario duplicar este valor y el de los otros imp_, puesto que les pueden servir para hacer cálculos en DOMO
t1.nom_NombreDelComprador=t2.nom_NombreDelComprador,
t1.num_DNICUIT=t2.num_DNICUIT,
t1.num_Telefono=t2.num_Telefono,
t1.nom_NombreParaElEnvio=t2.nom_NombreParaElEnvio,
t1.num_TelefonoParaElEnvio=t2.num_TelefonoParaElEnvio,
t1.des_Direccion=t2.des_Direccion,
t1.des_Numero=t2.des_Numero,
t1.des_Piso=t2.des_Piso,
t1.nom_Localidad=t2.nom_Localidad,
t1.nom_Ciudad=t2.nom_Ciudad,
t1.des_CodigoPostal=t2.des_CodigoPostal,
t1.nom_ProvinciaoEstado=t2.nom_ProvinciaoEstado,
t1.nom_Pais=t2.nom_Pais,
t1.des_MedioDeEnvio=t2.des_MedioDeEnvio,
t1.des_MedioDePago=t2.des_MedioDePago,
t1.des_CuponDeDescuento=t2.des_CuponDeDescuento,
t1.des_NotasDelComprador=t2.des_NotasDelComprador,
t1.des_NotasDelVendedor=t2.des_NotasDelVendedor,
t1.fec_FechaDePago=t2.fec_FechaDePago,
t1.fec_FechaDeEnvio=t2.fec_FechaDeEnvio,
t1.des_Canal=t2.des_Canal,
t1.des_Codigodetrackingdelenvio=t2.des_Codigodetrackingdelenvio,
t1.des_Identificadordelatransaccionenelmediodepago=t2.des_Identificadordelatransaccionenelmediodepago,
t1.des_Identificadordelaorden=t2.des_Identificadordelaorden
where t2.fec_Fecha is not null and t1.fec_Fecha is null;

-- FUNCIÓN para resolver el problema de la fecha con -0001 como año
DELIMITER //
CREATE FUNCTION FECHAVALIDA ( FECHA varchar (30)) -- Determina si la fecha es valida, por poblemas con una que tenia un -
RETURNS varchar (30)
READS SQL DATA
DETERMINISTIC
BEGIN
   DECLARE  FECHA_return varchar (30);
   
   IF  LOCATE('-',FECHA)>0 THEN
      SET FECHA_return = NULL;
   ELSE
      SET FECHA_return = FECHA;
   END IF;
   RETURN FECHA_return;
END; // 
DELIMITER ;
