pageextension 60010 PurchInvCard extends "Purchase Invoice"
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
