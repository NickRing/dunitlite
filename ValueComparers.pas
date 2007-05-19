unit ValueComparers;

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

type
  TValueComparison = (vcEqual, vcLess, vcGreater, vcUnorderedAndNotEqual);
  TValueComparisonSet = set of TValueComparison;

  IValueComparer = interface
  ['{7E727781-3AC3-4C5B-AA8B-17AE47554D32}']
    function AsString: string;
    function CompareExtendeds(const A, B: Extended): TValueComparison;
  end;

  TDefaultValueComparer = class(TInterfacedObject, IValueComparer)
  private class var
    // should be strict private, but Delphi doesn't have class constructors
    FInstance: IValueComparer;
  public
    function AsString: string;
    function CompareExtendeds(const A, B: Extended): TValueComparison;

    class property Instance: IValueComparer read FInstance;
  end;

  TEpsilonValueComparer = class(TInterfacedObject, IValueComparer)
  strict private
    FEpsilon: Extended;
  public
    constructor Create(AEpsilon: Extended);
    function AsString: string;
    function CompareExtendeds(const A, B: Extended): TValueComparison;
  end;

  TExactValueComparer = class(TInterfacedObject, IValueComparer)
  public
    function AsString: string;
    function CompareExtendeds(const A, B: Extended): TValueComparison;
  end;

implementation

uses
  Math,
  SysUtils;

{ TDefaultValueComparer }

function TDefaultValueComparer.AsString: string;
begin
  Result := '';
end;

function TDefaultValueComparer.CompareExtendeds(const A, B: Extended): TValueComparison;
var
  First: Double;
  Second: Double;
begin
  First := A;
  Second := B;
  if SameValue(First, Second) then
    Result := vcEqual
  else if First < Second then
    Result := vcLess
  else
    Result := vcGreater;
end;

{ TEpsilonValueComparer }

function TEpsilonValueComparer.AsString: string;
begin
  Result := 'to within ' + FloatToStr(FEpsilon);
end;

function TEpsilonValueComparer.CompareExtendeds(const A,
  B: Extended): TValueComparison;
begin
  if Abs(A - B) <= FEpsilon then
    Result := vcEqual
  else if A < B then
    Result := vcLess
  else
    Result := vcGreater;
end;

constructor TEpsilonValueComparer.Create(AEpsilon: Extended);
begin
  inherited Create;
  FEpsilon := AEpsilon;
end;

{ TExactValueComparer }

function TExactValueComparer.AsString: string;
begin
  Result := 'exactly';
end;

function TExactValueComparer.CompareExtendeds(const A,
  B: Extended): TValueComparison;
begin
  if A = B then
    Result := vcEqual
  else if A < B then
    Result := vcLess
  else
    Result := vcGreater;
end;

initialization
  TDefaultValueComparer.FInstance := TDefaultValueComparer.Create;
end.
