unit App_Utilities;

interface

uses
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

end.
