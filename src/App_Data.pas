unit App_Data;

interface
uses
  App_Utilities,

  Data.DB,

  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.DatS,
  FireDAC.DApt,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Param,

  System.Classes,
  System.Generics.Collections,
  System.IOUtils,
  System.SysUtils,

  Vcl.Clipbrd,
  Vcl.Forms;

type
  TAccount = record
  private
    FId: Integer;
    FSiteName: string;
    FUserName: string;
    FPassword: string;
    FAddress: string;
    FRemarks: string;
  public
    constructor Create(Id: Integer; SiteName, UserName, Password, Address, Remarks: string);
    property Id: Integer read FId;
    property SiteName: string read FSiteName write FSiteName;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property Address: string read FAddress write FAddress;
    property Remarks: string read FRemarks write FRemarks;
  end;

  TModel = class(TObject)
  private
    FOnChange: TNotifyEvent;
    FDBConnection: TFDConnection;
    FList: TList<TAccount>;
    FDelayCall: TDelayCall;
    function GetAccount(Index: Integer): TAccount;
    function GetDBFileName: string;
    function IndexOf(Id: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function GetEnumerator: TEnumerator<TAccount>;
    function GetPassword(Id: Integer): string;
    function Open(Password: string): Boolean;
    function Append(Account: TAccount): Boolean;
    function Update(Account: TAccount): Boolean;
    function Remove(Account: TAccount): Boolean;
    procedure Close;
    procedure CopyPasswordToClipBoard(Id: Integer);
    property Account[Index: Integer]: TAccount read GetAccount;
    property DBFileName: string read GetDBFileName;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

constructor TAccount.Create(Id: Integer; SiteName, UserName, Password, Address, Remarks: string);
begin
  FId := Id;

  FSiteName := SiteName;
  FUserName := UserName;
  FPassword := Password;

  FRemarks := Remarks;
  FAddress := Address;
end;

constructor TModel.Create;
begin
  FDBConnection := TFDConnection.Create(nil);
  FList := TList<TAccount>.Create;

  FDelayCall := TDelayCall.Create(
    procedure
    begin
      Clipboard.AsText := '';
    end);
end;

destructor TModel.Destroy;
begin
  FDelayCall.Free;
  FDBConnection.Free;
  FList.Free;
end;

function TModel.GetEnumerator: TEnumerator<TAccount>;
begin
  Result := FList.GetEnumerator;
end;

function TModel.GetAccount(Index: Integer): TAccount;
begin
  Result := FList[Index];
end;

function TModel.GetDBFileName;
const
  DB_FILE_EXTENSION = '.sqlite3';
begin
  Result := ChangeFileExt(Application.ExeName, DB_FILE_EXTENSION);
end;

function TModel.GetPassword(Id: Integer): string;
const
  STATEMENT = 'SELECT Password FROM Accounts WHERE Id = :Id';
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDBConnection;
    Query.Open(STATEMENT, [Id]);

    if not Query.Eof then
      Result := Query.FieldByName('Password').AsString
    else
      Result := '';
  finally
    Query.Free;
  end;
end;

function TModel.IndexOf(Id: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to FList.Count - 1 do
    if FList[I].Id = Id then
      Result := I;
end;

function TModel.Open(Password: string): Boolean;
var
  DBType, DBName, EncryptionParamName: string;
  Query: TFDQuery;
  New: TAccount;
const
  STATEMENT = 'CREATE TABLE IF NOT EXISTS Accounts' +
              '(Id INTEGER PRIMARY KEY, SiteName TEXT, Address TEXT, UserName TEXT, Password TEXT, Remarks TEXT)';
begin
  // データベースへ接続

  DBType := 'SQLite';
  DBName := DBFileName;

  // データベースを新規作成する場合と、
  // 既存のデータベースを開く場合で暗号化パラメータの名称が異なることに注意する。

  if TFile.Exists(DBName) then
    EncryptionParamName := 'Password'
  else
    EncryptionParamName := 'NewPassword';

  FDBConnection.Params.Add('DriverID=' + DBType);
  FDBConnection.Params.Add('Database=' + DBName);
  FDBConnection.Params.Add(EncryptionParamName + '=' + Password);

  try
    FDBConnection.Open;
  except
    // パスワードの誤りによるデータベースの接続例外が一度でも起こると、
    // 以後、正しいパスワードであっても接続例外が起こる。
    // 接続例外の発生時にCloseメソッドをコールしても同じなため、
    // オブジェクトを再作成することとする。

    FDBConnection.Free;
    FDBConnection := TFDConnection.Create(nil);

    Exit(False);
  end;

  // テーブルが存在しない場合、テーブルを作成

  try
    FDBConnection.ExecSQL(STATEMENT);
  except
    Exit(False);
  end;

  // テーブルの各レコードを各アカウントオブジェクトへマッピング

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDBConnection;
    Query.SQL.Text := 'SELECT Id, SiteName, Address, UserName, Remarks FROM Accounts';
    Query.Open; // SQLを実行

    while not Query.Eof do
    begin
      New.FId := Query.FieldByName('Id').AsInteger;
      New.FSiteName := Query.FieldByName('SiteName').AsString;
      New.FUserName := Query.FieldByName('UserName').AsString;
      New.FAddress := Query.FieldByName('Address').AsString;
      New.FRemarks := Query.FieldByName('Remarks').AsString;

      FList.Add(New);

      Query.Next;
    end;
  finally
    Query.Free;
  end;

  if Assigned(FOnChange) then
    FOnChange(Self);

  Exit(True);
end;

function TModel.Append(Account: TAccount): Boolean;
const
  STATEMENT = 'INSERT INTO Accounts(SiteName, UserName, Password, Address, Remarks)' +
              'VALUES(:SiteName, :UserName, :Password, :Address, :Remarks)';
var
  Query: TFDQuery;
  NumberOfChangedRow: LongInt; // 変更されたレコード数
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDBConnection;
    Query.SQL.Text := STATEMENT;

    Query.ParamByName('SiteName').AsString := Account.SiteName;
    Query.ParamByName('UserName').AsString := Account.UserName;
    Query.ParamByName('Password').AsString := Account.Password;
    Query.ParamByName('Address').AsString := Account.Address;
    Query.ParamByName('Remarks').AsString := Account.Remarks;

    NumberOfChangedRow := Query.ExecSQL(False);
  finally
    Query.Free;
  end;

  if NumberOfChangedRow > 0 then
  begin
    Result := True;

    Account.FId := FDBConnection.GetLastAutoGenValue('');
    FList.Add(Account);

    if Assigned(FOnChange) then
      FOnChange(Self);
  end
  else
    Result := False;
end;

function TModel.Update(Account: TAccount): Boolean;
const
  STATEMENT = 'UPDATE Accounts SET SiteName = :SiteName,' +
                                 ' UserName = :UserName,' +
                                 ' Password = :Password,' +
                                 ' Address = :Address, Remarks = :Remarks WHERE Id = :Id';
var
  Index: Integer;
  Query: TFDQuery;
  NumberOfChangedRow: LongInt; // 変更されたレコード数
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDBConnection;
    Query.SQL.Text := STATEMENT;

    Query.Params.ParamByName('Id').AsInteger := Account.Id;
    Query.Params.ParamByName('SiteName').AsString := Account.SiteName;
    Query.Params.ParamByName('UserName').AsString := Account.UserName;
    Query.Params.ParamByName('Password').AsString := Account.Password;
    Query.Params.ParamByName('Address').AsString := Account.Address;
    Query.Params.ParamByName('Remarks').AsString := Account.Remarks;

    NumberOfChangedRow := Query.ExecSQL(False);
  finally
    Query.Free;
  end;

  if NumberOfChangedRow > 0 then
  begin
    Result := True;

    Index := IndexOf(Account.Id);
    FList[Index] := Account;

    if Assigned(FOnChange) then
      FOnChange(Self);
  end
  else
    Result := False;
end;

function TModel.Remove(Account: TAccount): Boolean;
const
  STATEMENT = 'DELETE FROM Accounts WHERE Id = :Id';
var
  Query: TFDQuery;
  NumberOfChangedRow: LongInt;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDBConnection;
    NumberOfChangedRow := Query.ExecSQL(STATEMENT, [Account.Id]);
  finally
    Query.Free;
  end;

  if NumberOfChangedRow > 0 then
  begin
    Result := True;
    FList.Remove(Account);

    if Assigned(FOnChange) then
      FOnChange(Self);
  end
  else
    Result := False;
end;

procedure TModel.Close;
begin
  FDBConnection.Close;
  FList.Clear;
end;

procedure TModel.CopyPasswordToClipBoard(Id: Integer);
begin
  Clipboard.AsText := GetPassword(Id);
  if Clipboard.AsText <> '' then
    FDelayCall.Schedule(6000); // ミリ秒
end;

end.
