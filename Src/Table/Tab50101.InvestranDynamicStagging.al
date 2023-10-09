table 50101 "Investran Dynamic Stagging"
{
    Caption = 'Investran Dynamic Stagging';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Row No"; Integer)
        {
            Caption = 'Row No';
        }
        field(2; "Legal Entity"; Text[50])
        {
            Caption = 'Legal Entity';
        }
        field(3; "Product Name"; Text[50])
        {
            Caption = 'Product Name';
        }
        field(4; "Investment Code"; Text[50])
        {
            Caption = 'Investment Code';
        }
        field(5; "Deal Domain"; Text[50])
        {
            Caption = 'Deal Domain';
        }
        field(6; "Security Type"; Text[50])
        {
            Caption = 'Security Type';
        }
        field(7; "Deal Currency"; Code[10])
        {
            Caption = 'Deal Currency';
        }
        field(8; "GL Date"; Date)
        {
            Caption = 'GL Date';
        }
        field(9; "GL Account"; Text[100])
        {
            Caption = 'GL Account';
        }
        field(10; "Trans Type"; Text[100])
        {
            Caption = 'Trans Type';
        }
        field(11; "Batch ID"; Code[50])
        {
            Caption = 'Batch ID';
        }
        field(12; Debits; Decimal)
        {
            Caption = 'Debits';
        }
        field(13; Credits; Decimal)
        {
            Caption = 'Credits';
        }
        field(14; "Comments Batch"; Text[100])
        {
            Caption = 'Comments Batch';
        }
        field(15; "Cash Account"; Text[100])
        {
            Caption = 'Cash Account';
        }
    }
    keys
    {
        key(PK; "Row No")
        {
            Clustered = true;
        }
    }
}
