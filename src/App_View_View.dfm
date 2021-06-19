object ViewAccount: TViewAccount
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
    object DoShowAddress: TEdit
      Left = 77
      Top = 53
      Width = 220
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object DoShowUserName: TEdit
      Left = 77
      Top = 85
      Width = 220
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object DoShowRemarks: TMemo
      Left = 77
      Top = 149
      Width = 220
      Height = 76
      ReadOnly = True
      TabOrder = 2
    end
    object DoCopyToClipBoard: TButton
      Left = 77
      Top = 114
      Width = 220
      Height = 25
      Caption = #12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540
      TabOrder = 3
      OnClick = OnDoCopyToClipBoard
    end
    object DoChooseSite: TComboBox
      Left = 77
      Top = 21
      Width = 220
      Height = 21
      Style = csDropDownList
      TabOrder = 4
      OnSelect = OnDoChoose
    end
  end
end
