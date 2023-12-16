### Introducción a la computación en la Nube

# Odoo
Odoo, es un software de planificación de recursos empresariales (ERP) de código abierto escritas en Python y publicadas bajo la licencia LGPL. Este ERP cubre todas las necesidades empresariales, desde sitios web/comercio electrónico hasta fabricación, inventario y contabilidad, todo perfectamente integrado. Odoo es uno de los softwares empresariales más instalado del mundo, es utilizado por 2.000.000 de usuarios en todo el mundo, desde empresas muy pequeñas (1 usuario) hasta empresas muy grandes (300.000 usuarios). 

Para obtener más información, consulte www.odoo.com

## Introducción
El presente repositorio se construyó en base a la documentación proveida en dockerhub sobre la imagen oficial de odoo. [Odoo](https://hub.docker.com/_/odoo/) 

Esqumaticamente, lo que realizamos en este repositorio es: crear un servido de base de datos postgress y vincularlo con un o más instancias de odoo. Ambas aplicaciónes utlizan PVs para almacenar su información independientemente de si los pods correspondientes se caen y así poder brindar un mejor servicio.

Para dealizar estas acciones utilizamos [helm](https://helm.sh/), el cual deberá estar instalado junto con kubernetes como prerequisitos.

## Instalación
Para instalar este repositorio se pueden seguir cualquiera de los siguientes caminos (pueden existir otros, aqui brindamos solamente 2).

### Instalación del paquete almacenado en este mismo repositorio

Clonar el repositorio y abrir una terminal en la carpeta del repositorio.

Ejecutar el siquienre comando:

```
helm install my-release ./myOdoo-0.1.0.tgz
```

### Generación del paquete helm e instalación.

Clonar el repositorio y abrir una terminal en la carpeta del repositorio.
Generar el paquete para la instalación

```
helm package myOdoo/
```
Una vez generado el paquete corremos el siguiente comando.
```
helm install my-release ./myOdoo-0.1.0.tgz
```
 **_NOTA:_** Notese que en este caso hemos utilizado como nombre de la instalación ``my-release``. Esto será utilizado en caso de querer desinstalar el paquete. Ver [helm install command](https://helm.sh/docs/helm/helm_install/)

 ## Parámetros

 Dentro de los parametros que se pueden editar se encuentran los sigueintes:

| Nombre ||| Descripción |
| ------------- | ------------- |------------- | ------------- |
| Postgres  | config | name | nombre del configMap que utiliza el contendor de postgres para determinar información de acceso a la base de datos
|||   db | nombre de la base de datos. Por defecto su valor es ``postgresdb``
|||   user | nombre de usuario de la base de datos. Por defecto su valor es ``odoo`` *
|||   pass | password de acceso a la base de datos. Por defecto su valor es ``odoo`` * 
|| deployment | image | imagen utilizada de postgres. Valor por defecto  ``postgres:15``
|| | replicas | cantidad de réplicas de la base de datos. Valor por defecto  ``1``
| Odoo  | deployment | image | imagen de odoo utilizada. Valor por defecto ``odoo:16.0``
|| | replicas | cantidad de réplicas de odoo. Valor por defecto  ``2``

Existén más parametros configurables. Para eso ver el archivo Values.yaml del repositorio.
 **_NOTA:_** Los valores marcados con * Se sugiere cambiarlos luego de las pruebas de concepto.

## Troubleshooting
Puede que al iniciar, los pods de odoo tengan problemas con la base de datos. Esto puede verse si luego de instalar el paquete, los pods comienzan a resetarse muy seguido. 
Para confirmar el problema correremos el siguiente comando:

```
kubectl logs [ODOO POD NAME] -f
```
En los logs identificaremos un mensaje similar a lo sigueinte: "ERROR postgresdb odoo.http. Exception during request handling". 

Para solucionarlo, hacemos lo sigueinte:

Detenemos el deployment de odoo

```
kubectl delete deployment odoo
```

Accedemos a la temrinal del pod de Postgres (ejecutar ``kubectl get all`` to para ver el nombre del pod-)

```
kubectl exec -it [POSTGRES POD NAME] -- bash
```

Alli ejecutramos el siguiente comando para ver las tablas relacionadas:

```
psql -U odoo -l
```

Eliminamos la base de datos postgresdb

```
dropdb -U odoo postgresdb
```

Hecho esto, salimos con el comando exit y podemos levantar manualmente el deployment de odoo o terminar todos los procesos iniciados con helm (``helm uninstall my-release``) y levantarlo de nuevo.

## Desinstalación
Para desinstalar el paquete utilizamos:
```
helm uninstall my-release
```

 **_NOTA:_** En caso de haber utilizado otro nombre para la instalacioń, sustituir ``my-release`` con dicho nombre.
