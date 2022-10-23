unit TileCore;

interface

uses
  Winapi.Windows;

type
  TWinData = record
    WinID    : HWnd;
    WinTitle : string;
    WinClass : string;
  end;

  TWinsData = array of TWinData;

// Search for windows by substrings of Window Class and Window Title
// aHandle - handler of caller window or 0. If aHandle=0 caller window can be in search results
// Retrieves an array of found windows
function SearchWin(aHandle: HWnd; const aWinClass, aWinTitle: string): TWinsData;

// Hides windows of array A
procedure HideWin(const A: TWinsData);

// Closes windows of array A
procedure CloseWin(const A: TWinsData);

// Tiles windows of array A on working area of display R (WorkAreaRect)
// aHandle - handler of caller window or 0. If aHandle=0 caller window focus won't be returned back
// aCols - wanted amount of columns; aRows - wanted amount of rows
// aMode - tiling mode. true - rows first, false - columns first
procedure TileWin(aHandle: HWnd; R: TRect; aCols, aRows: integer; const A: TWinsData; aMode: boolean = true);

implementation

uses
  Winapi.Messages, System.SysUtils, System.Math;

// Variables for EnumProc
var
  WinArray: TWinsData;
  WinData: TWinData;
  WinTitleStr: string;
  WinClassStr: string;
  WinHandle: HWnd;

function EnumProc(WinID: HWnd; Param: LongInt): boolean; stdcall;
var
  WinTitle,                         // buffer for window title
  WinClass: array[0..255] of Char;  // buffer for window class
  SkipByFilter: boolean;
begin
    if (WinID <> WinHandle) and IsWindowVisible(WinID) then
    begin
      GetWindowText(WinID, WinTitle, 255);
      GetClassName(WinID, WinClass, 255);
    // filters
      SkipByFilter:= false;
      if Length(WinTitleStr) > 0 then
        if Pos(AnsiUpperCase(WinTitleStr), AnsiUpperCase(WinTitle)) = 0 then SkipByFilter:= true;
      if Length(WinClassStr) > 0 then
        if Pos(AnsiUpperCase(WinClassStr), AnsiUpperCase(WinClass)) = 0 then SkipByFilter:= true;

      if not SkipByFilter then
      begin
        WinData.WinID:= WinID;
        WinData.WinTitle:= WinTitle;
        WinData.WinClass:= WinClass;

        WinArray:= WinArray + [WinData];
      end;
    end;

  EnumProc:= true;
end;

function SearchWin(aHandle: HWnd; const aWinClass, aWinTitle: string): TWinsData;
begin
  WinHandle:= aHandle;
  WinClassStr:= aWinClass;
  WinTitleStr:= aWinTitle;
  SetLength(WinArray, 0);

  EnumWindows(@EnumProc, 0);

  Result:= WinArray;
end;

procedure HideWin(const A: TWinsData);
var
  WinData: TWinData;
begin
  for WinData in A do
    if not IsIconic(WinData.WinID) then
      ShowWindow(WinData.WinID, SW_MINIMIZE);
end;

procedure CloseWin(const A: TWinsData);
var
  WinData: TWinData;
begin
  for WinData in A do
    SendMessage(WinData.WinID, WM_SYSCOMMAND, SC_CLOSE, 0);
end;

procedure TileWin(aHandle: HWnd; R: TRect; aCols, aRows: integer; const A: TWinsData; aMode: boolean = true);
var
  RowsPerCol: word; // calculated amount of windows in a column
  iCol : integer;   // index of window column
  iRow : integer;   // index of window row
  WW : word;        // width of windows
  WH : word;        // height of windows
  I: integer;       // index of window in A
label
  BreakLoops;

  procedure TileWindow(const WinID: HWnd; const Row, Col: word);
  begin
    if IsIconic(WinID) then
      ShowWindow(WinID, SW_RESTORE);
    SetWindowPos(WinID,
                 HWND_NOTOPMOST,
                 Col * WW,
                 Row * WH,
                 WW,
                 WH,
                 SWP_SHOWWINDOW);
  end;

// make cursor visible (most simple but probably wrong way)
  procedure ScrlWindow(const WinID: HWnd);
  begin
    SendMessage(WinID, WM_VSCROLL, SB_TOP, 0);
    PostMessage(WinID, WM_KEYDOWN, VK_SPACE, 0);
    PostMessage(WinID, WM_KEYDOWN, VK_BACK, 0);
  end;

begin
  if Length(A) = 0 then Exit;

// Calculated amount of rows (windows in a column)
  SetRoundMode(rmUp);                 // round up
  RowsPerCol:= Round(Length(A)/aCols);
  if aRows < RowsPerCol then          // if wanted amount of rows less than calculated amount of rows
    aRows:= RowsPerCol;

// windows height
  WH:= R.Height div aRows;
// windows width
  WW:= R.Width div aCols;

  I:= 0;                              // 1st TWinsData element
  if aMode then                       // rows first
    begin
      for iRow:= 0 to aRows-1 do
        for iCol:= 0 to aCols-1 do
        begin
          TileWindow(A[i].WinID, iRow, iCol);
          ScrlWindow(A[i].WinID);
          if I < Length(A)-1 then Inc(I)  // next TWinsData element
          else goto BreakLoops;
        end;
    end
  else                                // columns first
    for iCol:= 0 to aCols-1 do
      for iRow:= 0 to aRows-1 do
      begin
        TileWindow(A[i].WinID, iRow, iCol);
        ScrlWindow(A[i].WinID);
        if I < Length(A)-1 then Inc(I)    // next TWinsData element
        else goto BreakLoops;
      end;
  BreakLoops:

  if aHandle > 0 then                 // return focus back to main (caller) window
    PostMessage(aHandle, WM_ACTIVATE, WA_ACTIVE, 0);
end;

end.
