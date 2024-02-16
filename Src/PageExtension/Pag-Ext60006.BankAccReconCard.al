pageextension 60006 BankAccReconCard extends "Bank Acc. Reconciliation"
{
    layout
    {
        addlast(General)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify(General)
        {
            Editable = PageEditable;
        }
        modify(Control8)
        {
            Editable = PageEditable;
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Approved);
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Approved);
            end;
        }
        addfirst(processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Enabled = IsSendRequest;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WfInitCode: Codeunit "Init Workflow";
                        AdvanceWorkflowCUL: Codeunit "Customized Workflow";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        if WfInitCode.CheckWorkflowEnabled(Rec) then begin
                            WfInitCode.OnSendApproval_BRS(Rec);
                        end;
                        //SetControl();
                    end;
                }

                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Enabled = IsCancel;
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    var
                        InitWf: Codeunit "Init Workflow";
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        InitWf.OnCancelApproval_BRS(Rec);
                        //SetControl();
                    end;
                }
                action("Reopen")
                {
                    ApplicationArea = All;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Enabled = (Rec.Status = Rec.Status::Approved);
                    trigger OnAction()
                    var
                        Utility: Codeunit "Customized Workflow";
                    begin
                        Utility.ReopenOrder(Rec);
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RunWorkflowEntriesPage(Rec.RecordId(), DATABASE::"Bank Acc. Reconciliation", Enum::"Approval Document Type"::" ", Rec."Bank Account No.");
                    end;
                }
            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject to approve the incoming document.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = false;// OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        SetControl();
    end;

    trigger OnOpenPage()
    begin
        SetControl();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetControl();
    end;

    local procedure SetControl()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        if Rec."Status" = Rec."Status"::Open then begin
            IsSendRequest := true;
            IsCancel := false;
            PageEditable := true;
            StyleText := '';
        end else
            if Rec."Status" = Rec."Status"::"Pending Approval" then begin
                IsSendRequest := false;
                IsCancel := true;
                PageEditable := false;
                StyleText := 'Ambiguous';
            end else begin
                IsSendRequest := false;
                IsCancel := false;
                PageEditable := false;
                StyleText := 'Favorable';
            end;
        CurrPage.Update(false);
    end;

    var
        IsSendRequest: Boolean;
        PageEditable: Boolean;
        IsCancel: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        StyleText: Text;
        SetEditable: Boolean;
}
