page 60004 "GL Entries-Global"
{
    Caption = 'GL Entries-Global';
    PageType = List;
    SourceTable = "GL Entries-Global";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.';
                    ApplicationArea = All;
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ToolTip = 'Specifies the value of the System-Created Entry field.';
                    ApplicationArea = All;
                }
                field("Prior-Year Entry"; Rec."Prior-Year Entry")
                {
                    ToolTip = 'Specifies the value of the Prior-Year Entry field.';
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ToolTip = 'Specifies the value of the VAT Amount field.';
                    ApplicationArea = All;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ToolTip = 'Specifies the value of the Business Unit Code field.';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    ApplicationArea = All;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ToolTip = 'Specifies the value of the Gen. Posting Type field.';
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                    ApplicationArea = All;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                    ApplicationArea = All;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.';
                    ApplicationArea = All;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.';
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Source Type field.';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = All;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ToolTip = 'Specifies the value of the Tax Area Code field.';
                    ApplicationArea = All;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ToolTip = 'Specifies the value of the Tax Liable field.';
                    ApplicationArea = All;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ToolTip = 'Specifies the value of the Tax Group Code field.';
                    ApplicationArea = All;
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ToolTip = 'Specifies the value of the Use Tax field.';
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                    ApplicationArea = All;
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    ToolTip = 'Specifies the value of the Additional-Currency Amount field.';
                    ApplicationArea = All;
                }
                field("Add.-Currency Debit Amount"; Rec."Add.-Currency Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Add.-Currency Debit Amount field.';
                    ApplicationArea = All;
                }
                field("Add.-Currency Credit Amount"; Rec."Add.-Currency Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Add.-Currency Credit Amount field.';
                    ApplicationArea = All;
                }
                field("Close Income Statement Dim. ID"; Rec."Close Income Statement Dim. ID")
                {
                    ToolTip = 'Specifies the value of the Close Income Statement Dim. ID field.';
                    ApplicationArea = All;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ToolTip = 'Specifies the value of the IC Partner Code field.';
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.';
                    ApplicationArea = All;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ToolTip = 'Specifies the value of the Reversed by Entry No. field.';
                    ApplicationArea = All;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ToolTip = 'Specifies the value of the Reversed Entry No. field.';
                    ApplicationArea = All;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ToolTip = 'Specifies the value of the G/L Account Name field.';
                    ApplicationArea = All;
                }
                field("Journal Templ. Name"; Rec."Journal Templ. Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                    ApplicationArea = All;
                }
                field("VAT Reporting Date"; Rec."VAT Reporting Date")
                {
                    ToolTip = 'Specifies the value of the VAT Date field.';
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code field.';
                    ApplicationArea = All;
                }
                field("Last Dim. Correction Entry No."; Rec."Last Dim. Correction Entry No.")
                {
                    ToolTip = 'Specifies the value of the Last Dim. Correction Entry No. field.';
                    ApplicationArea = All;
                }
                field("Last Dim. Correction Node"; Rec."Last Dim. Correction Node")
                {
                    ToolTip = 'Specifies the value of the Last Dim. Correction Node field.';
                    ApplicationArea = All;
                }
                field("Dimension Changes Count"; Rec."Dimension Changes Count")
                {
                    ToolTip = 'Specifies the value of the Count of Dimension Changes field.';
                    ApplicationArea = All;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ToolTip = 'Specifies the value of the Prod. Order No. field.';
                    ApplicationArea = All;
                }
                field("FA Entry Type"; Rec."FA Entry Type")
                {
                    ToolTip = 'Specifies the value of the FA Entry Type field.';
                    ApplicationArea = All;
                }
                field("FA Entry No."; Rec."FA Entry No.")
                {
                    ToolTip = 'Specifies the value of the FA Entry No. field.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                    ApplicationArea = All;
                }
                field("Non-Deductible VAT Amount"; Rec."Non-Deductible VAT Amount")
                {
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Amount field.';
                    ApplicationArea = All;
                }
                field("Non-Deductible VAT Amount ACY"; Rec."Non-Deductible VAT Amount ACY")
                {
                    ToolTip = 'Specifies the value of the Non-Deductible VAT Amount ACY field.';
                    ApplicationArea = All;
                }
                field("Account Id"; Rec."Account Id")
                {
                    ToolTip = 'Specifies the value of the Account Id field.';
                    ApplicationArea = All;
                }
                field("Last Modified DateTime"; Rec."Last Modified DateTime")
                {
                    ToolTip = 'Specifies the value of the Last Modified DateTime field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
