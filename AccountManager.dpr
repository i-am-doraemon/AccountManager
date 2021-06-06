program AccountManager;

uses
  Vcl.Forms,
  App_Start in 'src\App_Start.pas' {Start};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStart, Start);
  Application.Run;
end.
