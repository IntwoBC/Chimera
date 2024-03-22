pageextension 60004 PurchOrderSubform extends "Purchase Order Subform"
{
    //Need to remove from live
    layout
    {
        addlast(Control1)
        {
            field("Amount Inc. VAT LCY"; Rec."Amount Inc. VAT LCY")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Budget Exceeded"; Rec."Budget Exceeded")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
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
