unit App_Start;

interface

uses
  App_Data,
  App_Utilities,
  App_View_Authenticate,
  App_View_EditAccount,
  App_View_SetupPassword,
  App_View_ViewAccount,

  System.Classes,
  System.Generics.Collections,
  System.IOUtils,
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
    DoSetupPassword: TSetupPassword;
    DoAppendAccount: TMenuItem;
    DoUpdateAccount: TMenuItem;
    DoRemoveAccount: TMenuItem;

    procedure OnDoExitApp(Sender: TObject);
    procedure OnDoShowAppVersion(Sender: TObject);
    procedure OnDoAppendAccount(Sender: TObject);
    procedure OnDoUpdateAccount(Sender: TObject);
    procedure OnDoRemoveAccount(Sender: TObject);
    procedure OnCloseApp(Sender: TObject; var Action: TCloseAction);
  private
    { Private 宣言 }
    FModel: TModel;
    FDoAuthenticate: TAuthenticate;
    FEditAccount: TEditAccount; // アカウントの編集ビュー
    FViewAccount: TViewAccount; // アカウントの閲覧ビュー

    procedure OnChangeModel(Sender: TObject);
    procedure OnDoSetupPassword(Sender: TObject; Password: string);
    procedure OnDoAuthenticate(Sender: TObject; Password: string);
    procedure OnCancelEditing(Sender: TObject);
    procedure OnDidEdit(Sender: TObject; Account: TAccount);
    procedure OnSelectAccount(Sender: TObject; Index: Integer);
    procedure OnCopyPasswordToClipBoard(Sender: TObject; Id: Integer);
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

  DoSetupPassword.OnSetupPassword := OnDoSetupPassword;

  FDoAuthenticate := TAuthenticate.Create(Self);
  FDoAuthenticate.OnAuthenticate := OnDoAuthenticate;

  FEditAccount := TEditAccount.Create(Self);
  FViewAccount := TViewAccount.Create(Self);

  FEditAccount.Align := alClient;
  FViewAccount.Align := alClient;

  FEditAccount.OnCancel := OnCancelEditing;
  FEditAccount.OnOK := OnDidEdit;

  FViewAccount.OnSelect := OnSelectAccount;
  FViewAccount.OnCopyToClipBoard := OnCopyPasswordToClipBoard;

  if TFile.Exists(FModel.DBFileName) then
    FDoAuthenticate.Parent := Self;
end;

procedure TStart.OnDoExitApp(Sender: TObject);
begin
  Close;
end;

procedure TStart.OnDoSetupPassword(Sender: TObject; Password: string);
begin
  FModel.Open(Password);
  FModel.Close;

  FDoAuthenticate.Parent := Self;
end;

procedure TStart.OnDoAuthenticate(Sender: TObject; Password: string);
begin
  if FModel.Open(Password) then
  begin
    FViewAccount.Parent := Self;
    DoAppendAccount.Enabled := True;
    DoUpdateAccount.Enabled := True;
    DoRemoveAccount.Enabled := True;
  end
  else
    ShowMessage('パスワードが違います。');
end;

procedure TStart.OnDoAppendAccount(Sender: TObject);
begin
  FEditAccount.Parent := Self;
end;

procedure TStart.OnDoUpdateAccount(Sender: TObject);
var
  Index: Integer;
  Account: TAccount;
begin
  Index := FViewAccount.ItemIndex;

  if Index < 0 then
    ShowMessage('アカウントが選択されていません。')
  else
  begin
    Account := FModel.Account[Index];

    FViewAccount.Parent := nil;
    FEditAccount.Parent := Self;

    FEditAccount.Reset(Account);
    FEditAccount.Password := FModel.GetPassword(Account.Id);
  end;
end;

procedure TStart.OnDoRemoveAccount(Sender: TObject);
var
  Index: Integer;
begin
  Index := FViewAccount.ItemIndex;

  if Index < 0 then
    ShowMessage('アカウントが選択されていません。')
  else
  begin
    if MessageDlg('選択されているアカウントを本当に削除しますか？',
          mtConfirmation, mbOKCancel, 0, mbCancel) = mrYes then
      FModel.Remove(FModel.Account[Index]);
  end;
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

procedure TStart.OnCancelEditing(Sender: TObject);
begin
  FEditAccount.Parent := nil;
  FViewAccount.Parent := Self;
end;

procedure TStart.OnDidEdit(Sender: TObject; Account: TAccount);
begin
  FEditAccount.Clear;

  if Account.Id < 0 then
    FModel.Append(Account)
  else
    FModel.Update(Account);

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

procedure TStart.OnCopyPasswordToClipBoard(Sender: TObject; Id: Integer);
begin
  FModel.CopyPasswordToClipBoard(Id);
end;

procedure TStart.OnCloseApp(Sender: TObject; var Action: TCloseAction);
begin
  FModel.Free;
end;

end.
