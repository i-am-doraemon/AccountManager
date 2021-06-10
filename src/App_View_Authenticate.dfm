object Authenticate: TAuthenticate
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object Container: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    TabOrder = 0
    object DoInputPassword: TEdit
      Left = 16
      Top = 38
      Width = 290
      Height = 21
      PasswordChar = '*'
      TabOrder = 0
    end
    object DoAuthenticate: TButton
      Left = 231
      Top = 68
      Width = 75
      Height = 25
      Caption = #35469#35388
      TabOrder = 1
      OnClick = OnDoAuthenticate
    end
  end
end
