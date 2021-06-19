program AccountManager;

uses
  Vcl.Forms,
  App_Start in 'src\App_Start.pas' {Start},
  App_View_Authenticate in 'src\App_View_Authenticate.pas' {Authenticate: TFrame},
  App_View_View in 'src\App_View_View.pas' {ViewAccount: TFrame},
  App_View_Edit in 'src\App_View_Edit.pas' {EditAccount: TFrame},
  App_Data in 'src\App_Data.pas',
  App_Utilities in 'src\App_Utilities.pas',
  App_View_Setup in 'src\App_View_Setup.pas' {SetupPassword: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStart, Start);
  Application.Run;
end.
