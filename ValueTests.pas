unit ValueTests;

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
  TestValues,
  Types,
  ValueComparers,
  Values;

type
  TValueTestCase = class(TRegisterableTestCase)
  strict protected
    procedure CheckComparesAs(Comparisons: TValueComparisonSet;
      const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckDoesNotCompareAs(Comparisons: TValueComparisonSet;
      const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckEndsStr(const ASubStr, AStr: string);
    procedure CheckGreaterThan(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckGreaterThanOrEqualTo(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckInspectValue(const Expected: string; const Value: TValue);
    procedure CheckLessThan(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckLessThanOrEqualTo(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckNotGreaterThan(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckNotGreaterThanOrEqualTo(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckNotLessThan(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckNotLessThanOrEqualTo(const Left, Right: TValue; Comparer: IValueComparer = nil);
    procedure CheckNotSameInstance(const A, B: TValue);
    procedure CheckReferenceString(const ExpectedReferenceString, Actual: string);
    procedure CheckSameInstance(const A, B: TValue);
    procedure CheckStartsStr(const ASubStr, AStr: string);
    procedure CheckValueAsString(ExpectedString: string; const Value: TValue);
    procedure CheckValuesEqual(const A, B: TValue; Comparer: IValueComparer = nil);
    procedure CheckValuesNotEqual(const A, B: TValue; Comparer: IValueComparer = nil);
  end;

  TestBooleanValue = class(TValueTestCase)
  published
    procedure TestEquality;
    procedure TestInequality;
    procedure TestAsString;
    procedure TestInspect;
    procedure TestLessThan;
    procedure TestGreaterThan;
  end;

  TestCrossTypeValueComparisons = class(TValueTestCase)
  strict private
    procedure CheckValuesNotComparable(const A, B: TValue);
  published
    procedure TestCannotCompareFloatToInt64;
    procedure TestCanCompareFloatToInteger;
    procedure TestCanCompareIntegerToFloat;
    procedure TestCanCompareIntegerToInt64;
    procedure TestCannotCompareInt64ToFloat;
    procedure TestCanCompareInt64ToInteger;
    procedure TestCannotCompareFooEnumToBarEnum;
    procedure TestCannotCompareFooEnumToInteger;
  end;

  TestEnumValue = class(TValueTestCase)
  published
    procedure TestFooEnumEquality;
    procedure TestFooEnumInequality;
    procedure TestFooEnumAsString;
    procedure TestBarEnumAsString;
    procedure TestInspectFooEnum;
    procedure TestLessThan;
    procedure TestGreaterThan;
  end;

  TestFloatValue = class(TValueTestCase)
  published
    procedure TestEquality;
    procedure TestInequality;
    procedure TestEqualityWithEpsilon;
    procedure TestInequalityWithEpsilon;
    procedure TestIntegerFloatEqualityWithEpsilon;
    procedure TestIntegerFloatInequalityWithEpsilon;
    procedure TestFloatIntegerEqualityWithEpsilon;
    procedure TestFloatIntegerInequalityWithEpsilon;
    procedure TestDefaultEpsilon;
    procedure TestAsString;
    procedure TestInspect;
    procedure TestLessThan;
    procedure TestNotLessThanWhenEqual;
    procedure TestNotLessThanWhenGreater;
    procedure TestNotLessThanWhenEqualWithEpsilon;
    procedure TestLessThanOrEqualWhenLess;
    procedure TestLessThanOrEqualWhenEqual;
    procedure TestNotLessThanOrEqualWhenGreater;
    procedure TestLessThanOrEqualWhenEqualWithEpsilon;
    procedure TestGreaterThan;
    procedure TestNotGreaterThanWhenEqual;
    procedure TestNotGreaterThanWhenLess;
    procedure TestNotGreaterThanWhenEqualWithEpsilon;
    procedure TestNotGreaterThanOrEqualWhenLess;
    procedure TestGreaterThanOrEqualWhenEqual;
    procedure TestGreaterThanOrEqualWhenGreater;
    procedure TestGreaterThanOrEqualWhenEqualWithEpsilon;
    procedure TestIntegerLessThanFloat;
    procedure TestFloatLessThanInteger;
  end;

  TestInt64Value = class(TValueTestCase)
  published
    procedure TestEquality;
    procedure TestInequality;
    procedure TestAsString;
    procedure TestInspect;
    procedure TestLessThan;
    procedure TestGreaterThan;
  end;

  TestIntegerValue = class(TValueTestCase)
  published
    procedure TestEquality;
    procedure TestInequality;
    procedure TestAsString;
    procedure TestInspect;
    procedure TestLessThan;
    procedure TestGreaterThan;
  end;

  TestInterfaceValue = class(TValueTestCase)
  strict private
    FFirstInterface: IInterface;
    FFirstValue: TValue;
    FSecondInterface: IInterface;
    FSecondValue: TValue;
  strict protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSameInstance;
    procedure TestDifferentInstance;
    procedure TestDifferentInterfaceOnSameInstance;
    procedure TestAsString;
    procedure TestNilAsString;
    procedure TestInspect;
  end;

  TestObjectValue = class(TValueTestCase)
  strict private
    FBaseObject: TBase;
    FBaseValue: TValue;
    FFirstObject: TObject;
    FFirstValue: TValue;
    FSecondObject: TObject;
    FSecondValue: TValue;
  strict protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSameInstance;
    procedure TestDifferentInstance;
    procedure TestAsString;
    procedure TestNilAsString;
    procedure TestInspect;
    procedure TestIsOfType;
    procedure TestIsNotOfBaseType;
    procedure TestIsNotOfDescendantType;
  end;

  TestPointValue = class(TValueTestCase)
  strict private
    FFirstPoint: TValue;
    FSecondPoint: TValue;
  strict protected
    procedure SetUp; override;
  published
    procedure TestEquality;
    procedure TestInequality;
    procedure TestGreaterThanIsNotSupported;
    procedure TestLessThanIsNotSupported;
  end;

  TestStringValue = class(TValueTestCase)
  strict private
    procedure CheckNotSameText(const A, B: TValue);
    procedure CheckSameText(const A, B: TValue);
  published
    procedure TestEquality;
    procedure TestInequality;
    procedure TestSameText;
    procedure TestNotSameText;
    procedure TestAsString;
    procedure TestInspect;
    procedure TestLessThan;
    procedure TestGreaterThan;
  end;

implementation

uses
  Math,
  StrUtils,
  SysUtils;

{ TValueTestCase }

procedure TValueTestCase.CheckComparesAs(Comparisons: TValueComparisonSet;
  const Left, Right: TValue; Comparer: IValueComparer);
begin
  if Comparer = nil then
    Comparer := TDefaultValueComparer.Instance;
  CheckTrue(Left.ComparesAs(Comparisons, Right, Comparer));
end;

procedure TValueTestCase.CheckDoesNotCompareAs(Comparisons: TValueComparisonSet;
  const Left, Right: TValue; Comparer: IValueComparer);
begin
  if Comparer = nil then
    Comparer := TDefaultValueComparer.Instance;
  CheckFalse(Left.ComparesAs(Comparisons, Right, Comparer));
end;

procedure TValueTestCase.CheckEndsStr(const ASubStr, AStr: string);
begin
  Check(EndsStr(ASubStr, AStr), 'Expected to end with <' + ASubStr +
    '> but was <' + AStr + '>');
end;

procedure TValueTestCase.CheckGreaterThan(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckComparesAs([vcGreater], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckGreaterThanOrEqualTo(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckComparesAs([vcGreater, vcEqual], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckInspectValue(const Expected: string;
  const Value: TValue);
begin
  CheckEquals(Expected, Value.Inspect);
end;

procedure TValueTestCase.CheckLessThan(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckComparesAs([vcLess], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckLessThanOrEqualTo(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckComparesAs([vcLess, vcEqual], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckNotGreaterThan(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckDoesNotCompareAs([vcGreater], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckNotGreaterThanOrEqualTo(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckDoesNotCompareAs([vcGreater, vcEqual], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckNotLessThan(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckDoesNotCompareAs([vcLess], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckNotLessThanOrEqualTo(const Left, Right: TValue;
  Comparer: IValueComparer);
begin
  CheckDoesNotCompareAs([vcLess, vcEqual], Left, Right, Comparer);
end;

procedure TValueTestCase.CheckNotSameInstance(const A, B: TValue);
begin
  CheckFalse(A.SameInstance(B));
end;

procedure TValueTestCase.CheckReferenceString(const ExpectedReferenceString,
  Actual: string);
begin
  CheckStartsStr(ExpectedReferenceString + '($', Actual);
  CheckEndsStr(')', Actual);
end;

procedure TValueTestCase.CheckSameInstance(const A, B: TValue);
begin
  CheckTrue(A.SameInstance(B));
end;

procedure TValueTestCase.CheckStartsStr(const ASubStr, AStr: string);
begin
  Check(StartsStr(ASubStr, AStr), 'Expected to start with <' + ASubStr +
    '> but was <' + AStr + '>');
end;

procedure TValueTestCase.CheckValueAsString(ExpectedString: string;
  const Value: TValue);
begin
  CheckEquals(ExpectedString, Value.AsString);
end;

procedure TValueTestCase.CheckValuesEqual(const A, B: TValue;
  Comparer: IValueComparer);
begin
  CheckComparesAs([vcEqual], A, B, Comparer);
end;

procedure TValueTestCase.CheckValuesNotEqual(const A, B: TValue;
  Comparer: IValueComparer);
begin
  CheckDoesNotCompareAs([vcEqual], A, B, Comparer);
end;

{ TestBooleanValue }

procedure TestBooleanValue.TestAsString;
begin
  CheckValueAsString('False', False);
  CheckValueAsString('True', True);
end;

procedure TestBooleanValue.TestEquality;
begin
  CheckValuesEqual(True, True);
  CheckValuesEqual(False, False);
end;

procedure TestBooleanValue.TestGreaterThan;
begin
  CheckGreaterThan(True, False);
  CheckNotGreaterThan(False, False);
  CheckNotGreaterThan(True, True);
  CheckNotGreaterThan(False, True);
end;

procedure TestBooleanValue.TestInequality;
begin
  CheckValuesNotEqual(True, False);
  CheckValuesNotEqual(False, True);
end;

procedure TestBooleanValue.TestInspect;
begin
  CheckInspectValue('True', True);
  CheckInspectValue('False', False);
end;

procedure TestBooleanValue.TestLessThan;
begin
  CheckLessThan(False, True);
  CheckNotLessThan(False, False);
  CheckNotLessThan(True, True);
  CheckNotLessThan(True, False);
end;

{ TestCrossTypeValueComparisons }

procedure TestCrossTypeValueComparisons.CheckValuesNotComparable(const A, B: TValue);
begin
  ExpectedException := EInvalidCast;
  A.ComparesAs([vcEqual], B, TDefaultValueComparer.Instance);
end;

procedure TestCrossTypeValueComparisons.TestCanCompareFloatToInteger;
begin
  CheckValuesEqual(42.0, 42);
end;

procedure TestCrossTypeValueComparisons.TestCanCompareInt64ToInteger;
begin
  CheckValuesEqual(Int64(42), 42);
end;

procedure TestCrossTypeValueComparisons.TestCanCompareIntegerToFloat;
begin
  CheckValuesEqual(42, 42.0);
end;

procedure TestCrossTypeValueComparisons.TestCanCompareIntegerToInt64;
begin
  CheckValuesEqual(42, Int64(42));
end;

procedure TestCrossTypeValueComparisons.TestCannotCompareFloatToInt64;
begin
  CheckValuesNotComparable(42.0, Int64(42));
end;

procedure TestCrossTypeValueComparisons.TestCannotCompareFooEnumToBarEnum;
begin
  CheckValuesNotComparable(fooBar, barBaz);
end;

procedure TestCrossTypeValueComparisons.TestCannotCompareFooEnumToInteger;
begin
  CheckValuesNotComparable(fooBar, 0);
end;

procedure TestCrossTypeValueComparisons.TestCannotCompareInt64ToFloat;
begin
  CheckValuesNotComparable(Int64(42), 42.0);
end;

{ TestEnumValue }

procedure TestEnumValue.TestBarEnumAsString;
begin
  CheckValueAsString('barBaz', barBaz);
  CheckValueAsString('barQuux', barQuux);
end;

procedure TestEnumValue.TestFooEnumAsString;
begin
  CheckValueAsString('fooBar', fooBar);
  CheckValueAsString('fooBaz', fooBaz);
end;

procedure TestEnumValue.TestFooEnumEquality;
begin
  CheckValuesEqual(fooBar, fooBar);
end;

procedure TestEnumValue.TestFooEnumInequality;
begin
  CheckValuesNotEqual(fooBar, fooBaz);
end;

procedure TestEnumValue.TestGreaterThan;
begin
  CheckGreaterThan(fooBaz, fooBar);
end;

procedure TestEnumValue.TestInspectFooEnum;
begin
  CheckInspectValue('fooBar', fooBar);
  CheckInspectValue('fooBaz', fooBaz);
end;

procedure TestEnumValue.TestLessThan;
begin
  CheckLessThan(fooBar, fooBaz);
end;

{ TestFloatValue }

procedure TestFloatValue.TestDefaultEpsilon;
begin
  CheckValuesEqual(EpsilonTestValues.BaseValue, EpsilonTestValues.SameAtDefaultEpsilon);
  CheckValuesNotEqual(EpsilonTestValues.BaseValue, EpsilonTestValues.DifferentAtDefaultEpsilon);
end;

procedure TestFloatValue.TestAsString;
begin
  CheckValueAsString('4.25', 4.25);
end;

procedure TestFloatValue.TestEquality;
begin
  CheckValuesEqual(42.0, 42.0);
end;

procedure TestFloatValue.TestEqualityWithEpsilon;
begin
  CheckValuesEqual(42.0, 42.1, TEpsilonValueComparer.Create(0.2));
end;

procedure TestFloatValue.TestInequality;
begin
  CheckValuesNotEqual(42.0, 42.5);
end;

procedure TestFloatValue.TestInequalityWithEpsilon;
begin
  CheckValuesNotEqual(42.0, 42.1, TEpsilonValueComparer.Create(0.05));
end;

procedure TestFloatValue.TestInspect;
begin
  CheckInspectValue('4.25', 4.25);
end;

procedure TestFloatValue.TestFloatIntegerEqualityWithEpsilon;
begin
  CheckValuesEqual(4.25, 4, TEpsilonValueComparer.Create(0.5));
end;

procedure TestFloatValue.TestFloatIntegerInequalityWithEpsilon;
begin
  CheckValuesNotEqual(4.25, 4, TEpsilonValueComparer.Create(0.125));
end;

procedure TestFloatValue.TestFloatLessThanInteger;
begin
  CheckLessThan(3.75, 4);
end;

procedure TestFloatValue.TestGreaterThan;
begin
  CheckGreaterThan(4.25, 4.0);
end;

procedure TestFloatValue.TestGreaterThanOrEqualWhenEqual;
begin
  CheckGreaterThanOrEqualTo(4.0, 4.0);
end;

procedure TestFloatValue.TestGreaterThanOrEqualWhenEqualWithEpsilon;
begin
  CheckGreaterThanOrEqualTo(4.0, 4.25, TEpsilonValueComparer.Create(0.5));
end;

procedure TestFloatValue.TestGreaterThanOrEqualWhenGreater;
begin
  CheckGreaterThanOrEqualTo(4.0, 3.75);
end;

procedure TestFloatValue.TestIntegerFloatEqualityWithEpsilon;
begin
  CheckValuesEqual(4, 4.25, TEpsilonValueComparer.Create(0.5));
end;

procedure TestFloatValue.TestIntegerFloatInequalityWithEpsilon;
begin
  CheckValuesNotEqual(4, 4.25, TEpsilonValueComparer.Create(0.125));
end;

procedure TestFloatValue.TestIntegerLessThanFloat;
begin
  CheckLessThan(4, 4.25);
end;

procedure TestFloatValue.TestLessThan;
begin
  CheckLessThan(4.0, 4.25);
end;

procedure TestFloatValue.TestLessThanOrEqualWhenEqual;
begin
  CheckLessThanOrEqualTo(4.0, 4.0);
end;

procedure TestFloatValue.TestLessThanOrEqualWhenEqualWithEpsilon;
begin
  CheckLessThanOrEqualTo(4.0, 3.75, TEpsilonValueComparer.Create(0.5));
end;

procedure TestFloatValue.TestLessThanOrEqualWhenLess;
begin
  CheckLessThanOrEqualTo(4.0, 4.25);
end;

procedure TestFloatValue.TestNotGreaterThanOrEqualWhenLess;
begin
  CheckNotGreaterThanOrEqualTo(4.0, 4.25);
end;

procedure TestFloatValue.TestNotGreaterThanWhenEqual;
begin
  CheckNotGreaterThan(4.0, 4.0);
end;

procedure TestFloatValue.TestNotGreaterThanWhenEqualWithEpsilon;
begin
  CheckNotGreaterThan(4.25, 4.0, TEpsilonValueComparer.Create(0.5));
end;

procedure TestFloatValue.TestNotGreaterThanWhenLess;
begin
  CheckNotGreaterThan(4.0, 4.25);
end;

procedure TestFloatValue.TestNotLessThanOrEqualWhenGreater;
begin
  CheckNotLessThanOrEqualTo(4.0, 3.75);
end;

procedure TestFloatValue.TestNotLessThanWhenEqual;
begin
  CheckNotLessThan(4.0, 4.0);
end;

procedure TestFloatValue.TestNotLessThanWhenEqualWithEpsilon;
begin
  CheckNotLessThan(4.0, 4.25, TEpsilonValueComparer.Create(0.5));
end;

procedure TestFloatValue.TestNotLessThanWhenGreater;
begin
  CheckNotLessThan(4.25, 4.0);
end;

{ TestInt64Value }

procedure TestInt64Value.TestAsString;
begin
  CheckValueAsString('42', Int64(42));
end;

procedure TestInt64Value.TestEquality;
begin
  CheckValuesEqual(Int64(42), Int64(42));
end;

procedure TestInt64Value.TestGreaterThan;
begin
  CheckGreaterThan(Int64(5), Int64(4));
end;

procedure TestInt64Value.TestInequality;
begin
  CheckValuesNotEqual(Int64(42), Int64(0));
end;

procedure TestInt64Value.TestInspect;
begin
  CheckInspectValue('42', Int64(42));
end;

procedure TestInt64Value.TestLessThan;
begin
  CheckLessThan(Int64(4), Int64(5));
end;

{ TestIntegerValue }

procedure TestIntegerValue.TestAsString;
begin
  CheckValueAsString('42', 42);
end;

procedure TestIntegerValue.TestEquality;
begin
  CheckValuesEqual(42, 42);
end;

procedure TestIntegerValue.TestGreaterThan;
begin
  CheckGreaterThan(5, 4);
end;

procedure TestIntegerValue.TestInequality;
begin
  CheckValuesNotEqual(42, 0);
end;

procedure TestIntegerValue.TestInspect;
begin
  CheckInspectValue('42', 42);
end;

procedure TestIntegerValue.TestLessThan;
begin
  CheckLessThan(4, 5);
end;

{ TestInterfaceValue }

procedure TestInterfaceValue.SetUp;
begin
  inherited;
  FFirstInterface := TInterfacedObject.Create;
  FFirstValue := FFirstInterface;
  FSecondInterface := TInterfacedObject.Create;
  FSecondValue := FSecondInterface;
end;

procedure TestInterfaceValue.TearDown;
begin
  FSecondInterface := nil;
  FFirstInterface := nil;
  inherited;
end;

procedure TestInterfaceValue.TestDifferentInstance;
begin
  CheckNotSameInstance(FFirstValue, FSecondValue);
end;

procedure TestInterfaceValue.TestDifferentInterfaceOnSameInstance;
var
  FooBar: TFooBar;
  Foo: IFoo;
  Bar: IBar;
begin
  FooBar := TFooBar.Create;
  Foo := FooBar;
  Bar := FooBar;
  CheckSameInstance(Foo, Bar);
end;

procedure TestInterfaceValue.TestInspect;
begin
  CheckReferenceString('interface', FFirstValue.Inspect);
end;

procedure TestInterfaceValue.TestNilAsString;
var
  Intf: IInterface;
begin
  Intf := nil;
  CheckValueAsString('nil interface', Intf);
end;

procedure TestInterfaceValue.TestAsString;
begin
  CheckReferenceString('interface', FFirstValue.AsString);
end;

procedure TestInterfaceValue.TestSameInstance;
begin
  CheckSameInstance(FFirstValue, FFirstValue);
end;

{ TestObjectValue }

procedure TestObjectValue.SetUp;
begin
  inherited;
  FFirstObject := TObject.Create;
  FFirstValue := FFirstObject;
  FSecondObject := TObject.Create;
  FSecondValue := FSecondObject;
  FBaseObject := TBase.Create;
  FBaseValue := FBaseObject;
end;

procedure TestObjectValue.TearDown;
begin
  FreeAndNil(FBaseObject);
  FreeAndNil(FSecondObject);
  FreeAndNil(FFirstObject);
  inherited;
end;

procedure TestObjectValue.TestDifferentInstance;
begin
  CheckNotSameInstance(FFirstObject, FSecondObject);
end;

procedure TestObjectValue.TestInspect;
begin
  CheckReferenceString('TObject', FFirstValue.Inspect);
end;

procedure TestObjectValue.TestIsNotOfBaseType;
begin
  CheckFalse(FBaseValue.IsOfType(TObject));
end;

procedure TestObjectValue.TestIsNotOfDescendantType;
begin
  CheckFalse(FBaseValue.IsOfType(TSub));
end;

procedure TestObjectValue.TestIsOfType;
begin
  CheckTrue(FBaseValue.IsOfType(TBase));
end;

procedure TestObjectValue.TestNilAsString;
var
  Obj: TObject;
begin
  Obj := nil;
  CheckValueAsString('nil object', Obj);
end;

procedure TestObjectValue.TestAsString;
begin
  CheckReferenceString('TObject', FFirstValue.AsString);
end;

procedure TestObjectValue.TestSameInstance;
begin
  CheckSameInstance(FFirstObject, FFirstObject);
end;

{ TestPointValue }

procedure TestPointValue.SetUp;
begin
  inherited;
  FFirstPoint := Point(1, 1);
  FSecondPoint := Point(1, 2);
end;

procedure TestPointValue.TestEquality;
begin
  CheckValuesEqual(FFirstPoint, FFirstPoint);
end;

procedure TestPointValue.TestGreaterThanIsNotSupported;
begin
  ExpectedException := ERangeError;
  FFirstPoint.ComparesAs([vcGreater], FSecondPoint, TDefaultValueComparer.Instance);
end;

procedure TestPointValue.TestInequality;
begin
  CheckValuesNotEqual(FFirstPoint, FSecondPoint);
end;

procedure TestPointValue.TestLessThanIsNotSupported;
begin
  ExpectedException := ERangeError;
  FFirstPoint.ComparesAs([vcLess], FSecondPoint, TDefaultValueComparer.Instance);
end;

{ TestStringValue }

procedure TestStringValue.CheckNotSameText(const A, B: TValue);
begin
  CheckFalse(A.SameText(B));
end;

procedure TestStringValue.CheckSameText(const A, B: TValue);
begin
  CheckTrue(A.SameText(B));
end;

procedure TestStringValue.TestNotSameText;
begin
  CheckNotSameText('Abc', '');
end;

procedure TestStringValue.TestSameText;
begin
  CheckSameText('', '');
  CheckSameText('Abc', 'abc');
end;

procedure TestStringValue.TestAsString;
begin
  CheckValueAsString('', '');
  CheckValueAsString('abc', 'abc');
end;

procedure TestStringValue.TestEquality;
begin
  CheckValuesEqual('', '');
  CheckValuesEqual('Abc', 'Abc');
end;

procedure TestStringValue.TestGreaterThan;
begin
  CheckGreaterThan('z', 'a');
end;

procedure TestStringValue.TestInequality;
begin
  CheckValuesNotEqual('Abc', '');
  CheckValuesNotEqual('Abc', 'abc');
end;

procedure TestStringValue.TestInspect;
begin
  CheckInspectValue('''ab''#13#10', 'ab'#13#10);
end;

procedure TestStringValue.TestLessThan;
begin
  CheckLessThan('a', 'z');
end;

initialization
  TestBooleanValue.Register;
  TestCrossTypeValueComparisons.Register;
  TestEnumValue.Register;
  TestFloatValue.Register;
  TestInt64Value.Register;
  TestIntegerValue.Register;
  TestInterfaceValue.Register;
  TestObjectValue.Register;
  TestPointValue.Register;
  TestStringValue.Register;
end.
