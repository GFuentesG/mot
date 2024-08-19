import Result "mo:base/Result";
//import HashMap "mo:base/HashMap";
import Text "mo:base/Text";

module Types {

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
        owner: Principal;
        email: Text;
        country: Text;
    //    tasks: [Task]; //lugar para listar las tareas de cada perfil
    };

    public type ProfileWithCountryDetails = {
        profile: Profile;
        countryDetails: Text;
    };

    type GetProfileResultOk = {
        #profile: Profile; //hereda la estructura de otro type
        #profiles: [Profile];
        #userSuccessfullyAdded;
        #userSuccessfullyDeleted;
        
    };

    type GetProfileResultErr = { //es un varian, ahora con 2 opciones
        #userDoesNotExist;
        #userNotAuthenticated;
        #unregisteredUser_nameOrEmailIsInvalid;
        #countryDataNotFound;
    };

    public type GetProfileResult = Result.Result<GetProfileResultOk, GetProfileResultErr>;
                                                //igual que Profile

    public type GetProfileCountryResult = Result.Result<ProfileWithCountryDetails,GetProfileResultErr>;

    type GetTaskResultOk = {
        #task: Task;
        #tasks: [Task];
        #taskAddedSuccessfully;
        #taskStatusUpdatedSuccessfully;
        #theTaskWasDeleted;
    };

    type GetTaskResultErr = {
        #taskNotFound;
        #taskNotAdded;
        #youDoNotHavePermissionToViewThisTask;
        #userNotAuthenticated;
        #userDoesNotExist;
        #taskIsAlreadyInTheRequestedStatus;
        #taskNotFoundOrYouDoNotOwnThisTask;
        #youAreNotTheOwnerOfThisTask;
        #countryDataNotFound;
        #errModuleHttp;
    };

    public type GetTaskResult = Result.Result<GetTaskResultOk, GetTaskResultErr>;

    // Para futuras implementaciones
    public type GetCountryDataError = {
    };
    public type GetCountryDataOk = {
    };
    public type GetCountryDataResult = Result.Result<GetCountryDataOk, GetCountryDataError>;



    //http

    //public type Timestamp = Nat64;

    //1. Type that describes the Request arguments for an HTTPS outcall
    //See: /docs/current/references/ic-interface-spec#ic-http_request
    public type HttpRequestArgs = {
        url : Text;
        max_response_bytes : ?Nat64;
        headers : [HttpHeader];
        body : ?[Nat8];
        method : HttpMethod;
        transform : ?TransformRawResponseFunction;
    };

    public type HttpHeader = {
        name : Text;
        value : Text;
    };

    public type HttpMethod = {
        #get;
        #post;
        #head;
    };

    public type HttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : [Nat8];
    };

    //2. HTTPS outcalls have an optional "transform" key. These two types help describe it.
    //"The transform function may, for example, transform the body in any way, add or remove headers,
    //modify headers, etc. "
    //See: /docs/current/references/ic-interface-spec#ic-http_request


    //2.1 This type describes a function called "TransformRawResponse" used in line 14 above
    //"If provided, the calling canister itself must export this function."
    //In this minimal example for a `GET` request, you declare the type for completeness, but
    //you do not use this function. You will pass "null" to the HTTP request.
    public type TransformRawResponseFunction = {
        function : shared query TransformArgs -> async HttpResponsePayload;
        context : Blob;
    };

    //2.2 These types describes the arguments the transform function needs
    public type TransformArgs = {
        response : HttpResponsePayload;
        context : Blob;
    };

    public type CanisterHttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : [Nat8];
    };

    public type TransformContext = {
        function : shared query TransformArgs -> async HttpResponsePayload;
        context : Blob;
    };


    //3. Declaring the management canister which you use to make the HTTPS outcall
    public type IC = actor {
        http_request : HttpRequestArgs -> async HttpResponsePayload;
    };


};