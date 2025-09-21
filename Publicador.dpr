program Publicador;

uses
  Vcl.Forms,
  inMtoPublish in 'inMtoPublish.pas' {frmPublish};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPublish, frmPublish);
  Application.Run;
end.
