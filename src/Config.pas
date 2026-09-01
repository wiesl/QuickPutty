unit Config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFRM_Config = class(TForm)
    Label1: TLabel;
    EDT_PuttyPath: TLabeledEdit;
    Button1: TButton;
    DLG_OpenPutty: TOpenDialog;
    Label2: TLabel;
    BTN_Cancel: TButton;
    BTN_Ok: TButton;
    TRB_Transparency: TTrackBar;
    Label3: TLabel;
    CBX_UseTransparency: TCheckBox;
    CBX_AlwayOnTop: TCheckBox;
    CBX_SystemWideHotkey: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure BTN_OkClick(Sender: TObject);
    procedure BTN_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TRB_TransparencyChange(Sender: TObject);
    procedure CBX_UseTransparencyClick(Sender: TObject);
    procedure CBX_AlwayOnTopClick(Sender: TObject);
    procedure CBX_SystemWideHotkeyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRM_Config: TFRM_Config;

implementation

uses Main;

{$R *.dfm}

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
  FRM_Main.PuttyPath:=EDT_PuttyPath.Text;
  Close;
end;

procedure TFRM_Config.BTN_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFRM_Config.FormShow(Sender: TObject);
begin
  EDT_PuttyPath.Text:=FRM_Main.PuttyPath;
  TRB_Transparency.Position:=FRM_Main.AlphaBlendValue;
  CBX_UseTransparency.Checked:=FRM_Main.AlphaBlend;
  CBX_AlwayOnTop.Checked:=(FRM_Main.FormStyle=fsStayOnTop);
  CBX_SystemWideHotkey.Checked:=(FRM_Main.SystemWideHotKey);
end;

procedure TFRM_Config.TRB_TransparencyChange(Sender: TObject);
begin
  FRM_Main.AlphaBlendValue:=TRB_Transparency.Position;
end;

procedure TFRM_Config.CBX_UseTransparencyClick(Sender: TObject);
begin
  FRM_Main.AlphaBlend:=CBX_UseTransparency.Checked;
end;

procedure TFRM_Config.CBX_AlwayOnTopClick(Sender: TObject);
begin
  if CBX_AlwayOnTop.Checked
  then FRM_Main.FormStyle:=fsStayOnTop
  else FRM_Main.FormStyle:=fsNormal;
end;

procedure TFRM_Config.CBX_SystemWideHotkeyClick(Sender: TObject);
begin
  FRM_Main.SystemWideHotKey:=CBX_SystemWideHotkey.Checked;
end;

end.
