// codeunit 50100 "Investran - Dyanamic"
// {
//     trigger OnRun()
//     var
//         InstreamL: InStream;
//         FromFile: Text[200];
//         FileMgmt: Codeunit "File Management";
//         UploadExcelMsg: Label 'Please Choose the Excel file..';
//     begin
//         TempExcelBuffer.DeleteAll();
//         UploadIntoStream(UploadExcelMsg, '', '', FromFile, InstreamL);
//         if FromFile <> '' then begin
//             FileName := FileMgmt.GetFileName(FromFile);
//             SheetName := TempExcelBuffer.SelectSheetsNameStream(InstreamL);
//         end else
//             Error(NoFileFoundMsg);
//         if Company.FindSet() then
//             repeat
//                 TaskScheduler.CreateTask(3846, 0, true, Company.Name);
//                 ReadExcelSheet(FromFile, InstreamL, Company.Name);
//                 ImportExcelData(Company.Name);
//             until Company.Next() = 0;
//     end;

//     local procedure ReadExcelSheet(FromFileP: Text[200]; InstreamP: InStream; CompanyNameP: Text);
//     var
//         CompanyL: Record Company;
//     begin
//         Clear(TempExcelBuffer);
//         TempExcelBuffer.ChangeCompany(CompanyNameP);
//         TempExcelBuffer.Reset();
//         TempExcelBuffer.DeleteAll();
//         TempExcelBuffer.OpenBookStream(InstreamP, SheetName);
//         TempExcelBuffer.ReadSheet();
//     end;


//     local procedure ImportExcelData(CompanyNameP: Text)
//     var
//         RowNo: Integer;
//         LoopRowNo: Integer;
//         ColNo: Integer;
//         MaxRowNo: Integer;
//         RecGenJournalLine: Record "Gen. Journal Line";
//         InvestranSetupL: Record "Investran - Dyanamic Setup";
//         LineNumberL: Integer;
//     begin
//         RowNo := 0;
//         LoopRowNo := 0;
//         MaxRowNo := 0;

//         InvestranSetupL.Get();

//         RecGenJournalLine.ChangeCompany(CompanyNameP);

//         TempExcelBuffer.SetRange("Cell Value as Text", CompanyNameP);
//         if TempExcelBuffer.FindFirst() then
//             RowNo := TempExcelBuffer."Row No.";

//         TempExcelBuffer.SetRange("Cell Value as Text", CompanyNameP);
//         if TempExcelBuffer.FindLast() then
//             MaxRowNo := TempExcelBuffer."Row No.";

//         LineNumberL := GetLastJournalLineNumber(InvestranSetupL."Journal Template Name", InvestranSetupL."Journal Batch Name", CompanyNameP);

//         for LoopRowNo := RowNo to MaxRowNo do begin
//             LineNumberL += 10000;
//             RecGenJournalLine.Init();
//             RecGenJournalLine."Journal Template Name" := InvestranSetupL."Journal Template Name";
//             RecGenJournalLine."Journal Batch Name" := InvestranSetupL."Journal Batch Name";
//             RecGenJournalLine."Line No." := LineNumberL;
//             RecGenJournalLine.Validate("Currency Code", GetValueAtCell(RowNo, 6));
//             RecGenJournalLine.Insert(true);
//         end;
//     end;

//     local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
//     begin
//         TempExcelBuffer.Reset();
//         If TempExcelBuffer.Get(RowNo, ColNo) then
//             exit(TempExcelBuffer."Cell Value as Text")
//         else
//             exit('');
//     end;

//     local procedure GetLastJournalLineNumber(Template: code[20]; Batch: code[20]; CompanyNameP: Text): Integer
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//     begin
//         Clear(GenJnlLine);
//         GenJnlLine.ChangeCompany(CompanyNameP);
//         GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name");
//         GenJnlLine.SetRange("Journal Template Name", Template);
//         GenJnlLine.SetRange("Journal Batch Name", Batch);
//         if GenJnlLine.FindLast() then
//             exit(GenJnlLine."Line No.")
//         else
//             exit(0);
//     end;

//     var
//         FileName: Text[100];
//         SheetName: Text[100];
//         TempExcelBuffer: Record "Excel Buffer" temporary;
//         Company: Record Company;
//         UploadExcelMsg: Label 'Please Choose the Excel file.';
//         NoFileFoundMsg: Label 'No Excel file found!';
//         ExcelImportSucess: Label 'Excel is successfully imported.';
// }
