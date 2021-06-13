unit App_View_EditAccount;

interface

uses
  App_Data,

  System.Classes,
  System.SysUtils,
  System.Variants,

  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Graphics,

  Winapi.Messages,
  Winapi.Windows, Vcl.ExtCtrls, Vcl.StdCtrls;

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

    procedure OnDoCancel(Sender: TObject);
    procedure OnDoOK(Sender: TObject);
  private
    { Private êÈåæ }
    FOnCancel: TNotifyEvent;
    FOnOK: TAccountNotifyEvent;
  public
    { Public êÈåæ }
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
    property OnOK: TAccountNotifyEvent read FOnOK write FOnOK;
  end;

implementation

{$R *.dfm}

procedure TEditAccount.OnDoCancel(Sender: TObject);
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
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
    FOnOK(Self, TAccount.Create(-1, SiteName, UserName, Password, Address, Remarks));
end;

end.
