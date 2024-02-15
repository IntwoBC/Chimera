table 60007 "Product Relations"
{
    Caption = 'Product Relations';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product Type"; Code[20])
        {
            Caption = 'Product Type';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('TYPEOFPRODUCT'));
            trigger OnValidate()
            var
                DimVal: Record "Dimension Value";
            begin
                if "Product Type" <> '' then begin
                    if DimVal.GET('TYPEOFPRODUCT', "Product Type") then begin
                        "Product Type Description" := DimVal.Name;
                    end else
                        "Product Type Description" := '';
                end else
                    "Product Type Description" := '';
            end;
        }
        field(2; "Product Type Description"; Text[100])
        {
            Caption = 'Product Type Description';
            Editable = false;
        }
        field(3; "Product Name"; Code[20])
        {
            Caption = 'Product Name';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('NAMEOFPRODUCT'));
            trigger OnValidate()
            var
                DimVal: Record "Dimension Value";
            begin
                if "Product Type" <> '' then begin
                    if DimVal.GET('NAMEOFPRODUCT', "Product Name") then begin
                        "Product Name Description" := DimVal.Name;
                    end else
                        "Product Name Description" := '';
                end else
                    "Product Name Description" := '';
            end;
        }
        field(4; "Product Name Description"; Text[100])
        {
            Caption = 'Product Name Description';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Product Type", "Product Name")
        {
            Clustered = true;
        }
    }
}
