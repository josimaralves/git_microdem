object ThreeDview: TThreeDview
  Left = 441
  Top = 195
  Hint = 'Gazetteer labels'
  BorderIcons = [biSystemMenu, biMinimize]
  ClientHeight = 521
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  Menu = MainMenu1
  Position = poDefaultSizeOnly
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  TextHeight = 16
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 25
    Width = 774
    Height = 455
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 792
    ExplicitHeight = 557
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 585
      Height = 369
      OnDblClick = Image1DblClick
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 774
    Height = 25
    AutoSize = True
    ButtonHeight = 25
    TabOrder = 1
    ExplicitWidth = 792
    object SpeedButton2: TSpeedButton
      Left = 0
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Save image'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      OnClick = SpeedButton2Click
    end
    object SpeedButton5: TSpeedButton
      Left = 25
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Copy to clipboard'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFF0000000000FFFFF0FFFFFFFFFF0FFFF0FFFFFFFFFF0FFFF0F9FFFFFFF
        F0FFFF0FF9FFFFFFF0FF9999999FFFFFF0FF99999999FFFFF0FF99999999FFFF
        F0FF9999999FFFFFF0FFFF0FF9FFFFFFF0FFFF0F9FFFFFFFF0FFFF0FFFDDDDFF
        F0FFFFF000DDDD000FFFFFFFFDDFFDDFFFFFFFFFFFDDDDFFFFFF}
      OnClick = SpeedButton5Click
    end
    object SpeedButton4: TSpeedButton
      Left = 50
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Modify and redraw'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFCFFFFFFFFFFFFFFCCFFFFFFFFFFFFCCCCFFFFFFFFFFFFCCCFFFFFFFF
        FFFFFCCFFFFFFFFFFFFFFCCFFFFFCCCCCCFFFCCFFFCCCCCCCCFFFCCFFFCCCCCC
        CCFFFCCFFFFFFFCCCCFFFCCCFFFFFFCCCCCFFCCCFFFFFCCCCCCFFFCCCCCCCCCC
        FCCFFFCCCCCCCCCFFCCFFFFFFFFFFFFFFCCFFFFFFFFFFFFFFFFF}
      OnClick = SpeedButton4Click
    end
    object SpeedButton6: TSpeedButton
      Left = 75
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Maximize Image'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00700000777000
        0007099997777779999009777777777779900997777777779790097977777779
        7790097700070007779007770777770777707777077777077777777777777777
        7777077707777707777709770777770777700977000700977790097977777779
        7790099777777777979009999977779999907000007770000007}
      OnClick = SpeedButton6Click
    end
    object SpeedButton7: TSpeedButton
      Left = 100
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Minimize'
      Enabled = False
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00800000888000
        00080A888888888888A008A8A88888A88A80088AA88888A8A88008AAA88888AA
        88800888000000AAAA8008880888880888808888088888088888888808888808
        88880888088888088888088808888808888008AAA00000AAAA80088AA88888AA
        888008A8A88888A8A8800A88888888888A808000008880000008}
      OnClick = SpeedButton7Click
    end
    object SpeedButton9: TSpeedButton
      Left = 123
      Top = 0
      Width = 23
      Height = 25
      Glyph.Data = {
        7E010000424D7E01000000000000760000002800000016000000160000000100
        0400000000000801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFF00F0AAAAAAAAAAAAAAAAAAAF00F0AAAAAAAAAAAAAAAAAA0F00FF0A
        AAAAAAAAAAAAAAA0FF00FF0AAAAAAAAAAAAAAAA0FF00FFF0AAAAAAAAAAAAAA0F
        FF00FFF0AAAAAAAAAAAAAA0FFF00FFFF0AAAAAAAAAAAA0FFFF00FFFF0AAAAAAA
        AAAAA0FFFF00FFFFF0AAAAAFFFFA0FFFFF00FFFFF0AAFFFF0FFF0FFFFF00FFFF
        FF0FFFF0F000FFFFFF00FFFFFF0FFF0FFFF00FFFFF00FFFFFFF0FF0FFFFFFFFF
        FF00FFFFFFF0F0FFFFFFFFFFFF00FFF080800F7000FFFFFFFF00FFF08080FF0F
        00FFFFFFFF00FFF07870FF0F00FFFFFFFF00FFF07870FF0F00FFFFFFFF00FFF0
        0F00F00008FFFFFFFF00FFF00F00FF0FFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
        FF00}
      OnClick = SpeedButton9Click
    end
    object SpeedButton10: TSpeedButton
      Left = 146
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Angular resolution'
      Glyph.Data = {
        EE000000424DEE0000000000000076000000280000000F0000000F0000000100
        0400000000007800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFF0F0FFFFFFFFFFFFF0F00FFFFFFFFFFFF0F0F0FFFFFFFFFFF0F0FF0FFFFFFF
        FFF0F0FFF0FFFFFFFFF0F0FFFF00FFFFFFF0F0FFFFFF0FFFFFF0F0FFFFFF00FF
        FFF0F0FFFFF0FF0FFFF0F0FFFFF0FFF0FFF0F000000FFFFF0FF0F0FFFFFFFFFF
        FFF0F0FFFFFFFFFFFFF0FFFFFFFFFFFFFFF0}
      OnClick = SpeedButton10Click
    end
    object SpeedButton11: TSpeedButton
      Left = 169
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Show horizon on view'
      Caption = 'Hz'
      OnClick = SpeedButton11Click
    end
    object InfoSpeedButton6: TSpeedButton
      Left = 192
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Map information'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333FF3FF3333333333CC30003333333333773777333333333C33
        3000333FF33337F33777339933333C3333333377F33337F3333F339933333C33
        33003377333337F33377333333333C333300333F333337F33377339333333C33
        3333337FF3333733333F33993333C33333003377FF33733333773339933C3333
        330033377FF73F33337733339933C33333333FF377F373F3333F993399333C33
        330077F377F337F33377993399333C33330077FF773337F33377399993333C33
        33333777733337F333FF333333333C33300033333333373FF7773333333333CC
        3000333333333377377733333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = InfoSpeedButton6Click
    end
    object SpeedButton8: TSpeedButton
      Left = 217
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Show draping map'
      Glyph.Data = {
        36080000424D3608000000000000360400002800000020000000200000000100
        08000000000000040000CE0E0000C40E00000001000000000000FFFFFF00CCFF
        FF0099FFFF0066FFFF0033FFFF0000FFFF00FFCCFF00CCCCFF0099CCFF0066CC
        FF0033CCFF0000CCFF00FF99FF00CC99FF009999FF006699FF003399FF000099
        FF00FF66FF00CC66FF009966FF006666FF003366FF000066FF00FF33FF00CC33
        FF009933FF006633FF003333FF000033FF00FF00FF00CC00FF009900FF006600
        FF003300FF000000FF00FFFFCC00CCFFCC0099FFCC0066FFCC0033FFCC0000FF
        CC00FFCCCC00CCCCCC0099CCCC0066CCCC0033CCCC0000CCCC00FF99CC00CC99
        CC009999CC006699CC003399CC000099CC00FF66CC00CC66CC009966CC006666
        CC003366CC000066CC00FF33CC00CC33CC009933CC006633CC003333CC000033
        CC00FF00CC00CC00CC009900CC006600CC003300CC000000CC00FFFF9900CCFF
        990099FF990066FF990033FF990000FF9900FFCC9900CCCC990099CC990066CC
        990033CC990000CC9900FF999900CC9999009999990066999900339999000099
        9900FF669900CC66990099669900666699003366990000669900FF339900CC33
        990099339900663399003333990000339900FF009900CC009900990099006600
        99003300990000009900FFFF6600CCFF660099FF660066FF660033FF660000FF
        6600FFCC6600CCCC660099CC660066CC660033CC660000CC6600FF996600CC99
        660099996600669966003399660000996600FF666600CC666600996666006666
        66003366660000666600FF336600CC3366009933660066336600333366000033
        6600FF006600CC00660099006600660066003300660000006600FFFF3300CCFF
        330099FF330066FF330033FF330000FF3300FFCC3300CCCC330099CC330066CC
        330033CC330000CC3300FF993300CC9933009999330066993300339933000099
        3300FF663300CC66330099663300666633003366330000663300FF333300CC33
        330099333300663333003333330000333300FF003300CC003300990033006600
        33003300330000003300FFFF0000CCFF000099FF000066FF000033FF000000FF
        0000FFCC0000CCCC000099CC000066CC000033CC000000CC0000FF990000CC99
        000099990000669900003399000000990000FF660000CC660000996600006666
        00003366000000660000FF330000CC3300009933000066330000333300000033
        0000FF000000CC00000099000000660000003300000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000072B2B2B2B31
        262C2C502C2B325C32002B312C2C072B2C2B24240124002424002B0D2B2B3207
        2B2C262C57262B325C2B072B562B2B2B325624242A24242424242B2B2C2B2B31
        2C0D2B2C2C2C262C5D2B002C56322B2B2C2B2B2424242B002B242B2B2B312B2B
        322B2B2B2B2C512C56382B2B322C2B072B573224002424242424322B2B32322B
        2B322B2B07262C2C2C572C072B322B2B2B324F242424242424242C2C322B2B2B
        2B2B2B2B2B262C502C57312B2C562C2B072B2B24242500240724572C50262C32
        31072B323131262C2C32572C3256322B2C56324F00242A242425512C2C2D2C50
        2C2C2B312C2B262C502D5D565781562B2B56562B2424242400242C5133502C51
        2C2C262B322B322C262C5D323257562C2B3250072424002B24242C2C2C51332C
        572C2C2C262C2C2C2C515757502D56562C5632242524242424242C502D50502D
        2D502D2C512C51502C2C57562C5132562B32502400242425242A572D2C2D2C57
        562D2C502C262C2D2C2C2D5D2D5656572C563124242A24002400572C512C5150
        3357572C2C2C512C2C51565D2C2C325656322B2424242424242451573251322D
        512C57572C2C2C502C2C2D81335032572C812C24242500242B012C57512C512C
        572D575757562D512D502C82572D565732562B2400242A24242433512C573357
        502C5757572D5033502C575D572C505632502B242424240024242C512C515156
        2D3357502D56572C51332C5D575732562C562B24240724242406502C512C3351
        2C503357572D57572C5757815D51325631572B242424242B25242D2C2C512C57
        572D505757562D572D575D5D562D562C565D2424242424002424502C512C2D50
        33502D2C2C512C5756575D5D57513256572B2424002B242424242C2C2C262C26
        50512C2C5133575757575D5D57325657574F24242424002B2424512C2C502C2C
        2C2D512C57575D5D57395D5756563256562B2B242424242424242C572C2C512C
        2C562D5D5D395D5D5D5D57562B57574F2C4F2B242424242424002C2C2D572C2D
        5757575D5D5D5D575D57572C3256324F2B2B4F2C2B2B242424245157572C2C57
        5657575D5D5D575D5D575656562C5656562C242B2B2B254F254F7B827B575757
        2D5D5D5D575D575D57562C32562B563256322424242B2B322B2B5D815D565157
        5D5D57575D57335D2D502C56564F3250562B2407240024242B2B5757562D3381
        828157575D575D5756335632574F2C560724242424242424012A575757575781
        5D815D825D5D56575D56565624002B2B24252A24252A242424248281575D8157
        578281885D5756325732563124242424002424002424002B0024818257575781
        815D815D573256565756502B562B24242424242424242424242B5D815D575757
        5781885D2C562B3256562B565755242424242424242424242424}
      OnClick = SpeedButton8Click
    end
    object SpeedButton19: TSpeedButton
      Left = 240
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Show visible points on map'
      Glyph.Data = {
        7E010000424D7E01000000000000760000002800000016000000160000000100
        0400000000000801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFF
        FFFFFFFFFFFFFFFFFF00FFFFFFFFFFF9999FFFFFFF00FFFFFFFFFF999999FFFF
        FF00FFFFFFFFFF999999FFFFFF00FFFFFFFFFFF9999FFFFFFF00FFFFF99FFFFF
        FFFFFFFFFF00FFFF99999FFFFFFFFFFFFF00FFF9999999FFFFFFFFFFFF00FF99
        9999999999FFFFFFFF00FF9999999999999FFFFFFF00FFF999999999999FFFFF
        FF00FFFF99999999999FFFFFFF00FFFFFFF99999999FFFFFFF00FFFFFFFF9999
        99FFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFF
        FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
        FF00}
      OnClick = SpeedButton19Click
    end
    object SpeedButton20: TSpeedButton
      Left = 265
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Show sensor pitch limits'
      Glyph.Data = {
        46060000424D4606000000000000360400002800000016000000160000000100
        0800000000001002000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A6000020400000206000002080000020A0000020C0000020E000004000000040
        20000040400000406000004080000040A0000040C0000040E000006000000060
        20000060400000606000006080000060A0000060C0000060E000008000000080
        20000080400000806000008080000080A0000080C0000080E00000A0000000A0
        200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
        200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
        200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
        20004000400040006000400080004000A0004000C0004000E000402000004020
        20004020400040206000402080004020A0004020C0004020E000404000004040
        20004040400040406000404080004040A0004040C0004040E000406000004060
        20004060400040606000406080004060A0004060C0004060E000408000004080
        20004080400040806000408080004080A0004080C0004080E00040A0000040A0
        200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
        200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
        200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
        20008000400080006000800080008000A0008000C0008000E000802000008020
        20008020400080206000802080008020A0008020C0008020E000804000008040
        20008040400080406000804080008040A0008040C0008040E000806000008060
        20008060400080606000806080008060A0008060C0008060E000808000008080
        20008080400080806000808080008080A0008080C0008080E00080A0000080A0
        200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
        200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
        200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
        2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
        2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
        2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
        2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
        2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
        2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
        2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707070707070700000707070707070707070707070707
        0707070707070707000007070707070707070707070707070707070707070707
        0000070707070707070707070707070707070707070707070000070707070707
        0707070707070707070707070707070700000707070707070707070707070707
        0707070707070707000002020202020202020202020202020202020202020202
        0000000707070707070707070707070707070707070707070000000707070707
        070707070707070707070707070707070000FF00070707070707070007070707
        07070700070707070000FFFF0007070707070000070707070707000007070707
        0000020202020202020202020202020202020202020202020000FFFFFF000700
        FFFFFFFF000707070700FFFF000707070000FFFFFFFF00FFFFFFFFFFFF000707
        00FFFFFFFF0007070000FFFFFFFFFFFFFFFFFFFFFF00070700FFFFFFFF000700
        0000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF00FF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000}
      OnClick = SpeedButton20Click
    end
    object SpeedButton21: TSpeedButton
      Left = 290
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Zoom in'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
        3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
        33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
        333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      OnClick = SpeedButton21Click
    end
    object SpeedButton22: TSpeedButton
      Left = 315
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Zoom out'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        333333773337777333333078F8F87033333337F3333337F33333778F8F8F8773
        333337333333373F333307F8F8F8F70333337F33FFFFF37F3333078999998703
        33337F377777337F333307F8F8F8F703333373F3333333733333778F8F8F8773
        333337F3333337F333333078F8F870333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
      OnClick = SpeedButton22Click
    end
    object SpeedButton14: TSpeedButton
      Left = 340
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Radial properties'
      Caption = 'R'
      OnClick = SpeedButton14Click
    end
    object SpeedButton15: TSpeedButton
      Left = 363
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Rotate counterclockwise'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000100B0000100B00001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF0088888878F888
        888888888878F88888888888877777788888888744444444788887448878F888
        447874888878F888884747888878F888887447888878F888887474888878F884
        874787448878F844447888877878F444488888888878F444488888888878F888
        888888888878F888888888888878F88888888888888888888888}
    end
    object SpeedButton16: TSpeedButton
      Left = 386
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Rotate Clockwise'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000110B0000110B00001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF008888888F8788
        88888888888F87888888888887777778888888874444444478888744888F8788
        44787488888F878888474788888F878888744788888F878888747478488F8788
        88478744448F878844788884444F878778888884444F878888888888888F8788
        88888888888F878888888888888F878888888888888888888888}
    end
    object SpeedButton17: TSpeedButton
      Left = 409
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Increase vertical exagerration'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000110B0000110B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00FFFFFFFF2FFF
        FFFFFFFFFFFF2FFFFFFFFF000FFF2F00000FFF000FFF2F00FFFFF00F00FF2F00
        FFFFF00F00FF2F00FFFFF00F00FF2F00000FF00F00FF2F00FFFF00FFF00F2F00
        FFFF00FFF00F2F00000FFFFFFFFF2FF2FFFFFFFFFF2F2F2FFFFFFFFFFF2F2F2F
        FFFFFFFFFFF222FFFFFFFFFFFFF222FFFFFFFFFFFFFF2FFFFFFF}
    end
    object SpeedButton18: TSpeedButton
      Left = 432
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Decrease vertical exagerration'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000110B0000110B00001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00FFFFFFFF9FFF
        FFFFFFFFFFF999FFFFFFFFFFFF9F9F9FFFFFFFFFFF9F9FF9FFFFFFFFF9FF9FFF
        9FFFFFFFFFFF9FFFFFFFFFFFFFFF9FFFFFFFFF000FFF9F00000FFF000FFF9F00
        FFFFF00F00FF9F00FFFFF00F00FF9F00FFFFF00F00FF9F00000FF00F00FF9F00
        FFFF00FFF00F9F00FFFF00FFF00F9F00000FFFFFFFFF9FFFFFFF}
    end
    object BitBtn2: TBitBtn
      Left = 455
      Top = 0
      Width = 33
      Height = 25
      Caption = 'z'
      TabOrder = 0
      OnClick = BitBtn2Click
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 480
    Width = 774
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 582
    ExplicitWidth = 792
    object TrackBar1: TTrackBar
      Left = 204
      Top = 1
      Width = 587
      Height = 39
      Align = alRight
      Max = 255
      Frequency = 10
      Position = 255
      TabOrder = 0
      OnChange = TrackBar1Change
    end
    object Panel2: TPanel
      Left = -6
      Top = 0
      Width = 248
      Height = 41
      TabOrder = 1
      object Label1: TLabel
        Left = 121
        Top = 8
        Width = 112
        Height = 16
        Caption = 'Alpha blend:  255'
      end
      object SpeedButton12: TSpeedButton
        Left = 6
        Top = 8
        Width = 25
        Height = 25
        Hint = 'Save alpah blend  image'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
          7700333333337777777733333333008088003333333377F73377333333330088
          88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
          000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
          FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
          99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
          99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
          99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
          93337FFFF7737777733300000033333333337777773333333333}
        NumGlyphs = 2
        OnClick = SpeedButton2Click
      end
      object SpeedButton13: TSpeedButton
        Left = 56
        Top = 8
        Width = 23
        Height = 25
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFFFFFF0000000000FFFFF0FFFFFFFFFF0FFFF0FFFFFFFFFF0FFFF0F9FFFFFFF
          F0FFFF0FF9FFFFFFF0FF9999999FFFFFF0FF99999999FFFFF0FF99999999FFFF
          F0FF9999999FFFFFF0FFFF0FF9FFFFFFF0FFFF0F9FFFFFFFF0FFFF0FFFDDDDFF
          F0FFFFF000DDDD000FFFFFFFFDDFFDDFFFFFFFFFFFDDDDFFFFFF}
        OnClick = SpeedButton13Click
      end
      object CancelBtn: TSpeedButton
        Left = 85
        Top = 8
        Width = 25
        Height = 25
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        OnClick = CancelBtnClick
      end
      object BitBtn1: TBitBtn
        Left = 29
        Top = 8
        Width = 27
        Height = 25
        Hint = 'Save alpha blend movie'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          033333FFFF77777773F330000077777770333777773FFFFFF733077777000000
          03337F3F3F777777733F0797A770003333007F737337773F3377077777778803
          30807F333333337FF73707888887880007707F3FFFF333777F37070000878807
          07807F777733337F7F3707888887880808807F333333337F7F37077777778800
          08807F333FFF337773F7088800088803308073FF777FFF733737300008000033
          33003777737777333377333080333333333333F7373333333333300803333333
          33333773733333333333088033333333333373F7F33333333333308033333333
          3333373733333333333333033333333333333373333333333333}
        NumGlyphs = 2
        TabOrder = 0
        OnClick = BitBtn1Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 17
    Top = 57
    object File1: TMenuItem
      Caption = '&File'
      object Imagescaling1: TMenuItem
        Caption = 'Image scaling'
        OnClick = Imagescaling1Click
      end
      object Alphablendbitmap1: TMenuItem
        Caption = 'Alpha blend bitmap'
        OnClick = Alphablendbitmap1Click
      end
      object Showthedrapemap1: TMenuItem
        Caption = 'Show drape map'
        OnClick = Showthedrapemap1Click
      end
      object Saveimage1: TMenuItem
        Caption = '&Save image'
        OnClick = Saveimage1Click
      end
      object Close1: TMenuItem
        Caption = '&Close'
        OnClick = Close1Click
      end
    end
    object Modify1: TMenuItem
      Caption = '&Modify'
      OnClick = Modify1Click
    end
    object Sunposition1: TMenuItem
      Caption = 'Sun position'
      object oday1: TMenuItem
        Caption = 'Today'
        OnClick = oday1Click
      end
      object Pickday1: TMenuItem
        Caption = 'Pick day'
        OnClick = Pickday1Click
      end
    end
    object Moonposition1: TMenuItem
      Caption = 'Moon position'
      object Moonposition2: TMenuItem
        Caption = 'Today'
        OnClick = Moonposition2Click
      end
      object Pickday2: TMenuItem
        Caption = 'Pick day'
        OnClick = Pickday2Click
      end
    end
  end
end
