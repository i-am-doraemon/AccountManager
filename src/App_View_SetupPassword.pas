unit App_View_SetupPassword;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Variants,

  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.StdCtrls,

  Winapi.Messages,
  Winapi.Windows;

type
  TPasswordNotifyEvent = procedure(Sender: TObject; Password: string) of object;

  TSetupPassword = class(TFrame)
    Container: TPanel;
    PleaseSetupPasswordLabel: TLabel;

    PasswordLabel: TLabel;
    DoInputPassword: TEdit;

    ConfirmationLabel: TLabel;
    DoConfirmPassword: TEdit;

    DoOK: TButton;

    procedure OnDoOK(Sender: TObject);
  private
    { Private 宣言 }
    FOnSetupPassword: TPasswordNotifyEvent;
  public
    { Public 宣言 }
    property OnSetupPassword: TPasswordNotifyEvent read FOnSetupPassword write FOnSetupPassword;
  end;

implementation

{$R *.dfm}

procedure TSetupPassword.OnDoOK(Sender: TObject);
var
  Password1, Password2: string;
begin
  Password1 := DoInputPassword.Text;
  Password2 := DoConfirmPassword.Text;

  if Password1 <> Password2 then
    ShowMessage('パスワードが一致しません。')
  else if Password1.Length < 4 then
    ShowMessage('パスワードが短すぎます。')
  else
    if Assigned(FOnSetupPassword) then
      FOnSetupPassword(Self, Password1);
end;

end.
