object FormAnimate: TFormAnimate
  Left = 493
  Top = 238
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Animated GIF '
  ClientHeight = 704
  ClientWidth = 1092
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnCreate = FormCreate
  TextHeight = 14
  object ScrollBoxSource: TScrollBox
    Left = 0
    Top = 0
    Width = 1092
    Height = 93
    VertScrollBar.Visible = False
    Align = alTop
    TabOrder = 0
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 92
      Height = 66
      Hint = 'Click image to display'
      ParentShowHint = False
      ShowHint = True
      Stretch = True
    end
    object Image2: TImage
      Left = 98
      Top = 0
      Width = 92
      Height = 66
      Hint = 'Click image to display'
      ParentShowHint = False
      ShowHint = True
      Stretch = True
    end
    object Image3: TImage
      Left = 184
      Top = 0
      Width = 92
      Height = 66
      Hint = 'Click image to display'
      ParentShowHint = False
      ShowHint = True
      Stretch = True
    end
    object Image4: TImage
      Left = 282
      Top = 3
      Width = 92
      Height = 66
      Hint = 'Click image to display'
      ParentShowHint = False
      ShowHint = True
      Stretch = True
    end
    object Image5: TImage
      Left = 372
      Top = 3
      Width = 92
      Height = 66
      Hint = 'Click image to display'
      ParentShowHint = False
      ShowHint = True
      Stretch = True
    end
    object Image6: TImage
      Left = 470
      Top = 3
      Width = 92
      Height = 66
      Hint = 'Click image to display'
      ParentShowHint = False
      ShowHint = True
      Stretch = True
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 93
    Width = 1092
    Height = 592
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = ' '
    TabOrder = 1
    object PanelPreview: TPanel
      Left = 137
      Top = 4
      Width = 951
      Height = 584
      Align = alClient
      BevelOuter = bvLowered
      BorderWidth = 2
      Caption = ' '
      TabOrder = 0
      object ImageAnimate: TImage
        Left = 3
        Top = 3
        Width = 945
        Height = 578
        Align = alClient
        Center = True
        Proportional = True
        Transparent = True
        ExplicitLeft = 6
        ExplicitTop = 4
      end
    end
    object Panel3: TPanel
      Left = 4
      Top = 4
      Width = 133
      Height = 584
      Align = alLeft
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 1
      object Label1: TLabel
        Left = 9
        Top = 112
        Width = 96
        Height = 14
        Caption = 'Frame delay (msec)'
      end
      object ButtonAnimate: TButton
        Left = 28
        Top = 12
        Width = 75
        Height = 25
        Caption = 'Animate'
        TabOrder = 0
        OnClick = ButtonAnimateClick
      end
      object ButtonSave: TButton
        Left = 28
        Top = 44
        Width = 75
        Height = 25
        Caption = 'Save GIF'
        Enabled = False
        TabOrder = 1
        OnClick = ButtonSaveClick
      end
      object GroupBox1: TGroupBox
        Left = 18
        Top = 160
        Width = 85
        Height = 94
        Caption = 'Optimize'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        object CheckBoxCrop: TCheckBox
          Left = 10
          Top = 39
          Width = 60
          Height = 18
          Hint = 'Removes transparent areas'
          Caption = 'Crop'
          TabOrder = 0
        end
        object CheckBoxMerge: TCheckBox
          Left = 12
          Top = 16
          Width = 58
          Height = 17
          Hint = 'Removes redundant pixels between image layers'
          Caption = 'Merge'
          TabOrder = 1
        end
        object CheckBoxPalette: TCheckBox
          Left = 10
          Top = 63
          Width = 60
          Height = 17
          Hint = 
            'Creates a single global color map instead of multiple local colo' +
            'r maps'
          Caption = 'Palette'
          TabOrder = 2
        end
      end
      object Edit1: TEdit
        Left = 34
        Top = 132
        Width = 57
        Height = 22
        TabOrder = 3
        Text = '1000'
        OnChange = Edit1Change
      end
      object BitBtn1: TBitBtn
        Left = 28
        Top = 260
        Width = 75
        Height = 25
        Caption = 'Clipboard'
        Enabled = False
        TabOrder = 4
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 30
        Top = 75
        Width = 75
        Height = 25
        Caption = 'Load New'
        TabOrder = 5
        OnClick = BitBtn2Click
      end
      object BitBtn3: TBitBtn
        Left = 28
        Top = 291
        Width = 75
        Height = 25
        Caption = 'Reorder'
        TabOrder = 6
        OnClick = BitBtn3Click
      end
      object BitBtn4: TBitBtn
        Left = 28
        Top = 322
        Width = 75
        Height = 25
        Caption = 'Create new'
        TabOrder = 7
        OnClick = BitBtn4Click
      end
      object CheckBox1: TCheckBox
        Left = 8
        Top = 360
        Width = 97
        Height = 17
        Caption = 'Labels from file name'
        TabOrder = 8
        OnClick = CheckBox1Click
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 685
    Width = 1092
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 115
      end
      item
        Alignment = taCenter
        Width = 135
      end
      item
        Alignment = taCenter
        Width = 120
      end>
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'gif'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn]
    Title = 'Save animated GIF'
    Left = 29
    Top = 418
  end
end
