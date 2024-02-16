tableextension 60004 BankAccRecon extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(60000; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval","Approved";
        }
    }
}
