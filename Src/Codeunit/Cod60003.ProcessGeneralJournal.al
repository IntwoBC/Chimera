codeunit 60003 "Process General Journal"
{
    TableNo = "Investran Dynamic Stagging";

    trigger OnRun()
    var
        RecInvestranDynamicSetupL: Record "Investran - Dyanamic Setup";
        LineNoL: Integer;
        RecGeneralJournalLine: Record "Gen. Journal Line";
        DimMgt: Codeunit DimensionManagement;
    begin
        RecInvestranDynamicSetupL.Get();
        LineNoL := GetLastJournalLineNumber(RecInvestranDynamicSetupL."Journal Template Name", RecInvestranDynamicSetupL."Journal Batch Name");

        TempDimensionBuffer.Reset();
        TempDimensionBuffer.DeleteAll();
        LineNoL += 10000;
        RecGeneralJournalLine.Init();
        RecGeneralJournalLine."Journal Template Name" := RecInvestranDynamicSetupL."Journal Template Name";
        RecGeneralJournalLine."Journal Batch Name" := RecInvestranDynamicSetupL."Journal Batch Name";
        RecGeneralJournalLine.Validate("Document No.", Rec."Batch ID");
        RecGeneralJournalLine.Validate("Line No.", LineNoL);
        RecGeneralJournalLine.Validate("Posting Date", Rec."GL Date");
        if '10010' = CopyStr(Rec."GL Account", 1, 5) then
            RecGeneralJournalLine.Validate("Account Type", RecGeneralJournalLine."Account Type"::"Bank Account")
        else
            RecGeneralJournalLine.Validate("Account Type", RecGeneralJournalLine."Account Type"::"G/L Account");
        RecGeneralJournalLine.Validate("Account No.", GetGLAccount(Rec));
        //RecGeneralJournalLine.Validate("Currency Code", Rec."Deal Currency");
        RecGeneralJournalLine.Validate("Debit Amount", Rec.Debits);
        RecGeneralJournalLine.Validate("Credit Amount", Rec.Credits);
        SetShortDim1(Rec);
        SetShortDim2(Rec);
        SetShortDim5(Rec);
        SetShortDim6(Rec);
        SetShortDim8(Rec);
        RecGeneralJournalLine.Validate("Dimension Set ID", GetDimensionSetID());
        DimMgt.UpdateGlobalDimFromDimSetID(RecGeneralJournalLine."Dimension Set ID", RecGeneralJournalLine."Shortcut Dimension 1 Code", RecGeneralJournalLine."Shortcut Dimension 2 Code");
        RecGeneralJournalLine.Validate(Description, Rec."Comments Batch");
        RecGeneralJournalLine.Insert(true);
    end;

    var
        TempDimensionBuffer: Record "Dimension Buffer" temporary;

    local procedure GetLastJournalLineNumber(Template: code[20]; Batch: code[20]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
        GenJour: Page "General Journal";
    begin
        Clear(GenJnlLine);
        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
        GenJnlLine.SetRange("Journal Template Name", Template);
        GenJnlLine.SetRange("Journal Batch Name", Batch);
        if GenJnlLine.FindLast() then
            exit(GenJnlLine."Line No.")
        else
            exit(0);
    end;

    local procedure GetGLAccount(RecInvestranDynamicStaggingP: Record "Investran Dynamic Stagging"): Code[20];
    var
        AccountNoL: Code[20];
        GLAccountL: Record "G/L Account";
        BankAccountL: Record "Bank Account";
    begin
        Clear(AccountNoL);
        Clear(GLAccountL);
        if '10010' = CopyStr(RecInvestranDynamicStaggingP."GL Account", 1, 5) then begin
            BankAccountL.SetRange("Investran Bank Mapping", RecInvestranDynamicStaggingP."Cash Account");
            BankAccountL.FindFirst();
            AccountNoL := BankAccountL."No.";
            exit(AccountNoL);
        end else begin
            GLAccountL.SetRange("Investran Code Mapping", CopyStr(RecInvestranDynamicStaggingP."GL Account", 1, 5));
            GLAccountL.FindFirst();
            AccountNoL := GLAccountL."No.";
            exit(AccountNoL);
        end;
    end;

    local procedure SetShortDim1(RecInvestranDynamicStaggingP: Record "Investran Dynamic Stagging")
    var
        DimensionValueL: Record "Dimension Value";
        GLSetupL: Record "General Ledger Setup";
    begin
        Clear(GLSetupL);
        GLSetupL.Get();
        DimensionValueL.SetRange("Dimension Code", GLSetupL."Shortcut Dimension 1 Code");
        //commented and added setfilter as client want to set multiple Dimension name for one company.
        //DimensionValueL.SetRange("Investran Code Mapping", RecInvestranDynamicStaggingP."Legal Entity");
        DimensionValueL.SetFilter("Investran Code Mapping", '%1', '@*' + RecInvestranDynamicStaggingP."Legal Entity" + '*');
        DimensionValueL.FindFirst();
        TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
        TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
        TempDimensionBuffer.Insert();
    end;

    local procedure SetShortDim2(RecInvestranDynamicStaggingP: Record "Investran Dynamic Stagging")
    var
        DimensionValueL: Record "Dimension Value";
        GLSetupL: Record "General Ledger Setup";
    begin
        Clear(GLSetupL);
        GLSetupL.Get();
        DimensionValueL.SetRange("Dimension Code", GLSetupL."Shortcut Dimension 2 Code");
        DimensionValueL.SetRange("Investran Code Mapping", RecInvestranDynamicStaggingP."Deal Domain");
        DimensionValueL.FindFirst();
        TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
        TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
        TempDimensionBuffer.Insert();
    end;

    local procedure SetShortDim5(RecInvestranDynamicStaggingP: Record "Investran Dynamic Stagging")
    var
        DimensionValueL: Record "Dimension Value";
        GLSetupL: Record "General Ledger Setup";
    begin
        Clear(GLSetupL);
        GLSetupL.Get();
        DimensionValueL.SetRange("Dimension Code", GLSetupL."Shortcut Dimension 5 Code");
        DimensionValueL.SetRange("Investran Code Mapping", RecInvestranDynamicStaggingP."Investment Code");
        DimensionValueL.FindFirst();
        TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
        TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
        TempDimensionBuffer.Insert();
    end;

    local procedure SetShortDim6(RecInvestranDynamicStaggingP: Record "Investran Dynamic Stagging")
    var
        DimensionValueL: Record "Dimension Value";
        GLSetupL: Record "General Ledger Setup";
    begin
        Clear(GLSetupL);
        GLSetupL.Get();
        DimensionValueL.SetRange("Dimension Code", GLSetupL."Shortcut Dimension 6 Code");
        DimensionValueL.SetRange("Investran Code Mapping", RecInvestranDynamicStaggingP."Product Name");
        DimensionValueL.FindFirst();
        TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
        TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
        TempDimensionBuffer.Insert();
    end;

    local procedure SetShortDim8(RecInvestranDynamicStaggingP: Record "Investran Dynamic Stagging")
    var
        DimensionValueL: Record "Dimension Value";
        GLSetupL: Record "General Ledger Setup";
    begin
        Clear(GLSetupL);
        GLSetupL.Get();
        DimensionValueL.SetRange("Dimension Code", GLSetupL."Shortcut Dimension 8 Code");
        DimensionValueL.SetRange("Investran Code Mapping", RecInvestranDynamicStaggingP."Security Type");
        DimensionValueL.FindFirst();
        TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
        TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
        TempDimensionBuffer.Insert();
    end;

    local procedure GetDimensionSetID(): Integer
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        if not DimMgt.CheckDimBuffer(TempDimensionBuffer) then
            Error(DimMgt.GetDimCombErr());
        Exit(DimMgt.CreateDimSetIDFromDimBuf(TempDimensionBuffer));
    end;
}
