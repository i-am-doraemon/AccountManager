object SetupPassword: TSetupPassword
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
    ExplicitWidth = 185
    ExplicitHeight = 41
    object PleaseSetupPasswordLabel: TLabel
      Left = 16
      Top = 24
      Width = 162
      Height = 13
      Caption = #21021#12417#12395#12497#12473#12527#12540#12489#12434#35373#23450#12375#12390#12367#12384#12373#12356
    end
    object PasswordLabel: TLabel
      Left = 16
      Top = 56
      Width = 47
      Height = 13
      Caption = #12497#12473#12527#12540#12489
    end
    object ConfirmationLabel: TLabel
      Left = 16
      Top = 88
      Width = 24
      Height = 13
      Caption = #30906#35469
    end
    object DoInputPassword: TEdit
      Left = 69
      Top = 53
      Width = 228
      Height = 21
      TabOrder = 0
    end
    object DoConfirmPassword: TEdit
      Left = 69
      Top = 85
      Width = 228
      Height = 21
      TabOrder = 1
    end
    object DoOK: TButton
      Left = 222
      Top = 120
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 2
      OnClick = OnDoOK
    end
  end
end
