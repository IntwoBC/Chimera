pageextension 60008 VATEntries extends "VAT Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(TRNNumber; TRNNumber)
            {
                Caption = 'TRN No.';
                ApplicationArea = All;
                Editable = false;
            }
            field(BillToPayToName; BillToPayToName)
            {
                ApplicationArea = All;
                Caption = 'Bill To/Pay To Name';
                Editable = false;
            }
            field(VendorInvNo; VendorInvNo)
            {
                ApplicationArea = All;
                Caption = 'Vendor Invoice No.';
                Editable = false;
            }
            field(ExternalDocNumber; ExternalDocNumber)
            {
                ApplicationArea = All;
                Caption = 'External Document No.';
                Editable = false;
            }
            field(CUrrencyCode; CUrrencyCode)
            {
                ApplicationArea = All;
                Caption = 'Currency Code';
                Editable = false;
            }
            field("VAT Prod. Posting_Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'Type of Transaction';
            }
            field("Customer/vendorAddress"; "Customer/vendorAddress")
            {
                ApplicationArea = All;
                Caption = 'Customer/Vendor Address';
            }

        }
    }
    actions
    {
        addlast(processing)
        {
            action("Export VAT Entries")
            {
                ApplicationArea = All;
                Image = Export;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = report ExportVATEntries;
                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        InitValuesInCustomFields();
    end;

    local procedure InitValuesInCustomFields()
    var
        SInvHdr: Record "Sales Invoice Header";
        SCrHdr: Record "Sales Cr.Memo Header";
        PurchINHdr: Record "Purch. Inv. Header";
        PurchCrMemo: Record "Purch. Cr. Memo Hdr.";
        RecVendor: Record Vendor;
        RecCustomer: Record Customer;
        GenLedSetup: Record "General Ledger Setup";
    begin
        ClearVariables();
        if Rec.Type = Rec.Type::Sale then begin
            If Rec."Document Type" = Rec."Document Type"::Invoice then begin
                if SInvHdr.GET(Rec."Document No.") then begin
                    GenLedSetup.GET;
                    if SInvHdr."Currency Code" <> '' then
                        CUrrencyCode := SInvHdr."Currency Code"
                    else
                        CUrrencyCode := GenLedSetup."LCY Code";
                    BillToPayToName := SInvHdr."Sell-to Customer Name";
                    ExternalDocNumber := SInvHdr."External Document No.";
                    if RecCustomer.GET(SInvHdr."Sell-to Customer No.") then
                        TRNNumber := RecCustomer."VAT Registration No.";
                    "Customer/vendorAddress" := RecCustomer.Address;
                end;
            end else begin
                if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then begin
                    if SCrHdr.GET(Rec."Document No.") then begin
                        GenLedSetup.GET;
                        if SCrHdr."Currency Code" <> '' then
                            CUrrencyCode := SCrHdr."Currency Code"
                        else
                            CUrrencyCode := GenLedSetup."LCY Code";
                        BillToPayToName := SCrHdr."Sell-to Customer Name";
                        ExternalDocNumber := SCrHdr."External Document No.";
                        if RecCustomer.GET(SCrHdr."Sell-to Customer No.") then
                            TRNNumber := RecCustomer."VAT Registration No.";
                        "Customer/vendorAddress" := RecCustomer.Address;
                    end;
                end;
            end;
        end else begin
            if Rec.Type = Rec.Type::Purchase then begin
                If Rec."Document Type" = Rec."Document Type"::Invoice then begin
                    if PurchINHdr.GET(Rec."Document No.") then begin
                        GenLedSetup.GET;
                        if PurchINHdr."Currency Code" <> '' then
                            CUrrencyCode := PurchINHdr."Currency Code"
                        else
                            CUrrencyCode := GenLedSetup."LCY Code";
                        BillToPayToName := PurchINHdr."Buy-from Vendor Name";
                        VendorInvNo := PurchINHdr."Vendor Invoice No.";
                        if RecVendor.GET(PurchINHdr."Buy-from Vendor No.") then
                            TRNNumber := RecVendor."VAT Registration No.";
                        "Customer/vendorAddress" := RecVendor.Address;
                    end;
                end else begin
                    if Rec."Document Type" = Rec."Document Type"::"Credit Memo" then begin
                        if PurchCrMemo.GET(Rec."Document No.") then begin
                            GenLedSetup.GET;
                            if PurchCrMemo."Currency Code" <> '' then
                                CUrrencyCode := PurchCrMemo."Currency Code"
                            else
                                CUrrencyCode := GenLedSetup."LCY Code";
                            BillToPayToName := PurchCrMemo."Buy-from Vendor Name";
                            VendorInvNo := '';
                            if RecVendor.GET(PurchCrMemo."Buy-from Vendor No.") then
                                TRNNumber := RecVendor."VAT Registration No.";
                            "Customer/vendorAddress" := RecVendor.Address;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure ClearVariables()
    begin
        clear(TRNNumber);
        clear(BillToPayToName);
        clear(VendorInvNo);
        clear(ExternalDocNumber);
        clear(CUrrencyCode);
        Clear("Customer/vendorAddress");
    end;

    var
        TRNNumber: Text[20];
        BillToPayToName, "Customer/vendorAddress" : Text[100];
        VendorInvNo: Code[35];
        ExternalDocNumber: Code[35];
        CUrrencyCode: code[10];
}
