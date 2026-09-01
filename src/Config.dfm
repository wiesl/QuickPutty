object FRM_Config: TFRM_Config
  Left = 788
  Top = 422
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configuration'
  ClientHeight = 702
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 10
    Top = 660
    Width = 230
    Height = 16
    Caption = 'See Help Screen for more informations'
  end
  object Label5: TLabel
    Left = 10
    Top = 679
    Width = 154
    Height = 16
    Caption = '(press F1 on main screen)'
  end
  object BTN_Cancel: TButton
    Left = 443
    Top = 660
    Width = 92
    Height = 30
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 6
    OnClick = BTN_CancelClick
  end
  object BTN_Ok: TButton
    Left = 345
    Top = 660
    Width = 92
    Height = 30
    Caption = '&Ok'
    Default = True
    TabOrder = 5
    OnClick = BTN_OkClick
  end
  object Button1: TButton
    Left = 476
    Top = 30
    Width = 57
    Height = 28
    Caption = '&Browse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object EDT_PuttyPath: TLabeledEdit
    Left = 10
    Top = 30
    Width = 454
    Height = 24
    EditLabel.Width = 500
    EditLabel.Height = 16
    EditLabel.Caption = 
      'Path to Putty.exe/Kitty.exe/Kitty_nocompress.exe/Kitty_notrans.e' +
      'xe/Kitty_portable.exe'
    TabOrder = 0
  end
  object GRB_Transparency: TGroupBox
    Left = 10
    Top = 354
    Width = 523
    Height = 149
    Caption = 'Main window options'
    TabOrder = 3
    object Label2: TLabel
      Left = 118
      Top = 118
      Width = 49
      Height = 16
      Caption = 'Invisible'
    end
    object Label3: TLabel
      Left = 443
      Top = 118
      Width = 70
      Height = 16
      Caption = 'Fully visible'
    end
    object Label4: TLabel
      Left = 10
      Top = 79
      Width = 119
      Height = 16
      Caption = 'Transparency level:'
    end
    object TRB_Transparency: TTrackBar
      Left = 128
      Top = 79
      Width = 366
      Height = 40
      Max = 255
      Frequency = 10
      Position = 255
      TabOrder = 2
      OnChange = TRB_TransparencyChange
    end
    object CBX_UseTransparency: TCheckBox
      Left = 10
      Top = 49
      Width = 267
      Height = 21
      Caption = 'Use Transparency (Windows 2000 && XP)'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CBX_UseTransparencyClick
    end
    object CBX_AlwayOnTop: TCheckBox
      Left = 10
      Top = 20
      Width = 129
      Height = 21
      Caption = 'Always on top'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CBX_AlwayOnTopClick
    end
  end
  object CBX_AutoRun: TCheckBox
    Left = 10
    Top = 69
    Width = 267
    Height = 21
    Caption = 'Make QuickPutty run on startup'
    TabOrder = 2
  end
  object GRB_StartMenu: TGroupBox
    Left = 10
    Top = 512
    Width = 523
    Height = 139
    Caption = 'Start Menu options'
    TabOrder = 4
    object CBX_Sessions: TCheckBox
      Left = 10
      Top = 79
      Width = 218
      Height = 21
      Caption = 'Create shortcuts for sessions'
      TabOrder = 2
    end
    object CBX_Sessions_StartMenu: TCheckBox
      Left = 10
      Top = 105
      Width = 395
      Height = 21
      Caption = 'Put sessions directly on Start Menu (instead of in PuTTY folder)'
      TabOrder = 4
    end
    object BTN_CreateStartMenu: TButton
      Left = 10
      Top = 30
      Width = 198
      Height = 40
      Hint = 'Create Start Menu shortcuts for PuTTY/KiTTY & QuickPutty'
      Caption = 'Create Start Menu shortcuts'
      TabOrder = 0
      OnClick = BTN_CreateStartMenuClick
    end
    object BTN_RemoveStartMenu: TButton
      Left = 217
      Top = 30
      Width = 198
      Height = 40
      Hint = 'Remove Start Menu shortcuts for PuTTY/KiTTY & QuickPutty'
      Caption = 'Remove Start Menu shortcuts'
      TabOrder = 1
      OnClick = BTN_RemoveStartMenuClick
    end
    object CBX_Sessions_Autoupdate: TCheckBox
      Left = 217
      Top = 79
      Width = 237
      Height = 21
      Caption = 'Update session shortcuts on startup'
      TabOrder = 3
    end
  end
  object CBX_SystemWideHotkey: TCheckBox
    Left = 10
    Top = 98
    Width = 468
    Height = 21
    Caption = 
      'Use system-wide hotkey (ALT-Q, configurable in INI file)  (effec' +
      'tive on restart)'
    TabOrder = 7
  end
  object CBX_UseKiTTYSessions: TCheckBox
    Left = 10
    Top = 128
    Width = 218
    Height = 21
    Caption = 'Use KiTTY style config directory'
    TabOrder = 8
    OnClick = CBX_UseKiTTYSessionsClick
  end
  object EDT_KiTTYConfigPath: TLabeledEdit
    Left = 10
    Top = 177
    Width = 454
    Height = 24
    EditLabel.Width = 216
    EditLabel.Height = 16
    EditLabel.Caption = 'Path to KiTTY configuration directory'
    Enabled = False
    TabOrder = 9
  end
  object Button2: TButton
    Left = 476
    Top = 177
    Width = 57
    Height = 29
    Caption = '&Browse'
    Enabled = False
    TabOrder = 10
    OnClick = Button2Click
  end
  object EDT_KiTTY_Ignore_Session_Filter: TLabeledEdit
    Left = 10
    Top = 226
    Width = 454
    Height = 24
    EditLabel.Width = 482
    EditLabel.Height = 16
    EditLabel.Caption = 
      'Ignore Session Filter substring list (e.g. substring;company1\se' +
      'ssion1;company2\)'
    Enabled = False
    TabOrder = 11
  end
  object CBX_KiTTY_Sort_Directories_First: TCheckBox
    Left = 10
    Top = 266
    Width = 267
    Height = 21
    Caption = 'Sort KiTTY directories before KiTTY files'
    Enabled = False
    TabOrder = 12
  end
  object CBX_KiTTY_Sort_Directories_Case_Insensitive: TCheckBox
    Left = 10
    Top = 295
    Width = 267
    Height = 21
    Caption = 'Sort KiTTY directories case insensitive'
    Enabled = False
    TabOrder = 13
  end
  object CBX_KiTTY_Sort_Files_Case_Insensitive: TCheckBox
    Left = 10
    Top = 325
    Width = 267
    Height = 21
    Caption = 'Sort KiTTY files case insensitive'
    Enabled = False
    TabOrder = 14
  end
  object CBX_Search_For_Substrings: TCheckBox
    Left = 314
    Top = 293
    Width = 175
    Height = 21
    Caption = 'Search for substrings'
    TabOrder = 15
  end
  object CBX_Search_Key_Only_Session_Name: TCheckBox
    Left = 314
    Top = 269
    Width = 215
    Height = 21
    Caption = 'Search only the session name'
    TabOrder = 16
  end
  object DLG_OpenPutty: TOpenDialog
    FileName = 'putty.exe'
    Filter = 'Executables (*.exe)|*.exe|Any Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 384
    Top = 48
  end
end
