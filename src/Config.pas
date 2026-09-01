unit Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFRM_Config = class(TForm)
    Label1: TLabel;
    BTN_Cancel: TButton;
    BTN_Ok: TButton;
    DLG_OpenPutty: TOpenDialog;
    Label5: TLabel;
    Button1: TButton;
    EDT_PuttyPath: TLabeledEdit;
    GRB_Transparency: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TRB_Transparency: TTrackBar;
    CBX_UseTransparency: TCheckBox;
    CBX_AlwayOnTop: TCheckBox;
    CBX_AutoRun: TCheckBox;
    GRB_StartMenu: TGroupBox;
    CBX_Sessions: TCheckBox;
    CBX_Sessions_StartMenu: TCheckBox;
    BTN_CreateStartMenu: TButton;
    BTN_RemoveStartMenu: TButton;
    CBX_Sessions_Autoupdate: TCheckBox;
    CBX_SystemWideHotkey: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure BTN_OkClick(Sender: TObject);
    procedure BTN_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TRB_TransparencyChange(Sender: TObject);
    procedure CBX_UseTransparencyClick(Sender: TObject);
    procedure CBX_AlwayOnTopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BTN_CreateStartMenuClick(Sender: TObject);
    procedure BTN_RemoveStartMenuClick(Sender: TObject);
  private
    { Private declarations }
    procedure InfoMessage(Text: String);
    procedure ErrorMessage(Text: String);    
  public
    { Public declarations }
    procedure CreateSessionShortCuts(OnStartMenu: Boolean; PuttyPath: String);
  end;

var
  FRM_Config: TFRM_Config;

implementation

uses Main, Registry, ShortCuts;

var
  Reg : TRegistry;

{$R *.dfm}

procedure TFrm_Config.InfoMessage(Text: String);
begin
  MessageBox(Handle, PChar(Text), kApplicationName, MB_OK + MB_ICONINFORMATION);
end;

procedure TFrm_Config.ErrorMessage(Text: String);
begin
  MessageBox(Handle, PChar(Text), kApplicationName, MB_OK + MB_ICONERROR);
end;

procedure TFrm_Config.CreateSessionShortCuts(OnStartMenu: Boolean; PuttyPath: String);
var
  Reg: TRegistry;
  i : integer;
  Sessions: TStrings;
  SessionsDir: String;
  Session: String;
begin
  // Read Registry and populate mainform on ListBox
  Reg := TRegistry.Create;
  Sessions := TStringList.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\SimonTatham\PuTTY\Sessions', True) then
   begin
      Reg.GetKeyNames(Sessions);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;

  if OnStartMenu then
    SessionsDir := GetStartMenuDir(Handle) + '\PuTTY Sessions'
  else
    SessionsDir := GetProgramsDir(Handle) + '\PuTTY\PuTTY Sessions';

  DeleteDir(SessionsDir); // Don't care about the result and hope for the best ;-)
  CreateDir(SessionsDir);

  for i:=0 to Sessions.Count-1 do
  begin
    // special character handling by Putty
    Session := Frm_Main.url_unquote(Sessions[i]);
    CreateShortCut(SessionsDir + '\' + Session + '.lnk',
                   PuttyPath, '-load "' + Session + '"'); // Use new PuTTY 0.53 syntax.
  end;
  Sessions.Free;
end;

procedure TFRM_Config.Button1Click(Sender: TObject);
begin
  if EDT_PuttyPath.Text='' then DLG_OpenPutty.InitialDir:='C:\Program Files';
  if DLG_OpenPutty.Execute then
  begin
    EDT_PuttyPath.Text:=DLG_OpenPutty.FileName;
  end;
end;

