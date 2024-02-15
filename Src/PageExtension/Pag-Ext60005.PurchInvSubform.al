pageextension 60005 PurchInvSubform extends "Purch. Invoice Subform"
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
                    Rec.TestField("UserBased Allocation", false);
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
                    Rec.TestField("HeadCount Allocation", false);
                    if not Confirm('Go ahead?', false) then exit;
                    Utility.HeadCountAllocation(Rec);
                end;
            }
            action("SquareFoot Allocation")
            {
                ApplicationArea = All;
                Image = Allocate;
                trigger OnAction()
                var
                    Utility: Codeunit InvestranUtility;
                begin
                    Rec.TestField("SquareFoot Allocation", false);
                    if not Confirm('Go ahead?', false) then exit;
                    Utility.SqareFootAllocation(Rec);
                end;
            }

            action("Product Type Based Allocation")
            {
                ApplicationArea = All;
                Image = Allocate;
                trigger OnAction()
                var
                    Utility: Codeunit InvestranUtility;
                begin
                    Rec.TestField("Product Type Based Allocation", false);
                    if not Confirm('Go ahead?', false) then exit;
                    Utility.ProductTypeBasedAllocation(Rec);
                end;
            }
        }
    }
}
