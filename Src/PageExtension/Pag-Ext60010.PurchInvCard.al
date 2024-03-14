pageextension 60010 PurchInvCard extends "Purchase Invoice"
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
