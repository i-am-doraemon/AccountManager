unit App_View_ReSetup;

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
  TPasswordChangeEvent = procedure(Sender: TObject; Password, NewPassword: string) of object;

  TReSetupPassword = class(TFrame)
    Container: TPanel;
    PleaseSetupPasswordLabel: TLabel;

    CurrentPasswordLabel: TLabel;
    DoInputCurrentPassword: TEdit;

    NewPasswordLabel: TLabel;
    DoInputNewPassword: TEdit;

    ConfirmationLabel: TLabel;
    DoConfirmPassword: TEdit;

    DoOK: TButton;
    DoCancel: TButton;
    procedure OnDoOK(Sender: TObject);
    procedure OnDoCancel(Sender: TObject);
  private
    { Private 宣言 }
    FOnCancel: TNotifyEvent;
    FOnOK: TPasswordChangeEvent;
  public
    { Public 宣言 }
    procedure Clear;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnOK: TPasswordChangeEvent read FOnOK write FOnOK;
  end;

implementation

{$R *.dfm}

procedure TReSetupPassword.Clear;
begin
  DoInputCurrentPassword.Clear;
  DoInputNewPassword.Clear;
  DoConfirmPassword.Clear;
end;

procedure TReSetupPassword.OnDoOK(Sender: TObject);
var
  NewPassword, Confirmation: string;
begin
  NewPassword := DoInputNewPassword.Text;
  Confirmation := DoConfirmPassword.Text;

  if NewPassword <> Confirmation then
    ShowMessage('２つのパスワードが一致しません。')
  else if NewPassword.Length < 4 then
    ShowMessage('入力したパスワードが短すぎます。')
  else
    if Assigned(FOnOK) then
      FOnOK(Self, DoInputCurrentPassword.Text, DoInputNewPassword.Text);
  Clear;
end;

procedure TReSetupPassword.OnDoCancel(Sender: TObject);
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
  Clear;
end;

end.
