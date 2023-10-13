codeunit 50002 ProcessInvestranGeneral
{
    Permissions = tabledata "Scheduled Task" = RIMD;
    trigger OnRun()
    var
        CreateGeneralJournal: Codeunit CreateGeneralJournal;
        CompanyL: Record Company;
        InvsetranSetupL: Record "Investran - Dyanamic Setup";
    begin
        if CompanyL.FindSet() then
            repeat
                Clear(InvsetranSetupL);
                InvsetranSetupL.ChangeCompany(CompanyL.Name);
                InvsetranSetupL.Get();
                if InvsetranSetupL."Import From SFT" then begin
                    if TaskScheduler.CanCreateTask() then begin
                        TaskScheduler.CreateTask(Codeunit::CreateGeneralJournal, 0, true, CompanyL.Name);
                    end;
                end;
            until CompanyL.Next() = 0;
    end;
}
