table 60006 "Square Foot Allocation Matrix"
{
    Caption = 'Square Foot Allocation Matrix';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Department; Code[20])
        {
            Caption = 'Department';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
        }
        field(2; "Space Per Department"; Decimal)
        {
            Caption = 'Space Per Department';
            trigger OnValidate()
            begin
                // Rec.CalcFields("Total Space of Department");
                // if Rec."Total Space of Department" <> 0 then
                //     Rec."% For Cost Allocation" := (Rec."Space Per Department" / Rec."Total Space of Department") * 100
            end;
        }
        field(3; "% For Cost Allocation"; Decimal)
        {
            Caption = '% For Cost Allocation';
        }
        field(4; "Total Space of Department"; Decimal)
        {
            Caption = 'Total Space of Department';
            FieldClass = FlowField;
            CalcFormula = sum("Square Foot Allocation Matrix"."Space Per Department");
        }
    }
    keys
    {
        key(PK; Department)
        {
            Clustered = true;
        }
    }

    /*trigger OnModify()
    var
        Utility: Codeunit InvestranUtility;
    begin
        Utility.UpdateCostAllocationPercentage(Rec);
    end;

    trigger OnInsert()
    var
        Utility: Codeunit InvestranUtility;
    begin
        Utility.UpdateCostAllocationPercentage(Rec);
    end;

    trigger OnDelete()
    var
        Utility: Codeunit InvestranUtility;
    begin
        Utility.UpdateCostAllocationPercentage(Rec);
    end;*/
}
