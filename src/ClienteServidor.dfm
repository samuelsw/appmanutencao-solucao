object fClienteServidor: TfClienteServidor
  Left = 0
  Top = 0
  Caption = 'Cliente - Servidor'
  ClientHeight = 80
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TProgressBar
    AlignWithMargins = True
    Left = 3
    Top = 60
    Width = 455
    Height = 17
    Align = alBottom
    TabOrder = 0
  end
  object btEnviarSemErros: TButton
    Left = 56
    Top = 19
    Width = 113
    Height = 25
    Caption = 'Enviar sem erros'
    TabOrder = 1
    OnClick = btEnviarSemErrosClick
  end
  object btEnviarComErros: TButton
    Left = 175
    Top = 19
    Width = 113
    Height = 25
    Caption = 'Enviar com erros'
    TabOrder = 2
    OnClick = btEnviarComErrosClick
  end
  object btEnviarParalelo: TButton
    Left = 294
    Top = 19
    Width = 113
    Height = 25
    Caption = 'Enviar paralelo'
    TabOrder = 3
    OnClick = btEnviarParaleloClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 700
    OnTimer = Timer1Timer
    Left = 368
    Top = 24
  end
end
