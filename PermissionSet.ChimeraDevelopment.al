permissionset 60000 "Chimera Development"
{
    Assignable = true;
    Caption = 'Chimera Development By InTWO', MaxLength = 30;
    Permissions =
        table "Investran - Dyanamic Setup" = X,
        tabledata "Investran - Dyanamic Setup" = RMID,
        table "Investran Dynamic Stagging" = X,
        tabledata "Investran Dynamic Stagging" = RMID,
        table "SFTP Integration Log" = X,
        tabledata "SFTP Integration Log" = RMID,
        codeunit AzureFunctionIntegration = X,
        codeunit InvestranUtility = X,
        codeunit ProcessInvestranGeneral = X,
        codeunit CreateGeneralJournal = X,
        codeunit "SFTP Automation" = X,
        codeunit "Import Investran File" = X,
        page "SFTP Integration Log" = X,
        page "Investran - Dyanamic Setup" = X,
        page "Investran Dynamic Stagging" = X,
        report "Import Investran Dynamic" = X,
        report "Global Trial Balance Report" = X,
        report "General Ledger Entries-Global" = X,
        Page "Global Report Configuration" = X,
        Page "GL Entries-Global" = X,
        Table "Global Report Configuration" = X,
        tabledata "Global Report Configuration" = RMID,
        table "GL Entries-Global" = X,
        tabledata "GL Entries-Global" = RMID;
}
