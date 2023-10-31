pageextension 60002 "GL account card" extends "G/L Account Card"
{
    layout
    {
        addafter("Cost Accounting")
        {
            group(ChimeraMapping)
            {
                Caption = 'Chimera Mapping';
                field("Investran Code Mapping"; Rec."Investran Code Mapping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chimera mapping field.';
                }

            }
        }
    }
}
