object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'fThreads'
  ClientHeight = 279
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 6
    Width = 94
    Height = 13
    Caption = 'N'#250'mero de Threads'
  end
  object Label2: TLabel
    Left = 143
    Top = 6
    Width = 65
    Height = 13
    Caption = 'Milissegundos'
  end
  object edtnumThreads: TEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 0
    Text = '4'
  end
  object Edit2: TEdit
    Left = 143
    Top = 24
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '100'
  end
  object Button1: TButton
    Left = 279
    Top = 20
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 56
    Width = 497
    Height = 17
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 16
    Top = 79
    Width = 497
    Height = 178
    TabOrder = 4
  end
  object Button2: TButton
    Left = 374
    Top = 20
    Width = 19
    Height = 25
    TabOrder = 5
    OnClick = Button2Click
  end
end
