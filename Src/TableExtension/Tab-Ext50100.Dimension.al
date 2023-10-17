tableextension 50100 DimensionValue extends "Dimension Value"
{
    fields
    {
        field(50100; "Investran Code Mapping"; code[50])
        {
            Caption = 'Investran Code Mapping';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RecDimensionValue: Record "Dimension Value";
            begin
                if Rec."Investran Code Mapping" <> '' then begin
                    Clear(RecDimensionValue);
                    RecDimensionValue.SetRange("Dimension Code", Rec."Dimension Code");
                    RecDimensionValue.SetRange("Investran Code Mapping", Rec."Investran Code Mapping");
                    RecDimensionValue.SetFilter(Code, '<>%1', Rec.Code);
                    if RecDimensionValue.FindFirst() then
                        Error('Same mapping has been already used for Dimension Code %1, Value:%2', RecDimensionValue."Dimension Code", RecDimensionValue.Code);
                end

            end;
        }
    }
}
