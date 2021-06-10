unit App_View_EditAccount;

interface

uses
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
  TEditAccount = class(TFrame)
    Container: TPanel;
    NameLabel: TLabel;
    AddressLabel: TLabel;
    UserNameLabel: TLabel;
    PasswordLabel: TLabel;

    DoInputName: TEdit;
    DoInputAddress: TEdit;
    DoInputUserName: TEdit;
    DoInputPassword: TEdit;
    DoInputRemarks: TMemo;
    RemarksLabel: TLabel;

    DoOK: TButton;
    DoCancel: TButton;
    procedure OnDoCancel(Sender: TObject);
  private
    { Private êÈåæ }
    FOnCancel: TNotifyEvent;
  public
    { Public êÈåæ }
    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
  end;

implementation

{$R *.dfm}

procedure TEditAccount.OnDoCancel(Sender: TObject);
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

end.
