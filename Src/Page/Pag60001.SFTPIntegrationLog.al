page 60001 "SFTP Integration Log"
{
    ApplicationArea = All;
    Caption = 'SFTP Integration Log';
    PageType = List;
    SourceTable = "SFTP Integration Log";
    UsageCategory = Lists;
    SourceTableView = sorting("Entry No.") order(descending);
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("SFTP URL"; Rec."SFTP URL")
                {
                    ToolTip = 'Specifies the value of the SFTP URL field.';
                    ApplicationArea = All;
                }
                field("Action Performed By"; Rec."Action Performed By")
                {
                    ToolTip = 'Specifies the value of the Action Performed By field.';
                    ApplicationArea = All;
                }
                field("Action Performed At"; Rec."Action Performed At")
                {
                    ToolTip = 'Specifies the value of the Action Performed At field.';
                    ApplicationArea = All;
                }
                field("Folder Pah"; Rec."Folder Pah")
                {
                    ToolTip = 'Specifies the value of the Folder Pah field.';
                    ApplicationArea = All;
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specifies the value of the Filename field.';
                    ApplicationArea = All;
                }
                field("Successfully Imported"; Rec."Successfully Imported")
                {
                    ToolTip = 'Specifies the value of the Successfully Imported field.';
                    ApplicationArea = All;
                }
                field("Action Performed ON"; Rec."Action Performed ON")
                {
                    ToolTip = 'Specifies the value of the Action Performed At field.';
                    ApplicationArea = All;
                }
                field("Error Remarks"; Rec."Error Remarks")
                {
                    ToolTip = 'Specifies the value of the Error Remarks field.';
                    ApplicationArea = All;
                }
                field("File Received From SFTP"; Rec."File Received From SFTP")
                {
                    ToolTip = 'Specifies the value of the File Received From SFTP field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
