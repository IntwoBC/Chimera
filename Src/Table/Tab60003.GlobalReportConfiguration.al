table 60003 "Global Report Configuration"
{
    Caption = 'Global Report Configuration';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
        }
        field(2; "Trial Balance Report"; Boolean)
        {
            Caption = 'Trial Balance Report';
        }
        field(3; "G/L Entries Dump"; Boolean)
        {
            Caption = 'G/L Entries Dump';
        }
    }
    keys
    {
        key(PK; "Company Name")
        {
            Clustered = true;
        }
    }
}
