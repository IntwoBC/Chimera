report 60100 "Import Investran Dynamic"
{
    ApplicationArea = All;
    Caption = 'Import Investran Dynamic';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPostReport()
    var
        ImportExcelInvestranDynamicL: Codeunit "Import Investran File";
    begin
        ImportExcelInvestranDynamicL.Run();
    end;
}
