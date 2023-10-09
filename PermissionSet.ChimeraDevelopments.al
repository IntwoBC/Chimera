permissionset 50000 Chimera_Developments
{
    Assignable = true;
    Caption = 'Chimera Development', MaxLength = 30;
    Permissions =
        table "Investran - Dyanamic Setup" = X,
        tabledata "Investran - Dyanamic Setup" = RMID,
        table "Investran Dynamic Stagging" = X,
        tabledata "Investran Dynamic Stagging" = RMID,
        codeunit CreateGeneralJournal = X,
        codeunit "Investran - Dyanamic" = X,
        page "Investran - Dyanamic Setup" = X,
        page "Investran Dynamic Stagging" = X,
        report "Import Investran Dynamic" = X;
}
