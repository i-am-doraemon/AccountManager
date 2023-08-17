object EditAccount: TEditAccount
  Left = 0
  Top = 0
  Width = 320
  Height = 280
  TabOrder = 0
  object Container: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 280
    Align = alClient
    TabOrder = 0
    object SiteNameLabel: TLabel
      Left = 24
      Top = 24
      Width = 26
      Height = 15
      Caption = #21517#21069
    end
    object AddressLabel: TLabel
      Left = 24
      Top = 56
      Width = 39
      Height = 15
      Caption = #12450#12489#12524#12473
    end
    object UserNameLabel: TLabel
      Left = 24
      Top = 88
      Width = 46
      Height = 15
      Caption = #12518#12540#12470#21517
    end
    object PasswordLabel: TLabel
      Left = 24
      Top = 120
      Width = 51
      Height = 15
      Caption = #12497#12473#12527#12540#12489
    end
    object RemarksLabel: TLabel
      Left = 24
      Top = 152
      Width = 26
      Height = 15
      Caption = #20633#32771
    end
    object DoInputSiteName: TEdit
      Left = 77
      Top = 21
      Width = 220
      Height = 23
      TabOrder = 0
    end
    object DoInputAddress: TEdit
      Left = 77
      Top = 53
      Width = 220
      Height = 23
      TabOrder = 1
    end
    object DoInputUserName: TEdit
      Left = 77
      Top = 85
      Width = 220
      Height = 23
      TabOrder = 2
    end
    object DoInputPassword: TEdit
      Left = 77
      Top = 117
      Width = 164
      Height = 23
      TabOrder = 3
    end
    object DoInputRemarks: TMemo
      Left = 77
      Top = 149
      Width = 220
      Height = 76
      TabOrder = 5
    end
    object DoOK: TButton
      Left = 222
      Top = 240
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 6
      OnClick = OnDoOK
    end
    object DoCancel: TButton
      Left = 136
      Top = 240
      Width = 75
      Height = 25
      Caption = #12461#12515#12531#12475#12523
      TabOrder = 7
      OnClick = OnDoCancel
    end
    object DoGeneratePassword: TButton
      Left = 249
      Top = 117
      Width = 48
      Height = 22
      Caption = #29983#25104
      TabOrder = 4
      OnClick = OnDoGeneratePassword
    end
  end
end
