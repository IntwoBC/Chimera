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
            var
                RecBuilding: Record "Building List";
            begin
                RecBuilding.GET("Building Name");
                RecBuilding.CalcFields("Total Space of Department");
                if RecBuilding."Total Space of Department" <> 0 then
                    Rec."% For Cost Allocation" := (Rec."Space Per Department" / RecBuilding."Total Space of Department") * 100
            end;
        }
        field(3; "% For Cost Allocation"; Decimal)
        {
            Caption = '% For Cost Allocation';
        }

        field(5; "Building Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Building List";
        }
    }
    keys
    {
        key(PK; Department, "Building Name")
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
