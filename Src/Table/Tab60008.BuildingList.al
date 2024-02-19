table 60008 "Building List"
{
    Caption = 'Building List';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Code[20])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Total Space of Department"; Decimal)
        {
            Caption = 'Total Space of Department';
            FieldClass = FlowField;
            CalcFormula = sum("Square Foot Allocation Matrix"."Space Per Department" where("Building Name" = field(Name)));
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}
