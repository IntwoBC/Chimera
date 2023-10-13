tableextension 50101 "GL Account" extends "G/L Account"
{
    fields
    {
        field(50100; "Investran Code Mapping"; Text[100])
        {
            Caption = 'Investran Code Mapping';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RecGLAccount: Record "G/L Account";
            begin
                if Rec."Investran Code Mapping" <> '' then begin
                    Clear(RecGLAccount);
                    RecGLAccount.SetRange("Investran Code Mapping", Rec."Investran Code Mapping");
                    RecGLAccount.SetFilter("No.", '<>%1', Rec."No.");
                    if RecGLAccount.FindFirst() then
                        Error('Same mapping has been already used for G/L Account No.: %1', RecGLAccount."No.");
                end

            end;
        }
    }
}
