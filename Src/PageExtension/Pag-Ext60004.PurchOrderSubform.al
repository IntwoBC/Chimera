pageextension 60004 PurchOrderSubform extends "Purchase Order Subform"
{
    actions
    {
        addafter(Dimensions)
        {
            action("UserBased Allocation")
            {
                ApplicationArea = All;
                Image = Allocate;
                trigger OnAction()
                var
                    Utility: Codeunit InvestranUtility;
                begin
                    if not Confirm('Go ahead?', false) then exit;
                    Utility.UserBasedAllocation(Rec);
                end;
            }
            action("Headcount Allocation")
            {
                ApplicationArea = All;
                Image = Allocate;
                trigger OnAction()
                var
                    Utility: Codeunit InvestranUtility;
                begin
                    if not Confirm('Go ahead?', false) then exit;
                    Utility.HeadCountAllocation(Rec);
                end;
            }
        }
    }
}
