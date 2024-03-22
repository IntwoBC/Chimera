pageextension 60009 PurchOrderCard extends "Purchase Order"
{
    //Need to remove from live
    layout
    {
        addlast(General)
        {
            field("Budget Exceeded"; Rec."Budget Exceeded")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
