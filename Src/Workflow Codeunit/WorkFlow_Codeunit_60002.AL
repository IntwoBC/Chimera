codeunit 60008 "Customized Workflow"
{
    //Workflow demo created by Krishna Kumar 22 Oct 2020
    Permissions = tabledata "Approval Entry" = RIMD;

    trigger OnRun()
    begin

    end;

    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";



    //**************************Send For Approval Event Start***************************
    procedure RunWorkflowOnSendApproval_BRS(): Code[128]
    begin
        exit('RunWorkflowOnSendApproval_BRS');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnSendApproval_BRS', '', true, true)]
    procedure RunWorkflowOnSendApprovalForTO(var RecBRSHeader: Record "Bank Acc. Reconciliation")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendApproval_BRS, RecBRSHeader);
    end;


    //************* To set status pending approval *************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure ChangeAssetStatus(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    VAR
        RecBRSHdr: Record "Bank Acc. Reconciliation";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Bank Acc. Reconciliation":
                begin
                    RecRef.SetTable(RecBRSHdr);
                    RecBRSHdr.Validate("Status", RecBRSHdr."Status"::"Pending Approval");
                    RecBRSHdr.Modify(true);
                    Variant := RecBRSHdr;
                    IsHandled := true;
                end;
        end;
    end;
    //****************************************** Send For Approval End ***********************


    //************ After approval *** Set status to Approved**************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    procedure OnReleaseDocument(RecRef: RecordRef; VAR Handled: Boolean)
    var
        RecBRSHdr: Record "Bank Acc. Reconciliation";
        Variant: Variant;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Bank Acc. Reconciliation":
                BEGIN
                    RecRef.SetTable(RecBRSHdr);
                    RecBRSHdr."Status" := RecBRSHdr."Status"::Approved;
                    RecBRSHdr.Modify(true);
                    Variant := RecBRSHdr;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
        end;
    end;


    //*******************On Populate Approval Entry *********************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecBRSHdr: Record "Bank Acc. Reconciliation";
    begin
        case RecRef.Number of
            database::"Bank Acc. Reconciliation":
                begin
                    RecRef.SetTable(RecBRSHdr);
                    ApprovalEntryArgument."Table ID" := Database::"Bank Acc. Reconciliation";
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Document No." := RecBRSHdr."Bank Account No.";
                    ApprovalEntryArgument."Record ID to Approve" := RecBRSHdr.RecordId;
                    ApprovalEntryArgument."Due Date" := WorkDate();
                    RecRef.GetTable(RecBRSHdr);
                end;
        end;
    end;





    //******************To cancel approval in case of 2nd level***************** 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Management", 'OnBeforeHandleEventWithxRec', '', false, false)]
    procedure OnBeforeHandleEventWithxRec(FunctionName: Code[128]; Variant: Variant; xVariant: Variant; VAR IsHandled: Boolean)
    Var
        RecBRSHdr: Record "Bank Acc. Reconciliation";
        RecRef: RecordRef;
        RecApprovalEntry: Record "Approval Entry";
        ActionableWorkflowStepInstance: Record "Workflow Step Instance";
        WorkFlowMgmt: Codeunit "Workflow Management";
    begin
        RecRef.GetTable(Variant);
        if (RecRef.Number = Database::"Bank Acc. Reconciliation") AND (FunctionName = RunWorkflowOnCancelApproval_BRS()) Then begin
            IF NOT WorkFlowMgmt.FindEventWorkflowStepInstance(ActionableWorkflowStepInstance, FunctionName, Variant, xVariant) THEN BEGIN
                RecBRSHdr := Variant;
                Clear(RecApprovalEntry);
                RecApprovalEntry.SetRange("Table ID", Database::"Bank Acc. Reconciliation");
                RecApprovalEntry.SetRange("Document No.", RecBRSHdr."Bank Account No.");
                RecApprovalEntry.SetRange("Record ID to Approve", RecBRSHdr.RecordId);
                RecApprovalEntry.SetFilter(Status, '%1|%2', RecApprovalEntry.Status::Created, RecApprovalEntry.Status::Open);
                if RecApprovalEntry.FindSet() then
                    RecApprovalEntry.ModifyAll(Status, RecApprovalEntry.Status::Canceled);
                RecBRSHdr.Validate("Status", RecBRSHdr."Status"::Open);
                RecBRSHdr.Modify();
                Variant := RecBRSHdr;
                Message('Bank Account Reconciliation approval request has been cancelled.');
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendApproval_BRS(), Database::"Bank Acc. Reconciliation", 'Bank Acc. Recon approval required', 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelApproval_BRS(), Database::"Bank Acc. Reconciliation", 'Bank Acc. Recon cancel request', 0, false);
    end;

    //****************Reject***************
    procedure RunWorkflowOnReject_BRS(): Code[128]
    begin
        exit('RunWorkflowOnReject_BRS');
    end;
    //****************Reject End***************



    //***********************Cancel For Approval Event  Start******************
    procedure RunWorkflowOnCancelApproval_BRS(): Code[128]
    begin
        exit('RunWorkflowOnCancelApproval_BRS');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Init Workflow", 'OnCancelApproval_BRS', '', true, true)]
    procedure RunWorkflow_OnCancelApproval_BRS(var RecBRSHeader: Record "Bank Acc. Reconciliation")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelApproval_BRS, RecBRSHeader);
    end;
    //***********************End***********************************


    //****************In case of Reject and cancel Approval request***********
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    procedure OnOpenDocument(RecRef: RecordRef; VAR Handled: Boolean)
    VAR
        RecBRSHdr: Record "Bank Acc. Reconciliation";
        Variant: Variant;
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Bank Acc. Reconciliation":
                BEGIN
                    RecRef.SetTable(RecBRSHdr);
                    RecBRSHdr."Status" := RecBRSHdr."Status"::Open;
                    RecBRSHdr.Modify(true);
                    Variant := RecBRSHdr;
                    RecRef.GetTable(Variant);
                    Handled := true;
                END;
        end;

    end;

    //Code to Open Record from Request to Appprove page//Krishna
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', false, false)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; VAR CardPageID: Integer)
    begin
        CASE RecordRef.NUMBER OF
            DATABASE::"Bank Acc. Reconciliation":
                CardPageID := Page::"Bank Acc. Reconciliation";
        end;
    end;

    //To set document Type and No. in Notifiation email Body
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure OnGetDocumentTypeAndNumber(var RecRef: RecordRef; var DocumentType: Text; var DocumentNo: Text; var IsHandled: Boolean);
    var
        FieldRef: FieldRef;
    begin
        case RecRef.Number of
            DATABASE::"Bank Acc. Reconciliation":
                begin
                    DocumentType := RecRef.Caption;
                    FieldRef := RecRef.Field(1);
                    DocumentNo := Format(FieldRef.Value);
                    IsHandled := true;
                end;
        end;
    end;

    //to change the Email Subject
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Entry Dispatcher", 'OnBeforeCreateMailAndDispatch', '', false, false)]
    local procedure OnBeforeCreateMailAndDispatch(var NotificationEntry: Record "Notification Entry"; var MailSubject: Text; var Email: Text; var IsHandled: Boolean);
    var
        RecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
    begin

        if NotificationEntry.Type = NotificationEntry.Type::Approval then begin
            if RecRef.Get(NotificationEntry."Triggered By Record") then begin
                //RecRef.Open(NotificationEntry."Triggered By Record".TableNo);
                RecRef.SetTable(ApprovalEntry);

                case ApprovalEntry.Status of
                    ApprovalEntry.Status::Open:
                        MailSubject := 'Approval Required';
                    ApprovalEntry.Status::Approved:
                        MailSubject := 'Request Approved';
                    ApprovalEntry.Status::Rejected:
                        MailSubject := 'Request Rejected';
                    ApprovalEntry.Status::Canceled:
                        MailSubject := 'Request Canceled';

                end;
            end;
        end;
    end;

    //Manual Reopen
    procedure ReopenOrder(Var RecBankAccRecon: Record "Bank Acc. Reconciliation")
    begin
        if not Confirm('Re-Open, confirm?', false) then exit;
        RecBankAccRecon.TestField(Status, RecBankAccRecon.Status::Approved);
        RecBankAccRecon.Validate(Status, RecBankAccRecon.Status::Open);
        RecBankAccRecon.Modify();
    end;
}