table 60005 "Employee Dimension Matrix"
{
    Caption = 'Employee Dimension Matrix';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('EMPLOYEENAME'));
            trigger OnValidate()
            var
                DimVal: Record "Dimension Value";
            begin
                if "Employee Code" <> '' then begin
                    DimVal.Get('EMPLOYEENAME', "Employee Code");
                    "Employee Name" := DimVal.Name;
                end else
                    "Employee Name" := '';

            end;
        }
        field(2; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(3; "Software Dimension"; Code[20])
        {
            Caption = 'Software Dimension';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('SOFTWARE'));
        }
        field(4; "Department Dimension"; Code[20])
        {
            Caption = 'Department Dimension';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
        }
    }
    keys
    {
        key(PK; "Employee Code", "Software Dimension", "Department Dimension")
        {
            Clustered = true;
        }
    }
}