procedure TFRM_Config.BTN_OkClick(Sender: TObject);
begin
  if not FileExists(EDT_PuttyPath.Text) then
  begin
    ErrorMessage('File ''' + EDT_PuttyPath.Text + ''' does not exist!');
    EDT_PuttyPath.SetFocus;
  end
  else
  begin
    FRM_Main.PuttyPath:=EDT_PuttyPath.Text;

    // Handle AutoRun feature.
    if CBX_AutoRun.Checked then
    begin
      // Add QuickPutty to Run registry.
      if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
      begin
        Reg.WriteString(kApplicationName, '"' + Application.ExeName + '"');
        Reg.CloseKey;
      end;
    end
    else
    begin
      // Remove QuickPutty from Run registry.
      if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
      begin
        Reg.DeleteValue(kApplicationName);
        Reg.CloseKey;
      end;
    end;

    // Handle Auto Update Sessions feature
    if CBX_Sessions_Autoupdate.Checked then
    begin
      // Add QuickPutty -updatesessions to Run registry.
      if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
      begin
        Reg.WriteString(kApplicationName + 'AutoUpdateSessions', '"' + Application.ExeName + '" -updatesessions');
        Reg.CloseKey;
      end;
    end
    else
    begin
      // Remove QuickPutty -updatesessions from Run registry.
      if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
      begin
        Reg.DeleteValue(kApplicationName + 'AutoUpdateSessions');
        Reg.CloseKey;
      end;
    end;

    FRM_Main.SessionShortCuts := CBX_Sessions.Checked;
    FRM_Main.SessionsStartMenu := CBX_Sessions_StartMenu.Checked;
    FRM_Main.SystemWideHotKey:=CBX_SystemWideHotkey.Checked;

    Close;
  end;
end;

procedure TFRM_Config.BTN_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFRM_Config.FormShow(Sender: TObject);
begin
  // Initialize TRegistry object
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.LazyWrite := true;

  EDT_PuttyPath.Text:=FRM_Main.PuttyPath;
  TRB_Transparency.Position:=FRM_Main.AlphaBlendValue;
  CBX_UseTransparency.Checked:=FRM_Main.AlphaBlend;
  CBX_AlwayOnTop.Checked:=(FRM_Main.FormStyle=fsStayOnTop);
  CBX_SystemWideHotkey.Checked:=(FRM_Main.SystemWideHotKey);

  // Check if AutoRun feature is enabled.
  if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
  begin
    CBX_AutoRun.Checked := Reg.ValueExists(kApplicationName);
    Reg.CloseKey;
  end;

  // Check if Auto Update Sessions is enabled.
  if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', False) then
  begin
    CBX_Sessions_Autoupdate.Checked := Reg.ValueExists(kApplicationName + 'AutoUpdateSessions');
    Reg.CloseKey;
  end;

  CBX_Sessions.Checked := FRM_Main.SessionShortCuts;
  CBX_Sessions_StartMenu.Checked := FRM_Main.SessionsStartMenu;
end;

procedure TFRM_Config.TRB_TransparencyChange(Sender: TObject);
begin
  FRM_Main.AlphaBlendValue:=TRB_Transparency.Position;
end;

procedure TFRM_Config.CBX_UseTransparencyClick(Sender: TObject);
begin
  FRM_Main.AlphaBlend:= CBX_UseTransparency.Checked;
end;

procedure TFRM_Config.CBX_AlwayOnTopClick(Sender: TObject);
begin
  if CBX_AlwayOnTop.Checked
  then FRM_Main.FormStyle:=fsStayOnTop
  else FRM_Main.FormStyle:=fsNormal;
end;

procedure TFRM_Config.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Reg.Free;
end;

procedure TFRM_Config.BTN_CreateStartMenuClick(Sender: TObject);
var
  PuttyDir: String;
  FileName: String;
begin
  PuttyDir := GetProgramsDir(Handle) + '\PuTTY';
  if not DirectoryExists(PuttyDir) then
    CreateDir(PuttyDir);

  FileName := PuttyDir + '\PuTTY.lnk';
  if FileExists(FileName) then
    DeleteFile(FileName);
  CreateShortCut(FileName, EDT_PuttyPath.Text);

  FileName := PuttyDir + '\' + kApplicationName + '.lnk';
  if FileExists(FileName) then
    DeleteFile(FileName);
  CreateShortCut(FileName, Application.ExeName);

  If CBX_Sessions.Checked then
  begin
    CreateSessionShortCuts(CBX_Sessions_StartMenu.Checked, EDT_PuttyPath.Text);
    // Create shortcut for update sessions.
    FileName := PuttyDir + '\Update Session Shortcuts.lnk';
    if FileExists(FileName) then
      DeleteFile(FileName);
    CreateShortCut(FileName, Application.ExeName, '-updatesessions');
  end;

  InfoMessage('Start Menu shortcuts have been created');
end;

procedure TFRM_Config.BTN_RemoveStartMenuClick(Sender: TObject);
var
  SessionsDir: String;
  MsgBoxRes: Integer;
  Res: Boolean;
begin
  Res := True;
  SessionsDir := GetStartMenuDir(Handle) + '\PuTTY Sessions';
  if DirectoryExists(SessionsDir) then
  begin
    MsgBoxRes := MessageBox(Handle, 'Would you like to remove the session shortcuts on the Start Menu too?',kApplicationName, MB_YESNO + MB_ICONQUESTION);
    if MsgBoxRes = IDYES then
      Res := DeleteDir(SessionsDir);
  end;

  if DeleteDir(GetProgramsDir(Handle) + '\PuTTY') and Res then
    InfoMessage('Start Menu shortcuts have been removed')
  else
    ErrorMessage('Unable to delete some of the Start Menu shortcuts');
end;

end.
