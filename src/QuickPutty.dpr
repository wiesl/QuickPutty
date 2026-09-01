program QuickPutty;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {FRM_Main},
  Config in 'Config.pas' {FRM_Config},
  BomeOneInstance in 'BomeOneInstance.pas';

{$R *.res}



begin
  Application.Initialize;
  Application.CreateForm(TFRM_Main, FRM_Main);
  Application.CreateForm(TFRM_Config, FRM_Config);
  Application.Run;
end.
