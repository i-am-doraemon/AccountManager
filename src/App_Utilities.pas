unit App_Utilities;

interface

uses
  System.IniFiles,
  System.SysUtils,

  Vcl.ExtCtrls,

  Winapi.Windows;

type
  TFileProperties = record
  private
    FFileName: string;
    FMajor: Cardinal;
    FMinor: Cardinal;
    FBuild: Cardinal;
    FRevision: Cardinal;
    procedure GetFileVersion(FileName: string);
  public
    constructor Create(FileName: string);
    property FileName: string read FFileName;
    property Major: Cardinal read FMajor;
    property Minor: Cardinal read FMinor;
    property Build: Cardinal read FBuild;
    property Revision: Cardinal read FRevision;
  end;

  TDelayTask = reference to procedure;

  TDelayCall = class(TObject)
  private
    FDelayTask: TDelayTask;
    FTimer: TTimer;
    procedure OnExpired(Sender: TObject);
  public
    constructor Create(DelayTask: TDelayTask);
    destructor Destroy; override;
    procedure Schedule(MilliSecond: Cardinal);
  end;

  TAvailableCharacterType = (acLowerCase, acUpperCase, acDigits);
  TCharSet = set of TAvailableCharacterType;
  EInvalidCharSetException = class(Exception);

  TPasswordGenerator = class(TObject)
  private
    FIniFileName: string;
    FLength: Integer;
    FCharSet: TCharSet;
    function GetRandomizedCharacter(CharSet: TCharSet): Char;
    function IsUseLowerCase: Boolean;
    function IsUseUpperCase: Boolean;
    function IsUseDigits: Boolean;
    procedure EnableUseDigits(Enable: Boolean);
    procedure EnableUseLowerCase(Enable: Boolean);
    procedure EnableUseUpperCase(Enable: Boolean);
  public
    constructor Create(IniFileName: string);
    function Generate: string;
    function Save: Boolean;
    property Length: Integer read FLength write FLength;
    property UseLowerCase: Boolean read IsUseLowerCase write EnableUseLowerCase;
    property UseUpperCase: Boolean read IsUseUpperCase write EnableUseUpperCase;
    property UseDigits: Boolean read IsUseDigits write EnableUseDigits;
  end;

  TPasswordPreferences = record
  private
    FLength: Integer;
    FUseDigits: Boolean;
    FUseLowerCase: Boolean;
    FUseUpperCase: Boolean;
  public
    constructor Create(Length: Integer; UseDigits, UseLowerCase, UseUpperCase: Boolean);
    property Length: Integer read FLength write FLength;
    property UseDigits: Boolean read FUseDigits write FUseDigits;
    property UseLowerCase: Boolean read FUseLowerCase write FUseLowerCase;
    property UseUpperCase: Boolean read FUseUpperCase write FUseUpperCase;
  end;

  TStringUtils = record
  public
    class function RemoveNewLineCode(Paragraph: string): string; static;
  end;

implementation

constructor TFileProperties.Create(FileName: string);
begin
  FFileName := ExtractFileName(FileName);
  GetFileVersion(FileName);
end;

procedure TFileProperties.GetFileVersion(FileName: string);
var
  ToSetToZero, VersionInfoSize: DWORD;
  PBuffer: Pointer;
  PFileInfo: PVSFixedFileInfo;
begin
  VersionInfoSize := GetFileVersionInfoSize(PChar(FileName), ToSetToZero);
  if VersionInfoSize > 0 then
  begin
    // 結果を受け取るためのバッファを確保
    GetMem(PBuffer, VersionInfoSize);
    try
      // ファイルのバージョン情報のリソースを取得
      GetFileVersionInfo(PChar(FileName), 0, VersionInfoSize, PBuffer);
      // ファイルのバージョン情報を取得
      VerQueryValue(PBuffer, PathDelim, Pointer(PFileInfo), VersionInfoSize);

      FMajor := PFileInfo.dwFileVersionMS shr $0010;
      FMinor := PFileInfo.dwFileVersionMS and $FFFF;
      FBuild := PFileInfo.dwFileVersionLS shr $0010;
      FRevision := PFileInfo.dwFileVersionLS and $FFFF;
    finally
      FreeMem(PBuffer);
    end;
  end;
end;

constructor TDelayCall.Create(DelayTask: TDelayTask);
begin
  FDelayTask := DelayTask;

  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.OnTimer := OnExpired;
end;

destructor TDelayCall.Destroy;
begin
  FTimer.Free;
end;

procedure TDelayCall.OnExpired(Sender: TObject);
begin
  FTimer.Enabled := False;

  if Assigned(FDelayTask) then
    FDelayTask;
end;

procedure TDelayCall.Schedule(MilliSecond: Cardinal);
begin
  FTimer.Enabled := False;
  FTimer.Interval := MilliSecond;
  FTimer.Enabled := True;
end;

constructor TPasswordGenerator.Create(IniFileName: string);
const
  SECTION_NAME = 'PASSWORD';
var
  IniFile: TIniFile;
  Value: Integer;
