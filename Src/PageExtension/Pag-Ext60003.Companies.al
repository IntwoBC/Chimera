pageextension 60003 Companies extends Companies
{
    actions
    {
        addfirst(processing)
        {
            action("Global Report Configuration")
            {
                ApplicationArea = All;
                Image = Report;
                RunObject = page "Global Report Configuration";
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
        }
    }
}
