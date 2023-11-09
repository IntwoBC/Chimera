codeunit 60007 "SFTP Automation"
{
    trigger OnRun()
    begin
        if Codeunit.Run(Codeunit::InvestranUtility) then;
    end;
}
