codeunit 60002 ProcessInvestranGeneral
{
    Permissions = tabledata "Scheduled Task" = RIMD;
    trigger OnRun()
    var
        CreateGeneralJournal: Codeunit CreateGeneralJournal;
        CompanyL: Record Company;
        InvsetranSetupL: Record "Investran - Dyanamic Setup";
    begin
        if CompanyL.FindSet() then begin
            repeat
                Clear(InvsetranSetupL);
                if InvsetranSetupL.ChangeCompany(CompanyL.Name) then begin
                    if InvsetranSetupL.Get() then begin
                        if InvsetranSetupL."Investran Entity Active" then begin
                            if TaskScheduler.CanCreateTask() then begin
                                TaskScheduler.CreateTask(Codeunit::CreateGeneralJournal, 0, true, CompanyL.Name);
                            end;
                        end;
                    end;
                end;
            until CompanyL.Next() = 0;
        end;
    end;
}
