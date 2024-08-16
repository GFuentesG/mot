import Result "mo:base/Result";
//import Task "task";

module {

    public type TaskId = Nat32; // identificador de cada tarea, unico, de 32 bits

    public type TaskStatus ={
        #pending;
        #completed;
    };

    public type Task ={
        id: TaskId;
        description: Text;
        status: TaskStatus;
        owner: Principal;
    };

    public type Profile ={  
        username: Text;
        email: Text;
        owner: Principal;
        tasks: [Task]; //lugar para listar las tareas de cada perfil
    };

    type GetProfileResultOk = Profile; //hereda la estructura de otro type

    type GetProfileResultErr = { //es un varian, ahora con 2 opciones
        #userDoesNotExist;
        #userNotAuthenticated;
    };

    public type GetProfileResult = Result.Result<GetProfileResultOk, GetProfileResultErr>;
                                                //igual que Profile
}