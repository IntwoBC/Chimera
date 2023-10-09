report 50000 "Import Investran Dynamic"
{
    ApplicationArea = All;
    Caption = 'Import Investran Dynamic';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPostReport()
    var
        ImportExcelInvestranDynamicL: Codeunit "Investran - Dyanamic";
    begin
        ImportExcelInvestranDynamicL.Run();
    end;
}
