# PROGRAMA DE REGISTRO DE USUARIOS Y SUPERVISION DE TAREAS
---
Nuestro sistema de identidad, Registro de perfiles, obtencion de datos y Supervision de
Tareas tiene como caracteristicas:

- Administrar usuarios para la Supervision de tareas
- Adicion de tareas por el Supervidor o por el usuario
- Cambio de estado de la tarea por el usuario
- Listar todas las tareas generadas por el usuario o Supervisor
- Filtrar las tareas de un usuario particular por el Administrador
- Filtrar solo las tareas propias del usuario, por el usuario
- Bloqueo de tareas que no pertenescan al propio usuario
- Uso de identidad o login para interactuar con los sistemas y realizar los filtros
- Validaciones de datos del perfil
- Cambio de estado de tareas
- Consumo base de api externa web2 para obtener datos del pais del usuario 
- Uso de arquitectura por capas

## Se ha utilizado funcionalidades como:

- uso de libreria del paquete mops
- uso de modulos base y propios
- validacion de usuario
- persistencia de datos
- manejo de mensajes de error
- conexion entre canister y dependencias
- conexion con el mundo exterior mediante api

El objetivo de este desarrollo es familiarizarse con las caracteristicas del lenguaje Motoko  y 
ver el comportamiento de diferentes funcionalidades (mostrar,
traer, devolver, hacer llamadas, borrar, entre otras).


## Operacion del Sistema
---
El Sistema tiene el desarrollo del BackEnd, por lo que haremos uso de la interface Candid UI para interactuar tanto el Supervisor como los usuarios, el Supervisor usara el canister principal: to-do1-backend (main.mo), y los usuarios el canister task (task.mo).

### Pre-condicion:
- Tanto el Supervisor como los usuarios, deberan loguearse con Identity, caso contrario no podran operar el sistema y les aparecera un mensaje de error.

### El Supervidor operara las siguientes funciones:

-  addProfile: colocara los datos del usuario como:
    - username
    - owner (que es su id principal obtenido al loguearse)
    - email
    - country
    Con este registro el Supervisor tendra los datos personales asi como acceso al
    registro de tareas personal de cada usuario.
- addTaskToProfile: el Supervisor podra adicionar tareas a un usuario, colocando
    - nombre del usuario
    - nombre de la tarea
    Las tareas seran adicionadas al registro de tareas personales de cada usuario
- delProfile: para borrar un perfil del registro colocara
    - nombre del usuario
- getProfile: obtendra los datos del perfil de un usuario, y colocara
    - nombre del usuario
    El sistema le devolvera el perfil del usuario, pero ademas el sistema hara la consulta
    a un servicio externo web2 para consultar los detalles del pais del usuario, esta
    informacion traera varios datos para ser considerados a futuro (idioma, moneda,
    nomenclatura del pais, codigo telefonico, entre muchos otros datos mas)
- getProfiles: obtendra los datos basicos de todos los usuarios
- getTaskForUser: obtendra los datos de las tareas de un ususario, debera colocar:
    - nombre del usuario
    En caso se deje en blanco, se ha diseñado el Sistema para que con esta condicion se
    muestre todas las tareas de todos los usuarios
- whoami: esta como referencia para obtener el id principal del propio Supervisor

### Los usurios operaran las siguientes funciones:

- addTask: colocara la informacion de su tarea para ser agregada en su registro personal:
    - nobre de la tarea
- addtaskforPrincipal: funcion para el Sistema
- delTask:  para borrar una tarea, se debera inddicar
    - numero de tarea
- getAllTask: funcion para el Sistema
- getMyTask: funcion para listar todas las tareas con su id de tarea asignado
- getTaskById: funcion para mostrar los detalles de una tarea especifica, se debera colocar:
    - numero de la tarea
- getTasksByOwner: funcion para el Sistema
- updateTaskStatus: funcion para cambiar el estado de una tarea (de pendiente a completado
o viseversa), se debera colocar:
    - numero de la tarea
    - escojer el estado
- whoami: funcion para obtener el id principal del propio usuario

### Funciones complementarias para la opracion del Sistema:
---
#### En canister task: 
Manejo interno y/o acceso para el Supervisor

- internalAddTask: funcion privada que obtiene la informacion de dos funciones (del
usuario o la asignada al administrador, para registrar una tarea)
- addTaskForPrincipal: funcion para la conexion con el canister del Administrador, donde
podra obtener las tareas, los datos que se manejan son:
    - nombre del usuario
    - id principal del usuario
- getAllTask: funcion para listar todas las tareas registradas en el sistema

#### Modulo types:

- Registro de todos los tipos de datos

#### Modulo validation:

- Funciones de validacion de parametros para los perfiles de usuario

#### Paquete mops:

- modulo map, para el registro de usuarios en un mapa de perfiles

#### Canister Http:

- Funciones para la conexion con api de https://restcountries.com que al darle el nombre
de un pais, retorna la informacion de dicho pais, proporciona datos como:
    - nombre
    - nombre oficial
    - sufijo de dominio
    - moneda
    - simbolo de moneda
    - capital
    - region
    - idiomas
    - codigo para marcado telefonico de pais
    - otros datos

- **Nota**:
*Dado que es un **servicio gratuito y proporcionado por terceros**, puede que la 
informacion no este completa o actualizada, por lo que no se ha incorporado validaciones 
en el registro de perfil de este campo por el momento.* 