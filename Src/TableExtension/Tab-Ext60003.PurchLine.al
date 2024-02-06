tableextension 60003 PurchLine extends "Purchase Line"
{
    fields
    {
        field(60000; "UserBased Allocation"; Boolean)
        {
            Caption = 'UserBased Allocation';
            DataClassification = ToBeClassified;
        }
        field(60001; "HeadCount Allocation"; Boolean)
        {
            Caption = 'HeadCount Allocation';
            DataClassification = ToBeClassified;
        }
        field(60002; "SquareFoot Allocation"; Boolean)
        {
            Caption = 'SquareFoot Allocation';
            DataClassification = ToBeClassified;
        }
        field(60003; "Product Type Based Allocation"; Boolean)
        {
            Caption = 'Product Type Based Allocation';
            DataClassification = ToBeClassified;
        }
        field(60004; "Derived From Line No."; Integer)
        {
            Caption = 'Product Type Based Allocation';
            DataClassification = ToBeClassified;
        }
    }
}
