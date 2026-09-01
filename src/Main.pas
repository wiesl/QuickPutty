unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ActnList, StdCtrls, ShellAPI, ExtCtrls, BomeOneInstance;

const
  CRLF=#10;
  kApplicationName='QuickPutty';
  kVersion = 'v1.1.5';
  kFullApplicationName=kApplicationName+' '+kVersion;
  kCopyright = '(c)2001-2003 Olivier DECKMYN, olivier@deckmyn.org';
  kLicense= 'This software complies to LGPL license, see http://www.gnu.org/licenses/lgpl.txt';
  kDocumentation = 'This stupid software is only an humble help to launch the marvelous Putty application.'+CRLF+
                   'It show the list of existing sessions, stored by Putty in Registry.'+CRLF+CRLF+
                   'Usage:'+CRLF+
                   ' - Right-click for menu, '+CRLF+
                   ' - Double-click to open session, '+CRLF+
                   ' - Ctrl-N to open a virgin/empty session, '+CRLF+
                   ' - Double-click on tray icon to show/hide sessions list'+CRLF+
                   ' - Use ALT-Q from Windows to show/hide QuickPutty'+CRLF+CRLF+
                   'Use PAgeant (see putty website) to avoid typing your password too.';

const
  WM_MYTRAYICONCALLBACK = WM_USER + 1;

