object Start: TStart
  Left = 0
  Top = 0
  Caption = 'Account Manager'
  ClientHeight = 201
  ClientWidth = 447
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
  object Container: TPanel
    Left = 0
    Top = 0
    Width = 447
    Height = 201
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
  object MainMenu: TMainMenu
    Left = 16
    Top = 16
    object FileMenu: TMenuItem
      Caption = #12501#12449#12452#12523'(&F)'
      object DoExit: TMenuItem
        Caption = #32066#20102'(&X)'
        OnClick = OnDoExit
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
