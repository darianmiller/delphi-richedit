object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Delphi RichEdit Preview'
  ClientHeight = 700
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 185
    Top = 41
    Height = 599
  end
  object panLeft: TPanel
    Left = 0
    Top = 41
    Width = 185
    Height = 599
    Align = alLeft
    TabOrder = 0
  end
  object panClient: TPanel
    Left = 188
    Top = 41
    Width = 812
    Height = 599
    Align = alClient
    TabOrder = 1
  end
  object panBottom: TPanel
    Left = 0
    Top = 640
    Width = 1000
    Height = 60
    Align = alBottom
    TabOrder = 2
  end
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 41
    Align = alTop
    TabOrder = 3
  end
end
