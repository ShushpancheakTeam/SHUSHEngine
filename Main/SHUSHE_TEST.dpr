program SHUSHE_TEST;

uses
  Vcl.Forms,
  ShushengineTEST in 'ShushengineTEST.pas' {Form1},
  SHUSHENGINE_classes in 'SHUSHENGINE_classes.PAS',
  SHUSHENGINE_consts in 'SHUSHENGINE_consts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
