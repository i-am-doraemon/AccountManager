object Start: TStart
  Left = 0
  Top = 0
  Caption = 'Account Manager'
  ClientHeight = 281
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline DoAuthenticate: TAuthenticate
    Left = 0
    Top = 0
    Width = 324
    Height = 281
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 324
    ExplicitHeight = 281
    inherited Container: TPanel
      Width = 324
      Height = 281
      ExplicitWidth = 324
      ExplicitHeight = 281
    end
  end
  object MainMenu: TMainMenu
    Left = 264
    Top = 224
    object FileMenu: TMenuItem
      Caption = #12501#12449#12452#12523'(&F)'
      object DoExit: TMenuItem
        Caption = #32066#20102'(&X)'
        OnClick = OnDoExit
      end
    end
    object EditMenu: TMenuItem
      Caption = #32232#38598'(&E)'
      object DoAppendAccount: TMenuItem
        Caption = #12450#12459#12454#12531#12488#12434#36861#21152'(&A)'
        Enabled = False
        OnClick = OnDoAppendAccount
      end
      object DoUpdateAccount: TMenuItem
        Caption = #12450#12459#12454#12531#12488#12434#32232#38598'(&E)'
        Enabled = False
      end
      object DoRemoveAccount: TMenuItem
        Caption = #12450#12459#12454#12531#12488#12434#21066#38500'(&R)'
        Enabled = False
      end
    end
    object HelpMenu: TMenuItem
      Caption = #12504#12523#12503'(&H)'
      object DoShowAppVersion: TMenuItem
        Caption = #12496#12540#12472#12519#12531#24773#22577'(&A)'
        OnClick = OnDoShowAppVersion
      end
    end
  end
end
