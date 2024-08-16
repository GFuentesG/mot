import Text "mo:base/Text";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Types "./types";
//import Validation "./validation";
//import Types "./types";
//import Task "./task";
//import TaskActor "canister:task";





actor TaskActor{

    stable var taskIdCounter: Nat32 = 0; // contador de tareas
    stable var tasks: [Types.Task] = [];

    //adicionar una tarea por el propio usuario
    public shared (msg) func addTask(description: Text): async Result.Result<Text, Text> {
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");

        let caller = msg.caller; 
        return await internalAddTask(description, caller);
    };

    //adicionar una tarea por el administrador
    public func addTaskForPrincipal(description: Text, owner: Principal): async Result.Result<Text, Text> {
        return await internalAddTask(description, owner);
    };

    //funcion privada donde se crea la tarea
    private func internalAddTask(description: Text, owner: Principal): async Result.Result<Text, Text> {
        let newTaskId = taskIdCounter;
        taskIdCounter += 1;

        let newTask: Types.Task = {
            id = newTaskId;
            description = description;
            status = #pending;
            owner = owner;
        };

        tasks := Array.append(tasks, [newTask]); //agrega la nueva tarea a la lista
        return #ok("Task added successfully");
    };

    //ver el detalle de una tarea por numero de tarea del propio usuario
    public query (msg) func getTaskById(taskId: Types.TaskId): async Result.Result<Types.Task, Text> {
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");

        let caller = msg.caller;  //obtenemos el usuario que llama a la función

        // Buscamos la tarea por su id
        let maybeTask = Array.find<Types.Task>(tasks, func (task) { task.id == taskId });

        switch (maybeTask) {
            case null
                return #err("Task not found");

            case (?task)
                //evaluamos si el solicitante es el propietario de la tarea o un canister (posterior desarrollo)
                //if (task.owner == caller or Principal.isAnonymous(caller)) {
                if (task.owner == caller or Principal.isAnonymous(caller)) {
                    return #ok(task);
                } else {
                    return #err("You do not have permission to view this task");
                };
        };
    };

    //listar todas las tareas del propio usuario
    public query (msg) func getMyTasks(): async Result.Result<[Types.Task], Text> { 
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");

        let caller = msg.caller; 
        let userTasks = Array.filter<Types.Task>(tasks, func (task) { task.owner == caller });
        return #ok(userTasks);
    };

    //listar todas las tareas para administracion
    public query func getAllTasks(): async [Types.Task] {
        return tasks;
    };

    //listar todas las tareas por usuario para administracion
    public query func getTasksByOwner(owner: Principal): async [Types.Task] { 
        let userTasks = Array.filter<Types.Task>(tasks, func (task){ 
            task.owner == owner
            });
        return userTasks;
    };

    //cambiar el status de una tarea por el usuario
    public shared (msg) func updateTaskStatus(taskId: Types.TaskId, newStatus: Types.TaskStatus): async Result.Result<Text, Text> {
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");
        
        let caller = msg.caller;  //el usuario logueado

        var taskFound: Bool = false;  //flag para indicar si la tarea fue encontrada

        var updatedTasks: [Types.Task] = [];  //lista para almacenar tareas actualizadas

        for (i in Iter.range(0, Array.size(tasks) - 1)) {  //recorremos las tareas por índice
            let task = tasks[i];

            if (task.id == taskId and task.owner == caller) {  //verificamos ID y propietario
                taskFound := true;

                if (task.status == newStatus) {
                    return #err("Task is already in the requested status");  //si la tarea ya está en el estado solicitado
                } else {
                    let updatedTask: Types.Task = {
                        id = task.id;
                        description = task.description;
                        owner = task.owner;
                        status = newStatus;  //actualizamos solo el estado de la tarea
                    };
                    updatedTasks := Array.append(updatedTasks, [updatedTask]);  //agregamos la tarea actualizada a la lista
                }
            } else {
                updatedTasks := Array.append(updatedTasks, [task]);  //agregamos las tareas no actualizadas a la lista
            }
        };

        if (taskFound) {
            tasks := updatedTasks;  //actualizamos la lista de tareas con las tareas actualizadas
            return #ok("Task status updated successfully");  
        } else {
            return #err("Task not found or you do not own this task");
        }
    };

    //ver nuestro id de usuario
    public query ({caller}) func whoami(): async Principal { 
        return caller;
    };

    //borrar tareas
    public shared (msg) func delTask(taskId: Types.TaskId) : async Result.Result<Types.Task, Text> {
        // Verificar si el usuario está autenticado
        if (Principal.isAnonymous(msg.caller)) return #err("User not authenticated"); //***

        // Buscar la tarea por ID
        let maybeTask = Array.find<Types.Task>(tasks, func (task) { task.id == taskId });

        switch (maybeTask) {
            case (null) { 
                return #err("Task not found");
            };
            case (?task) {
                if (task.owner != msg.caller) {
                    return #err("You are not the owner of this task"); 
                };

                // Eliminar la tarea de la lista de tareas
                tasks := Array.filter<Types.Task>(tasks, func (t) { t.id != taskId });
                return #ok(task); // Devolver la tarea eliminada como confirmación
            };
        };
    };


}
    