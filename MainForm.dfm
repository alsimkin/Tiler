object Form1: TForm1
  Left = 660
  Top = 415
  Width = 653
  Height = 276
  AutoScroll = True
  Caption = 'Tiler'
  Color = clBtnFace
  Constraints.MinHeight = 262
  Constraints.MinWidth = 653
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    637
    237)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 637
    Height = 130
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 14
    MultiSelect = True
    ParentFont = False
    Sorted = True
    TabOrder = 1
    OnClick = ListBox1Click
    OnKeyDown = ListBox1KeyDown
  end
  object Button1: TButton
    Left = 554
    Top = 143
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Search'
    TabOrder = 0
    OnClick = Button1Click
    OnKeyDown = ListBox1KeyDown
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 218
    Width = 637
    Height = 19
    Panels = <
      item
        Text = '0'
        Width = 100
      end
      item
        Text = '0'
        Width = 100
      end>
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 136
    Width = 257
    Height = 76
    Anchors = [akLeft, akBottom]
    Caption = 'Filters'
    TabOrder = 2
    object Label1: TLabel
      Left = 11
      Top = 24
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object Label2: TLabel
      Left = 11
      Top = 51
      Width = 25
      Height = 13
      Caption = 'Class'
    end
    object ComboBox1: TComboBox
      Left = 39
      Top = 20
      Width = 210
      Height = 21
      TabOrder = 0
    end
    object ComboBox2: TComboBox
      Left = 39
      Top = 47
      Width = 210
      Height = 21
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 271
    Top = 136
    Width = 196
    Height = 76
    Anchors = [akLeft, akBottom]
    Caption = 'Tile setup'
    TabOrder = 3
    object Label3: TLabel
      Left = 15
      Top = 24
      Width = 20
      Height = 13
      Caption = 'Cols'
    end
    object Label4: TLabel
      Left = 15
      Top = 50
      Width = 26
      Height = 13
      Caption = 'Rows'
    end
    object Edit1: TEdit
      Left = 47
      Top = 20
      Width = 26
      Height = 21
      Alignment = taCenter
      TabOrder = 0
      Text = '2'
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TEdit
      Left = 47
      Top = 47
      Width = 26
      Height = 21
      Alignment = taCenter
      TabOrder = 1
      Text = '4'
      OnKeyPress = Edit1KeyPress
    end
    object RBtn1: TRadioButton
      Left = 103
      Top = 23
      Width = 80
      Height = 17
      Caption = 'Cols first'
      TabOrder = 2
    end
    object RBtn2: TRadioButton
      Left = 103
      Top = 47
      Width = 78
      Height = 17
      Caption = 'Rows first'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
  end
  object Button3: TButton
    Left = 554
    Top = 174
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Tile'
    TabOrder = 5
    OnClick = Button3Click
    OnKeyDown = ListBox1KeyDown
  end
  object Button2: TButton
    Left = 473
    Top = 174
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Hide'
    TabOrder = 6
    OnClick = Button2Click
    OnKeyDown = ListBox1KeyDown
  end
  object Button4: TButton
    Left = 473
    Top = 143
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = ' Close'
    TabOrder = 7
    OnClick = Button4Click
  end
end
