page 60009 "Square Foot Allocation"
{
    ApplicationArea = All;
    Caption = 'Square Foot Allocation';
    PageType = Document;
    SourceTable = "Building List";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

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
            part("Lines"; "Square Foot Allocation Matrix")
            {
                ApplicationArea = All;
                SubPageLink = "Building Name" = field(Name);
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
