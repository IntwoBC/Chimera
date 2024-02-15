page 60003 "Global Report Configuration"
{
    Caption = 'Global Report Configuration';
    PageType = List;
    SourceTable = "Global Report Configuration";
    UsageCategory = None;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Trial Balance Report"; Rec."Trial Balance Report")
                {
                    ToolTip = 'Specifies the value of the Trial Balance Report field.';
                    ApplicationArea = All;
                }
                field("G/L Entries Dump"; Rec."G/L Entries Dump")
                {
                    ToolTip = 'Specifies the value of the G/L Entries Dump field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        ReportConfig: Record "Global Report Configuration";
        RecCompanies: Record Company;
    begin
        Clear(RecCompanies);
        if RecCompanies.FindSet() then begin
            repeat
                Clear(ReportConfig);
                if NOT ReportConfig.GET(RecCompanies.Name) then begin
                    ReportConfig."Company Name" := RecCompanies.Name;
                    ReportConfig.Insert(true);
                end;
            until RecCompanies.Next() = 0;
        end;
    end;
}
