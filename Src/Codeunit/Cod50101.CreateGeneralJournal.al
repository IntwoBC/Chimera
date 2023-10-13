codeunit 50101 CreateGeneralJournal
{
    trigger OnRun()
    var
        RecInvestranDynamicSetupL: Record "Investran - Dyanamic Setup";
        RecInvestranDynamicStaggingL: Record "Investran Dynamic Stagging";
        CountL: Integer;
    begin
        Clear(RecInvestranDynamicSetupL);
        RecInvestranDynamicSetupL.Get();
        RecInvestranDynamicSetupL.TestField("Investran Entity Active");
        RecInvestranDynamicSetupL.TestField("Journal Template Name");
        RecInvestranDynamicSetupL.TestField("Journal Batch Name");

        Clear(RecInvestranDynamicStaggingL);
        RecInvestranDynamicStaggingL.SetCurrentKey("Row No");
        RecInvestranDynamicStaggingL.SetAscending("Row No", true);
        RecInvestranDynamicStaggingL.SetRange("Legal Entity", RecInvestranDynamicSetupL."Investran Legal Entity");
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
                    RecInvestranDynamicStaggingL.Modify();
                end;
            until RecInvestranDynamicStaggingL.Next() = 0;
        Message('Total %1, lines processed sucessfully', CountL);
    end;
}
