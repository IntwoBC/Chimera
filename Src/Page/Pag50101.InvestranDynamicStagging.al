page 50101 "Investran Dynamic Stagging"
{
    ApplicationArea = All;
    Caption = 'Investran Dynamic Stagging';
    PageType = List;
    SourceTable = "Investran Dynamic Stagging";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Row No"; Rec."Row No")
                {
                    ToolTip = 'Specifies the value of the Row No field.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ToolTip = 'Specifies the value of the Legal Entity field.';
                }
                field("Product Name"; Rec."Product Name")
                {
                    ToolTip = 'Specifies the value of the Product Name field.';
                }
                field("Investment Code"; Rec."Investment Code")
                {
                    ToolTip = 'Specifies the value of the Investment Code field.';
                }
                field("Deal Domain"; Rec."Deal Domain")
                {
                    ToolTip = 'Specifies the value of the Deal Domain field.';
                }
                field("Security Type"; Rec."Security Type")
                {
                    ToolTip = 'Specifies the value of the Security Type field.';
                }
                field("Deal Currency"; Rec."Deal Currency")
                {
                    ToolTip = 'Specifies the value of the Deal Currency field.';
                }
                field("GL Date"; Rec."GL Date")
                {
                    ToolTip = 'Specifies the value of the GL Date field.';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field("Trans Type"; Rec."Trans Type")
                {
                    ToolTip = 'Specifies the value of the Trans Type field.';
                    Visible = false;
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.';
                }
                field(Debits; Rec.Debits)
                {
                    ToolTip = 'Specifies the value of the Debits field.';
                }
                field(Credits; Rec.Credits)
                {
                    ToolTip = 'Specifies the value of the Credits field.';
                }
                field("Comments Batch"; Rec."Comments Batch")
                {
                    ToolTip = 'Specifies the value of the Comments Batch field.';
                }
                field("Cash Account"; Rec."Cash Account")
                {
                    ToolTip = 'Specifies the value of the Cash Account field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                Caption = 'Import Investran Dynamic';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Import: Codeunit "Import Investran File";
                begin
                    Import.Run();
                end;
            }
            action(ProcessGeneralJournal)
            {
                Caption = 'Process General Journal';
                ApplicationArea = All;
                Image = Journal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    CreateGeneralJournal: Codeunit CreateGeneralJournal;
                begin
                    CreateGeneralJournal.Run();
                end;
            }
            action("Import File From SFTP")
            {
                Caption = 'Import File From SFTP';
                ApplicationArea = All;
                Image = Journal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Utility: Codeunit InvestranUtility;
                begin
                    Utility.ImportFileFromSFTPLocation(Rec);
                end;
            }
        }
    }
}
