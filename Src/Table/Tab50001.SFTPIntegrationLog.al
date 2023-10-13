table 50001 "SFTP Integration Log"
{
    Caption = 'SFTP Integration Log';
    DataClassification = ToBeClassified;
    DataPerCompany = false;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "SFTP URL"; Text[250])
        {
            Caption = 'SFTP URL';
        }
        field(3; "Action Performed By"; Text[50])
        {
            Caption = 'Action Performed By';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(4; "Action Performed At"; DateTime)
        {
            Caption = 'Action Performed At';
        }
        field(5; "Folder Pah"; Text[100])
        {
            Caption = 'Folder Pah';
        }
        field(6; Filename; Text[100])
        {
            Caption = 'Filename';
        }
        field(7; "Successfully Imported"; Boolean)
        {
            Caption = 'Successfully Imported';
        }
        field(8; "Error Remarks"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "File Received From SFTP"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Action Performed ON"; Date)
        {
            Caption = 'Action Performed At';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
