unit App_View_Edit;

interface

uses
  App_Data,
  App_Utilities,

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
  TAccountNotifyEvent = procedure(Sender: TObject; Account: TAccount) of object;

  TEditAccount = class(TFrame)
    Container: TPanel;

    SiteNameLabel: TLabel;
    DoInputSiteName: TEdit;

    AddressLabel: TLabel;
    DoInputAddress: TEdit;

    UserNameLabel: TLabel;
    DoInputUserName: TEdit;

    PasswordLabel: TLabel;
    DoInputPassword: TEdit;

    RemarksLabel: TLabel;
    DoInputRemarks: TMemo;

    DoCancel: TButton;
    DoOK: TButton;
    DoGeneratePassword: TButton;

    procedure OnDoCancel(Sender: TObject);
    procedure OnDoOK(Sender: TObject);
    procedure OnDoGeneratePassword(Sender: TObject);
  private
    { Private 宣言 }
    FId: Integer;
    FPasswordGenerator: TPasswordGenerator;
    FOnCancel: TNotifyEvent;
    FOnOK: TAccountNotifyEvent;
    function GetPasswordPreferences: TPasswordPreferences;
    procedure SetPasswordPreferences(Preferences: TPasswordPreferences);
    procedure SetPassword(Password: string);
  public
    { Public 宣言 }
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure Reset(Account: TAccount);
    property Password: string write SetPassword;
    property PasswordPreferences: TPasswordPreferences read GetPasswordPreferences write SetPasswordPreferences;
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnOK: TAccountNotifyEvent read FOnOK write FOnOK;
  end;

implementation

{$R *.dfm}

constructor TEditAccount.Create(Owner: TComponent);
const
  INI_FILE_EXTENSION = '.ini';
var
  IniFileName: string;
begin
  inherited;

  IniFileName := ChangeFileExt(Application.ExeName, INI_FILE_EXTENSION);
  FPasswordGenerator := TPasswordGenerator.Create(IniFileName);

  FId := -1;
end;

destructor TEditAccount.Destroy;
begin
  inherited;
  FPasswordGenerator.Free;
end;

function TEditAccount.GetPasswordPreferences: TPasswordPreferences;
begin
  Result.Length := FPasswordGenerator.Length;
  Result.UseDigits := FPasswordGenerator.UseDigits;
  Result.UseLowerCase := FPasswordGenerator.UseLowerCase;
  Result.UseUpperCase := FPasswordGenerator.UseUpperCase;
end;

procedure TEditAccount.SetPassword(Password: string);
begin
  DoInputPassword.Text := Password;
end;

procedure TEditAccount.SetPasswordPreferences(Preferences: TPasswordPreferences);
begin
  FPasswordGenerator.Length := Preferences.Length;
  FPasswordGenerator.UseDigits := Preferences.UseDigits;
  FPasswordGenerator.UseLowerCase := Preferences.UseLowerCase;
  FPasswordGenerator.UseUpperCase := Preferences.UseUpperCase;

  if not FPasswordGenerator.Save then
    ShowMessage('設定ファイルを保存できませんでした。');
end;

procedure TEditAccount.Clear;
begin
  FId := -1;

  DoInputSiteName.Clear;
  DoInputUserName.Clear;
  DoInputPassword.Clear;
  DoInputAddress.Clear;
  DoInputRemarks.Clear;
end;

procedure TEditAccount.Reset(Account: TAccount);
begin
  FId := Account.Id;

  DoInputSiteName.Text := Account.SiteName;
  DoInputUserName.Text := Account.UserName;
  DoInputPassword.Text := Account.Password;
  DoInputAddress.Text := Account.Address;
  DoInputRemarks.Text := Account.Remarks;
end;

procedure TEditAccount.OnDoCancel(Sender: TObject);
begin
  Clear;
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

procedure TEditAccount.OnDoGeneratePassword(Sender: TObject);
begin
  DoInputPassword.Text := FPasswordGenerator.Generate;
end;

procedure TEditAccount.OnDoOK(Sender: TObject);
var
  SiteName, UserName, Password, Remarks, Address: string;
begin
  SiteName := DoInputSiteName.Text;
  UserName := DoInputUserName.Text;
  Password := DoInputPassword.Text;

  Address := DoInputAddress.Text;
  Remarks := DoInputRemarks.Text;

  if Assigned(FOnOk) then
    FOnOK(Self, TAccount.Create(FId, SiteName, UserName, Password, Address, Remarks));
end;

end.
