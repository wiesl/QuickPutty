object FRM_Main: TFRM_Main
  Left = 820
  Top = 145
  Width = 168
  Height = 116
  AlphaBlend = True
  AlphaBlendValue = 150
  BorderStyle = bsSizeToolWin
  Caption = 'QuickPutty'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object LSV_Hosts: TListBox
    Left = 0
    Top = 0
    Width = 160
    Height = 79
    Align = alClient
    ItemHeight = 16
    TabOrder = 0
    OnDblClick = LSV_HostsDblClick
    OnKeyPress = LSV_HostsKeyPress
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 48
    Top = 8
    object MNI_Sessions: TMenuItem
      Caption = '&Sessions'
      object FakeMenu: TMenuItem
        OnClick = FakeMenuClick
      end
    end
    object NewSession1: TMenuItem
      Caption = 'New Session'
      ShortCut = 16462
      OnClick = NewSession1Click
    end
    object Update1: TMenuItem
      Action = ACT_PopulateHostList
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Configuration1: TMenuItem
      Action = ACT_Config
    end
    object SaveConfig1: TMenuItem
      Action = ACT_SaveConfig
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ShowHide1: TMenuItem
      Action = ACT_ShowHide
    end
    object Help1: TMenuItem
      Action = ACT_Help
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Action = ACT_Exit
    end
  end
  object ACL_Main: TActionList
    Left = 16
    Top = 8
    object ACT_PopulateHostList: TAction
      Caption = '&Update'
      ShortCut = 116
      OnExecute = ACT_PopulateHostListExecute
    end
    object ACT_Config: TAction
      Caption = '&Configuration'
      ShortCut = 113
      OnExecute = ACT_ConfigExecute
    end
    object ACT_Help: TAction
      Caption = '&Help'
      ShortCut = 112
      OnExecute = ACT_HelpExecute
    end
    object ACT_ShowHide: TAction
      Caption = 'Show/Hide'
      OnExecute = ACT_ShowHideExecute
    end
    object ACT_Exit: TAction
      Caption = 'Exit'
      OnExecute = ACT_ExitExecute
    end
    object ACT_SaveConfig: TAction
      Caption = 'Save Config'
      OnExecute = ACT_SaveConfigExecute
    end
  end
  object KeyTimer: TTimer
    Enabled = False
    OnTimer = DoKeyTimer
  end
end
