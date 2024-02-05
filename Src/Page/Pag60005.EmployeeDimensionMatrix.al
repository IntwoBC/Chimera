page 60005 "Employee Dimension Matrix"
{
    ApplicationArea = All;
    Caption = 'Employee Dimension Matrix';
    PageType = List;
    SourceTable = "Employee Dimension Matrix";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Software Dimension"; Rec."Software Dimension")
                {
                    ToolTip = 'Specifies the value of the Software Dimension field.';
                    ApplicationArea = All;
                }
                field("Department Dimension"; Rec."Department Dimension")
                {
                    ToolTip = 'Specifies the value of the Department Dimension field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
