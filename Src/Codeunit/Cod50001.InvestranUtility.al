codeunit 50001 InvestranUtility
{

    procedure ImportFileFromSFTPLocation(var RecStaging: Record "Investran Dynamic Stagging")
    var
        IntegrationSetup: Record "Investran - Dyanamic Setup";
        AzureFunction: Codeunit AzureFunctionIntegration;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        Outstream: OutStream;
        Instream: InStream;
        LogEntryNumber: Integer;
        ImportFileINBC: Codeunit "Import Investran File";
    begin
        if not Confirm('Do you want to import csv file from SFTP?', false) then exit;

        IntegrationSetup.GET;
        IntegrationSetup.TestField("Azure Function endpoint");
        IntegrationSetup.TestField("Authentication Code");
        IntegrationSetup.TestField(Host);
        IntegrationSetup.TestField(Username);
        IntegrationSetup.TestField(Password);
        CheckDuplicacy();
        LogEntryNumber := InsertLog(IntegrationSetup.Filename + Format(Today(), 0, '<Year4>/<Month,2>/<Day,2>') + '.csv',
         IntegrationSetup."Remote Folder", IntegrationSetup."Azure Function endpoint" + IntegrationSetup."Authentication Code");

        ClearLastError();
        Clear(AzureFunction);
        if AzureFunction.Run() then begin
            if AzureFunction.IsSuccessCall() then begin
                //Message('API response: %1', AzureFunction.GetResponse());
                ModifyLog(LogEntryNumber, false, CopyStr(AzureFunction.GetResponse(), 1, 500), true, true);
                TempBlob.CreateOutStream(Outstream);
                Base64Convert.FromBase64(AzureFunction.GetResponse(), Outstream);
                TempBlob.CreateInStream(Instream);
                ModifyLog(LogEntryNumber, false, CopyStr(AzureFunction.GetResponse(), 1, 500), true, true);
                //-importing file in BC
                ClearLastError();
                ImportFileINBC.SetValue(true, Instream, true);
                if ImportFileINBC.Run() then begin
                    ModifyLog(LogEntryNumber, true, CopyStr(AzureFunction.GetResponse(), 1, 500), true, true);
                    Message('File has been successfully fetched from SFTP & imported in Business Central');
                end else begin
                    ModifyLog(LogEntryNumber, false, CopyStr(GetLastErrorText(), 1, 500), true, true);
                end;
                //-end
                // DownloadFromStream(Instream, '', '', '', IntegrationSetup.Filename);
            end else begin
                ModifyLog(LogEntryNumber, false, CopyStr(AzureFunction.GetResponse(), 1, 500), false, true);
                Message('Status:Failed \Response:%1', CopyStr(AzureFunction.GetResponse(), 1, 500));
            end;

        end else begin
            ModifyLog(LogEntryNumber, false, CopyStr(StrSubstNo('Something went wront while connecting Azure FUnction. Response:%1', AzureFunction.GetResponse()), 1, 500), false, True);
            Message('Something went wront while connecting Azure FUnction. \Response:%1', AzureFunction.GetResponse());
        end;

    end;

    local procedure InsertLog(Filename: Text; FOlederPath: Text; URL: Text): Integer
    var
        SFTPLog: Record "SFTP Integration Log";
    begin
        SFTPLog.Init();
        SFTPLog."Entry No." := 0;
        SFTPLog.Insert(true);
        SFTPLog."Action Performed At" := CurrentDateTime;
        SFTPLog."Action Performed By" := UserId;
        SFTPLog.Filename := Filename;
        SFTPLog."Folder Pah" := FOlederPath;
        SFTPLog."SFTP URL" := URL;
        SFTPLog."Successfully Imported" := false;
        SFTPLog."Error Remarks" := '';
        SFTPLog."Action Performed ON" := Today();
        SFTPLog.Modify(true);
        Commit();
        exit(SFTPLog."Entry No.");
    end;

    local procedure ModifyLog(EntryNumber: Integer; Imported: Boolean; ErrorRemarks: Text; FIleReceived: Boolean; usecommit: Boolean)
    var
        SFTPLog: Record "SFTP Integration Log";
    begin
        SFTPLog.GET(EntryNumber);
        SFTPLog."Successfully Imported" := Imported;
        SFTPLog."Error Remarks" := ErrorRemarks;
        SFTPLog."File Received From SFTP" := FIleReceived;
        SFTPLog.Modify(true);
        if usecommit then
            Commit();
    end;

    local procedure CheckDuplicacy()
    var
        SFTPLog: Record "SFTP Integration Log";
    begin
        Clear(SFTPLog);
        SFTPLog.SetRange("Action Performed ON", Today());
        SFTPLog.SetRange("Successfully Imported", true);
        SFTPLog.SetRange("File Received From SFTP", true);
        //SFTPLog.SetFilter("Error Remarks", '=%1', '');
        if SFTPLog.FindFirst() then
            Error('Import action has been already performed by UserId: %1, at: %2', SFTPLog."Action Performed By", SFTPLog."Action Performed At");
    end;
}
