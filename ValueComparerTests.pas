unit ValueComparerTests;

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
  RegisterableTestCases,
  ValueComparers;

type
  TValueComparerTestCase = class(TRegisterableTestCase)
  strict private
    function EnumToStr(const Value: TValueComparison): string;
  strict protected
    procedure CheckCompare(const ExpectedComparison: TValueComparison;
      const A, B: Extended);
    procedure CheckEquals(const Expected, Actual: TValueComparison); overload;
    function GetComparer: IValueComparer; virtual; abstract;

    property Comparer: IValueComparer read GetComparer;
  published
    procedure TestExactlyEqual;
    procedure TestLess;
    procedure TestGreater;
  end;

  TestDefaultValueComparer = class(TValueComparerTestCase)
  strict protected
    function GetComparer: IValueComparer; override;
  published
    procedure TestCloseEnough;
    procedure TestNotCloseEnough;
    procedure TestAsString;
  end;

  TestExactComparer = class(TValueComparerTestCase)
  strict protected
    function GetComparer: IValueComparer; override;
  published
    procedure TestCloseButNoCigar;
    procedure TestAsString;
  end;

  TestEpsilonComparer = class(TValueComparerTestCase)
  strict protected
    function GetComparer: IValueComparer; override;
  published
    procedure TestCloseEnough;
    procedure TestNotCloseEnough;
    procedure TestAsString;
  end;

implementation

uses
  TestValues,
  TypInfo;

{ TValueComparerTestCase }

procedure TValueComparerTestCase.CheckCompare(
  const ExpectedComparison: TValueComparison; const A, B: Extended);
begin
  CheckEquals(ExpectedComparison, Comparer.CompareExtendeds(A, B));
end;

procedure TValueComparerTestCase.CheckEquals(const Expected,
  Actual: TValueComparison);
begin
  CheckEquals(EnumToStr(Expected), EnumToStr(Actual));
end;

function TValueComparerTestCase.EnumToStr(
  const Value: TValueComparison): string;
begin
  Result := GetEnumName(TypeInfo(TValueComparison), Ord(Value));
end;

procedure TValueComparerTestCase.TestExactlyEqual;
begin
  CheckCompare(vcEqual, 1, 1);
end;

procedure TValueComparerTestCase.TestGreater;
begin
  CheckCompare(vcGreater, 2, 1);
end;

procedure TValueComparerTestCase.TestLess;
begin
  CheckCompare(vcLess, 1, 2);
end;

{ TestDefaultValueComparer }

function TestDefaultValueComparer.GetComparer: IValueComparer;
begin
  Result := TDefaultValueComparer.Instance;
end;

procedure TestDefaultValueComparer.TestAsString;
begin
  CheckEquals('', Comparer.AsString);
end;

procedure TestDefaultValueComparer.TestCloseEnough;
begin
  CheckCompare(vcEqual, EpsilonTestValues.BaseValue, EpsilonTestValues.SameAtDefaultEpsilon);
end;

procedure TestDefaultValueComparer.TestNotCloseEnough;
begin
  CheckCompare(vcLess, EpsilonTestValues.BaseValue, EpsilonTestValues.DifferentAtDefaultEpsilon);
end;

{ TestExactComparer }

function TestExactComparer.GetComparer: IValueComparer;
begin
  Result := TExactValueComparer.Create;
end;

procedure TestExactComparer.TestAsString;
begin
  CheckEquals('exactly', Comparer.AsString);
end;

procedure TestExactComparer.TestCloseButNoCigar;
begin
  CheckEquals(vcLess, Comparer.CompareExtendeds(EpsilonTestValues.BaseValue,
    EpsilonTestValues.BarelyDifferent));
end;

{ TestEpsilonComparer }

function TestEpsilonComparer.GetComparer: IValueComparer;
begin
  Result := TEpsilonValueComparer.Create(0.5);
end;

procedure TestEpsilonComparer.TestAsString;
begin
  CheckEquals('to within 0.5', Comparer.AsString);
end;

procedure TestEpsilonComparer.TestCloseEnough;
begin
  CheckCompare(vcEqual, 1.0, 1.5);
end;

procedure TestEpsilonComparer.TestNotCloseEnough;
begin
  CheckCompare(vcLess, 1.0, 1.51);
end;

initialization
  TestDefaultValueComparer.Register;
  TestExactComparer.Register;
  TestEpsilonComparer.Register;
end.
