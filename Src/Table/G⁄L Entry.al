table 60004 "GL Entries-Global"
{
    Caption = 'G/L Entry';
    DataPerCompany = false;
    fields
    {

        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                UpdateAccountID();
            end;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';

            trigger OnLookup()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                IncomingDocument.HyperlinkToDocument("Document No.", "Posting Date");
            end;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) Employee;
        }
        field(17; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(29; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(30; "Prior-Year Entry"; Boolean)
        {
            Caption = 'Prior-Year Entry';
        }
        field(41; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(42; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(43; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(45; "Business Unit Code"; Code[20])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(46; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(47; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(48; "Gen. Posting Type"; Enum "General Posting Type")
        {
            Caption = 'Gen. Posting Type';
        }
        field(49; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(51; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(52; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(53; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(54; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(55; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ClosingDates = true;
        }
        field(56; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(57; "Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type';
        }
        field(58; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Source Type" = CONST(Employee)) Employee;
        }
        field(59; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(60; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(61; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(62; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(63; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(64; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(65; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(68; "Additional-Currency Amount"; Decimal)
        {
            AccessByPermission = TableData Currency = R;
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Additional-Currency Amount';
        }
        field(69; "Add.-Currency Debit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Currency Debit Amount';
        }
        field(70; "Add.-Currency Credit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Add.-Currency Credit Amount';
        }
        field(71; "Close Income Statement Dim. ID"; Integer)
        {
            Caption = 'Close Income Statement Dim. ID';
        }
        field(72; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(73; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(74; "Reversed by Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "G/L Entry";
        }
        field(75; "Reversed Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "G/L Entry";
        }
        field(76; "G/L Account Name"; Text[100])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Journal Templ. Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }
        field(79; "VAT Reporting Date"; Date)
        {
            Caption = 'VAT Date';
            Editable = false;
        }
        field(481; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(3)));
        }
        field(482; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(4)));
        }
        field(483; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(5)));
        }
        field(484; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(6)));
        }
        field(485; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(7)));
        }
        field(486; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(8)));
        }

        field(495; "Last Dim. Correction Entry No."; Integer)
        {
            Caption = 'Last Dim. Correction Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(496; "Last Dim. Correction Node"; Integer)
        {
            Caption = 'Last Dim. Correction Node';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(497; "Dimension Changes Count"; Integer)
        {
            Caption = 'Count of Dimension Changes';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(5400; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
        }
        field(5600; "FA Entry Type"; Option)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'FA Entry Type';
            OptionCaption = ' ,Fixed Asset,Maintenance';
            OptionMembers = " ","Fixed Asset",Maintenance;
        }
        field(5601; "FA Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'FA Entry No.';
            TableRelation = IF ("FA Entry Type" = CONST("Fixed Asset")) "FA Ledger Entry"
            ELSE
            IF ("FA Entry Type" = CONST(Maintenance)) "Maintenance Ledger Entry";
        }
        field(5618; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(6200; "Non-Deductible VAT Amount"; Decimal)
        {
            Caption = 'Non-Deductible VAT Amount';
            AutoFormatType = 1;
        }
        field(6201; "Non-Deductible VAT Amount ACY"; Decimal)
        {
            Caption = 'Non-Deductible VAT Amount ACY';
            AutoFormatType = 1;
        }
        field(8001; "Account Id"; Guid)
        {
            CalcFormula = Lookup("G/L Account".SystemId WHERE("No." = FIELD("G/L Account No.")));
            Caption = 'Account Id';
            FieldClass = FlowField;
            TableRelation = "G/L Account".SystemId;

            trigger OnValidate()
            begin
                UpdateAccountNo();
            end;
        }
        field(8005; "Last Modified DateTime"; DateTime)
        {
            Caption = 'Last Modified DateTime';
            Editable = false;
        }
        field(9099; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(50000; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "G/L Account No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "VAT Amount", Quantity;
        }
        key(Key3; "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "VAT Reporting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "VAT Amount";
        }
        key(Key4; "G/L Account No.", "Business Unit Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key5; "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount";
        }
        key(Key6; "Document No.", "Posting Date")
        {
            SumIndexFields = Amount, "Debit Amount", "Credit Amount", "Additional-Currency Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "VAT Amount";
        }
        key(Key7; "Transaction No.")
        {
        }
        key(Key8; "IC Partner Code")
        {
        }
        key(Key9; "G/L Account No.", "Job No.", "Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key10; "Posting Date", "G/L Account No.", "Dimension Set ID")
        {
            SumIndexFields = Amount;
        }
        key(Key11; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group")
        {
        }
        key(Key12; "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        {
        }
        key(Key13; "Dimension Set ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Description, "G/L Account No.", "Posting Date", "Document Type", "Document No.")
        {
        }
    }

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;

    procedure GetLastEntry(var LastEntryNo: Integer; var LastTransactionNo: Integer)
    var
        FindRecordManagement: Codeunit "Find Record Management";
        FieldNoValues: List of [Integer];
    begin
        FieldNoValues.Add(FieldNo("Entry No."));
        FieldNoValues.Add(FieldNo("Transaction No."));
        FindRecordManagement.GetLastEntryIntFieldValues(Rec, FieldNoValues);
        LastEntryNo := FieldNoValues.Get(1);
        LastTransactionNo := FieldNoValues.Get(2);
    end;

    procedure GetCurrencyCode(): Code[10]
    begin
        if not GLSetupRead then begin
            GLSetup.Get();
            GLSetupRead := true;
        end;
        exit(GLSetup."Additional Reporting Currency");
    end;

    procedure ShowValueEntries()
    var
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";
        ValueEntry: Record "Value Entry";
        TempValueEntry: Record "Value Entry" temporary;
    begin
        GLItemLedgRelation.SetRange("G/L Entry No.", "Entry No.");
        if GLItemLedgRelation.FindSet() then
            repeat
                ValueEntry.Get(GLItemLedgRelation."Value Entry No.");
                TempValueEntry.Init();
                TempValueEntry := ValueEntry;
                TempValueEntry.Insert();
            until GLItemLedgRelation.Next() = 0;

        PAGE.RunModal(0, TempValueEntry);
    end;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption(), "Entry No."));
    end;

    procedure UpdateAccountID()
    var
        GLAccount: Record "G/L Account";
    begin
        if "G/L Account No." = '' then begin
            Clear("Account Id");
            exit;
        end;

        if not GLAccount.Get("G/L Account No.") then
            exit;

        "Account Id" := GLAccount.SystemId;
    end;

    local procedure UpdateAccountNo()
    var
        GLAccount: Record "G/L Account";
    begin
        if IsNullGuid("Account Id") then
            exit;

        if not GLAccount.GetBySystemId("Account Id") then
            exit;

        "G/L Account No." := GLAccount."No.";
    end;

    local procedure SetVATDate(var GenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJnlLine."VAT Reporting Date" = 0D then
            "VAT Reporting Date" := GLSetup.GetVATDate(GenJnlLine."Posting Date", GenJnlLine."Document Date")
        else
            "VAT Reporting Date" := GenJnlLine."VAT Reporting Date";
    end;

    procedure UpdateDebitCredit(Correction: Boolean)
    begin
        if ((Amount > 0) and (not Correction)) or
           ((Amount < 0) and Correction)
        then begin
            "Debit Amount" := Amount;
            "Credit Amount" := 0
        end else begin
            "Debit Amount" := 0;
            "Credit Amount" := -Amount;
        end;

        if (("Additional-Currency Amount" > 0) and (not Correction)) or
           (("Additional-Currency Amount" < 0) and Correction)
        then begin
            "Add.-Currency Debit Amount" := "Additional-Currency Amount";
            "Add.-Currency Credit Amount" := 0
        end else begin
            "Add.-Currency Debit Amount" := 0;
            "Add.-Currency Credit Amount" := -"Additional-Currency Amount";
        end;
    end;
}

