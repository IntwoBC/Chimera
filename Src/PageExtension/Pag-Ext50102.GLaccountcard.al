pageextension 50102 "GL account card" extends "G/L Account Card"
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
                field("Investran Bank Mapping"; Rec."Investran Bank Mapping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Investran Bank Mapping field.';
                }
            }
        }
    }
}
