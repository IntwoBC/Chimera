codeunit 60001 InvestranUtility
{

    trigger OnRun()
    var
        RecStagingL: Record "Investran Dynamic Stagging";
    begin
        ImportFileFromSFTPLocation(RecStagingL);
    end;

    procedure ImportFileFromSFTPLocation(var RecStaging: Record "Investran Dynamic Stagging")
    var
        IntegrationSetup: Record "Investran - Dyanamic Setup";
        AzureFunction: Codeunit AzureFunctionIntegration;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        Outstream: OutStream;
        Instream: InStream;
        LogEntryNumber: Integer;
        ImportFileINBC: Codeunit "Import Investran File";
        ResponseText, SheetName, filenam : Text;
        TempExcelBuffer: Record "CSV Buffer" temporary;
    begin
        if GuiAllowed then
            if not Confirm('Do you want to import file from SFTP?', false) then exit;

        IntegrationSetup.GET;
        IntegrationSetup.TestField("Azure Function endpoint");
        IntegrationSetup.TestField("Authentication Code");
        IntegrationSetup.TestField(Host);
        IntegrationSetup.TestField(Username);
        IntegrationSetup.TestField(Password);
        CheckDuplicacy();
        LogEntryNumber := InsertLog(IntegrationSetup.Filename + DelChr(Format(Workdate(), 0, '<Year4>/<Month,2>/<Day,2>'), '=', '/\-:') + '.csv',
         IntegrationSetup."Remote Folder", IntegrationSetup."Azure Function endpoint" + IntegrationSetup."Authentication Code");

        ClearLastError();
        Clear(AzureFunction);
        if AzureFunction.Run() then begin
            ResponseText := AzureFunction.GetResponse();
            if AzureFunction.IsSuccessCall() then begin
                ModifyLog(LogEntryNumber, false, CopyStr(ResponseText, 1, 500), true, true);
                TempBlob.CreateOutStream(Outstream);
                Base64Convert.FromBase64(ResponseText, Outstream);
                TempBlob.CreateInStream(Instream);
                //-importing file in BC
                if ResponseText = '' then begin
                    ModifyLog(LogEntryNumber, false, 'Looks like SFTP File is not uploaded/accessible/Blank', true, true);
                    Error('Looks like SFTP File is not uploaded/accessible/Blank');
                end else
                    ModifyLog(LogEntryNumber, false, CopyStr(ResponseText, 1, 500), true, true);

                ClearLastError();
                ImportFileINBC.SetValue(true, Instream, true);
                if ImportFileINBC.Run() then begin
                    ModifyLog(LogEntryNumber, true, CopyStr(ResponseText, 1, 500), true, true);
                    if GuiAllowed then
                        Message('File has been successfully fetched from SFTP & imported in Business Central');
                end else begin
                    ModifyLog(LogEntryNumber, false, CopyStr(GetLastErrorText(), 1, 500), true, true);
                end;
                //-end
                // DownloadFromStream(Instream, '', '', '', IntegrationSetup.Filename);
            end else begin
                ModifyLog(LogEntryNumber, false, CopyStr(ResponseText, 1, 500), false, true);
                if GuiAllowed then
                    Message('Status:Failed \Response:%1', CopyStr(ResponseText, 1, 500));
            end;
        end else begin
            ModifyLog(LogEntryNumber, false, CopyStr(StrSubstNo('Something went wront while connecting Azure FUnction. Response:%1', AzureFunction.GetResponse()), 1, 500), false, True);
            if GuiAllowed then
                Message('Something went wront while connecting Azure FUnction. \Response:%1', AzureFunction.GetResponse());
        end;

    end;

    local procedure InsertLog(Filename: Text; FOlederPath: Text; URL: Text): Integer
    var
        SFTPLog: Record "SFTP Integration Log";
    begin
        SFTPLog.Init();
        SFTPLog."Entry No." := 0;
        SFTPLog.Insert(true);
        SFTPLog."Action Performed At" := CurrentDateTime;
        SFTPLog."Action Performed By" := UserId;
        SFTPLog.Filename := Filename;
        SFTPLog."Folder Pah" := FOlederPath;
        SFTPLog."SFTP URL" := URL;
        SFTPLog."Successfully Imported" := false;
        SFTPLog."Error Remarks" := '';
        SFTPLog."Action Performed ON" := WorkDate();
        SFTPLog.Modify(true);
        Commit();
        exit(SFTPLog."Entry No.");
    end;

    local procedure ModifyLog(EntryNumber: Integer; Imported: Boolean; ErrorRemarks: Text; FIleReceived: Boolean; usecommit: Boolean)
    var
        SFTPLog: Record "SFTP Integration Log";
    begin
        SFTPLog.GET(EntryNumber);
        SFTPLog."Successfully Imported" := Imported;
        SFTPLog."Error Remarks" := ErrorRemarks;
        SFTPLog."File Received From SFTP" := FIleReceived;
        SFTPLog.Modify(true);
        if usecommit then
            Commit();
    end;

    local procedure CheckDuplicacy()
    var
        SFTPLog: Record "SFTP Integration Log";
    begin
        Clear(SFTPLog);
        SFTPLog.SetRange("Action Performed ON", WorkDate());
        SFTPLog.SetRange("Successfully Imported", true);
        SFTPLog.SetRange("File Received From SFTP", true);
        //SFTPLog.SetFilter("Error Remarks", '=%1', '');
        if SFTPLog.FindFirst() then
            Error('Import action has been already performed by UserId: %1, at: %2', SFTPLog."Action Performed By", SFTPLog."Action Performed At");
    end;

    internal procedure UserBasedAllocation(var PurchLine: Record "Purchase Line")
    var
        RecPurchLineL: Record "Purchase Line";
        EmployeeDimensionMatrix: Record "Employee Dimension Matrix";
        EmployeeDimensionMatrix2: Record "Employee Dimension Matrix";
        DimSetEntry: Record "Dimension Set Entry";
        NoOfEmployee, TotalNoOfEmployee, LineNumber : Integer;
        DepartmentList: List of [Text];
    begin
        PurchLine.TestField(Type, PurchLine.Type::"G/L Account");
        PurchLine.TestField("Amount Including VAT");
        PurchLine.TestField("Dimension Set ID");

        Clear(DimSetEntry);
        DimSetEntry.SetRange("Dimension Set ID", PurchLine."Dimension Set ID");
        DimSetEntry.SetRange("Dimension Code", 'SOFTWARE');
        DimSetEntry.FindFirst();

        PurchLine."UserBased Allocation" := true;
        PurchLine.Modify();

        Clear(DepartmentList);
        LineNumber := GetLastPurchLineN(PurchLine);

        TotalNoOfEmployee := GetTotalNumberOfEmployeeFromMatrix(DimSetEntry."Dimension Value Code", '');

        Clear(EmployeeDimensionMatrix);
        EmployeeDimensionMatrix.SetRange("Software Dimension", DimSetEntry."Dimension Value Code");
        if EmployeeDimensionMatrix.FindSet() then begin
            repeat
                if not DepartmentList.Contains(EmployeeDimensionMatrix."Department Dimension") then begin
                    DepartmentList.Add(EmployeeDimensionMatrix."Department Dimension");
                    Clear(EmployeeDimensionMatrix2);
                    EmployeeDimensionMatrix2.SetRange("Software Dimension", DimSetEntry."Dimension Value Code");
                    EmployeeDimensionMatrix2.SetRange("Department Dimension", EmployeeDimensionMatrix."Department Dimension");
                    if EmployeeDimensionMatrix2.FindSet() then begin
                        NoOfEmployee := EmployeeDimensionMatrix2.Count();
                    end;
                    RecPurchLineL.Init();
                    RecPurchLineL."Document Type" := PurchLine."Document Type";
                    RecPurchLineL."Document No." := PurchLine."Document No.";
                    LineNumber += 10000;
                    RecPurchLineL."Line No." := LineNumber;
                    RecPurchLineL.Insert(true);
                    RecPurchLineL.Validate("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");
                    RecPurchLineL.Validate(Type, RecPurchLineL.Type::"G/L Account");
                    RecPurchLineL.Validate("No.", PurchLine."No.");
                    RecPurchLineL.Validate(Quantity, NoOfEmployee);
                    RecPurchLineL.Validate("Direct Unit Cost", PurchLine."Amount Including VAT" / TotalNoOfEmployee);
                    RecPurchLineL.Validate("Dimension Set ID", InsertDimension(PurchLine."Dimension Set ID", 'SOFTWARE', EmployeeDimensionMatrix."Software Dimension"));
                    RecPurchLineL.Validate("Dimension Set ID", InsertDimension(PurchLine."Dimension Set ID", 'DEPARTMENT', EmployeeDimensionMatrix."Department Dimension"));
                    RecPurchLineL."UserBased Allocation" := true;
                    RecPurchLineL."Derived From Line No." := PurchLine."Line No.";
                    RecPurchLineL.Modify(true);
                end;
            until EmployeeDimensionMatrix.Next() = 0;
        end;

    end;

    local procedure GetTotalNumberOfEmployeeFromMatrix(Software: Text; Department: Text): Integer
    var
        EmployeeDimensionMatrix: Record "Employee Dimension Matrix";
        EmpList: List of [Text];
        TotalEMployee: Integer;
    begin
        Clear(EmpList);
        Clear(EmployeeDimensionMatrix);

        if Software <> '' then
            EmployeeDimensionMatrix.SetRange("Software Dimension", Software)
        else
            if Department <> '' then
                EmployeeDimensionMatrix.SetRange("Department Dimension", Department)
            else
                EmployeeDimensionMatrix.SetFilter("Department Dimension", '<>%1', '');


        if EmployeeDimensionMatrix.FindSet() then begin
            repeat
                if not EmpList.Contains(EmployeeDimensionMatrix."Employee Code") then begin
                    EmpList.Add(EmployeeDimensionMatrix."Employee Code");
                    TotalEMployee += 1;
                end;
            until EmployeeDimensionMatrix.Next() = 0;
        end;
        exit(TotalEMployee);
    end;

    internal procedure HeadCountAllocation(var PurchLine: Record "Purchase Line")
    var
        RecPurchLineL: Record "Purchase Line";
        EmployeeDimensionMatrix: Record "Employee Dimension Matrix";
        EmployeeDimensionMatrix2: Record "Employee Dimension Matrix";
        //DimSetEntry: Record "Dimension Set Entry";
        NoOfEmployee, TotalNoOfEmployee, LineNumber : Integer;
        DepartmentList: List of [Text];
    begin
        PurchLine.TestField(Type, PurchLine.Type::"G/L Account");
        PurchLine.TestField("Amount Including VAT");

        Clear(DepartmentList);
        LineNumber := GetLastPurchLineN(PurchLine);

        PurchLine."HeadCount Allocation" := true;
        PurchLine.Modify();

        TotalNoOfEmployee := GetTotalNumberOfEmployeeFromMatrix('', '');

        Clear(EmployeeDimensionMatrix);
        if EmployeeDimensionMatrix.FindSet() then begin
            repeat
                if not DepartmentList.Contains(EmployeeDimensionMatrix."Department Dimension") then begin
                    DepartmentList.Add(EmployeeDimensionMatrix."Department Dimension");

                    NoOfEmployee := GetTotalNumberOfEmployeeFromMatrix('', EmployeeDimensionMatrix."Department Dimension");

                    RecPurchLineL.Init();
                    RecPurchLineL."Document Type" := PurchLine."Document Type";
                    RecPurchLineL."Document No." := PurchLine."Document No.";
                    LineNumber += 10000;
                    RecPurchLineL."Line No." := LineNumber;
                    RecPurchLineL.Insert(true);
                    RecPurchLineL.Validate("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");
                    RecPurchLineL.Validate(Type, RecPurchLineL.Type::"G/L Account");
                    RecPurchLineL.Validate("No.", PurchLine."No.");
                    RecPurchLineL.Validate(Quantity, NoOfEmployee);
                    RecPurchLineL.Validate("Direct Unit Cost", PurchLine."Amount Including VAT" / TotalNoOfEmployee);
                    RecPurchLineL.Validate("Dimension Set ID", InsertDimension(PurchLine."Dimension Set ID", 'DEPARTMENT', EmployeeDimensionMatrix."Department Dimension"));
                    RecPurchLineL."HeadCount Allocation" := true;
                    RecPurchLineL."Derived From Line No." := PurchLine."Line No.";
                    RecPurchLineL.Modify(true);
                end;
            until EmployeeDimensionMatrix.Next() = 0;
        end;

    end;

    local procedure GetLastPurchLineN(var PurchLine: Record "Purchase Line"): Integer
    var
        RecPurchLineL: Record "Purchase Line";
    begin
        Clear(RecPurchLineL);
        RecPurchLineL.SetCurrentKey("Document Type", "Document No.", "Line No.");
        RecPurchLineL.SetRange("Document Type", PurchLine."Document Type");
        RecPurchLineL.SetRange("Document No.", PurchLine."Document No.");
        if RecPurchLineL.FindLast() then
            exit(RecPurchLineL."Line No.")
        else
            exit(0);
    end;

    internal procedure InsertDimension(DimensionSetId: Integer; "DimensionCode": code[20]; DimVal: code[20]): Integer
    var
        DimSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionManagementCU: Codeunit DimensionManagement;
    begin
        DimensionManagementCU.GetDimensionSet(DimSetEntryTemp, DimensionSetId);
        if DimSetEntryTemp.Get(DimensionSetId, DimensionCode) then
            DimSetEntryTemp.Delete();
        DimSetEntryTemp."Dimension Code" := DimensionCode;
        DimSetEntryTemp."Dimension Value Code" := DimVal;
        if DimSetEntryTemp.Insert(true) then;
        exit(DimensionManagementCU.GetDimensionSetID(DimSetEntryTemp));
    end;

    internal procedure UpdateCostAllocationPercentage(var SqFtAllocation: Record "Square Foot Allocation Matrix")
    var
        SqFtAllocationL: Record "Square Foot Allocation Matrix";
    begin
        SqFtAllocation.CalcFields("Total Space of Department");
        Clear(SqFtAllocationL);
        SqFtAllocationL.SetFilter(Department, '<>%1', '');
        if SqFtAllocationL.FindSet() then begin
            repeat
                if SqFtAllocation."Total Space of Department" <> 0 then
                    SqFtAllocationL."% For Cost Allocation" := (SqFtAllocationL."Space Per Department" / SqFtAllocation."Total Space of Department") * 100
                else
                    SqFtAllocationL."% For Cost Allocation" := 0;
                SqFtAllocationL.Modify();
            until SqFtAllocationL.Next() = 0;
        end
    end;

    internal procedure SqareFootAllocation(var PurchLine: Record "Purchase Line")
    var
        SqFtAllocationL: Record "Square Foot Allocation Matrix";
        RecPurchLineL: Record "Purchase Line";
        LineNumber: Integer;
    begin
        PurchLine.TestField(Type, PurchLine.Type::"G/L Account");
        PurchLine.TestField("Amount Including VAT");
        LineNumber := GetLastPurchLineN(PurchLine);

        PurchLine."SquareFoot Allocation" := true;
        PurchLine.Modify();

        Clear(SqFtAllocationL);
        SqFtAllocationL.SetFilter(Department, '<>%1', '');
        if SqFtAllocationL.FindSet() then begin
            repeat
                RecPurchLineL.Init();
                RecPurchLineL."Document Type" := PurchLine."Document Type";
                RecPurchLineL."Document No." := PurchLine."Document No.";
                LineNumber += 10000;
                RecPurchLineL."Line No." := LineNumber;
                RecPurchLineL.Insert(true);
                RecPurchLineL.Validate("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");
                RecPurchLineL.Validate(Type, RecPurchLineL.Type::"G/L Account");
                RecPurchLineL.Validate("No.", PurchLine."No.");
                RecPurchLineL.Validate(Quantity, 1);
                RecPurchLineL.Validate("Direct Unit Cost", (PurchLine."Amount Including VAT" * SqFtAllocationL."% For Cost Allocation") / 100);
                RecPurchLineL.Validate("Dimension Set ID", InsertDimension(PurchLine."Dimension Set ID", 'DEPARTMENT', SqFtAllocationL.Department));
                RecPurchLineL."SquareFoot Allocation" := true;
                RecPurchLineL."Derived From Line No." := PurchLine."Line No.";
                RecPurchLineL.Modify(true);
            until SqFtAllocationL.Next() = 0;
        end;
    end;


    internal procedure ProductTypeBasedAllocation(var PurchLine: Record "Purchase Line")
    var
        ProductRelation: Record "Product Relations";
        RecPurchLineL: Record "Purchase Line";
        DimSetEntry: Record "Dimension Set Entry";
        NoOfEmployee, TotalNoOfEmployee, LineNumber : Integer;
    begin
        PurchLine.TestField(Type, PurchLine.Type::"G/L Account");
        PurchLine.TestField("Amount Including VAT");
        PurchLine.TestField("Dimension Set ID");

        Clear(DimSetEntry);
        DimSetEntry.SetRange("Dimension Set ID", PurchLine."Dimension Set ID");
        DimSetEntry.SetRange("Dimension Code", 'TYPEOFPRODUCT');
        DimSetEntry.FindFirst();

        PurchLine."Product Type Based Allocation" := true;
        PurchLine.Modify();

        LineNumber := GetLastPurchLineN(PurchLine);

        Clear(ProductRelation);
        ProductRelation.SetRange("Product Type", DimSetEntry."Dimension Value Code");
        if ProductRelation.FindSet() then begin
            TotalNoOfEmployee := ProductRelation.Count();
            repeat
                RecPurchLineL.Init();
                RecPurchLineL."Document Type" := PurchLine."Document Type";
                RecPurchLineL."Document No." := PurchLine."Document No.";
                LineNumber += 10000;
                RecPurchLineL."Line No." := LineNumber;
                RecPurchLineL.Insert(true);
                RecPurchLineL.Validate("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");
                RecPurchLineL.Validate(Type, RecPurchLineL.Type::"G/L Account");
                RecPurchLineL.Validate("No.", PurchLine."No.");
                RecPurchLineL.Validate(Quantity, 1);
                RecPurchLineL.Validate("Direct Unit Cost", PurchLine."Amount Including VAT" / TotalNoOfEmployee);
                RecPurchLineL.Validate("Dimension Set ID", InsertDimension(PurchLine."Dimension Set ID", 'TYPEOFPRODUCT', ProductRelation."Product Type"));
                RecPurchLineL.Validate("Dimension Set ID", InsertDimension(PurchLine."Dimension Set ID", 'NAMEOFPRODUCT', ProductRelation."Product Name"));
                RecPurchLineL."Product Type Based Allocation" := true;
                RecPurchLineL."Derived From Line No." := PurchLine."Line No.";
                RecPurchLineL.Modify(true);
            until ProductRelation.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Square Foot Allocation Matrix", 'OnAfterInsertEvent', '', false, false)]
    local procedure SqftOnInsert(var Rec: Record "Square Foot Allocation Matrix"; RunTrigger: Boolean)
    var
        Utility: Codeunit InvestranUtility;
    begin
        if RunTrigger then
            Utility.UpdateCostAllocationPercentage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Square Foot Allocation Matrix", 'OnAfterModifyEvent', '', false, false)]
    local procedure SqftOnModify(var Rec: Record "Square Foot Allocation Matrix"; var xRec: Record "Square Foot Allocation Matrix"; RunTrigger: Boolean)
    var
        Utility: Codeunit InvestranUtility;
    begin
        if RunTrigger then
            Utility.UpdateCostAllocationPercentage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Square Foot Allocation Matrix", 'OnAfterDeleteEvent', '', false, false)]
    local procedure SqftOnDelete(var Rec: Record "Square Foot Allocation Matrix"; RunTrigger: Boolean)
    var
        Utility: Codeunit InvestranUtility;
    begin
        if RunTrigger then
            Utility.UpdateCostAllocationPercentage(Rec);
    end;
}
