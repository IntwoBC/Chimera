pageextension 60007 GenJournal extends "General Journal"
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
                    Utility.UserBasedAllocationForGenJnl(Rec);
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
                    Utility.HeadCountAllocationForGenJnl(Rec);
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
                    Utility.SqareFootAllocationForGenJnl(Rec);
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
                    Utility.ProductTypeBasedAllocationForGenJnl(Rec);
                end;
            }
        }
    }
}
