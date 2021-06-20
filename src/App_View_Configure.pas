unit App_View_Configure;

interface

uses
  App_Utilities,

  System.Classes,
  System.Math,
  System.SysUtils,
  System.Variants,

  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Graphics,

  Winapi.Messages,
  Winapi.Windows, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TConfigure = class(TForm)
    PasswordGenerationBox: TGroupBox;

    Length: TLabel;
    DoSetLength: TEdit;
    DoChangeLengthByStep: TUpDown;
    DoUseDigits: TCheckBox;
    DoUseLowerCase: TCheckBox;
    DoUseUpperCase: TCheckBox;

    DoOK: TButton;
    DoCancel: TButton;
  private
    { Private êÈåæ }
    function GetPasswordPreferences: TPasswordPreferences;
    procedure SetPasswordPreferences(Preferences: TPasswordPreferences);
  public
    { Public êÈåæ }
    property PasswordPreferences: TPasswordPreferences read GetPasswordPreferences write SetPasswordPreferences;
  end;

implementation

{$R *.dfm}

function TConfigure.GetPasswordPreferences: TPasswordPreferences;
begin
  Result.Length := DoChangeLengthByStep.Position;
  Result.UseDigits := DoUseDigits.Checked;
  Result.UseLowerCase := DoUseLowerCase.Checked;
  Result.UseUpperCase := DoUseUpperCase.Checked;
end;

procedure TConfigure.SetPasswordPreferences(Preferences: TPasswordPreferences);
begin
  DoChangeLengthByStep.Position := Preferences.Length;
  DoUseDigits.Checked := Preferences.UseDigits;
  DoUseLowerCase.Checked := Preferences.UseLowerCase;
  DoUseUpperCase.Checked := Preferences.UseUpperCase;
end;

end.
