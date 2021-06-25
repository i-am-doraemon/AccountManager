object ReSetupPassword: TReSetupPassword
  Left = 0
  Top = 0
  Width = 451
  Height = 305
  Align = alClient
  TabOrder = 0
  object Container: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 305
    Align = alClient
    TabOrder = 0
    object PleaseSetupPasswordLabel: TLabel
      Left = 16
      Top = 24
      Width = 162
      Height = 13
      Caption = #26032#12375#12356#12497#12473#12527#12540#12489#12434#35373#23450#12375#12390#12367#12384#12373#12356
    end
    object CurrentPasswordLabel: TLabel
      Left = 16
      Top = 56
      Width = 81
      Height = 13
      Caption = #29694#22312#12398#12497#12473#12527#12540#12489
    end
    object NewPasswordLabel: TLabel
      Left = 16
      Top = 88
      Width = 78
      Height = 13
      Caption = #26032#12375#12356#12497#12473#12527#12540#12489
    end
    object ConfirmationLabel: TLabel
      Left = 16
      Top = 120
      Width = 24
      Height = 13
      Caption = #30906#35469
    end
    object DoInputCurrentPassword: TEdit
      Left = 103
      Top = 53
      Width = 194
      Height = 21
      PasswordChar = '*'
      TabOrder = 0
    end
    object DoInputNewPassword: TEdit
      Left = 103
      Top = 85
      Width = 194
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object DoOK: TButton
      Left = 222
      Top = 152
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 3
      OnClick = OnDoOK
    end
    object DoConfirmPassword: TEdit
      Left = 103
      Top = 117
      Width = 194
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
    object DoCancel: TButton
      Left = 136
      Top = 152
      Width = 75
      Height = 25
      Caption = #12461#12515#12531#12475#12523
      TabOrder = 4
      OnClick = OnDoCancel
    end
  end
end
