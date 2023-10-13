permissionset 50000 """Chimera Development"
{
    Assignable = true;
    Caption = '"Chimera Development', MaxLength = 30;
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
        codeunit "Import Investran File" = X,
        page "SFTP Integration Log" = X,
        page "Investran - Dyanamic Setup" = X,
        page "Investran Dynamic Stagging" = X,
        report "Import Investran Dynamic" = X;
}
