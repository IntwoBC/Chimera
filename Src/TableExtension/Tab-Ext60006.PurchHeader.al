tableextension 60006 PurchHeader extends "Purchase Header"
{
    //Need to remove from live
    fields
    {
        field(60000; "Budget Exceeded"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), Type = const("G/L Account"), "Budget Exceeded" = const(true)));
        }
    }
}
