permissionset 50000 "Chimera Development"
{
    Assignable = true;
    Caption = 'Chimera Development', MaxLength = 30;
    Permissions =
        table "Investran Dynamic Stagging" = X,
        tabledata "Investran Dynamic Stagging" = RMID,
        table "Investran - Dyanamic Setup" = X,
        tabledata "Investran - Dyanamic Setup" = RMID,
        codeunit CreateGeneralJournal = X,
        codeunit "Investran - Dyanamic" = X,
        codeunit AzureFunctionIntegration = X,
        page "Investran - Dyanamic Setup" = X,
        page "Investran Dynamic Stagging" = X,
        report "Import Investran Dynamic" = X;
}
