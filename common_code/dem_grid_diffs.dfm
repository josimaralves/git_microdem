object GridDiffForm: TGridDiffForm
  Left = 533
  Top = 363
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Grid Differences '
  ClientHeight = 304
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poDefaultSizeOnly
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 183
    Top = 116
    Width = 80
    Height = 13
    Caption = 'Level to highlight'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 77
    Width = 113
    Height = 17
    Caption = 'Histograms'
    TabOrder = 0
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 8
    Width = 137
    Height = 17
    Caption = 'Difference map'
    TabOrder = 1
  end
  object OKBtn: TBitBtn
    Left = 10
    Top = 244
    Width = 77
    Height = 27
    Kind = bkOK
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
    OnClick = OKBtnClick
    IsControl = True
  end
  object HelpBtn: TBitBtn
    Left = 101
    Top = 244
    Width = 77
    Height = 27
    Kind = bkHelp
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 3
    OnClick = HelpBtnClick
    IsControl = True
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 54
    Width = 97
    Height = 17
    Caption = 'Scatter plot'
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 279
    Top = 116
    Width = 74
    Height = 21
    TabOrder = 5
    Text = 'Edit1'
  end
  object CheckBox5: TCheckBox
    Left = 8
    Top = 31
    Width = 162
    Height = 17
    Caption = 'Merge hillsahde first DEM'
    TabOrder = 6
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 143
    Width = 568
    Height = 79
    Caption = 'Grid to copy for difference'
    TabOrder = 7
  end
  object RadioGroup2: TRadioGroup
    Left = 183
    Top = 8
    Width = 178
    Height = 86
    Caption = 'Map coloring'
    Items.Strings = (
      'Color map'
      'Highlight cutoff'
      'Red/blue divengent')
    TabOrder = 8
    OnClick = RadioGroup2Click
  end
end
