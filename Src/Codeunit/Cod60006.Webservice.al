codeunit 60006 AzureFunctionIntegration
{
    trigger OnRun()
    begin
        //CallWebservice();
        CallAzureFunction();
    end;

    procedure CallWebservice()
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        HttpRequestMessage: HttpRequestMessage;
        Helper: Codeunit "Type Helper";
    begin
        CLEAR(Response);
        HttpRequestMessage.Method(Method);
        HttpClient.SetBaseAddress(URL);
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'Application/json');
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        HttpClient.DefaultRequestHeaders.TryAddWithoutValidation('Content-Type', 'Application/json');
        HttpRequestMessage.Content(HttpContent);
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsSuccessStatusCode() then begin
                IsSuccess := TRUE;
                HttpResponseMessage.Content.ReadAs(Response);
            end else begin
                IsSuccess := FALSE;
                HttpResponseMessage.Content().ReadAs(Response);
            end;
        end else
            Error('Something went wrong while connecting API. %1', GetLastErrorText);
    end;

    local procedure CallAzureFunction()
    var
        AzureAuth: Codeunit "Azure Functions Authentication";
        AzureFn: Codeunit "Azure Functions";
        Auth: Interface "Azure Functions Authentication";
        CodResponse: Codeunit "Azure Functions Response";
        DQuery: Dictionary of [Text, Text];
        Result: Text;
        IntegrationSetup: Record "Investran - Dyanamic Setup";
    begin
        IntegrationSetup.GET;
        Auth := AzureAuth.CreateCodeAuth(IntegrationSetup."Azure Function endpoint", IntegrationSetup."Authentication Code");
        DQuery.Add('Host', IntegrationSetup.Host);//'SFTP-Investran-uk.fisglobal.com');
        DQuery.Add('UserName', IntegrationSetup.Username);//'FTP_Chimera_PBI_PROD');
        DQuery.Add('Password', IntegrationSetup.Password);//'r#f4y4*dt#tzyzD$');
        DQuery.Add('RemoteFolder', IntegrationSetup."Remote Folder");//'/');
        DQuery.Add('FileName', IntegrationSetup.Filename + DelChr(Format(WorkDate(), 0, '<Year4>/<Month,2>/<Day,2>'), '=', '/\-:'));// 'Dynamics Daily Report_20230922170158.csv');
        CodResponse := AzureFn.SendGetRequest(Auth, DQuery);
        if CodResponse.IsSuccessful() then begin
            IsSuccess := TRUE;
            CodResponse.GetResultAsText(Response);
        end else begin
            IsSuccess := FALSE;
            CodResponse.GetError(Response);
        end;
    end;

    procedure GetResponse(): Text
    begin
        exit(Response);
    end;

    procedure IsSuccessCall(): Boolean
    begin
        exit(IsSuccess);
    end;

    procedure SetValues(URLp: Text; Methodp: Code[10])
    begin
        URL := URLp;
        Method := Methodp;
    end;

    var
        URL: Text;
        Response: Text;
        IsSuccess: Boolean;
        Method: Code[10];
}