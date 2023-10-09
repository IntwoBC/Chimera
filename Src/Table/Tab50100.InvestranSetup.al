table 50100 "Investran - Dyanamic Setup"
{
    Caption = 'Investran Dyanamic Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";

        }
        field(3; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(4; "Investran Legal Entity"; Text[100])
        {
            Caption = 'Investran Legal Entity Name';
            DataClassification = ToBeClassified;
        }
        field(5; "Investran Entity Active"; Boolean)
        {
            Caption = 'Investran Entity Active';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