type
  TFRM_Main = class(TForm)
    LSV_Hosts: TListBox;
    PopupMenu1: TPopupMenu;
    Update1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ACL_Main: TActionList;
    ACT_PopulateHostList: TAction;
    ACT_Config: TAction;
    Configuration1: TMenuItem;
    ACT_Help: TAction;
    N2: TMenuItem;
    Help1: TMenuItem;
    ACT_ShowHide: TAction;
    ShowHide1: TMenuItem;
    MNI_Sessions: TMenuItem;
    FakeMenu: TMenuItem;
    ACT_Exit: TAction;
    ACT_NewSession: TAction;                             //Added by Pat
    ACT_SaveConfig: TAction;
    SaveConfig1: TMenuItem;
    N3: TMenuItem;

    procedure Exit1Click(Sender: TObject);
    procedure ACT_PopulateHostListExecute(Sender: TObject);
    procedure LSV_HostsDblClick(Sender: TObject);
    procedure ACT_ConfigExecute(Sender: TObject);

    procedure ACT_NewSessionExecute(Sender: TObject);    //Added by Pat
    procedure FormCreate(Sender: TObject);
    procedure ACT_HelpExecute(Sender: TObject);
    procedure ACT_ShowHideExecute(Sender: TObject);
    procedure FakeMenuClick(Sender: TObject);
    procedure ACT_ExitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HotKeyActivate(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure LSV_HostsKeyPress(Sender: TObject; var Key: Char);
    procedure ACT_SaveConfigExecute(Sender: TObject);
  private
    { Private declarations }
    procedure WMMyTrayIconCallback(var Msg:TMessage); message WM_MYTRAYICONCALLBACK;
  protected
    OneInstance : TOneInstance;
    procedure WndProc(var Msg : TMessage); override;
    procedure WMActivate(var msg:TMessage);message WM_ACTIVATE;
    procedure SwitchVisible(aVisible : Integer=-1);
    procedure OpenSelectedSession;
  public
    { Public declarations }
    PuttyPath : String;
    IconData : TNotifyIconData;
    IconCount : integer;
    SystemWideHotKey : boolean;
    procedure Populate();
    function url_unquote(s:string): string;
    procedure WriteConfig();
    procedure ReadConfig();
    procedure OpenSession(name : String);
  end;

var
  FRM_Main: TFRM_Main;

implementation

{$R *.dfm}

uses
  Registry, Config, IniFiles;

const
  kSectionName = 'Application';

function GetIniFileName:String;
begin
  result:=ExtractFilePath(Application.ExeName)+'quickputty.ini';
end;

procedure TFRM_Main.WndProc(var Msg : TMessage);
var
  p : TPoint;
begin
  case Msg.Msg of
    WM_USER + 1:
    case Msg.lParam of
      WM_RBUTTONDOWN: begin
         SetForegroundWindow(Handle);
         GetCursorPos(p);
         PopupMenu1.Popup(p.x, p.y);
         PostMessage(Handle, WM_NULL, 0, 0);
      end
    end;
  end;
  inherited;
end;

procedure TFRM_Main.WMMyTrayIconCallback(var Msg:TMessage);
begin
  case Msg.lParam of
    WM_LBUTTONDBLCLK  :
      begin
        SwitchVisible;
      end;
  end;
end;

procedure TFRM_Main.Populate();
var
  Reg: TRegistry;
  i : integer;
  item : TMenuItem;
begin
  // Read Registry and populate mainform on ListBox
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\SimonTatham\PuTTY\Sessions', True) then
   begin
      Reg.GetKeyNames(LSV_Hosts.Items);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  // Populate menu
  MNI_Sessions.Clear;
  for i:=0 to LSV_Hosts.Items.Count-1 do
  begin
    item := TMenuItem.Create(Self);
    with item do
    begin
      // special character handling by Putty
      LSV_Hosts.Items[i]:=url_unquote(LSV_Hosts.Items[i]);
      Caption:=LSV_Hosts.Items[i];
      OnClick:=FakeMenuClick;
    end;
    MNI_Sessions.Add(Item);
  end;

end;

function TFRM_Main.url_unquote(s:string): string; // Thanx to Ulrich Breckel
var
  i,j:integer;
begin
  result := '';
  while (Length(s) > 0) do
  begin
    if (s[1] = '%') and (Length(s) > 2) then
    begin
      i := ord(s[2]) - ord('0');
      if (i>9) then dec(i,7);
      j := ord(s[3]) - ord('0');
      if (j>9) then dec(j,7);
      result := result + chr(i*16+j);
      Delete(s,1,3);
    end
    else
    begin
      result := result + s[1];
      Delete(s,1,1);
    end;
  end;
end;

procedure TFRM_Main.WriteConfig();
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(GetIniFileName);
  try
    ini.WriteInteger(kSectionName, 'width', Width);
    ini.WriteInteger(kSectionName, 'height', Height);
    ini.WriteInteger(kSectionName, 'left', Left);
    ini.WriteInteger(kSectionName, 'top', Top);
    ini.WriteBool(kSectionName, 'visible', Visible);
    ini.WriteString(kSectionName, 'PuttyPath', PuttyPath);
    ini.WriteInteger(kSectionName, 'alpha', AlphaBlendValue);
    ini.WriteBool(kSectionName, 'usealpha', AlphaBlend);
    ini.WriteBool(kSectionName, 'alwaysontop', (FormStyle=fsStayOnTop));
    ini.WriteBool(kSectionName, 'systemwidehotkey', SystemWideHotKey);
  finally
    ini.Free;
  end;
end;

procedure TFRM_Main.ReadConfig();
var
  ini : TIniFile;
  lBool : Boolean;
begin
  lBool:=True;
  ini := TIniFile.Create(GetIniFileName);
  try
    Width:=ini.ReadInteger(kSectionName, 'width', Width);
    Height:=ini.ReadInteger(kSectionName, 'height', Height);
    Left:=ini.ReadInteger(kSectionName, 'left', Left);
    Top:=ini.ReadInteger(kSectionName, 'top', Top);
    try
      lBool:=ini.ReadBool(kSectionName, 'visible', Visible);
      if lBool then SwitchVisible(1) else SwitchVisible(0);
      AlphaBlend:=ini.ReadBool(kSectionName, 'usealpha', AlphaBlend);
      lBool:=ini.ReadBool(kSectionName, 'alwaysontop', True);
    except
    end;
    if lBool then FormStyle:=fsStayOnTop else FormStyle:=fsNormal;
    PuttyPath:=ini.ReadString(kSectionName, 'PuttyPath', PuttyPath);
    AlphaBlendValue:=ini.ReadInteger(kSectionName, 'alpha', AlphaBlendValue);
    SystemWideHotKey:=ini.ReadBool(kSectionName, 'systemwidehotkey', True)
  finally
    ini.Free;
  end;
end;

procedure TFRM_Main.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFRM_Main.ACT_PopulateHostListExecute(Sender: TObject);
begin
  Populate;
end;

procedure TFRM_Main.LSV_HostsDblClick(Sender: TObject);
begin
  OpenSelectedSession;
end;

procedure TFRM_Main.OpenSession(name :String);
var
  cmd : String;
begin
  cmd:=PuttyPath;
  if name<>''
  then cmd:=cmd+' -load '+name;
  WinExec(pchar(cmd), SW_SHOWNORMAL);
end;


procedure TFRM_Main.ACT_NewSessionExecute(Sender: TObject);   //Added by Pat
begin                                                         //Added by Pat
  OpenSession('');
end;                                                          //Added by Pat


procedure TFRM_Main.ACT_ConfigExecute(Sender: TObject);
begin
  FRM_Config.ShowModal;
end;

procedure TFRM_Main.FormCreate(Sender: TObject);
begin
  OneInstance:=TOneInstance.Create(self);
  OneInstance.Init;
  // Handle TaskBar removal
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
                GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW );
  // Handle Tray Icon
  BorderIcons := [biSystemMenu];
  IconCount := 0;
  IconData.cbSize := sizeof(IconData);
  IconData.Wnd := Handle;
  IconData.uID := 100;
  IconData.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
  IconData.uCallBackMessage := WM_MYTRAYICONCALLBACK;
  IconData.hIcon := Application.Icon.Handle;
  StrPCopy(IconData.szTip, Application.Title);
  Shell_NotifyIcon(NIM_ADD, @IconData);
  // Read Config and Populate list
  ReadConfig;
  Populate;
  // Set System-Wide HotKey
  If SystemWideHotKey then RegisterHotKey(Self.Handle,Ord('Q')-64,MOD_ALT,Ord('Q'));
