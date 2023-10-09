page 50100 "Investran - Dyanamic Setup"
{
    ApplicationArea = All;
    Caption = 'Investran Dyanamic Setup';
    PageType = Card;
    SourceTable = "Investran - Dyanamic Setup";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    ApplicationArea = All;
                }
                field("Investran Legal Entity"; Rec."Investran Legal Entity")
                {
                    ToolTip = 'Specifies the value of the Investran Legal Entity Name field.';
                    ApplicationArea = all;
                }
                field("Investran Entity Active"; Rec."Investran Entity Active")
                {
                    ToolTip = 'Specifies the value of the Investran Entity Active field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
