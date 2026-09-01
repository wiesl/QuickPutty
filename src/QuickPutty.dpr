program QuickPutty;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFDEF FPC}
  Interfaces,
{$ENDIF}
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
{$IFnDEF FPC}
    Shell_NotifyIcon(NIM_DELETE, @FRM_Main.IconData);   // Remove Tray Icon
{$ELSE}
    Shell_NotifyIconA(NIM_DELETE, @FRM_Main.IconData);   // Remove Tray Icon
{$ENDIF}
    Application.ProcessMessages;
    Application.Terminate; // Kill Application
  end;
  Application.Run;
end.
