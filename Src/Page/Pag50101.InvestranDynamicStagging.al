page 50101 "Investran Dynamic Stagging"
{
    ApplicationArea = All;
    Caption = 'Investran Dynamic Stagging';
    PageType = List;
    SourceTable = "Investran Dynamic Stagging";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Row No"; Rec."Row No")
                {
                    ToolTip = 'Specifies the value of the Row No field.';
                }
                field("Legal Entity"; Rec."Legal Entity")
                {
                    ToolTip = 'Specifies the value of the Legal Entity field.';
                }
                field("Product Name"; Rec."Product Name")
                {
                    ToolTip = 'Specifies the value of the Product Name field.';
                }
                field("Investment Code"; Rec."Investment Code")
                {
                    ToolTip = 'Specifies the value of the Investment Code field.';
                }
                field("Deal Domain"; Rec."Deal Domain")
                {
                    ToolTip = 'Specifies the value of the Deal Domain field.';
                }
                field("Security Type"; Rec."Security Type")
                {
                    ToolTip = 'Specifies the value of the Security Type field.';
                }
                field("Deal Currency"; Rec."Deal Currency")
                {
                    ToolTip = 'Specifies the value of the Deal Currency field.';
                }
                field("GL Date"; Rec."GL Date")
                {
                    ToolTip = 'Specifies the value of the GL Date field.';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field("Trans Type"; Rec."Trans Type")
                {
                    ToolTip = 'Specifies the value of the Trans Type field.';
                    Visible = false;
                }
                field("Batch ID"; Rec."Batch ID")
                {
                    ToolTip = 'Specifies the value of the Batch ID field.';
                }
                field(Debits; Rec.Debits)
                {
                    ToolTip = 'Specifies the value of the Debits field.';
                }
                field(Credits; Rec.Credits)
                {
                    ToolTip = 'Specifies the value of the Credits field.';
                }
                field("Comments Batch"; Rec."Comments Batch")
                {
                    ToolTip = 'Specifies the value of the Comments Batch field.';
                }
                field("Cash Account"; Rec."Cash Account")
                {
                    ToolTip = 'Specifies the value of the Cash Account field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                Caption = 'Import Investran Dynamic';
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    Import: Codeunit "Investran - Dyanamic";
                begin
                    Import.Run();
                end;
            }
            action(ProcessGeneralJournal)
            {
                Caption = 'Process General Journal';
                ApplicationArea = All;
                Image = Journal;
                trigger OnAction()
                var
                    CreateGeneralJournal: Codeunit CreateGeneralJournal;
                begin
                    CreateGeneralJournal.Run();
                end;
            }
            action("Download Files From SFTP")
            {
                Caption = 'Download Files SFTP';
                ApplicationArea = All;
                Image = Journal;
                trigger OnAction()
                var
                    AzureFunction: Codeunit AzureFunctionIntegration;
                    IntSetup: Record "Investran - Dyanamic Setup";
                    Base64Convert: Codeunit "Base64 Convert";
                    TempBlob: Codeunit "Temp Blob";
                    Outstream: OutStream;
                    Instream: InStream;
                begin
                    Clear(AzureFunction);
                    IntSetup.GET;
                    if AzureFunction.Run() then begin
                        if AzureFunction.IsSuccessCall() then begin
                            TempBlob.CreateOutStream(Outstream);
                            Base64Convert.FromBase64(AzureFunction.GetResponse(), Outstream);
                            TempBlob.CreateInStream(Instream);
                            DownloadFromStream(Instream, '', '', '', IntSetup.Filename);
                        end else
                            Message('Status:Failed \Response:%1', AzureFunction.GetResponse());
                    end else
                        Message('Something went wront while connecting Azure FUnction. \Response:%1', AzureFunction.GetResponse());

                end;
            }
        }
    }
}
