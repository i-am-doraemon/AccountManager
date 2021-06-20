object Configure: TConfigure
  Left = 0
  Top = 0
  Caption = #35373#23450
  ClientHeight = 201
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PasswordGenerationBox: TGroupBox
    Left = 8
    Top = 8
    Width = 352
    Height = 137
    Caption = #12497#12473#12527#12540#12489#29983#25104
    TabOrder = 0
    object Length: TLabel
      Left = 16
      Top = 32
      Width = 36
      Height = 13
      Caption = #25991#23383#25968
    end
    object DoSetLength: TEdit
      Left = 64
      Top = 29
      Width = 32
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 0
      Text = '12'
    end
    object DoChangeLengthByStep: TUpDown
      Left = 96
      Top = 29
      Width = 16
      Height = 21
      Associate = DoSetLength
      Min = 4
      Max = 24
      Position = 12
      TabOrder = 1
    end
    object DoUseDigits: TCheckBox
      Left = 16
      Top = 59
      Width = 64
      Height = 17
      Alignment = taLeftJustify
      Caption = #25968#23383
      TabOrder = 2
    end
    object DoUseLowerCase: TCheckBox
      Left = 16
      Top = 82
      Width = 64
      Height = 17
      Alignment = taLeftJustify
      Caption = #23567#25991#23383
      TabOrder = 3
    end
    object DoUseUpperCase: TCheckBox
      Left = 16
      Top = 105
      Width = 64
      Height = 17
      Alignment = taLeftJustify
      Caption = #22823#25991#23383
      TabOrder = 4
    end
  end
  object DoOK: TButton
    Left = 285
    Top = 168
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object DoCancel: TButton
    Left = 199
    Top = 168
    Width = 75
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 2
  end
end