begin
  inherited Create;

  FIniFileName := IniFileName;
  IniFile := TIniFile.Create(FIniFileName);
  try
    FLength := IniFile.ReadInteger(SECTION_NAME, 'LENGTH', 12);

    Value := IniFile.ReadInteger(SECTION_NAME, 'USE_LOWER_CASE', 1);
    if Value <> 0 then
      Include(FCharSet, acLowerCase);

    Value := IniFile.ReadInteger(SECTION_NAME, 'USE_UPPER_CASE', 1);
    if Value <> 0 then
      Include(FCharSet, acUpperCase);

    Value := IniFile.ReadInteger(SECTION_NAME, 'USE_DIGITS', 1);
    if Value <> 0 then
      Include(FCharSet, acDigits);
  finally
    IniFile.Free;
  end;
end;

function TPasswordGenerator.IsUseLowerCase: Boolean;
begin
  Result := acLowerCase in FCharSet;
end;

function TPasswordGenerator.IsUseUpperCase: Boolean;
begin
  Result := acUpperCase in FCharSet;
end;

function TPasswordGenerator.IsUseDigits: Boolean;
begin
  Result := acDigits in FCharSet;
end;

function TPasswordGenerator.GetRandomizedCharacter(CharSet: TCharSet): Char;
const
  ZERO = $30;
  LOWER_A = $61;
  UPPER_A = $41;
var
  Value: Integer;
begin
  if CharSet = [] then
    raise EInvalidCharSetException.Create('Neither character type is specified.')
  else if CharSet = [acDigits] then
  begin
    Value := Random(10);
    Result := Chr(ZERO + Value);
  end
  else if CharSet = [acLowerCase] then
  begin
    Value := Random(26);
    Result := Chr(LOWER_A + Value);
  end
  else if CharSet = [acUpperCase] then
  begin
    Value := Random(26);
    Result := Chr(UPPER_A + Value);
  end
  else if CharSet = [acLowerCase, acDigits] then
  begin
    Value := Random(36);
    if Value < 10 then
      Result := Chr(ZERO + Value)
    else
      Result := Chr(LOWER_A + Value - 10);
  end
  else if CharSet = [acUpperCase, acDigits] then
  begin
    Value := Random(36);
    if Value < 10 then
      Result := Chr(ZERO + Value)
    else
      Result := Chr(UPPER_A + Value - 10);
  end
  else if CharSet = [acLowerCase, acUpperCase] then
  begin
    Value := Random(52);
    if Value < 26 then
      Result := Chr(LOWER_A + Value)
    else
      Result := Chr(UPPER_A + Value - 26);
  end
  else
  begin
    Value := Random(62);
    if Value < 10 then
      Result := Chr(ZERO + Value)
    else if Value < 36 then
      Result := Chr(LOWER_A + Value - 10)
    else
      Result := Chr(UPPER_A + Value - 36);
  end;
end;

function TPasswordGenerator.Generate: string;
var
  I: Integer;
  Apendable: TStringBuilder;
begin
  if FCharSet = [] then
    raise EInvalidCharSetException.Create('Neither character type is specified.');

  Apendable := TStringBuilder.Create;
  try
    for I := 0 to FLength - 1 do
      Apendable.Append(GetRandomizedCharacter(FCharSet));

    Result := Apendable.ToString;
  finally
    Apendable.Free;
  end;
end;

function TPassWordGenerator.Save: Boolean;
const
  SECTION_NAME = 'PASSWORD';
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(FIniFileName);
  try
    IniFile.WriteInteger(SECTION_NAME, 'LENGTH', FLength);

    IniFile.WriteBool(SECTION_NAME, 'USE_DIGITS', IsUseDigits);
    IniFile.WriteBool(SECTION_NAME, 'USE_LOWER_CASE', IsUseLowerCase);
    IniFile.WriteBool(SECTION_NAME, 'USE_UPPER_CASE', IsUseUpperCase);
  except
    on E: Exception do
      Exit(False);
  end;
  IniFile.Free;

  Exit(True);
end;

procedure TPasswordGenerator.EnableUseDigits(Enable: Boolean);
begin
  if Enable then
    Include(FCharSet, acDigits)
  else
    Exclude(FCharSet, acDigits);
end;

procedure TPasswordGenerator.EnableUseLowerCase(Enable: Boolean);
begin
  if Enable then
    Include(FCharSet, acLowerCase)
  else
    Exclude(FCharSet, acLowerCase);
end;

procedure TPasswordGenerator.EnableUseUpperCase(Enable: Boolean);
begin
  if Enable then
    Include(FCharSet, acUpperCase)
  else
    Exclude(FCharSet, acUpperCase);
end;

constructor TPasswordPreferences.Create(Length: Integer; UseDigits: Boolean; UseLowerCase: Boolean; UseUpperCase: Boolean);
begin
  FLength := Length;
  FUseDigits := UseDigits;
  FUseLowerCase := UseLowerCase;
  FUseUpperCase := UseUpperCase;
end;

class function TStringUtils.RemoveNewLineCode(Paragraph: string): string;
const
  LF = #$0A; // \n
  CR = #$0D; // \r
var
  Modifiable: TStringBuilder;
  Value: Char;
begin
  Modifiable := TStringBuilder.Create;
  try
    for Value in Paragraph do
      if (Value <> LF) and
         (Value <> CR) then
        Modifiable.Append(Value);

    Result := Modifiable.ToString;
  finally
    Modifiable.Free;
  end;
end;

initialization
  Randomize;

end.
