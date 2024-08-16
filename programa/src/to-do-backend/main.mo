import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Map "mo:map/Map";
import { thash } "mo:map/Map";
import Iter "mo:base/Iter";
import Validation "./validation";
import Types "./types";
import Task "./task";
//import TaskActor "canister:task";

actor MainActor{

  stable var profiles = Map.new<Text, Types.Profile>();
    //adicionar un usuario
    //public shared (msg) func addProfile(newProfile: Types.Profile): async Result.Result<Text, Text> {
    public shared (msg) func addProfile(newProfile: Types.Profile): async GetProfileResult {
    
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");

        let isNameValid = Validation.validateName(newProfile.username);
        let isEmailValid = Validation.validateEmail(newProfile.email);
        
        if (isNameValid and isEmailValid) {   //
            Debug.print("adding profile: " # newProfile.username);
            Map.set(profiles, thash, newProfile.username, newProfile);
            return #ok("Profile successfully added");
        } else {
            Debug.print("No se adicionó el registro");
            return #err("Profile not registered, the name or email is invalid");
        };
    };

    //obtener un perfil de usuario
    public query (msg) func getProfile(username: Text): async Types.GetProfileResult {
        if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);

        let maybeProfile = Map.get(profiles, thash, username);

        switch(maybeProfile) {
            case(null) {#err(#userDoesNotExist)};    
            case(?profile) {#ok(profile)};
        };
    };

    //borramos un perfil de usuario
    public shared (msg) func delProfile (username: Text) : async Types.GetProfileResult {
        if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);

        let maybeProfile = Map.get(profiles, thash, username);

        switch(maybeProfile) {
            case(null) {#err(#userDoesNotExist)};    
            case(?profile) {
                Map.delete(profiles, thash, username);
                Debug.print("Se borro el registro");
                return #ok(profile);
                };
        }
    };

    //obtenemos toda la lista de perfiles que tenemos
    public query (msg) func getProfiles(): async Result.Result<[Types.Profile], Text>{
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");

         let profileIter = Map.vals(profiles);
        return #ok(Iter.toArray(profileIter));
     };

    //adicionar tareas a un usuario en particular
    public shared (msg) func addTaskToProfile(username: Text, description: Text): async Result.Result<Text, Text> {
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");
        
        let maybeProfile = Map.get(profiles, thash, username);

        switch (maybeProfile) {
            case(null) { return #err("User does not exist")};
            case(?profile) {
                // Agregar tarea directamente en el módulo TaskActor
                let result = await TaskActor.addTaskForPrincipal(description, profile.owner);

                switch(result) {
                    case(#ok(_)) {
                        Debug.print("Tarea agregada");
                        return #ok("Task added successfully");
                    };
                    case (#err(msg)) {
                        return #err("The task was not added: " # msg);
                    };
                }
            };
        }
    };

    //listar las tareas por usuario o listar todas las tareas
    public shared (msg) func listTasksForUser(username: Text): async Result.Result<[Types.Task], Text> {
        if(Principal.isAnonymous(msg.caller)) return #err("User not authenticated");
    
        //si el nombre de usuario está en blanco devuelve todas las tareas
        if (Text.equal(username, "")) {
            let allTasks = await TaskActor.getAllTasks();
            return #ok(allTasks);
        };

        //verifica si el perfil existe
        let maybeProfile = Map.get(profiles, thash, username);

        switch (maybeProfile) {
            case (null) {
                return #err("User does not exist");
            };
            case (?profile) {
                //retorna las tareas de un usuario paticular
                let userTasks = await TaskActor.getTasksByOwner(profile.owner);
                return #ok(userTasks);
            };
        };
    };

    //Función para ver nuestro id de usuario como referencia
    public query ({caller}) func whoami(): async Principal { //***
        return caller;
    };

};
