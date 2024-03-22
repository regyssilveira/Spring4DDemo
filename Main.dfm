object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 603
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 133
    Height = 25
    Caption = 'Datas'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 250
    Top = 8
    Width = 366
    Height = 587
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 59
    Width = 133
    Height = 25
    Caption = 'Evento'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 115
    Width = 133
    Height = 25
    Caption = 'Shared #1'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 146
    Width = 133
    Height = 25
    Caption = 'Shared #2'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 177
    Width = 133
    Height = 25
    Caption = 'Shared #3'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 208
    Width = 133
    Height = 25
    Caption = 'Weak'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 8
    Top = 260
    Width = 133
    Height = 25
    Caption = 'Lista enumerada'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 8
    Top = 291
    Width = 133
    Height = 25
    Caption = 'Lista'
    TabOrder = 8
    OnClick = Button8Click
  end
end
