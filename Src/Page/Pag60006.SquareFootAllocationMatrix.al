page 60006 "Square Foot Allocation Matrix"
{
    //ApplicationArea = All;
    Caption = 'Square Foot Allocation Matrix';
    PageType = ListPart;
    SourceTable = "Square Foot Allocation Matrix";
    //UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Space Per Department"; Rec."Space Per Department")
                {
                    ToolTip = 'Specifies the value of the Space Per Department field.';
                    ApplicationArea = All;
                }
                field("% For Cost Allocation"; Rec."% For Cost Allocation")
                {
                    ToolTip = 'Specifies the value of the % For Cost Allocation field.';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
}
