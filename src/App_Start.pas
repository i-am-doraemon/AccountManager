unit App_Start;

interface

uses
  App_Data,
  App_View_Authenticate,
  App_View_EditAccount,
  App_Utilities,
  App_View_ViewAccount,

  System.Classes,
  System.Generics.Collections,
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
    DoExitApp: TMenuItem;
    DoShowAppVersion: TMenuItem;
    DoAppendAccount: TMenuItem;
    DoUpdateAccount: TMenuItem;
    DoRemoveAccount: TMenuItem;

    DoAuthenticate: TAuthenticate;

    procedure OnDoExitApp(Sender: TObject);
    procedure OnDoShowAppVersion(Sender: TObject);
    procedure OnDoAppendAccount(Sender: TObject);
    procedure OnCloseApp(Sender: TObject; var Action: TCloseAction);
    procedure OnDoRemoveAccount(Sender: TObject);
  private
    { Private 宣言 }
    FModel: TModel;
    FEditAccount: TEditAccount; // アカウントの編集ビュー
    FViewAccount: TViewAccount; // アカウントの閲覧ビュー

    procedure OnChangeModel(Sender: TObject);
    procedure OnDoAuthenticate(Sender: TObject; Password: string);
    procedure OnCancelEditing(Sender: TObject);
    procedure OnDidEdit(Sender: TObject; Account: TAccount);
    procedure OnSelectAccount(Sender: TObject; Index: Integer);
    procedure OnCopyPasswordToClipBoard(Sender: TObject; Index: Integer);
  public
    { Public 宣言 }
    constructor Create(Owner: TComponent); override;
  end;

var
  Start: TStart;

implementation

{$R *.dfm}

constructor TStart.Create(Owner: TComponent);
begin
  inherited;

  FModel := TModel.Create;
  FModel.OnChange := OnChangeModel;

  DoAuthenticate.OnAuthenticate := OnDoAuthenticate;

  FEditAccount := TEditAccount.Create(Self);
  FViewAccount := TViewAccount.Create(Self);

  FEditAccount.Align := alClient;
  FViewAccount.Align := alClient;

  FEditAccount.OnCancel := OnCancelEditing;
  FEditAccount.OnOK := OnDidEdit;

  FViewAccount.OnSelect := OnSelectAccount;
  FViewAccount.OnCopyToClipBoard := OnCopyPasswordToClipBoard;
end;

procedure TStart.OnDoExitApp(Sender: TObject);
begin
  Close;
end;

procedure TStart.OnDoRemoveAccount(Sender: TObject);
var
  Index: Integer;
begin
  Index := FViewAccount.ItemIndex;
  ShowMessage(Format('Index = %d', [Index]));

  if Index < 0 then
    ShowMessage('アカウントが選択されていません。')
  else
    FModel.Remove(FModel.Account[Index]);
end;

procedure TStart.OnDoShowAppVersion(Sender: TObject);
var
  FileProperties: TFileProperties;
begin
  FileProperties := TFileProperties.Create(Application.ExeName);

  ShowMessage(Format('%s バージョン %d.%d.%d.%d',
    [FileProperties.FileName,
     FileProperties.Major,
     FileProperties.Minor,
     FileProperties.Build,
     FileProperties.Revision]));
end;

procedure TStart.OnChangeModel(Sender: TObject);
var
  Items: TStrings;
  Enumerator: TEnumerator<TAccount>;
begin
  Items := TStringList.Create;
  try
    Enumerator := FModel.GetEnumerator;

    while Enumerator.MoveNext do
      Items.Add(Enumerator.Current.SiteName);

    FViewAccount.Reset(Items);
  finally
    Items.Free;
  end;
end;

procedure TStart.OnDoAppendAccount(Sender: TObject);
begin
  FEditAccount.Parent := Self;
end;

procedure TStart.OnDoAuthenticate(Sender: TObject; Password: string);
begin
  FModel.Open(Password);

  FViewAccount.Parent := Self;
  DoAppendAccount.Enabled := True;
  DoRemoveAccount.Enabled := True;
end;

procedure TStart.OnCancelEditing(Sender: TObject);
begin
  FEditAccount.Parent := nil;
  FViewAccount.Parent := Self;
end;

procedure TStart.OnDidEdit(Sender: TObject; Account: TAccount);
begin
  FModel.Append(Account);
  FEditAccount.Parent := nil;
  FViewAccount.Parent := Self;
end;

procedure TStart.OnSelectAccount(Sender: TObject; Index: Integer);
var
  Account: TAccount;
begin
  Account := FModel.Account[Index];

  FViewAccount.SetContents(Account.Id,
                           Account.UserName,
                           Account.Address,
                           Account.Remarks);
end;

procedure TStart.OnCopyPasswordToClipBoard(Sender: TObject; Index: Integer);
begin
  FModel.CopyPasswordToClipBoard(Index);
end;

procedure TStart.OnCloseApp(Sender: TObject; var Action: TCloseAction);
begin
  FModel.Free;
end;

end.
