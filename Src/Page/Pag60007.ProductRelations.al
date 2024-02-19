page 60007 "Product Relations"
{
    ApplicationArea = All;
    Caption = 'Product Relations';
    PageType = List;
    SourceTable = "Product Relations";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Product Type"; Rec."Product Type")
                {
                    ToolTip = 'Specifies the value of the Product Type field.';
                    ApplicationArea = All;
                }
                field("Product Type Description"; Rec."Product Type Description")
                {
                    ToolTip = 'Specifies the value of the Product Type Description field.';
                    ApplicationArea = All;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ToolTip = 'Specifies the value of the Product Name field.';
                    ApplicationArea = All;
                }
                field("Product Name Description"; Rec."Product Name Description")
                {
                    ToolTip = 'Specifies the value of the Product Name Description field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