end;

// Handle TaskBar Removal
procedure TFRM_Main.WMActivate(var msg: TMessage);
var
  wp:WINDOWPLACEMENT;
begin
  wp.flags:=WPF_SETMINPOSITION;
  wp.showCmd:=SW_HIDE;
  wp.ptMinPosition.x:=-1000;
  wp.ptMinPosition.y:=-1000;
  wp.length:=sizeof(WINDOWPLACEMENT);
  SetWindowPlacement(Application.Handle,@wp);
end;

procedure TFRM_Main.ACT_HelpExecute(Sender: TObject);
var
  msg : String;
begin
  msg := kFullApplicationName+CRLF+kCopyright+CRLF+CRLF+kDocumentation+CRLF+CRLF+kLicense;
  ShowMessage(msg);
end;

procedure TFRM_Main.ACT_ShowHideExecute(Sender: TObject);
begin
  FRM_Main.Visible:=not FRM_Main.Visible;
end;

procedure TFRM_Main.FakeMenuClick(Sender: TObject);
begin
  With TMenuItem(Sender) do
  begin
    OpenSession(Caption);
  end;
end;

procedure TFRM_Main.ACT_ExitExecute(Sender: TObject);
begin
  WriteConfig;
  Shell_NotifyIcon(NIM_DELETE, @IconData);   // Remove Tray Icon
  Application.ProcessMessages;
  Application.Terminate; // Kill Application
end;

procedure TFRM_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Visible:=False;
  Action:=caNone;
end;

procedure TFRM_Main.SwitchVisible(aVisible : Integer=-1);
begin
  if aVisible<>-1
  then Visible := (aVisible=1)
  else Visible := not Visible; { reverse visibility state }

  { set showing of mainform to visibility state }
  Application.ShowMainForm := Visible;

  If Visible then
  begin
    SetFocus;
    LSV_Hosts.SetFocus;
    ActiveControl:=LSV_Hosts;
  end;
end;


procedure TFRM_Main.HotKeyActivate(var Msg: TWMHotKey);
begin
  SwitchVisible;
end;

procedure TFRM_Main.LSV_HostsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then OpenSelectedSession;
end;

procedure TFRM_Main.OpenSelectedSession;
begin
  if LSV_Hosts.ItemIndex<>-1 then OpenSession(LSV_Hosts.Items[LSV_Hosts.ItemIndex]);
end;


procedure TFRM_Main.ACT_SaveConfigExecute(Sender: TObject);
begin
  WriteConfig;
end;

end.

