object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Test'
  ClientHeight = 532
  ClientWidth = 765
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object conMemo: TMemo
    Left = -56
    Top = -288
    Width = 57
    Height = 289
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clLime
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnKeyDown = conMemoKeyDown
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 728
    Top = 8
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    Left = 728
    Top = 56
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    Left = 728
    Top = 88
  end
end
