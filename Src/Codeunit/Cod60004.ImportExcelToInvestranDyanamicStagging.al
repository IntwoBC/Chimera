codeunit 60004 "Import Investran File"
{
    trigger OnRun()
    var
        FileMgmt: Codeunit "File Management";
        FromFile: Text[200];
    begin
        if not CallingFromSFT then begin
            UploadIntoStream(UploadExcelMsg, '', '', FromFile, InstreamG);
            if FromFile <> '' then begin
                FileName := FileMgmt.GetFileName(FromFile);
            end else
                Error(NoFileFoundMsg);
        end;
        ReadExcelSheet();
    end;

    internal procedure ReadExcelSheet()
    var
        ProcessInvestranJournalL: Codeunit ProcessInvestranGeneral;
        filenam: Text;
    begin
        // filenam := 'Dynamics Daily Report_' + DelChr(Format(WorkDate(), 0, '<Year4>/<Month,2>/<Day,2>'), '=', '/\-:') + '.xlsx';
        // DownloadFromStream(Instream, '', '', '', filenam);
        /* if not CallingFromSFT then begin
             SheetName := TempExcelBuffer.SelectSheetsNameStream(Instream);
             TempExcelBuffer.Reset();
             TempExcelBuffer.DeleteAll();
             TempExcelBuffer.OpenBookStream(Instream, SheetName);
             TempExcelBuffer.ReadSheet();
         end;*/
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.LoadDataFromStream(InstreamG, ',');
        ImportExcelData();
        ClearLastError();
        Commit();
        // ProcessInvestranJournalL.Run();//commented as client want to process data manually.s
    end;


    local procedure ImportExcelData()
    var
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        RecInvestranStaggingL: Record "Investran Dynamic Stagging";
    begin
        RowNo := 0;
        MaxRowNo := 0;

        // TempExcelBuffer.Reset();
        // if TempExcelBuffer.FindLast() then begin
        //     MaxRowNo := TempExcelBuffer."Row No.";
        // end;
        MaxRowNo := TempExcelBuffer.GetNumberOfLines();
        for RowNo := 2 to MaxRowNo do begin
            RecInvestranStaggingL.Init();
            RecInvestranStaggingL."Row No" := 0;// RowNo;
            RecInvestranStaggingL.Insert(true);
            RecInvestranStaggingL."Legal Entity" := GetValueAtCell(RowNo, 1);
            RecInvestranStaggingL."Product Name" := GetValueAtCell(RowNo, 2);
            RecInvestranStaggingL."Investment Code" := GetValueAtCell(RowNo, 3);
            RecInvestranStaggingL."Deal Domain" := GetValueAtCell(RowNo, 4);
            RecInvestranStaggingL."Security Type" := GetValueAtCell(RowNo, 5);
            RecInvestranStaggingL."Deal Currency" := GetValueAtCell(RowNo, 6);
            RecInvestranStaggingL."GL Date" := GetValueAsDate(GetValueAtCell(RowNo, 7));
            RecInvestranStaggingL."GL Account" := GetValueAtCell(RowNo, 8);
            RecInvestranStaggingL."Batch ID" := GetValueAtCell(RowNo, 9);
            RecInvestranStaggingL.Debits := GetValueAsDecimal(GetValueAtCell(RowNo, 10));
            RecInvestranStaggingL.Credits := GetValueAsDecimal(GetValueAtCell(RowNo, 11));
            RecInvestranStaggingL."Comments Batch" := GetValueAtCell(RowNo, 12);
            RecInvestranStaggingL."Cash Account" := GetValueAtCell(RowNo, 13);
            RecInvestranStaggingL.Status := RecInvestranStaggingL.Status::"Ready To Sync";
            RecInvestranStaggingL.Modify(true);
        end;
        if GuiAllowed then begin
            if NOT HideMessage then
                Message(ExcelImportSucess);
        end;
    end;

    // local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    // begin
    //     TempExcelBuffer.Reset();
    //     If TempExcelBuffer.Get(RowNo, ColNo) then
    //         exit(TempExcelBuffer."Cell Value as Text")
    //     else
    //         exit('');
    // end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer.Value.TrimEnd('"').TrimStart('"'))
        else
            exit('');
    end;

    local procedure GetValueAsDecimal(pValue: Text) Return: Decimal
    begin
        Evaluate(Return, pValue);
    end;

    local procedure GetValueAsDate(pValue: Text) Return: Date
    begin
        Evaluate(Return, pValue);
    end;

    internal procedure SetValue(CallingFromSFTp: Boolean; var Ins: InStream; HideMessagep: Boolean)
    begin
        CallingFromSFT := CallingFromSFTp;
        InstreamG := Ins;
        HideMessage := HideMessagep;
    end;

    var
        FileName: Text[100];
        SheetName: Text[100];
        // TempExcelBuffer: Record "Excel Buffer" temporary;
        TempExcelBuffer: Record "CSV Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'The Excel file has been successfully imported';
        CallingFromSFT: Boolean;
        InstreamG: InStream;
        HideMessage: Boolean;
}
