unit ShortCuts;

(*
  Delphi unit for creating start menu (or other) shortcuts, aka
  Shell Links.

  By Henrik Djärv <henrik.djarv@home.se>, 2003.
*)

interface

uses Windows;

(*
  Creates a shortcut (Shell Link).
  The directory where the shortcut is created must exist.
*)
procedure CreateShortCut(ShortCut, Application, Parameters, WorkDir: string;
                         SW_State: Integer; IconFile: string;
                         IconIndex: Byte); overload;

(*
  Creates a shortcut (Shell Link).
  The directory where the shortcut is created must exist.
*)
procedure CreateShortCut(ShortCut, Application, Parameters: String); overload;

(*
  Creates a shortcut (Shell Link).
  The directory where the shortcut is created must exist.
*)
procedure CreateShortCut(ShortCut, Application: String); overload;


(*
  Gets the programs directory on the start menu for the current user.
*)
function GetProgramsDir(Handle: HWND): String;

(*
  Gets the start menu directory for the current user.
*)
function GetStartMenuDir(Handle: HWND): String;


(*
  Deletes a directory even if there are files
  or sub-directories in it.

  A return value of True means that all files and sub-directories
  were successfully deleted, or that the directory didn't exist.
  If it's false, some of the files and sub-directories may have been deleted.
*)
function DeleteDir(Const Directory: String): Boolean;

implementation

uses ShlObj, ActiveX, ComObj, SysUtils, Dialogs (*remove*);

procedure CreateShortCut(ShortCut, Application, Parameters, WorkDir:
string; SW_State: Integer; IconFile: string; IconIndex: Byte); overload;
var
  SCObject: IUnknown;
  SCSLink: IShellLink;
  SCPFile: IPersistFile;
  WFName: WideString;
begin
  SCObject := CreateComObject(CLSID_ShellLink);
  SCSLink := SCObject as IShellLink;
  SCPFile := SCObject as IPersistFile;
  SCSLink.SetPath(PChar(Application));
  SCSLink.SetArguments(PChar(Parameters));
  SCSLink.SetWorkingDirectory(PChar(WorkDir));
  SCSLink.SetShowCmd(SW_State);
  SCSLink.SetIconLocation(PChar(IconFile), IconIndex);
  WFName := ShortCut;
  SCPFile.Save(PWChar(WFName), False);
end;

procedure CreateShortCut(ShortCut, Application, Parameters: String); overload;
var
  SCObject: IUnknown;
  SCSLink: IShellLink;
  SCPFile: IPersistFile;
  WFName: WideString;
begin
  SCObject := CreateComObject(CLSID_ShellLink);
  SCSLink := SCObject as IShellLink;
  SCPFile := SCObject as IPersistFile;
  SCSLink.SetPath(PChar(Application));
  SCSLink.SetArguments(PChar(Parameters));
  WFName := ShortCut;
  SCPFile.Save(PWChar(WFName), False);
end;

procedure CreateShortCut(ShortCut, Application: String); overload;
var
  SCObject: IUnknown;
  SCSLink: IShellLink;
  SCPFile: IPersistFile;
  WFName: WideString;
begin
  SCObject := CreateComObject(CLSID_ShellLink);
  SCSLink := SCObject as IShellLink;
  SCPFile := SCObject as IPersistFile;
  SCSLink.SetPath(PChar(Application));
  WFName := ShortCut;
  SCPFile.Save(PWChar(WFName), False);
end;


(*
  Gets the path for a special folder (such as Start Menu)
*)
function GetSpecialFolderPath(Handle: HWND; Folder: Integer): String;
var
  S: PChar;
begin
  GetMem(S, MAX_PATH + 1);
  SHGetSpecialFolderPath(Handle, S, Folder, false);
  GetSpecialFolderPath := S;
  FreeMem(S);
end;

function GetProgramsDir(Handle: HWND): String;
begin
  GetProgramsDir := GetSpecialFolderPath(Handle, CSIDL_PROGRAMS);
end;

function GetStartMenuDir(Handle: HWND): String;
begin
  GetStartMenuDir := GetSpecialFolderPath(Handle, CSIDL_STARTMENU);
end;

function DeleteDir(Const Directory: String): Boolean;
var
  FRec: TSearchRec;
  i: Integer;
  Name: String;
  Res: Boolean;
  R2: Boolean;
begin
  Res := DirectoryExists(Directory);
  if Res then
  begin
    try
      i := FindFirst(Directory + '\*.*', faDirectory, FRec);
      while i = 0 do
      begin
        Name := FRec.Name;
        if (Name <> '.') and (Name <> '..') then
        begin
          if DirectoryExists(Directory + '\' + Name) then
          begin
            R2 := DeleteDir(Directory + '\' + Name);
            if Res then  // This means that a previous False value won't be replaced with a True (since something went wrong earlier).
              Res := R2; // Everything went ok before, replace with result from last operation.
          end
          else
          begin
            R2 := DeleteFile(Directory + '\' + Name);
            if Res then
              Res := R2;
          end;
        end;
        i := FindNext(FRec);
      end;
    finally
      FindClose(FRec);
    end;

    R2 := RemoveDir(Directory);
    if Res then
      Res := R2;
  end
  else
    Res := True;  // The directory didn't exist. Return true (=it's ok to create the dir).

  DeleteDir := Res;
end;

end.


(*

Special folder constants.

CSIDL_BITBUCKET	        Recycle bin ¾ file system directory containing file objects in the user's recycle bin. The location of this directory is not in the registry; it is marked with the hidden and system attributes to prevent the user from moving or deleting it.
CSIDL_CONTROLS	        Control Panel ¾ virtual folder containing icons for the control panel applications.
CSIDL_DESKTOP	          Windows desktop ¾ virtual folder at the root of the name space.
CSIDL_DESKTOPDIRECTORY  File system directory used to physically store file objects on the desktop (not to be confused with the desktop folder itself).
CSIDL_COMMON_DESKTOPDIRECTORY
CSIDL_DRIVES	          My Computer ¾ virtual folder containing everything on the local computer: storage devices, printers, and Control Panel. The folder may also contain mapped network drives.
CSIDL_FONTS	            Virtual folder containing fonts.
CSIDL_NETHOOD	          File system directory containing objects that appear in the network neighborhood.
CSIDL_NETWORK	          Network Neighborhood ¾ virtual folder representing the top level of the network hierarchy.
CSIDL_PERSONAL	        File system directory that serves as a common respository for documents.
CSIDL_PRINTERS	        Printers folder ¾ virtual folder containing installed printers.
CSIDL_PROGRAMS	        File system directory that contains the user's program groups (which are also file system directories).
CSIDL_COMMON_PROGRAMS
CSIDL_RECENT	          File system directory that contains the user's most recently used documents.
CSIDL_SENDTO	          File system directory that contains Send To menu items.
CSIDL_STARTMENU	        File system directory containing Start menu items.
CSIDL_STARTUP	          File system directory that corresponds to the user's Startup program group.
CSIDL_TEMPLATES	        File system directory that serves as a common repository for document templates.
*)