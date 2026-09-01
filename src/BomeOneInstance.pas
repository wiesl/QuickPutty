unit BomeOneInstance;

{ The TOneInstance Component, V1.01

  MOST IMPORTANT :)
  =================
  This is Freeware: However, it's also PostcardWare. When you use
  this component or think it's useful, send me a post-card
  to: Florian Bömers, Colmarer Str.11, D - 28211 Bremen, Germany
  See legal.txt for more details.

  And of course, I am very interested in any application
  that uses this component (or any other application you wrote).
  If so, mail me (not the program, just an URL or similar) !
  (mail address below)


  OVERVIEW
  ========
  This component prevents that your application may be started
  more than once.
  To the first instance are passed the parameters with which the
  second instance was started. The first instance is shown and
  the second instance is closed (= never shown).
  Special handling occurs when the first instance doesn't react
  during 10 seconds: in this case the second instance will start
  nonetheless.

  COMPATIBILITY
  =============
  Delphi 2,3,4
  Windows 95, 98, NT4, NT2000 (Beta3)

  INSTALLATION
  ============
  1. Copy the File BomeOneInstance.pas and BomeOneInstance.dcr to the
     directory where you store your components
     (or let it where it is)
  2. In Delphi, select Component|Install Component. In the
     following dialog, enter the path and filename of
     BomeOneInstance.pas and hit OK.
  3. Now the TOneInstance Component is available in the
     Component palette under Bome.


  HOW TO USE IT
  =============
  Drop it on a form or in a data module.


  PROPERTIES
  ==========
  ShowOnNewInstance
  When this property is true, the first instance will be shown when
  a second instance is started. When the first instance is minimized,
  it will be restored.

  UseHaltToExit
  When this property is true, the Halt command is used to stop the
  second instance. Otherwise a regular "Application.Terminate" will
  be executed. Halt may be necessary in rare cases to prevent
  popping up of splash screens or similar.

  OnInstanceStarted
  This event is fired in the FIRST instance when a second instance
  is started. As parameter will be passed a StringList which
  contains all parameters with which the second instance was started.
  Don't free the StringList, this will be done by the component.


  INTERNALS
  =========
  The component works like this:
  When it is in the first instance, it creates a shared memory block
  and an invisible window. In the shared memory it writes the window
  handle of the internal window.

  When a second instance is started, it detects the presence of the
  shared memory block which means that there is already running
  an instance. It writes the parameters into the shared memory block
  and posts a message to the internal window of the first instance.
  Then the second instance quits.

  When the first instance receives this message, it reads the
  parameters from the shared memory and fires the event with the
  parameter list as parameter. It restores and brings to front
  the application when ShowOnNewInstance is true.

  The shared memory is protected by a semaphore. The semaphore object
  is used here like a mutex, only that the semaphore may be released
  by another process than the one that set it.
  The Lock procedure waits for a maximum of 10 seconds to get the
  semaphore. When it doesn't get it, it is assumed that the first
  instance is down. The first instance will release the semaphore
  when it processed the parameters. The second issues another lock
  in order to wait for the first instance to release it.
  This mechanism makes it possible to start many instances at once
  from the explorer (for example by clicking on the document file type)
  and all documents will be charged by the first appearing instance.

  CREDITS
  =======
  This component is partially based on
  "Fnugry Single Instance Component", Version 1.0.0.1,
  (c) 1996-97 by Gleb Yourchenko


  CONTACT, NEW VERSIONS
  =====================
  Send any comments, proposals, enhancements etc. to
  delphi@bome.com
  The latest version of this component can be found on
  http://www.bome.com/


  COPYRIGHT
  =========
  (c) 1999 by Florian Bömers


  VERSION HISTORY
  ===============
  V1.01 Now possible to compile with Delphi 4 (25 Mar 99)
  V1.00 initial release
}


interface

uses
  Windows, SysUtils, Messages, Classes, Forms;

type
  // don't free "params" in the app, this is done by this component
  TOnInstanceStarted = procedure(Sender :TObject; params:TStringList) of object;

const MAX_PARAM_SIZE=300; // size of one parameter in characters
      MAX_PARAMS=10;      // maximum number of parameters
      MSG_2ND_INSTANCE=wm_user+300; // message that is sent to the
                                    // internal window

