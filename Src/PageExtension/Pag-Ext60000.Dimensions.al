pageextension 60000 DimensionsValues extends "Dimension Values"
{
    layout
    {
        addafter(Blocked)
        {
            field("Investran Code Mapping"; Rec."Investran Code Mapping")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Chimera mapping field.';
            }
        }
    }
}
