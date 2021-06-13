program AccountManager;

uses
  Vcl.Forms,
  App_Start in 'src\App_Start.pas' {Start},
  App_View_Authenticate in 'src\App_View_Authenticate.pas' {Authenticate: TFrame},
  App_View_ViewAccount in 'src\App_View_ViewAccount.pas' {ViewAccount: TFrame},
  App_View_EditAccount in 'src\App_View_EditAccount.pas' {EditAccount: TFrame},
  App_Data in 'src\App_Data.pas',
  App_Utilities in 'src\App_Utilities.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStart, Start);
  Application.Run;
end.
