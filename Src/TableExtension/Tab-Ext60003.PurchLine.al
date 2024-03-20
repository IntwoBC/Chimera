tableextension 60003 PurchLine extends "Purchase Line"
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
        field(60006; "Amount Inc. VAT LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        modify("No.")
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
    var
        CurrencyExchRate: Record "Currency Exchange Rate";
        Phdr: Record "Purchase Header";
        GenLedgSetup: Record "General Ledger Setup";
    begin
        if NOT (Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice]) then begin
            Rec."Budget Exceeded" := false;
            exit;
        end;
        if Rec.Type <> Rec.Type::"G/L Account" then begin
            Rec."Budget Exceeded" := false;
            exit;
        end;

        if Rec."Shortcut Dimension 2 Code" = '' then begin
            Rec."Budget Exceeded" := false;
            exit;
        end;
        If Rec."Amount Including VAT" = 0 then begin
            Rec."Budget Exceeded" := false;
            exit;
        end;
        GenLedgSetup.GET;
        Phdr := rec.GetPurchHeader();
        Rec."Amount Inc. VAT LCY" := CurrencyExchRate.ExchangeAmount("Amount Including VAT", Phdr."Currency Code", GenLedgSetup."LCY Code", Phdr."Posting Date");
        if Rec."Amount Inc. VAT LCY" > GetBudgetedAmount() then
            "Budget Exceeded" := true
        else
            "Budget Exceeded" := false;

    end;

    local procedure GetBudgetedAmount(): Decimal
    var
        RecGLBudgetEntry: Record "G/L Budget Entry";
        Phdr: Record "Purchase Header";
    begin
        Phdr := rec.GetPurchHeader();
        clear(RecGLBudgetEntry);
        RecGLBudgetEntry.SetRange("G/L Account No.", Rec."No.");
        RecGLBudgetEntry.SetRange("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        RecGLBudgetEntry.SetRange(Date, CALCDATE('<-CY>', Phdr."Posting Date"), CALCDATE('<CY>', Phdr."Posting Date"));
        if RecGLBudgetEntry.FindSet() then begin
            RecGLBudgetEntry.CalcSums(Amount);
            exit(RecGLBudgetEntry.Amount - GetActualAmountFromGL());
        end else
            exit(0);
    end;

    local procedure GetActualAmountFromGL(): Decimal
    var
        RecGLEntry: Record "G/L Entry";
        Phdr: Record "Purchase Header";
    begin
        Phdr := rec.GetPurchHeader();
        clear(RecGLEntry);
        RecGLEntry.SetRange("G/L Account No.", Rec."No.");
        RecGLEntry.SetRange("Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        RecGLEntry.SetRange("Posting Date", CALCDATE('<-CY>', Phdr."Posting Date"), CALCDATE('<CY>', Phdr."Posting Date"));
        if RecGLEntry.FindSet() then begin
            RecGLEntry.CalcSums(Amount);
            exit(RecGLEntry.Amount);
        end else
            exit(0);
    end;
}
