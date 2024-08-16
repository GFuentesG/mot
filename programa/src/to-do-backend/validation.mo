import Text "mo:base/Text";
import Debug "mo:base/Debug";

module{
    //funcion para validar el nombre, que tenga mas de 3 letras
    //y no tengan caracteres especiales
    public func validateName(name: Text): Bool {
        var tieneTresLetras: Bool = false;
        var soloLetras: Bool = true;
        var contadorLetras: Int = 0;

        let iter = Text.toIter(name);
        for (char in iter) {
            if ((char >= 'A' and char <= 'Z') or (char >= 'a' and char <= 'z')) {
                contadorLetras += 1;
            } else {
                soloLetras := false;
            };
        };

        if (contadorLetras >= 3) {
            tieneTresLetras := true;
        };

        if (tieneTresLetras and soloLetras) {
            return true;
        } else {
            Debug.print("The name: " # name # " is invalid");
            return false;
        };
    };

    //funcion para validar el email, que tenga el @ y el .
    public func validateEmail(email: Text): Bool {
        var hasAtSymbol = false;
        var hasDotAfterAt = false;
        var atIndex = -1;
        var dotIndex = -1;

        let length = Text.size(email);
        var i = 0;

        // Recorrer cada carácter del texto del email
        for (char in Text.toIter(email)) {
            if (char == '@') {
                if (hasAtSymbol) {
                    // Si ya se ha encontrado un '@' antes, no es un email válido
                    
                    return false;
                } else {
                    hasAtSymbol := true;
                    atIndex := i; //guardamos posicion el @
                };
            };

            //verificamos el caracter . despues del @
            if (char == '.' and hasAtSymbol and i > atIndex) {
                hasDotAfterAt := true;
                dotIndex := i;
            };

            i += 1;
        };

        // Validar posiciones de '@' y '.'
        // que haya un @ , un . , que haya almenos un caracter antes del @
        // que el . este almenos un caracter que el @, que la longitud no sea 0
        // que el . no este en la ultima posicion
        if (hasAtSymbol and hasDotAfterAt and atIndex > 0 and dotIndex > atIndex + 1 and (length > 0) and dotIndex < length - 1) {
            return true;
        } else {
            Debug.print("The email: " # email # " is invalid");
            return false;
        };
    };
    
}
