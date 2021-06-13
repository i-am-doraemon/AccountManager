unit App_View_ViewAccount;

interface

uses
  App_Data,

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
  TIndexNotifyEvent = procedure(Sender: TObject; Index: Integer) of object;

  TViewAccount = class(TFrame)
    Container: TPanel;

    SiteNameLabel: TLabel;
    DoChooseSite: TComboBox;

    AddressLabel: TLabel;
    DoShowAddress: TEdit;

    UserNameLabel: TLabel;
    DoShowUserName: TEdit;

    PasswordLabel: TLabel;
    DoCopyToClipBoard: TButton;

    RemarksLabel: TLabel;
    DoShowRemarks: TMemo;

    procedure OnDoChoose(Sender: TObject);
    procedure OnDoCopyToClipBoard(Sender: TObject);
  private
    { Private êÈåæ }
    FId: Integer;
    FOnSelect: TIndexNotifyEvent;
    FOnCopyToClipBoard: TIndexNotifyEvent;
    function GetItemIndex: Integer;
  public
    { Public êÈåæ }
    procedure Clear;
    procedure Reset(Items: TStrings);
    procedure SetContents(Id: Integer; UserName, Address, Remarks: string);
    property ItemIndex: Integer read GetItemIndex;
    property OnSelect: TIndexNotifyEvent read FOnSelect write FOnSelect;
    property OnCopyToClipBoard: TIndexNotifyEvent read FOnCopyToClipBoard write FOnCopyToClipBoard;
  end;

implementation

{$R *.dfm}

function TViewAccount.GetItemIndex;
begin
  Result := DoChooseSite.ItemIndex;
end;

procedure TViewAccount.OnDoChoose(Sender: TObject);
begin
  if Assigned(FOnSelect) then
    FOnSelect(Self, DoChooseSite.ItemIndex);
end;

procedure TViewAccount.OnDoCopyToClipBoard(Sender: TObject);
begin
  if Assigned(FOnCopyToClipBoard) then
    FOnCopyToClipBoard(Self, FId);
end;

procedure TViewAccount.Clear;
begin
  DoChooseSite.Clear;
  DoShowAddress.Clear;
  DoShowRemarks.Clear;
  DoShowUserName.Clear;
end;

procedure TViewAccount.Reset(Items: TStrings);
begin
  Clear;
  DoChooseSite.Items.AddStrings(Items);
end;

procedure TViewAccount.SetContents(Id: Integer; UserName: string; Address: string; Remarks: string);
begin
  FId := Id;

  DoShowUserName.Text := UserName;
  DoShowAddress.Text := Address;
  DoShowRemarks.Text := Remarks;
end;

end.
