unit Lib;

interface

uses System.Classes, Vcl.Dialogs, Vcl.Forms;

// Free all TStrings.Objects
procedure FreeObjects(const AStrings: TStrings);

// MessageDlg centered on owner form by David Heffernan
// https://stackoverflow.com/questions/4618743/how-to-make-messagedlg-centered-on-owner-form
function MessageDlgC(OwnerForm: TForm; const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; DefaultButton: TMsgDlgBtn): Integer;


implementation

procedure FreeObjects(const AStrings: TStrings);
var I: Integer;
begin
  for I:= 0 to AStrings.Count-1 do
    AStrings.Objects[i].Free;
end;

function MessageDlgC(OwnerForm: TForm; const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; DefaultButton: TMsgDlgBtn): Integer;
var
  Dialog: TForm;
begin
  Dialog:= CreateMessageDialog(Msg, DlgType, Buttons, DefaultButton);
  try
    OwnerForm.InsertComponent(Dialog);
    Dialog.Position:= poOwnerFormCenter;
    Result:= Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

end.


