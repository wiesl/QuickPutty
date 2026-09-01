program QuickPutty;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {FRM_Main},
  Config in 'Config.pas' {FRM_Config},
  BomeOneInstance in 'BomeOneInstance.pas',
  ShortCuts in 'ShortCuts.pas',
  SysUtils, ShellAPI, IniFiles;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFRM_Main, FRM_Main);
  Application.CreateForm(TFRM_Config, FRM_Config);
  if FindCmdLineSwitch('updatesessions') then
  begin
    FRM_Config.CreateSessionShortCuts(FRM_Main.SessionsStartMenu, FRM_Main.PuttyPath);
    Shell_NotifyIcon(NIM_DELETE, @FRM_Main.IconData);   // Remove Tray Icon
    Application.ProcessMessages;
    Application.Terminate; // Kill Application
  end;
  Application.Run;
end.
