pageextension 60009 PurchOrderCard extends "Purchase Order"
{
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
