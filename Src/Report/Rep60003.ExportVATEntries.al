report 60003 ExportVATEntries
{
    Caption = 'ExportVATEntries';
    UseRequestPage = true;
    ProcessingOnly = true;

    dataset
    {
        dataitem(VATEntry; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") order(descending) where("Document Type" = filter(<> ' '));
            trigger OnAfterGetRecord()
            var
                Amt, BaseAmt : Decimal;
            begin
                if not CheckList.Contains(VATEntry."Document No." + Format(VATEntry."Posting Date")) then
                    CheckList.Add(VATEntry."Document No." + Format(VATEntry."Posting Date"))
                else
                    CurrReport.Skip();
                ExcelBuf.NewRow();
                ExcelBuf.AddColumn(VATEntry."VAT Bus. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."VAT Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."VAT Reporting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Document Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry.Type, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                GetTotalAmountBaseAmt(VATEntry."Document No.", VATEntry."Posting Date", Amt, BaseAmt);
                ExcelBuf.AddColumn(BaseAmt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Amt, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."VAT Calculation Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Bill-to/Pay-to No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Country/Region Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."EU 3-Party Trade", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry.Closed, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Closed by Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Internal Ref. No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                InitValuesInCustomFields();
                ExcelBuf.AddColumn(SourceTYpe, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Bill-to/Pay-to No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(BillToPayToName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."Gen. Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(TRNNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(BillToPayToName, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VendorInvNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(ExternalDocNumber, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(CUrrencyCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Desc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(RecCurrEchRate.ExchangeAmount(Amt, GenLedgSetup."LCY Code", CUrrencyCode, VATEntry."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(RecCurrEchRate.ExchangeAmount(BaseAmt, GenLedgSetup."LCY Code", CUrrencyCode, VATEntry."Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(VATEntry."VAT Prod. Posting Group", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Paid, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Customer/vendorAddress", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Discount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(DocumentDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            end;
        }
    }

    trigger OnPostReport()
    begin
        CreateExcelbook();
    end;

    trigger OnPreReport()
    begin
        MakeExcelDataHeader();
        GenLedgSetup.GET;
    end;

    local procedure CreateExcelbook()
    var
        ExcelFileName: Label 'VAT Report _%1_%2';
    begin
        ExcelBuf.CreateNewBook('Vat Entries');
        ExcelBuf.WriteSheet('Vat Entries', COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        ExcelBuf.OpenExcel();
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(VATEntry.FieldCaption("VAT Bus. Posting Group"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("VAT Prod. Posting Group"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("VAT Reporting Date"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Posting Date"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Document No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Document Type"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption(Type), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption(Base), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption(Amount), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("VAT Calculation Type"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Bill-to/Pay-to No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Country/Region Code"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("EU 3-Party Trade"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption(Closed), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Closed by Entry No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Internal Ref. No."), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Source Type', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Source No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Source Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(VATEntry.FieldCaption("Gen. Prod. Posting Group"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('TRN No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Bill To/Pay To Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Vendor Invoice No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('External Document No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Currency Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Amount' + '(' + CUrrencyCode + ')', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Base Amount' + '(' + CUrrencyCode + ')', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Type of Transaction', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Paid/Unpaid', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer/Vendor Address', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Discount Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Document/Vendor Invoice Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    END;

    local procedure GetTotalAmountBaseAmt(Doc: code[20]; PostingD: Date; var Amt: Decimal; var BaseAmt: Decimal)
    var
        RecVatEnt: Record "VAT Entry";
    begin
        Amt := 0;
        BaseAmt := 0;
        Clear(RecVatEnt);
        RecVatEnt.SetRange("Document No.", Doc);
        RecVatEnt.SetRange("Posting Date", PostingD);
        if RecVatEnt.FindSet() then begin
            RecVatEnt.CalcSums(Amount, Base);
            Amt := RecVatEnt.Amount;
            BaseAmt := RecVatEnt.Base;
        end;
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
        SinvLine: Record "Sales Invoice Line";
        PInvLine: Record "Purch. Inv. Line";
        SCrMLine: Record "Sales Cr.Memo Line";
        PCrMLine: Record "Purch. Cr. Memo Line";
        CLE: Record "Cust. Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
    begin
        ClearVariables();
        if VATEntry.Type = VATEntry.Type::Sale then begin
            If VATEntry."Document Type" = VATEntry."Document Type"::Invoice then begin
                if SInvHdr.GET(VATEntry."Document No.") then begin
                    GenLedSetup.GET;
                    if SInvHdr."Currency Code" <> '' then
                        CUrrencyCode := SInvHdr."Currency Code"
                    else
                        CUrrencyCode := GenLedSetup."LCY Code";
                    BillToPayToName := SInvHdr."Sell-to Customer Name";
                    ExternalDocNumber := SInvHdr."External Document No.";
                    if RecCustomer.GET(SInvHdr."Sell-to Customer No.") then
                        TRNNumber := RecCustomer."VAT Registration No.";
                    "Customer/vendorAddress" := RecCustomer.Address + ' ' + RecCustomer."Address 2";
                    SourceTYpe := 'CUSTOMER';

                    SInvHdr.CalcFields("Invoice Discount Amount");
                    Discount := SInvHdr."Invoice Discount Amount";
                    DocumentDate := SInvHdr."Document Date";
                    Clear(SinvLine);
                    SinvLine.SetRange("Document No.", SInvHdr."No.");
                    SinvLine.SetFilter(Description, '<>%1', '');
                    if SinvLine.FindFirst() then
                        Desc := SinvLine.Description;

                end;
            end else begin
                if VATEntry."Document Type" = VATEntry."Document Type"::"Credit Memo" then begin
                    if SCrHdr.GET(VATEntry."Document No.") then begin
                        GenLedSetup.GET;
                        if SCrHdr."Currency Code" <> '' then
                            CUrrencyCode := SCrHdr."Currency Code"
                        else
                            CUrrencyCode := GenLedSetup."LCY Code";
                        BillToPayToName := SCrHdr."Sell-to Customer Name";
                        ExternalDocNumber := SCrHdr."External Document No.";
                        if RecCustomer.GET(SCrHdr."Sell-to Customer No.") then
                            TRNNumber := RecCustomer."VAT Registration No.";
                        "Customer/vendorAddress" := RecCustomer.Address + ' ' + RecCustomer."Address 2";
                        SourceTYpe := 'CUSTOMER';
                        DocumentDate := SCrHdr."Document Date";
                        SCrHdr.CalcFields("Invoice Discount Amount");
                        Discount := SCrHdr."Invoice Discount Amount";

                        Clear(SCrMLine);
                        SCrMLine.SetRange("Document No.", SCrHdr."No.");
                        SCrMLine.SetFilter(Description, '<>%1', '');
                        if SCrMLine.FindFirst() then
                            Desc := SCrMLine.Description;
                    end;
                end;
            end;
            Clear(CLE);
            CLE.SetRange("Document No.", VATEntry."Document No.");
            CLE.SetRange("Posting Date", VATEntry."Posting Date");
            if CLE.FindFirst() then begin
                IF CLE.Open then
                    Paid := 'Unpaid'
                else
                    Paid := 'Paid';
            end;
        end else begin
            if VATEntry.Type = VATEntry.Type::Purchase then begin
                If VATEntry."Document Type" = VATEntry."Document Type"::Invoice then begin
                    if PurchINHdr.GET(VATEntry."Document No.") then begin
                        GenLedSetup.GET;
                        if PurchINHdr."Currency Code" <> '' then
                            CUrrencyCode := PurchINHdr."Currency Code"
                        else
                            CUrrencyCode := GenLedSetup."LCY Code";
                        BillToPayToName := PurchINHdr."Buy-from Vendor Name";
                        VendorInvNo := PurchINHdr."Vendor Invoice No.";
                        if RecVendor.GET(PurchINHdr."Buy-from Vendor No.") then
                            TRNNumber := RecVendor."VAT Registration No.";
                        "Customer/vendorAddress" := RecVendor.Address + ' ' + RecVendor."Address 2";
                        SourceTYpe := 'VENDOR';
                        DocumentDate := PurchINHdr."Document Date";
                        PurchINHdr.CalcFields("Invoice Discount Amount");
                        Discount := PurchINHdr."Invoice Discount Amount";

                        Clear(PInvLine);
                        PInvLine.SetRange("Document No.", PurchINHdr."No.");
                        PInvLine.SetFilter(Description, '<>%1', '');
                        if PInvLine.FindFirst() then
                            Desc := PInvLine.Description;
                    end;
                end else begin
                    if VATEntry."Document Type" = VATEntry."Document Type"::"Credit Memo" then begin
                        if PurchCrMemo.GET(VATEntry."Document No.") then begin
                            GenLedSetup.GET;
                            if PurchCrMemo."Currency Code" <> '' then
                                CUrrencyCode := PurchCrMemo."Currency Code"
                            else
                                CUrrencyCode := GenLedSetup."LCY Code";
                            BillToPayToName := PurchCrMemo."Buy-from Vendor Name";
                            VendorInvNo := '';
                            if RecVendor.GET(PurchCrMemo."Buy-from Vendor No.") then
                                TRNNumber := RecVendor."VAT Registration No.";
                            "Customer/vendorAddress" := RecVendor.Address + ' ' + RecVendor."Address 2";
                            SourceTYpe := 'VENDOR';
                            DocumentDate := PurchCrMemo."Document Date";
                            Clear(PCrMLine);
                            PCrMLine.SetRange("Document No.", PurchCrMemo."No.");
                            PCrMLine.SetFilter(Description, '<>%1', '');
                            if PCrMLine.FindFirst() then
                                Desc := PCrMLine.Description;
                            PurchCrMemo.CalcFields("Invoice Discount Amount");
                            Discount := PurchCrMemo."Invoice Discount Amount";
                        end;
                    end;
                end;
                Clear(VLE);
                VLE.SetRange("Document No.", VATEntry."Document No.");
                VLE.SetRange("Posting Date", VATEntry."Posting Date");
                if VLE.FindFirst() then begin
                    IF VLE.Open then
                        Paid := 'Unpaid'
                    else
                        Paid := 'Paid';
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
        Clear(SourceTYpe);
        Clear(Desc);
        clear(Paid);
        clear(Discount);
        clear(DocumentDate);
    end;

    var
        TRNNumber: Text[20];
        BillToPayToName: Text[100];
        "Customer/vendorAddress": Text[200];
        VendorInvNo: Code[35];
        ExternalDocNumber: Code[35];
        CUrrencyCode: code[10];
        SourceTYpe: Code[20];
        ExcelBuf: Record "Excel Buffer" temporary;
        CheckList: List of [Text];
        Desc: Text[100];
        RecCurrEchRate: Record "Currency Exchange Rate";
        GenLedgSetup: Record "General Ledger Setup";
        Paid: code[10];
        Discount: Decimal;
        DocumentDate: Date;
}
