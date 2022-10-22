program Tiler;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  TileCore in 'TileCore.pas',
  Lib in 'Lib.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:= true;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.Title := 'Tiler';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
