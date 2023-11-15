page 60002 "Investran Dynamic Stagging"
{
    ApplicationArea = All;
    Caption = 'Investran Dynamic Stagging';
    PageType = List;
    SourceTable = "Investran Dynamic Stagging";
    UsageCategory = Lists;
    SourceTableView = sorting("Row No") order(descending);
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Row No"; Rec."Row No")
                {
                    ToolTip = 'Specifies the value of the Row No field.';
                    ApplicationArea = All;
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ToolTip = 'Specifies the value of the Legal Entity field.';
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ToolTip = 'Specifies the value of the Product Name field.';
                    ApplicationArea = All;
                }
                field("Investment Code"; Rec."Investment Code")
                {
                    ToolTip = 'Specifies the value of the Investment Code field.';
                    ApplicationArea = All;
                }
                field("Deal Domain"; Rec."Deal Domain")
                {
                    ToolTip = 'Specifies the value of the Deal Domain field.';
                    ApplicationArea = All;
                }
                field("Security Type"; Rec."Security Type")
                {
                    ToolTip = 'Specifies the value of the Security Type field.';
                    ApplicationArea = All;
                }
                // field("Deal Currency"; Rec."Deal Currency")
                // {
                //     ToolTip = 'Specifies the value of the Deal Currency field.';
                //     ApplicationArea = All;
                //     ObsoleteReason = 'Client Asked to Remove this field';
                // }
                field("GL Date"; Rec."GL Date")
                {
                    ToolTip = 'Specifies the value of the GL Date field.';
                    ApplicationArea = All;
                }
                field("GL Account"; Rec."GL Account")
                {
                    ToolTip = 'Specifies the value of the GL Account field.';
                    ApplicationArea = All;
                }
                field("Trans Type"; Rec."Trans Type")
                {
                    ToolTip = 'Specifies the value of the Trans Type field.';
                    Visible = false;
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.';
                    ApplicationArea = All;
                }
                field(Debits; Rec.Debits)
                {
                    ToolTip = 'Specifies the value of the Debits field.';
                    ApplicationArea = All;
                }
                field(Credits; Rec.Credits)
                {
                    ToolTip = 'Specifies the value of the Credits field.';
                    ApplicationArea = All;
                }
                field("Comments Batch"; Rec."Comments Batch")
                {
                    ToolTip = 'Specifies the value of the Comments Batch field.';
                    ApplicationArea = All;
                }
                field("Cash Account"; Rec."Cash Account")
                {
                    ToolTip = 'Specifies the value of the Cash Account field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Error Remarks"; Rec."Error Remarks")
                {
                    ToolTip = 'Specifies the value of the Error Remarks field.';
                    ApplicationArea = All;
                    Editable = false;
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
                Caption = 'Import File Manually';
                ApplicationArea = All;
                Image = Import;
                Visible = false;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedOnly = true;
                trigger OnAction()
                var
                    Import: Codeunit "Import Investran File";
                begin
                    Import.Run();
                end;
            }
            action(ProcessGeneralJournal)
            {
                Caption = 'Run Job To Transfer Data';
                ApplicationArea = All;
                Image = Journal;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedOnly = true;
                trigger OnAction()
                var
                    CreateGeneralJournal: Codeunit CreateGeneralJournal;
                begin
                    //CreateGeneralJournal.Run();
                    Codeunit.Run(Codeunit::ProcessInvestranGeneral);
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

            action("Reset Status")
            {
                Caption = 'Reset Status';
                ApplicationArea = All;
                Image = Journal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Utility: Codeunit InvestranUtility;
                    Recstaging: Record "Investran Dynamic Stagging";
                begin
                    Clear(Recstaging);
                    CurrPage.SetSelectionFilter(Recstaging);
                    if Recstaging.FindSet() then begin
                        if not Confirm('Do you want to reset status?', false) then
                            exit;
                        repeat
                            if not (Recstaging.Status in [Recstaging.Status::Error, Recstaging.Status::" "]) then
                                Recstaging.TestField(Status, Recstaging.Status::Error);

                            Recstaging.Status := Recstaging.Status::"Ready To Sync";
                            Recstaging."Error Remarks" := '';
                            Recstaging.Modify();
                        until Recstaging.Next() = 0;
                    end;
                end;
            }
        }
    }
}
