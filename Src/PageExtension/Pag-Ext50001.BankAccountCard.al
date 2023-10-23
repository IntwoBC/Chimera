pageextension 50001 BankAccountCard extends "Bank Account Card"
{
    layout
    {
        addlast(content)
        {
            group(ChimeraMapping)
            {
                Caption = 'Chimera Mapping';
                field("Investran Bank Mapping"; Rec."Investran Bank Mapping")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Investran Bank Mapping field.';
                }
            }
        }
    }
}
