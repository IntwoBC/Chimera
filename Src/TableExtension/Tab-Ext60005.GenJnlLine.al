tableextension 60005 GenJnlLine extends "Gen. Journal Line"
{
    fields
    {
        field(60000; "UserBased Allocation"; Boolean)
        {
            Caption = 'UserBased Allocation';
            DataClassification = ToBeClassified;
        }
        field(60001; "HeadCount Allocation"; Boolean)
        {
            Caption = 'HeadCount Allocation';
            DataClassification = ToBeClassified;
        }
        field(60002; "SquareFoot Allocation"; Boolean)
        {
            Caption = 'SquareFoot Allocation';
            DataClassification = ToBeClassified;
        }
        field(60003; "Product Type Based Allocation"; Boolean)
        {
            Caption = 'Product Type Based Allocation';
            DataClassification = ToBeClassified;
        }
        field(60004; "Derived From Line No."; Integer)
        {
            Caption = 'Product Type Based Allocation';
            DataClassification = ToBeClassified;
        }
        field(60005; "Budget Exceeded"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                CheckDimensionWiseBudgetForGL();
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CheckDimensionWiseBudgetForGL();
            end;
        }

        modify("Amount")
        {
            trigger OnAfterValidate()
            begin
                CheckDimensionWiseBudgetForGL();
            end;
        }
        modify("Shortcut Dimension 2 Code")
        {
            trigger OnAfterValidate()
            begin
                CheckDimensionWiseBudgetForGL();
                if "Budget Exceeded" then begin
                    if not confirm('Actual amount is exceeding the budgeted amount, Do you want to proceed?', false) then
                        Error('');
                end;
            end;
        }
    }
    internal procedure CheckDimensionWiseBudgetForGL()
    begin
        if Rec."Account Type" <> Rec."Account Type"::"G/L Account" then begin
            Rec."Budget Exceeded" := false;
            exit;
        end;

        if Rec."Shortcut Dimension 2 Code" = '' then begin
            Rec."Budget Exceeded" := false;
            exit;
        end;
        If Rec."Amount" = 0 then begin
            Rec."Budget Exceeded" := false;
            exit;
        end;

        if Rec."Amount" > GetBudgetedAmount() then
            "Budget Exceeded" := true
        else
            "Budget Exceeded" := false;

    end;

    local procedure GetBudgetedAmount(): Decimal
    var
        RecGLBudgetEntry: Record "G/L Budget Entry";
    begin
        //There can be more than 1 budget defined in the system for the same date range
        clear(RecGLBudgetEntry);
        RecGLBudgetEntry.SetRange("G/L Account No.", Rec."Account No.");
        RecGLBudgetEntry.SetRange("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        RecGLBudgetEntry.SetRange(Date, CALCDATE('<-CY>', Rec."Posting Date"), CALCDATE('<CY>', Rec."Posting Date"));
        if RecGLBudgetEntry.FindSet() then begin
            RecGLBudgetEntry.CalcSums(Amount);
            exit(RecGLBudgetEntry.Amount - GetActualAmountFromGL());
        end else
            exit(0);
    end;

    local procedure GetActualAmountFromGL(): Decimal
    var
        RecGLEntry: Record "G/L Entry";
    begin
        clear(RecGLEntry);
        RecGLEntry.SetRange("G/L Account No.", Rec."Account No.");
        RecGLEntry.SetRange("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        RecGLEntry.SetRange("Posting Date", CALCDATE('<-CY>', Rec."Posting Date"), CALCDATE('<CY>', Rec."Posting Date"));
        if RecGLEntry.FindSet() then begin
            RecGLEntry.CalcSums(Amount);
            exit(RecGLEntry.Amount);
        end else
            exit(0);
    end;
}
