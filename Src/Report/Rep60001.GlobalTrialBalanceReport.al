report 60001 "Global Trial Balance Report"
{
    ApplicationArea = All;
    Caption = 'Global Trial Balance Report';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(AsOfDate; AsOfDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As of';
                    }
                    // field(StartDate; StartDate)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Start Date';
                    // }
                    // field(EndDate; EndDate)
                    // {
                    //ApplicationArea = All;
                    //     Caption = 'Start Date';
                    // }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        if AsOfDate = 0D then
            Error('As of Date must have a value');
        GenerateReport();
    end;

    local procedure GenerateReport()
    var
        ReportConfig: Record "Global Report Configuration";
        GLAccount: Record "G/L Account";
        CurrentBal: Decimal;
        TotalBalance: Decimal;
    begin
        MakeExcelDataHeader();
        Clear(GLAccount);
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if GLAccount.FindSet() then begin
            repeat
                TotalBalance := 0;
                CurrentBal := 0;
                ExcelBuf.NewRow();
                ExcelBuf.AddColumn(GLAccount."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(GLAccount.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                Clear(ReportConfig);
                ReportConfig.SetRange("Trial Balance Report", true);
                if ReportConfig.FindSet() then begin
                    repeat
                        CurrentBal := GetGLBalance(GLAccount."No.", ReportConfig."Company Name");
                        ExcelBuf.AddColumn(CurrentBal, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                        TotalBalance += CurrentBal;
                    until ReportConfig.Next() = 0;
                end;
                ExcelBuf.AddColumn(TotalBalance, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            until GLAccount.Next() = 0;
        end;
        CreateExcelbook();
    end;

    local procedure MakeExcelDataHeader()
    var
        ReportConfig: Record "Global Report Configuration";
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Account No.', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Account Name', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);

        Clear(ReportConfig);
        ReportConfig.SetRange("Trial Balance Report", true);
        if ReportConfig.FindSet() then begin
            repeat
                ExcelBuf.AddColumn(ReportConfig."Company Name", false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
            until ReportConfig.Next() = 0;
        end else
            Error('There is no company allowed to generate Trial Balance Report');
        ExcelBuf.AddColumn('Total', false, '', true, false, true, '', ExcelBuf."Cell Type"::Text);
    End;

    local procedure CreateExcelbook()
    begin
        ExcelBuf.CreateNewBook('TrialBalance_Global');
        ExcelBuf.WriteSheet('TrialBalance_Global', COMPANYNAME, USERID);
        ExcelBuf.CloseBook();
        DownloadExcelFile('TrialBalance_Global_' + DelChr(FORMAT(CurrentDateTime), '=', '.:/\-AMPM') + '.xlsx');
    end;

    procedure DownloadExcelFile(FileName: Text)
    var
        InStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        FileInStream: OutStream;
    begin
        TempBlob.CreateOutStream(FileInStream);
        ExcelBuf.SaveToStream(FileInStream, True);
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, '', '', '', FileName);
    end;

    local procedure GetGLBalance(GLAcc: code[20]; comp: Text[50]): Decimal
    var
        GLAccountL: Record "G/L Account";
    begin
        Clear(GLAccountL);
        GLAccountL.ChangeCompany(comp);
        GLAccountL.SetRange("No.", GLAcc);
        GLAccountL.SetFilter("Date Filter", '..%1', AsOfDate);
        if GLAccountL.FindSet() then begin
            GLAccountL.CalcFields(Balance);
            exit(GLAccountL.Balance);
        end;
        exit(0);
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        AsOfDate: Date;
    //StartDate, EndDate : Date;
}
