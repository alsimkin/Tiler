unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, System.Math, IniFiles,
  Lib, TileCore;

type
  TWinDataObj = class    // Objects for ListBox1.Items
    WinData: TWinData;
  end;

  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    RBtn1: TRadioButton;
    RBtn2: TRadioButton;
    Button3: TButton;
    Button2: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    R: TRect;
    TileAfterClose: boolean;
    procedure ShowFound(A: integer);
    procedure ShowSelected(A: integer);
    procedure SearchWnd;
    procedure TileWnd;
    procedure HideWnd;
    procedure CloseWnd;
    function GetSelectedWnd: TWinsData;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  F: TMemIniFile;
  Fname: string;
begin
  R:= Screen.WorkAreaRect;

  ShowFound(0);
  ShowSelected(0);

// init ComboBoxes
  Fname:= ChangeFileExt(Application.ExeName, '.ini');
  if FileExists(Fname) then
    begin
      F:= TMemIniFile.Create(Fname);
      try
        F.ReadSectionValues('Title', ComboBox1.Items);
        F.ReadSectionValues('Class', ComboBox2.Items);
        TileAfterClose:= F.ReadString('Options','TileAfterClose', '0') = '1';
      finally
        F.Free;
      end;

      if ComboBox1.Items.Count > 0 then
        ComboBox1.Text:= ComboBox1.Items[0];
      if ComboBox2.Items.Count > 0 then
        ComboBox2.Text:= ComboBox2.Items[0];
    end
  else
    ShowMessage('Initialization file "'+Fname+'" not found !');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeObjects(ListBox1.Items);
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  ShowSelected(ListBox1.SelCount);
end;

procedure TForm1.ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with ListBox1 do begin
    if Count > 0 then
      case Key of
        VK_ESCAPE:                   // Clear selection
          begin
            ClearSelection;
            ShowSelected(0);
          end;
        Ord('A'):                    // Select all (Ctrl-A  $41)
          if Shift = [ssCtrl] then
          begin
            SelectAll;
            ShowSelected(SelCount);
          end;
        VK_DELETE:                   // Close selected
          CloseWnd;
      end;
  end;
end;

procedure TForm1.SearchWnd;
var
  A: TWinsData;
  WinData: TWinData;
  WinDataObj: TWinDataObj;
begin
  with ListBox1 do
  begin
    FreeObjects(ListBox1.Items);
    Clear;
    ShowFound(0);
    ShowSelected(0);

  // fill list
    A:= SearchWin(Handle, ComboBox2.Text, ComboBox1.Text);
    for WinData in A do
    begin
      WinDataObj:= TWinDataObj.Create;
      WinDataObj.WinData:= WinData;
      Items.AddObject(IntToStr(WinData.WinID) +'  '+ WinData.WinTitle, WinDataObj);
    end;

  // auto selection
    if Count > 0 then
    begin
      SelectAll;
      ShowFound(Count);
      ShowSelected(SelCount)
    end;
  end;
end;

procedure TForm1.HideWnd;
begin
  if ListBox1.SelCount > 0 then
    HideWin(GetSelectedWnd);
end;

procedure TForm1.TileWnd;
var
  Cols : integer;   // wanted amount of columns
  Rows : integer;   // wanted amount of rows
begin
  if ListBox1.SelCount > 0 then
  begin
    Cols:= StrToIntDef(Edit1.Text, 2);
    if not (Cols in [1..3]) then
      raise Exception.Create('Only 1 - 3 Cols allowed');
    Rows:= StrToIntDef(Edit2.Text, 4);
    if not (Rows in [2..8]) then
      raise Exception.Create('Only 2 - 8 Rows allowed');

    TileWin(Handle, R, Cols, Rows, GetSelectedWnd, RBtn2.Checked);
  end;
end;

procedure TForm1.CloseWnd;
begin
  if ListBox1.SelCount > 0 then
    if MessageDlgC(Form1, 'Close selected windows ?', mtConfirmation, [mbYes, mbNo], mbYes) = mrYes then
      CloseWin(GetSelectedWnd);
end;

function TForm1.GetSelectedWnd: TWinsData;
var
  I: integer;
begin
  SetLength(Result, 0);
  with ListBox1 do
    if SelCount > 0 then
      for I:= 0 to Count-1 do
        if Selected[i] then
          Result:= Result + [TWinDataObj(Items.Objects[i]).WinData];
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then Key:= #0;    // #8 - backspace key
end;

procedure TForm1.ShowFound(A: integer);
begin
  StatusBar1.Panels[0].Text:= 'Found: ' + A.ToString;
end;

procedure TForm1.ShowSelected(A: integer);
begin
  StatusBar1.Panels[1].Text:= 'Selected: ' + A.ToString;
end;

// Close selected windows
procedure TForm1.Button4Click(Sender: TObject);
begin
  CloseWnd;
  Sleep(500); // Some time for close windows
  SearchWnd;
  if (ListBox1.Count > 0) and TileAfterClose then
    TileWnd;
end;

// Tile
procedure TForm1.Button3Click(Sender: TObject);
begin
  TileWnd;
end;

// Hide
procedure TForm1.Button2Click(Sender: TObject);
begin
  HideWnd;
end;

// Search
procedure TForm1.Button1Click(Sender: TObject);
begin
  SearchWnd;
end;

end.
