page 60000 "Investran - Dyanamic Setup"
{
    ApplicationArea = All;
    Caption = 'Investran Dyanamic Setup';
    PageType = Card;
    SourceTable = "Investran - Dyanamic Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;

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
            group("Azure Function Setup")
            {
                field("Azure Function Endpoint"; Rec."Azure Function endpoint")
                {
                    ApplicationArea = All;
                }
                field("Authentication Code"; Rec."Authentication Code")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field(Host; Rec.Host)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field(Username; Rec.Username)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Username field.';
                    ExtendedDatatype = Masked;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Password field.';
                    ExtendedDatatype = Masked;
                }
                field("Remote Folder"; Rec."Remote Folder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remote Folder field.';
                }
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Filename field.';
                }

            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}