type
  // this is the structure to hold data that is used in
  // both instances.
  PInstInfo = ^TInstInfo;
  TInstInfo = packed record
    FirstInstanceWnd:HWND;
    ParamCount:Integer;
    Params:Array[0..MAX_PARAMS-1, 0..MAX_PARAM_SIZE] of Char;
  end;



 TOneInstance = class(TComponent)
  private
     FMappingHandle:THandle;
     HWNDHandle:THandle;
     HSemaphore:THandle;
     FShowOnNewInstance:Boolean;
     FUseHaltToExit:Boolean;
     FOnInstanceStarted:TOnInstanceStarted;
     procedure DestroySemaphore;
     function Lock:Boolean;
     function Unlock:Boolean;
     procedure ImTheFirstInstance(lpInfo:PInstInfo);
     procedure ImTheSecondInstance(var lpInfo:PInstInfo);
     procedure OnHWNDEvent(var Message: TMessage);
     function getIsFirstInstance:Boolean;
  protected
     procedure Loaded; override;
     procedure InstanceStarted(params:TStringList); virtual;
  public
     constructor Create(AOwner :TComponent); override;
     destructor Destroy; override;
     function Init:Boolean; // returns whether it is first instance
     property IsFirstInstance:Boolean read getIsFirstInstance;
  published
     property ShowOnNewInstance:Boolean
       read FShowOnNewInstance write FShowOnNewInstance default true;
     property UseHaltToExit:Boolean
       read FUseHaltToExit write FUseHaltToExit default false;
     property OnInstanceStarted:TOnInstanceStarted
       read FOnInstanceStarted write FOnInstanceStarted;
  end;

procedure Register;

implementation

// this variable is to prevent multiple times this component in
// your application (like a mutex...)
var
  SingleInstInstance :TComponent = nil;

// this procedure will be called in the first instance
// when a second instance is started
procedure TOneInstance.InstanceStarted(params:TStringList);
begin
 // eventually show or restore the app
 if FShowOnNewInstance then
 begin
  Application.Restore;
  Application.BringToFront;
 end;
 // fire the event
 if assigned(FOnInstanceStarted) then
  FOnInstanceStarted(Self, params);
end;

// returns whether this is the first instance
// this may only be when the internal window has been allocated
function TOneInstance.getIsFirstInstance:Boolean;
begin
 result:=HWNDHandle<>0;
end;

constructor TOneInstance.Create(AOwner :TComponent);
begin
 // don't drop more than one of this component on the form !
 if SingleInstInstance <> nil then
  raise Exception.Create('Drop only one of these components on your form !');
 inherited Create(AOwner);
 SingleInstInstance := Self;
 FShowOnNewInstance:=true;
end;

destructor TOneInstance.Destroy;
begin
 // deallocate shared memory block
 if FMappingHandle <> 0 then
  CloseHandle(FMappingHandle);
 // deallocate internal window
 if HWNDHandle<>0 then
  DeallocateHwnd(HWNDHandle);
 // destroy semaphore
 DestroySemaphore;
 inherited Destroy;
 SingleInstInstance := nil;
end;

procedure TOneInstance.DestroySemaphore;
begin
 if HSemaphore<>0 then
  CloseHandle(HSemaphore);
 HSemaphore:=0;
end;

// window proc of the internal window
procedure TOneInstance.OnHWNDEvent(var Message: TMessage);
var tempStr:String;
    params:TStringList;
    lpInfo:PInstInfo;
    i:Integer;
begin
 if message.Msg=MSG_2ND_INSTANCE then
 begin
  // another instance was started...
  if FMappingHandle <> 0 then
  begin
   lpInfo := MapViewOfFile(FMappingHandle,
     FILE_MAP_WRITE OR FILE_MAP_READ, 0, 0, sizeof(TInstInfo));
   if lpInfo <> nil then
   try
    // get Parameters
    params:=TStringList.Create;
    try
     for i:=0 to lpInfo^.ParamCount-1 do
     begin
      SetString(tempStr,
       PChar(@(lpInfo^.Params[i,0])),
       StrLen(@(lpInfo^.Params[i,0])));
      params.Add(tempStr);
     end;
     // notify the app
     InstanceStarted(params);
    finally
     params.Free;
    end;
   finally
    UnmapViewOfFile(lpInfo);
    // and release the semaphore which was set by the other instance
    Unlock;
   end;
  end;
 end
 else
  with Message do
   Result := DefWindowProc(HWNDHandle, Msg, wParam, lParam);
end;

const
// missing in windows.pas
 STANDARD_RIGHTS_REQUIRED = $000F0000;
 SYNCHRONIZE = $00100000;
 SEMAPHORE_MODIFY_STATE = $0002;
 SEMAPHORE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or $3);


