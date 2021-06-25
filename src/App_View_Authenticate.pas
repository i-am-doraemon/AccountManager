unit App_View_Authenticate;

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

  TAuthenticate = class(TFrame)
    Container: TPanel;

    DoInputPassword: TEdit;
    DoAuthenticate: TButton;

    procedure OnDoAuthenticate(Sender: TObject);
  private
    { Private êÈåæ }
    FOnAuthenticate: TPasswordNotifyEvent;
  public
    { Public êÈåæ }
    property OnAuthenticate: TPasswordNotifyEvent read FOnAuthenticate write FOnAuthenticate;
  end;

implementation

{$R *.dfm}

procedure TAuthenticate.OnDoAuthenticate(Sender: TObject);
begin
  if Assigned(FOnAuthenticate) then
    FOnAuthenticate(Self, DoInputPassword.Text);

  DoInputPassword.Clear;
end;

end.
