page 60008 "Building List"
{
    ApplicationArea = All;
    Caption = 'Building List';
    PageType = List;
    SourceTable = "Building List";
    UsageCategory = Lists;
    AdditionalSearchTerms = 'Square Foot Allocation Matrix';
    CardPageId = "Square Foot Allocation";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Total Space of Department"; Rec."Total Space of Department")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
