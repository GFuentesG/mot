import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
//import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
//import Result "mo:base/Result";

import Types "./types";

actor {

  public func get_country_data(countryName: Text) : async Text {

    let ic : Types.IC = actor ("aaaaa-aa");

    // 1. CONFIGURA EL URL DE LA SOLICITUD HTTP
    let baseUrl: Text = "https://restcountries.com/v3.1/name/"; // Endpoint para consultar por nombre de país
    let url: Text = baseUrl # Text.replace(countryName, #char ' ', "%20");

    // 2. PREPARA LOS ENCABEZADOS DE LA SOLICITUD
    let request_headers = [
        { name = "Host"; value = "restcountries.com:443" },
        { name = "User-Agent"; value = "country_data_canister" },
    ];

    // 3. CONTEXTO DE TRANSFORMACIÓN
    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    // 4. SOLICITUD HTTP
    let http_request : Types.HttpRequestArgs = {
        url = url;
        max_response_bytes = null;
        headers = request_headers;
        body = null;
        method = #get;
        transform = ?transform_context;
    };

    // 5. AÑADE CICLOS PARA LA SOLICITUD HTTP
    Cycles.add(20_949_972_000);

    // 6. REALIZA LA SOLICITUD HTTP Y ESPERA LA RESPUESTA
    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

    // 7. DECODIFICA LA RESPUESTA
    let response_body: Blob = Blob.fromArray(http_response.body);
    let decoded_text: Text = switch (Text.decodeUtf8(response_body)) {
        case (null) { "No value returned" };
        case (?y) { y };
    };

    // 8. RETORNA EL CUERPO DE LA RESPUESTA DECODIFICADA
    decoded_text
  };

  public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
      let transformed : Types.CanisterHttpResponsePayload = {
          status = raw.response.status;
          body = raw.response.body;
          headers = [
              { name = "Content-Security-Policy"; value = "default-src 'self'" },
              { name = "Referrer-Policy"; value = "strict-origin" },
              { name = "Permissions-Policy"; value = "geolocation=(self)" },
              { name = "Strict-Transport-Security"; value = "max-age=63072000" },
              { name = "X-Frame-Options"; value = "DENY" },
              { name = "X-Content-Type-Options"; value = "nosniff" },
          ];
      };
      transformed;
  };
};
