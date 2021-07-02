unit App_Start;

interface

uses
  App_Data,
  App_Utilities,
  App_View_Authenticate,
  App_View_Configure,
  App_View_Edit,
  App_View_ReSetup,
  App_View_Setup,
  App_View_View,

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
    DoConfigure: TMenuItem;
    DoChangeMasterPassword: TMenuItem;
    DoExportAsCsv: TMenuItem;

    SaveDialog: TSaveDialog;

    procedure OnDoExitApp(Sender: TObject);
    procedure OnDoShowAppVersion(Sender: TObject);
    procedure OnDoChangeMasterPassword(Sender: TObject);
    procedure OnDoAppendAccount(Sender: TObject);
    procedure OnDoUpdateAccount(Sender: TObject);
    procedure OnDoRemoveAccount(Sender: TObject);
    procedure OnCloseApp(Sender: TObject; var Action: TCloseAction);
    procedure OnDoConfigure(Sender: TObject);
    procedure OnDoExportAsCsv(Sender: TObject);
  private
    { Private 宣言 }
    FModel: TModel;
    FDoReSetup: TReSetupPassword;
    FDoAuthenticate: TAuthenticate;
    FEditAccount: TEditAccount; // アカウントの編集ビュー
    FViewAccount: TViewAccount; // アカウントの閲覧ビュー

    procedure ToForefront(Frame: TFrame);
    procedure OnChangeModel(Sender: TObject);
    procedure OnDoSetupPassword(Sender: TObject; Password: string);
    procedure OnDoReSetupPassword(Sender: TObject; Password, NewPassword: string);
    procedure OnDoAuthenticate(Sender: TObject; Password: string);
    procedure OnCancelEditing(Sender: TObject);
    procedure OnCancelReSettingUp(Sender: TObject);
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

  FDoReSetup := TReSetupPassword.Create(Self);
  FDoReSetup.OnOK := OnDoReSetupPassword;
  FDoReSetup.OnCancel := OnCancelReSettingUp;

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

  SaveDialog.InitialDir := ExtractFileDir(Application.ExeName);

  if TFile.Exists(FModel.DBFileName) then
    ToForefront(FDoAuthenticate);
end;

procedure TStart.ToForefront(Frame: TFrame);
var
  I: Integer;
begin
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TFrame then
      Controls[I].Parent := nil;

  Frame.Parent := Self;

  if Frame = FViewAccount then
  begin
    DoAppendAccount.Enabled := True;
    DoUpdateAccount.Enabled := True;
    DoRemoveAccount.Enabled := True;
    DoChangeMasterPassword.Enabled := True;
    DoExportAsCsv.Enabled := True;
  end
  else
  begin
    DoAppendAccount.Enabled := False;
    DoUpdateAccount.Enabled := False;
    DoRemoveAccount.Enabled := False;
    DoChangeMasterPassword.Enabled := False;
    DoExportAsCsv.Enabled := False;
  end;
end;

procedure TStart.OnDoExitApp(Sender: TObject);
begin
  Close;
end;

procedure TStart.OnDoExportAsCsv(Sender: TObject);
var
  IsExport: Boolean;
begin
  if SaveDialog.Execute then
    if TFile.Exists(SaveDialog.FileName) then
      // 同じ名前のファイルが存在する場合
      if MessageDlg('ファイルを上書きしますか？',
            mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes then
        // ファイルを上書きする場合
        IsExport := True
      else
        // ファイルを上書きしない場合
        IsExport := False
    else
      // 同じ名前のファイルが存在しない場合
      IsExport := True
  else
    // 保存をキャンセルした場合
    IsExport := False;

  if IsExport then
    try
      FModel.ExportAsCsv(SaveDialog.FileName);
    except
      on E: Exception do
        ShowMessage('ファイルを出力できません。');
    end;
end;

procedure TStart.OnDoSetupPassword(Sender: TObject; Password: string);
begin
  FModel.Open(TDBSecurityParam.GetCreateParam(Password));
  FModel.Close;

  ToForefront(FDoAuthenticate);
end;

procedure TStart.OnDoReSetupPassword(Sender: TObject; Password: string; NewPassword: string);
begin
  if FModel.Open(TDBSecurityParam.GetChangeParam(Password, NewPassword)) then
  begin
    ShowMessage('マスタパスワードの変更に成功しました。');
    FModel.Close;
    ToForefront(FDoAuthenticate);
  end
  else
    ShowMessage('マスタパスワードの変更に失敗しました。');
end;

procedure TStart.OnDoAuthenticate(Sender: TObject; Password: string);
begin
  if FModel.Open(TDBSecurityParam.GetOpenParam(Password)) then
  begin
    ToForefront(FViewAccount);
  end
  else
    ShowMessage('パスワードが違います。');
end;

procedure TStart.OnDoChangeMasterPassword(Sender: TObject);
begin
  ToForefront(FDoReSetup);
end;

procedure TStart.OnDoConfigure(Sender: TObject);
var
  Preferences: TConfigure;
begin
  Preferences := TConfigure.Create(Self);
  try
    Preferences.PasswordPreferences := FEditAccount.PasswordPreferences;
    if Preferences.ShowModal = mrOk then
      FEditAccount.PasswordPreferences := Preferences.PasswordPreferences;
  finally
    Preferences.Release;
  end;
end;

procedure TStart.OnDoAppendAccount(Sender: TObject);
begin
  ToForefront(FEditAccount);
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

    FEditAccount.Reset(Account);
    FEditAccount.Password := FModel.GetPassword(Account.Id);

    ToForefront(FEditAccount);
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
          mtConfirmation, mbOKCancel, 0, mbCancel) = mrOk then
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
  ToForefront(FViewAccount);
end;

procedure TStart.OnCancelReSettingUp(Sender: TObject);
begin
  ToForefront(FViewAccount);
end;

procedure TStart.OnDidEdit(Sender: TObject; Account: TAccount);
begin
  FEditAccount.Clear;

  if Account.Id < 0 then
    FModel.Append(Account)
  else
    FModel.Update(Account);

  ToForefront(FViewAccount);
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
