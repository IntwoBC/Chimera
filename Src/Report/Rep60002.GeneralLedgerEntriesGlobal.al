report 60002 "General Ledger Entries-Global"
{
    ApplicationArea = All;
    Caption = 'General Ledger Entries-Global';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        if (StartDate = 0D) OR (EndDate = 0D) then
            Error('Start Date & End Date must have a valid date');
        GenerateReport();
    end;

    local procedure GenerateReport()
    var
        ReportConfig: Record "Global Report Configuration";
        RecGLEntryChimera: Record "GL Entries-Global";
        GLEntry: Record "G/L Entry";
    begin
        Clear(RecGLEntryChimera);
        RecGLEntryChimera.DeleteAll(true);

        Clear(ReportConfig);
        ReportConfig.SetRange("G/L Entries Dump", true);
        if ReportConfig.FindSet() then begin
            repeat
                Clear(GLEntry);
                GLEntry.ChangeCompany(ReportConfig."Company Name");
                GLEntry.SetRange("Posting Date", StartDate, EndDate);
                if GLEntry.FindSet() then begin
                    repeat
                        RecGLEntryChimera.Init();
                        RecGLEntryChimera.TransferFields(GLEntry);
                        RecGLEntryChimera."Entry No." := 0;
                        RecGLEntryChimera."Company Name" := ReportConfig."Company Name";
                        RecGLEntryChimera.Insert();
                    until GLEntry.Next() = 0;
                end;
            until ReportConfig.Next() = 0;
        end;
        Page.Run(Page::"GL Entries-Global");
    end;

    var
        StartDate, EndDate : Date;

}
