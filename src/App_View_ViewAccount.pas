unit App_View_ViewAccount;

interface

uses
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
  TViewAccount = class(TFrame)
    Container: TPanel;
    NameLabel: TLabel;
    AddressLabel: TLabel;
    UserNameLabel: TLabel;
    PasswordLabel: TLabel;
    DoInputAddress: TEdit;
    DoInputUserName: TEdit;
    DoInputRemarks: TMemo;
    RemarksLabel: TLabel;
    DoCopyToClipBoard: TButton;
    DoChoose: TComboBox;
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

implementation

{$R *.dfm}

end.
