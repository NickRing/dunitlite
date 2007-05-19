unit StringInspectors;

// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is DUnitLite.
//
// The Initial Developer of the Original Code is Joe White.
// Portions created by Joe White are Copyright (C) 2007
// Joe White. All Rights Reserved.
//
// Contributor(s):
//
// Alternatively, the contents of this file may be used under the terms
// of the LGPL license (the  "LGPL License"), in which case the
// provisions of LGPL License are applicable instead of those
// above. If you wish to allow use of your version of this file only
// under the terms of the LGPL License and not to allow others to use
// your version of this file under the MPL, indicate your decision by
// deleting the provisions above and replace them with the notice and
// other provisions required by the LGPL License. If you do not delete
// the provisions above, a recipient may use your version of this file
// under either the MPL or the LGPL License.

interface

uses
  SysUtils;

const
  Apostrophe = '''';

type
  IStringInspector = interface
  ['{F91B9DBF-33FF-44EA-B800-6BCE3E4E127E}']
    function Execute(AString: string): string;
  end;

  TStringInspector = class(TInterfacedObject, IStringInspector)
  public
    function Execute(AString: string): string;
  end;

  IStringBuilder = interface
  ['{9FB96139-B4F7-47E4-820E-15857F60E912}']
    procedure Append(const Value: string);
    function AsString: string;
  end;

  TStringBuilder = class(TInterfacedObject, IStringBuilder)
  strict private
    FValue: string;
  public
    procedure Append(const Value: string);
    function AsString: string;
  end;

  IStringInspectorState = interface
  ['{F013CA74-BADC-4E3C-BD83-B580861D1552}']
    function Handle(Ch: Char): IStringInspectorState;
    procedure HandleEndOfString;
  end;

  TStringInspectorStateBase = class(TInterfacedObject, IStringInspectorState)
  strict private
    FBuilder: IStringBuilder;
  strict protected
    function HandleLowAscii(Ch: Char): IStringInspectorState; virtual;
    function HandleNormal(Ch: Char): IStringInspectorState; virtual;
    function InQuoteState: IStringInspectorState; virtual;
    function OuterState: IStringInspectorState; virtual;
    procedure TransitionAway; virtual;

    property Builder: IStringBuilder read FBuilder;
  public
    constructor Create(ABuilder: IStringBuilder);
    function Handle(Ch: Char): IStringInspectorState;
    procedure HandleEndOfString; virtual;
  end;

  TStringInspectorInitialState = class(TStringInspectorStateBase)
  public
    procedure HandleEndOfString; override;
  end;

  TStringInspectorOuterState = class(TStringInspectorStateBase)
  strict protected
    function HandleLowAscii(Ch: Char): IStringInspectorState; override;
    function OuterState: IStringInspectorState; override;
  end;

  TStringInspectorInQuoteState = class(TStringInspectorStateBase)
  strict protected
    function HandleNormal(Ch: Char): IStringInspectorState; override;
    function InQuoteState: IStringInspectorState; override;
    procedure TransitionAway; override;
  public
    constructor Create(ABuilder: IStringBuilder);
  end;

implementation

{ TStringInspector }

function TStringInspector.Execute(AString: string): string;
var
  Builder: IStringBuilder;
  State: IStringInspectorState;
  Ch: Char;
begin
  Builder := TStringBuilder.Create;
  State := TStringInspectorInitialState.Create(Builder);
  for Ch in AString do
    State := State.Handle(Ch);
  State.HandleEndOfString;
  Result := Builder.AsString;
end;

{ TStringBuilder }

procedure TStringBuilder.Append(const Value: string);
begin
  FValue := FValue + Value;
end;

function TStringBuilder.AsString: string;
begin
  Result := FValue;
end;

{ TStringInspectorStateBase }

constructor TStringInspectorStateBase.Create(ABuilder: IStringBuilder);
begin
  inherited Create;
  FBuilder := ABuilder;
end;

function TStringInspectorStateBase.Handle(Ch: Char): IStringInspectorState;
begin
  if Ch in [#0..#31] then
    Result := HandleLowAscii(Ch)
  else
    Result := HandleNormal(Ch);
end;

procedure TStringInspectorStateBase.HandleEndOfString;
begin
  TransitionAway;
end;

function TStringInspectorStateBase.HandleLowAscii(Ch: Char): IStringInspectorState;
begin
  Result := OuterState;
  Result.Handle(Ch);
end;

function TStringInspectorStateBase.HandleNormal(Ch: Char): IStringInspectorState;
begin
  Result := InQuoteState;
  Result.Handle(Ch);
end;

function TStringInspectorStateBase.InQuoteState: IStringInspectorState;
begin
  TransitionAway;
  Result := TStringInspectorInQuoteState.Create(Builder);
end;

function TStringInspectorStateBase.OuterState: IStringInspectorState;
begin
  TransitionAway;
  Result := TStringInspectorOuterState.Create(Builder);
end;

procedure TStringInspectorStateBase.TransitionAway;
begin
end;

{ TStringInspectorInitialState }

procedure TStringInspectorInitialState.HandleEndOfString;
begin
  inherited;
  Builder.Append(Apostrophe + Apostrophe);
end;

{ TStringInspectorOuterState }

function TStringInspectorOuterState.HandleLowAscii(
  Ch: Char): IStringInspectorState;
begin
  Builder.Append('#' + IntToStr(Ord(Ch)));
  Result := Self;
end;

function TStringInspectorOuterState.OuterState: IStringInspectorState;
begin
  Result := Self;
end;

{ TStringInspectorInQuoteState }

constructor TStringInspectorInQuoteState.Create(ABuilder: IStringBuilder);
begin
  inherited;
  Builder.Append(Apostrophe);
end;

function TStringInspectorInQuoteState.HandleNormal(Ch: Char): IStringInspectorState;
begin
  if Ch = Apostrophe then
    Builder.Append(Apostrophe + Apostrophe)
  else
    Builder.Append(Ch);
  Result := Self;
end;

function TStringInspectorInQuoteState.InQuoteState: IStringInspectorState;
begin
  Result := Self;
end;

procedure TStringInspectorInQuoteState.TransitionAway;
begin
  Builder.Append(Apostrophe);
end;

end.
