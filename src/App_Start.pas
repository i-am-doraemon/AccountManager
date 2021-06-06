unit App_Start;

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
  Vcl.Menus,

  Winapi.Messages,
  Winapi.Windows;

type
  TStart = class(TForm)
    Container: TPanel;

    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    HelpMenu: TMenuItem;

    DoExit: TMenuItem;
    DoShowAppVersion: TMenuItem;

    procedure OnDoExit(Sender: TObject);
    procedure OnDoShowAppVersion(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Start: TStart;

implementation

{$R *.dfm}

procedure TStart.OnDoExit(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TStart.OnDoShowAppVersion(Sender: TObject);
begin
  ShowMessage('Version 0.1.0.0');
end;

end.
