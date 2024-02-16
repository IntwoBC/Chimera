codeunit 60000 "Init Workflow"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendApproval_BRS(var RecBRSHeader: Record "Bank Acc. Reconciliation")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelApproval_BRS(var RecBRSHeader: Record "Bank Acc. Reconciliation")
    begin
    end;
    //Event Creation End

    local procedure IsWFEnabled_BRS(Var RecBRSHeader: Record "Bank Acc. Reconciliation"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "Customized Workflow";
    begin
        exit(WFMngt.CanExecuteWorkflow(RecBRSHeader, WFCode.RunWorkflowOnSendApproval_BRS))
    end;

    procedure CheckWorkflowEnabled(var RecBRSHeader: Record "Bank Acc. Reconciliation"): Boolean
    var
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsWFEnabled_BRS(RecBRSHeader) then
            Error(NoWorkflowEnb);
        exit(true);
    end;


    var
        WFMngt: Codeunit "Workflow Management";
        Text001: TextConst ENU = 'No Workflows Enabled';

}