function TOneInstance.Lock:Boolean;
begin
 // when this function returns false, then we couldn't get
 // the semaphore. That means either that the first instance
 // is down or that the semaphore doesn't exist anymore.
 // in both cases we must take the role as first instance
 if HSemaphore=0 then
  HSemaphore:=OpenSemaphore(SEMAPHORE_ALL_ACCESS, false,
    PChar(ExtractFileName(ParamStr(0))+'Sem'));
 result:=HSemaphore<>0;
 if result then
 begin
  // wait for 10 seconds to become owner of the semaphore
  result:=(WaitForSingleObject(HSemaphore, 10000)=WAIT_OBJECT_0);
 end;
end;

function TOneInstance.Unlock:Boolean;
begin
 // give the semaphore back
 result:=false;
 if HSemaphore<>0 then
 begin
  result:=ReleaseSemaphore(HSemaphore, 1, nil);
 end;
end;

procedure TOneInstance.ImTheFirstInstance(lpInfo:PInstInfo);
begin
 // allocate the internal window
 HWNDHandle:=AllocateHwnd(OnHWNDEvent);
 // Create the semaphore object. It limits the access to the
 // shared memory block to one instance
 Unlock;
 DestroySemaphore;
 HSemaphore:=CreateSemaphore(nil, 0, 1,
   PChar(ExtractFileName(ParamStr(0))+'Sem'));
 assert(HSemaphore<>0,'Unable to create semaphore');
 // now write the internal window handle into the shared memory block
 lpInfo^.FirstInstanceWnd:=HWNDHandle;
 // release the semaphore
 Unlock;
end;

procedure TOneInstance.ImTheSecondInstance(var lpInfo:PInstInfo);
var i:Integer;
    tempStr:String;
begin
 if not Lock then
 begin
  // not successful to get the semaphore object
  // => the first instance is down
  ImTheFirstInstance(lpInfo);
  exit;
 end;
 // put the parameters in the shared memory block
 lpInfo^.ParamCount:=ParamCount;
 if lpInfo^.ParamCount>MAX_PARAMS then
  lpInfo^.ParamCount:=MAX_PARAMS;
 for i:=0 to lpInfo^.ParamCount-1 do
 begin
  tempStr:=ParamStr(i+1);
  if length(tempStr)>MAX_PARAM_SIZE then
   setLength(tempStr,MAX_PARAM_SIZE);
  StrCopy(@(lpInfo^.Params[i,0]),PChar(tempStr));
 end;
 // and notify the first instance
 PostMessage(lpInfo^.FirstInstanceWnd, MSG_2ND_INSTANCE, 0, 0);
 // the first instance must respond by releasing the semaphore
 // so we can wait for it to be released
 if not Lock then
 begin
  // not successful to get the semaphore object
  // => the first instance is down
  // and we become first instance
  ImTheFirstInstance(lpInfo);
  exit;
 end;
 Unlock;
 // destroy semaphore
 DestroySemaphore;
 // for security, release lpInfo
 UnmapViewOfFile(lpInfo);
 lpInfo:=nil;
 // don't flash main form
 Application.ShowMainForm:=false;
 // and exit !
 if FUseHaltToExit then
  Halt
 else
  Application.Terminate;
end;

function TOneInstance.Init:Boolean; // returns whether it is first instance
var
 lpInfo:PInstInfo;
begin
 // don't do anything when designing in Delphi
 if not (csDesigning in ComponentState) then
 begin
  // create shared memory block
  FMappingHandle := CreateFileMapping($FFFFFFFF, NIL,
         PAGE_READWRITE, 0, sizeof(TInstInfo),
         PChar(ExtractFileName(ParamStr(0))));
  if FMappingHandle <> 0 then
  begin
   // get pointer to shared memory block
   lpInfo := MapViewOfFile(FMappingHandle,
     FILE_MAP_WRITE OR FILE_MAP_READ, 0, 0, sizeof(TInstInfo));
   if lpInfo <> nil then
   try
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
     // another instance is already running
     ImTheSecondInstance(lpInfo);
    end
    else
    begin
     // OK, we are the first instance
     ImTheFirstInstance(lpInfo);
    end;
   finally
    if lpInfo<>nil then
     UnmapViewOfFile(lpInfo);
   end;
  end;
 end;
 result:=IsFirstInstance;
end;

procedure TOneInstance.Loaded;
begin
 inherited Loaded;
 Init;
end;

procedure Register;
begin
 RegisterComponents('Bome', [TOneInstance]);
end;

initialization
 SingleInstInstance:=nil;

finalization
 if SingleInstInstance <> nil then
  SingleInstInstance.Free;

end.
