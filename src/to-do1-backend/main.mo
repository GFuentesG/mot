import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Types "./types";
import Map "mo:map/Map";
import { thash } "mo:map/Map";
import Validation "./validation";
import Iter "mo:base/Iter";
//import Task "./task";
import Task "canister:task";
import Http "canister:http";


actor MainActor{

  stable var profiles = Map.new<Text, Types.Profile>();

    //adicionar un usuario
    //public shared (msg) func addProfile(newProfile: Types.Profile): async Result.Result<Text, Text> {
    public shared (msg) func addProfile(newProfile: Types.Profile): async Types.GetProfileResult {  
        if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);

        let isNameValid = Validation.validateName(newProfile.username);
        let isEmailValid = Validation.validateEmail(newProfile.email);
        
        if (isNameValid and isEmailValid) {   //
            Debug.print("se adiciono el usuario: " # newProfile.username);
            Map.set(profiles, thash, newProfile.username, newProfile);
            return #ok(#userSuccessfullyAdded);
        } else {
            Debug.print("No se adicionó el usuario");
            return #err(#unregisteredUser_nameOrEmailIsInvalid);
        };
    };

    //obtener un perfil de usuario sin api de pais
    // public query (msg) func getProfile(username: Text): async Types.GetProfileResult {
    //     if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);

    //     let maybeProfile = Map.get(profiles, thash, username);

    //     switch(maybeProfile) {
    //         case(null) {#err(#userDoesNotExist)};    
    //         case(?profile) {#ok(#profile(profile))};
    //     };
    // };

    //obtener un perfil del usuario y detalles del país consumiendo el api de pais
    public shared (msg) func getProfile(username: Text): async Types.GetProfileCountryResult {
        if (Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);

        let maybeProfile = Map.get(profiles, thash, username);

        switch (maybeProfile) {
            case (null) {
                return #err(#userDoesNotExist);
            };
            case (?profile) {
                // Llama a la función get_country_data para obtener detalles del país
                let countryDetailsText = await Http.get_country_data(profile.country);

                // Verifica si la llamada a get_country_data fue exitosa
                if (countryDetailsText == "No value returned") {
                    return #err(#countryDataNotFound);
                };

                // Combina la información del perfil con los detalles del país y retorna
                let result = {
                    profile = profile;
                    countryDetails = countryDetailsText
                };
                return #ok(result);
            };
        };
    };


    //borramos un perfil de usuario
    public shared (msg) func delProfile (username: Text) : async Types.GetProfileResult {
        if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);

        let maybeProfile = Map.get(profiles, thash, username);

        switch(maybeProfile) {
            case(null) {#err(#userDoesNotExist)}; 
            //case(?profile) {   
            case(?_) {
                Map.delete(profiles, thash, username);
                Debug.print("Se borro el usuario");
                //return #ok(#profile(profile));
                return #ok(#userSuccessfullyDeleted);
                };
        }
    };

    //obtenemos toda la lista de perfiles que tenemos
    public query (msg) func getProfiles(): async Types.GetProfileResult {

        if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);

         let profileIter = Map.vals(profiles);
        //return #ok(Iter.toArray(profileIter));
        return #ok(#profiles(Iter.toArray(profileIter)));
     };

    //adicionar tareas a un usuario en particular
    public shared (msg) func addTaskToProfile(username: Text, description: Text): async Types.GetTaskResult {
        if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);
        
        let maybeProfile = Map.get(profiles, thash, username);

        switch (maybeProfile) {
            case(null) { return #err(#userDoesNotExist)};
            case(?profile) {
                // Agregar tarea directamente en el canister Task
                let result = await Task.addTaskForPrincipal(description, profile.owner);
                switch(result) {
                    case(#ok(_)) {
                        Debug.print("Tarea agregada");
                        return #ok(#taskAddedSuccessfully);
                    };
                    case (#err(_)) {
                        return #err(#taskNotAdded);
                    };
                }
            };
        }
    };

    //listar las tareas por usuario o listar todas las tareas
    public shared (msg) func listTasksForUser(username: Text): async Types.GetTaskResult {
        if(Principal.isAnonymous(msg.caller)) return #err(#userNotAuthenticated);
    
        //si el nombre de usuario está en blanco devuelve todas las tareas
        if (Text.equal(username, "")) {
            //let allTasks = await TaskActor.getAllTasks();
            let allTasks = await Task.getAllTasks();
            return #ok(#tasks(allTasks));
        };

        //verifica si el perfil existe
        let maybeProfile = Map.get(profiles, thash, username);

        switch (maybeProfile) {
            case (null) {
                return #err(#userDoesNotExist);
            };
            case (?profile) {
                //retorna las tareas de un usuario paticular
                let userTasks = await Task.getTasksByOwner(profile.owner);
                //return #ok(userTasks);
                return #ok(#tasks(userTasks));
            };
        };
    };

    //Función para ver nuestro id de usuario como referencia
    public query ({caller}) func whoami(): async Principal { //***
        return caller;
    };

};
