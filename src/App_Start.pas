unit App_Start;

interface

uses
  App_View_Authenticate,
  App_View_EditAccount,
  App_View_ViewAccount,

  System.Classes,
  System.SysUtils,
  System.Variants,

  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Menus,

  Winapi.Messages,
  Winapi.Windows;

type
  TStart = class(TForm)

    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    EditMenu: TMenuItem;
    HelpMenu: TMenuItem;

    DoExit: TMenuItem;
    DoShowAppVersion: TMenuItem;
    DoAppendAccount: TMenuItem;
    DoUpdateAccount: TMenuItem;
    DoRemoveAccount: TMenuItem;

    DoAuthenticate: TAuthenticate;

    procedure OnDoExit(Sender: TObject);
    procedure OnDoShowAppVersion(Sender: TObject);
    procedure OnDoAppendAccount(Sender: TObject);
  private
    { Private êÈåæ }
    FEditAccount: TEditAccount;
    FViewAccount: TViewAccount;

    procedure OnDoAuthenticate(Sender: TObject; Password: string);
    procedure OnCancelEditing(Sender: TObject);
  public
    { Public êÈåæ }
    constructor Create(Owner: TComponent); override;
  end;

var
  Start: TStart;

implementation

{$R *.dfm}

constructor TStart.Create(Owner: TComponent);
begin
  inherited;
  DoAuthenticate.OnAuthenticate := OnDoAuthenticate;

  FEditAccount := TEditAccount.Create(Self);
  FViewAccount := TViewAccount.Create(Self);

  FEditAccount.Align := alClient;
  FViewAccount.Align := alClient;

  FEditAccount.OnCancel := OnCancelEditing;
end;

procedure TStart.OnDoExit(Sender: TObject);
begin
  Close;
end;

procedure TStart.OnDoShowAppVersion(Sender: TObject);
begin
  ShowMessage('Version 0.1.0.0');
end;

procedure TStart.OnDoAppendAccount(Sender: TObject);
begin
  FEditAccount.Parent := Self;
end;

procedure TStart.OnDoAuthenticate(Sender: TObject; Password: string);
begin
  FViewAccount.Parent := Self;
  DoAppendAccount.Enabled := True;
end;

procedure TStart.OnCancelEditing(Sender: TObject);
begin
  FEditAccount.Parent := nil;
  FViewAccount.Parent := Self;
end;

end.
