page 60006 "Square Foot Allocation Matrix"
{
    ApplicationArea = All;
    Caption = 'Square Foot Allocation Matrix';
    PageType = List;
    SourceTable = "Square Foot Allocation Matrix";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Space Per Department"; Rec."Space Per Department")
                {
                    ToolTip = 'Specifies the value of the Space Per Department field.';
                }
                field("% For Cost Allocation"; Rec."% For Cost Allocation")
                {
                    ToolTip = 'Specifies the value of the % For Cost Allocation field.';
                    Editable = false;
                }
            }
            group(Total)
            {
                field("Total Space of Department"; Rec."Total Space of Department")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Update Allocation %")
            {
                ApplicationArea = All;
                Image = AllocatedCapacity;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Utility: Codeunit InvestranUtility;
                begin
                    if not Confirm('Go ahead?', false) then exit;
                    Utility.UpdateCostAllocationPercentage(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }
}
