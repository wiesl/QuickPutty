object FRM_Config: TFRM_Config
  Left = 664
  Top = 408
  Width = 465
  Height = 255
  Caption = 'Configuration'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 200
    Width = 373
    Height = 13
    Caption = 
      'QuickPutty is LGPL software, (c) Olivier DECKMYN 2001, olivier@d' +
      'eckmyn.org'
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 63
    Height = 13
    Caption = 'QuickPutty'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 96
    Width = 137
    Height = 13
    Caption = 'Transparency (Win2000, XP)'
  end
  object EDT_PuttyPath: TLabeledEdit
    Left = 16
    Top = 56
    Width = 369
    Height = 21
    EditLabel.Width = 68
    EditLabel.Height = 13
    EditLabel.Caption = 'Putty.exe path'
    LabelPosition = lpAbove
    LabelSpacing = 3
    TabOrder = 0
  end
  object Button1: TButton
    Left = 392
    Top = 56
    Width = 46
    Height = 23
    Caption = '&Browse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object BTN_Cancel: TButton
    Left = 376
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = BTN_CancelClick
  end
  object BTN_Ok: TButton
    Left = 296
    Top = 168
    Width = 75
    Height = 25
    Caption = '&Ok'
    TabOrder = 3
    OnClick = BTN_OkClick
  end
  object TRB_Transparency: TTrackBar
    Left = 16
    Top = 112
    Width = 281
    Height = 45
    Max = 255
    Orientation = trHorizontal
    Frequency = 10
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 4
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TRB_TransparencyChange
  end
  object DLG_OpenPutty: TOpenDialog
    FileName = 'putty.exe'
    Filter = 'Exe|*.exe|Any Files|*.*'
    Left = 344
    Top = 8
  end
end
