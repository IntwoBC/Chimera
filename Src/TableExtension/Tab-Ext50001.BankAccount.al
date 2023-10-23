tableextension 50001 BankAccount extends "Bank Account"
{
    fields
    {
        field(50100; "Investran Bank Mapping"; Text[250])
        {
            Caption = 'Investran Bank Mapping';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RecGLAccount: Record "Bank Account";
            begin
                if Rec."Investran Bank Mapping" <> '' then begin
                    Clear(RecGLAccount);
                    RecGLAccount.SetRange("Investran Bank Mapping", Rec."Investran Bank Mapping");
                    RecGLAccount.SetFilter("No.", '<>%1', Rec."No.");
                    if RecGLAccount.FindFirst() then
                        Error('Same mapping has been already used for G/L Account No.: %1', RecGLAccount."No.");
                end;
            end;
        }
    }
}
