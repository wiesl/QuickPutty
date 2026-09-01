object FRM_Config: TFRM_Config
  Left = 307
  Top = 448
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configuration'
  ClientHeight = 388
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 352
    Width = 181
    Height = 13
    Caption = 'See Help Screen for more informations'
  end
  object Label5: TLabel
    Left = 8
    Top = 368
    Width = 121
    Height = 13
    Caption = '(press F1 on main screen)'
  end
  object BTN_Cancel: TButton
    Left = 360
    Top = 352
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 6
    OnClick = BTN_CancelClick
  end
  object BTN_Ok: TButton
    Left = 280
    Top = 352
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    TabOrder = 5
    OnClick = BTN_OkClick
  end
  object Button1: TButton
    Left = 387
    Top = 24
    Width = 46
    Height = 23
    Caption = '&Browse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object EDT_PuttyPath: TLabeledEdit
    Left = 8
    Top = 24
    Width = 369
    Height = 21
    EditLabel.Width = 81
    EditLabel.Height = 13
    EditLabel.Caption = 'Path to Putty.exe'
    TabOrder = 0
  end
  object GRB_Transparency: TGroupBox
    Left = 8
    Top = 104
    Width = 425
    Height = 121
    Caption = 'Main window options'
    TabOrder = 3
    object Label2: TLabel
      Left = 96
      Top = 96
      Width = 38
      Height = 13
      Caption = 'Invisible'
    end
    object Label3: TLabel
      Left = 360
      Top = 96
      Width = 53
      Height = 13
      Caption = 'Fully visible'
    end
    object Label4: TLabel
      Left = 8
      Top = 64
      Width = 93
      Height = 13
      Caption = 'Transparency level:'
    end
    object TRB_Transparency: TTrackBar
      Left = 104
      Top = 64
      Width = 297
      Height = 33
      Max = 255
      Frequency = 10
      Position = 255
      TabOrder = 2
      OnChange = TRB_TransparencyChange
    end
    object CBX_UseTransparency: TCheckBox
      Left = 8
      Top = 40
      Width = 217
      Height = 17
      Caption = 'Use Transparency (Windows 2000 && XP)'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CBX_UseTransparencyClick
    end
    object CBX_AlwayOnTop: TCheckBox
      Left = 8
      Top = 16
      Width = 105
      Height = 17
      Caption = 'Always on top'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CBX_AlwayOnTopClick
    end
  end
  object CBX_AutoRun: TCheckBox
    Left = 8
    Top = 56
    Width = 217
    Height = 17
    Caption = 'Make QuickPutty run on startup'
    TabOrder = 2
  end
  object GRB_StartMenu: TGroupBox
    Left = 8
    Top = 232
    Width = 425
    Height = 113
    Caption = 'Start Menu options'
    TabOrder = 4
    object CBX_Sessions: TCheckBox
      Left = 8
      Top = 64
      Width = 177
      Height = 17
      Caption = 'Create shortcuts for sessions'
      TabOrder = 2
    end
    object CBX_Sessions_StartMenu: TCheckBox
      Left = 8
      Top = 85
      Width = 321
      Height = 17
      Caption = 'Put sessions directly on Start Menu (instead of in PuTTY folder)'
      TabOrder = 4
    end
    object BTN_CreateStartMenu: TButton
      Left = 8
      Top = 24
      Width = 161
      Height = 33
      Hint = 'Create Start Menu shortcuts for PuTTY & QuickPutty'
      Caption = 'Create Start Menu shortcuts'
      TabOrder = 0
      OnClick = BTN_CreateStartMenuClick
    end
    object BTN_RemoveStartMenu: TButton
      Left = 176
      Top = 24
      Width = 161
      Height = 33
      Hint = 'Remove Start Menu shortcuts for PuTTY & QuickPutty'
      Caption = 'Remove Start Menu shortcuts'
      TabOrder = 1
      OnClick = BTN_RemoveStartMenuClick
    end
    object CBX_Sessions_Autoupdate: TCheckBox
      Left = 176
      Top = 64
      Width = 193
      Height = 17
      Caption = 'Update session shortcuts on startup'
      TabOrder = 3
    end
  end
  object CBX_SystemWideHotkey: TCheckBox
    Left = 8
    Top = 80
    Width = 329
    Height = 17
    Caption = 'Use system-wide hotkey (ALT-Q)  (effective on restart)'
    TabOrder = 7
  end
  object DLG_OpenPutty: TOpenDialog
    FileName = 'putty.exe'
    Filter = 'Executables (*.exe)|*.exe|Any Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 384
    Top = 48
  end
end
