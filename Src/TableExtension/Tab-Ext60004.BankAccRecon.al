tableextension 60004 BankAccRecon extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(60000; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval","Approved";
        }
        field(60001; "Approver 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            begin
                ValidateApprovers();
            end;
        }
        field(60002; "Approver 2"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            begin
                ValidateApprovers();
            end;
        }
        field(60003; "Approver 3"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            begin
                ValidateApprovers();
            end;
        }
    }

    local procedure ValidateApprovers()
    begin
        If (Rec."Approver 1" <> '') AND ((Rec."Approver 1" = "Approver 2") OR (Rec."Approver 1" = Rec."Approver 3")) then
            Error('Approver 1 must not be same as Approver 2 or Approver 3')
        else
            If (Rec."Approver 2" <> '') AND ((Rec."Approver 2" = "Approver 1") OR (Rec."Approver 2" = Rec."Approver 3")) then
                Error('Approver 2 must not be same as Approver 1 or Approver 3')
            else
                If (Rec."Approver 3" <> '') AND ((Rec."Approver 3" = "Approver 1") OR (Rec."Approver 3" = Rec."Approver 2")) then
                    Error('Approver 3 must not be same as Approver 1 or Approver 2');
    end;
}
