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
      Width = 24
      Height = 13
      Caption = #21517#21069
    end
    object AddressLabel: TLabel
      Left = 24
      Top = 56
      Width = 36
      Height = 13
      Caption = #12450#12489#12524#12473
    end
    object UserNameLabel: TLabel
      Left = 24
      Top = 88
      Width = 42
      Height = 13
      Caption = #12518#12540#12470#21517
    end
    object PasswordLabel: TLabel
      Left = 24
      Top = 120
      Width = 47
      Height = 13
      Caption = #12497#12473#12527#12540#12489
    end
    object RemarksLabel: TLabel
      Left = 24
      Top = 152
      Width = 24
      Height = 13
      Caption = #20633#32771
    end
    object DoInputSiteName: TEdit
      Left = 77
      Top = 21
      Width = 220
      Height = 21
      TabOrder = 0
    end
    object DoInputAddress: TEdit
      Left = 77
      Top = 53
      Width = 220
      Height = 21
      TabOrder = 1
    end
    object DoInputUserName: TEdit
      Left = 77
      Top = 85
      Width = 220
      Height = 21
      TabOrder = 2
    end
    object DoInputPassword: TEdit
      Left = 77
      Top = 117
      Width = 220
      Height = 21
      TabOrder = 3
    end
    object DoInputRemarks: TMemo
      Left = 77
      Top = 149
      Width = 220
      Height = 76
      TabOrder = 4
    end
    object DoOK: TButton
      Left = 222
      Top = 240
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 5
      OnClick = OnDoOK
    end
    object DoCancel: TButton
      Left = 136
      Top = 240
      Width = 75
      Height = 25
      Caption = #12461#12515#12531#12475#12523
      TabOrder = 6
      OnClick = OnDoCancel
    end
  end
end
