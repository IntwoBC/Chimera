codeunit 60005 CreateGeneralJournal
{
    trigger OnRun()
    var
        RecInvestranDynamicSetupL: Record "Investran - Dyanamic Setup";
        RecInvestranDynamicStaggingL: Record "Investran Dynamic Stagging";
        CountL: Integer;
    begin
        Clear(RecInvestranDynamicSetupL);
        RecInvestranDynamicSetupL.Get();
        if (RecInvestranDynamicSetupL."Investran Entity Active" = false) OR (RecInvestranDynamicSetupL."Journal Template Name" = '') OR (RecInvestranDynamicSetupL."Journal Batch Name" = '') OR (RecInvestranDynamicSetupL."Investran Legal Entity" = '') then
            exit;

        Clear(RecInvestranDynamicStaggingL);
        RecInvestranDynamicStaggingL.SetCurrentKey("Row No");
        RecInvestranDynamicStaggingL.SetAscending("Row No", true);
        //commented and added setfilter as client want to set multiple names for one company.
        // RecInvestranDynamicStaggingL.SetRange("Legal Entity", RecInvestranDynamicSetupL."Investran Legal Entity");
        RecInvestranDynamicStaggingL.SetFilter("Legal Entity", RecInvestranDynamicSetupL."Investran Legal Entity");
        RecInvestranDynamicStaggingL.SetRange(Status, RecInvestranDynamicStaggingL.Status::"Ready To Sync");
        if RecInvestranDynamicStaggingL.FindSet() then
            repeat
                ClearLastError();
                Commit();
                if Codeunit.Run(Codeunit::"Process General Journal", RecInvestranDynamicStaggingL) then begin
                    RecInvestranDynamicStaggingL.Delete(true);
                    CountL += 1;
                end else begin
                    RecInvestranDynamicStaggingL.Status := RecInvestranDynamicStaggingL.Status::Error;
                    RecInvestranDynamicStaggingL."Error Remarks" := CopyStr(GetLastErrorText, 1, 500);
                    RecInvestranDynamicStaggingL."Tried in Company" := CompanyName;
                    RecInvestranDynamicStaggingL.Modify();
                end;
            until RecInvestranDynamicStaggingL.Next() = 0;
        if GuiAllowed then
            Message('Total %1, lines processed sucessfully', CountL);
    end;
}
