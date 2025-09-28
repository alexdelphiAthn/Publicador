program Publicador;

uses
  Vcl.Forms,
  inMtoPublish in 'inMtoPublish.pas' {frmPublish},
  inLibDir in 'inLibDir.pas',
  inLibLog in 'inLibLog.pas',
  inLibWin in 'inLibWin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPublish, frmPublish);
  Application.Run;
end.
