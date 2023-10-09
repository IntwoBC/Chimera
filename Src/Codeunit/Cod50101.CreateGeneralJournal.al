codeunit 50101 CreateGeneralJournal
{
    trigger OnRun()
    var
        RecInvestranDynamicStaggingL: Record "Investran Dynamic Stagging";
        RecInvestranDynamicSetupL: Record "Investran - Dyanamic Setup";
        RecGeneralJournalLine: Record "Gen. Journal Line";
        LineNoL: Integer;
        CountL: Integer;
        DimMgt: Codeunit DimensionManagement;
    begin
        RecInvestranDynamicSetupL.Get();
        RecInvestranDynamicSetupL.TestField("Investran Entity Active");

        LineNoL := GetLastJournalLineNumber(RecInvestranDynamicSetupL."Journal Template Name", RecInvestranDynamicSetupL."Journal Batch Name");

        Clear(RecInvestranDynamicStaggingL);
        Clear(RecGeneralJournalLine);
        RecInvestranDynamicStaggingL.SetCurrentKey("Row No");
        RecInvestranDynamicStaggingL.SetAscending("Row No", true);
        RecInvestranDynamicStaggingL.SetRange("Legal Entity", RecInvestranDynamicSetupL."Investran Legal Entity");
        if RecInvestranDynamicStaggingL.FindSet() then
            repeat
                TempDimensionBuffer.Reset();
                TempDimensionBuffer.DeleteAll();
                LineNoL += 10000;
                RecGeneralJournalLine.Init();
                RecGeneralJournalLine."Journal Template Name" := RecInvestranDynamicSetupL."Journal Template Name";
                RecGeneralJournalLine."Journal Batch Name" := RecInvestranDynamicSetupL."Journal Batch Name";
                RecGeneralJournalLine."Line No." := LineNoL;
                RecGeneralJournalLine."Currency Code" := RecInvestranDynamicStaggingL."Deal Currency";
                RecGeneralJournalLine."Posting Date" := RecInvestranDynamicStaggingL."GL Date";
                RecGeneralJournalLine."Account Type" := RecGeneralJournalLine."Account Type"::"G/L Account";
                RecGeneralJournalLine.Validate("Account No.", GetGLAccount(RecInvestranDynamicStaggingL));
                RecGeneralJournalLine."Document No." := RecInvestranDynamicStaggingL."Batch ID";
                RecGeneralJournalLine."Debit Amount" := RecInvestranDynamicStaggingL.Debits;
                RecGeneralJournalLine."Credit Amount" := RecInvestranDynamicStaggingL.Credits;
                SetShortDim1(RecInvestranDynamicStaggingL);
                SetShortDim2(RecInvestranDynamicStaggingL);
                SetShortDim5(RecInvestranDynamicStaggingL);
                SetShortDim6(RecInvestranDynamicStaggingL);
                SetShortDim8(RecInvestranDynamicStaggingL);
                RecGeneralJournalLine.Validate("Dimension Set ID", GetDimensionSetID());
                DimMgt.UpdateGlobalDimFromDimSetID(RecGeneralJournalLine."Dimension Set ID", RecGeneralJournalLine."Shortcut Dimension 1 Code", RecGeneralJournalLine."Shortcut Dimension 2 Code");
                RecGeneralJournalLine.Description := RecInvestranDynamicStaggingL."Comments Batch";
                RecGeneralJournalLine.Insert(true);
                RecInvestranDynamicStaggingL.Delete();
                CountL += 1;
            until RecInvestranDynamicStaggingL.Next() = 0;
        Message('Total %1, lines processed sucessfully', CountL);
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
    begin
        Clear(AccountNoL);
        Clear(GLAccountL);
        GLAccountL.SetRange("Investran Code Mapping", CopyStr(RecInvestranDynamicStaggingP."GL Account", 1, 5));
        if GLAccountL.FindFirst() then begin
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
        DimensionValueL.SetRange("Investran Code Mapping", RecInvestranDynamicStaggingP."Legal Entity");
        if DimensionValueL.FindFirst() then begin
            TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
            TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
            TempDimensionBuffer.Insert();
        end;
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
        if DimensionValueL.FindFirst() then begin
            TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
            TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
            TempDimensionBuffer.Insert();
        end;
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
        if DimensionValueL.FindFirst() then begin
            TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
            TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
            TempDimensionBuffer.Insert();
        end;
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
        if DimensionValueL.FindFirst() then begin
            TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
            TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
            TempDimensionBuffer.Insert();
        end;
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
        if DimensionValueL.FindFirst() then begin
            TempDimensionBuffer."Dimension Code" := DimensionValueL."Dimension Code";
            TempDimensionBuffer."Dimension Value Code" := DimensionValueL.Code;
            TempDimensionBuffer.Insert();
        end;
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
