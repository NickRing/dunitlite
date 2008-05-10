unit ConstraintTests;

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
  Constraints,
  Specifications,
  TestValues,
  Values;

type
  TConstraintTestCase = class(TRegisterableSpecification)
  strict protected
    procedure CheckDoesNotMatch(const AActualValue: TValue; const Constraint: IConstraint);
    procedure CheckExpectedAndActualStrings(
      const ExpectedExpected, ExpectedActual: string;
      const AActualValue: TValue; const Constraint: IConstraint);
    procedure CheckMatches(const AActualValue: TValue; const Constraint: IConstraint);
  end;

  TestBetweenConstraint = class(TConstraintTestCase)
  published
    procedure TestMatches;
    procedure TestDoesNotMatchWhenEqualToLowerBound;
    procedure TestDoesNotMatchWhenEqualToUpperBound;
    procedure TestDoesNotMatchWhenNearlyEqualToLowerBound;
    procedure TestDoesNotMatchWhenEqualToLowerBoundWithEpsilon;
    procedure TestMatchesWhenNearlyEqualToLowerBoundWithExactComparison;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestEqualConstraint = class(TConstraintTestCase)
  published
    procedure TestMatches;
    procedure TestDoesNotMatch;
    procedure TestMatchesWithEpsilon;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestGreaterThanConstraint = class(TConstraintTestCase)
  published
    procedure TestMatchesWhenGreater;
    procedure TestDoesNotMatchWhenEqual;
    procedure TestDoesNotMatchWhenLess;
    procedure TestDoesNotMatchWhenEqualWithEpsilon;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestGreaterThanOrEqualToConstraint = class(TConstraintTestCase)
  published
    procedure TestMatchesWhenGreater;
    procedure TestMatchesWhenEqual;
    procedure TestDoesNotMatchWhenLess;
    procedure TestMatchesWhenEqualWithEpsilon;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestInRangeConstraint = class(TConstraintTestCase)
  published
    procedure TestMatchesWhenBetween;
    procedure TestMatchesWhenEqualToLowerBound;
    procedure TestMatchesWhenEqualToUpperBound;
    procedure TestMatchesWhenNearlyEqualToLowerBound;
    procedure TestMatchesWhenEqualToLowerBoundWithEpsilon;
    procedure TestDoesNotMatchWhenNearlyEqualToLowerBoundWithExactComparison;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestIsOfTypeConstraint = class(TConstraintTestCase)
  strict private
    FBase: TBase;
  strict protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMatchesWhenSameType;
    procedure TestDoesNotMatchWhenBaseType;
    procedure TestDoesNotMatchWhenDescendantType;
  end;

  TestLessThanConstraint = class(TConstraintTestCase)
  published
    procedure TestDoesNotMatchWhenGreater;
    procedure TestDoesNotMatchWhenEqual;
    procedure TestMatchesWhenLess;
    procedure TestDoesNotMatchWhenEqualWithEpsilon;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestLessThanOrEqualToConstraint = class(TConstraintTestCase)
  published
    procedure TestDoesNotMatchWhenGreater;
    procedure TestMatchesWhenEqual;
    procedure TestMatchesWhenLess;
    procedure TestMatchesWhenEqualWithEpsilon;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestNotConstraint = class(TConstraintTestCase)
  published
    procedure TestMatches;
    procedure TestDoesNotMatch;
    procedure TestDoesNotMatchWithEpsilon;
    procedure TestIntegerFailureMessage;
    procedure TestStringFailureMessage;
  end;

  TestRefersToConstraint = class(TConstraintTestCase)
  strict private
    function NilInterface: IInterface;
    function NilObject: TObject;
  published
    procedure TestMatchesObjects;
    procedure TestDoesNotMatchObjects;
    procedure TestObjectDoesNotMatchNilObject;
    procedure TestNilObjectDoesNotMatchObject;
    procedure TestObjectObjectFailureMessage;
    procedure TestMatchesInterfaces;
    procedure TestDoesNotMatchInterfaces;
    procedure TestInterfaceDoesNotMatchNilInterface;
    procedure TestNilInterfaceDoesNotMatchInterface;
    procedure TestMatchesDifferentInterfacesOnSameInstance;
    procedure TestInterfaceInterfaceFailureMessage;
    procedure TestObjectMatchesInterface;
    procedure TestObjectDoesNotMatchOtherInterfaceInstance;
    procedure TestNilObjectMatchesNilInterface;
    procedure TestInterfaceMatchesObject;
    procedure TestInterfaceDoesNotMatchOtherObjectInstance;
    procedure TestNilInterfaceMatchesNilObject;
  end;

implementation

uses
  Specifiers,
  SysUtils;

{ TConstraintTestCase }

procedure TConstraintTestCase.CheckDoesNotMatch(const AActualValue: TValue;
  const Constraint: IConstraint);
begin
  CheckFalse(Constraint.Matches(AActualValue));
end;

procedure TConstraintTestCase.CheckExpectedAndActualStrings(
  const ExpectedExpected, ExpectedActual: string; const AActualValue: TValue;
  const Constraint: IConstraint);
var
  Strings: TExpectedAndActual;
begin
  Strings := Constraint.ExpectedAndActual(AActualValue);
  CheckEquals(ExpectedExpected, Strings.Expected, 'Expected');
  CheckEquals(ExpectedActual, Strings.Actual, 'Actual');
end;

procedure TConstraintTestCase.CheckMatches(const AActualValue: TValue;
  const Constraint: IConstraint);
begin
  CheckTrue(Constraint.Matches(AActualValue));
end;

{ TestBetweenConstraint }

procedure TestBetweenConstraint.TestDoesNotMatchWhenEqualToLowerBound;
begin
  CheckDoesNotMatch(4.0, Should.Be.Between(4.0, 5.0));
end;

procedure TestBetweenConstraint.TestDoesNotMatchWhenEqualToLowerBoundWithEpsilon;
begin
  CheckDoesNotMatch(4.125, Should.Be.Between(4.0, 5.0).ToWithin(0.25));
end;

procedure TestBetweenConstraint.TestDoesNotMatchWhenEqualToUpperBound;
begin
  CheckDoesNotMatch(5.0, Should.Be.Between(4.0, 5.0));
end;

procedure TestBetweenConstraint.TestDoesNotMatchWhenNearlyEqualToLowerBound;
begin
  CheckDoesNotMatch(EpsilonTestValues.SameAtDefaultEpsilon,
    Should.Be.Between(EpsilonTestValues.BaseValue, EpsilonTestValues.BaseValue + 1));
end;

procedure TestBetweenConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('in range (1, 2)', '0', 0, Should.Be.Between(1, 2));
end;

procedure TestBetweenConstraint.TestMatches;
begin
  CheckMatches(4.5, Should.Be.Between(4.0, 5.0));
end;

procedure TestBetweenConstraint.TestMatchesWhenNearlyEqualToLowerBoundWithExactComparison;
begin
  CheckMatches(EpsilonTestValues.SameAtDefaultEpsilon,
    Should.Be.Between(EpsilonTestValues.BaseValue, EpsilonTestValues.BaseValue + 1).Exactly);
end;

procedure TestBetweenConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('in range (''1'', ''2'')', '''0''',
    '0', Should.Be.Between('1', '2'));
end;

{ TestEqualConstraint }

procedure TestEqualConstraint.TestDoesNotMatch;
begin
  CheckDoesNotMatch(5, Should.Equal(4));
end;

procedure TestEqualConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('1', '2', 2, Should.Equal(1));
end;

procedure TestEqualConstraint.TestMatches;
begin
  CheckMatches(4, Should.Equal(4));
end;

procedure TestEqualConstraint.TestMatchesWithEpsilon;
begin
  CheckMatches(4.25, Should.Equal(4).ToWithin(0.5));
end;

procedure TestEqualConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('''1''', '''2''', '2', Should.Equal('1'));
end;

{ TestGreaterThanConstraint }

procedure TestGreaterThanConstraint.TestDoesNotMatchWhenEqual;
begin
  CheckDoesNotMatch(4.0, Should.Be.GreaterThan(4.0));
end;

procedure TestGreaterThanConstraint.TestDoesNotMatchWhenEqualWithEpsilon;
begin
  CheckDoesNotMatch(4.25, Should.Be.GreaterThan(4.0).ToWithin(0.5));
end;

procedure TestGreaterThanConstraint.TestDoesNotMatchWhenLess;
begin
  CheckDoesNotMatch(3.75, Should.Be.GreaterThan(4.0));
end;

procedure TestGreaterThanConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('> 1', '1', 1, Should.Be.GreaterThan(1));
end;

procedure TestGreaterThanConstraint.TestMatchesWhenGreater;
begin
  CheckMatches(4.25, Should.Be.GreaterThan(4.0));
end;

procedure TestGreaterThanConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('> ''1''', '''1''', '1', Should.Be.GreaterThan('1'));
end;

{ TestGreaterThanOrEqualToConstraint }

procedure TestGreaterThanOrEqualToConstraint.TestDoesNotMatchWhenLess;
begin
  CheckDoesNotMatch(3.75, Should.Be.GreaterThanOrEqualTo(4.0));
end;

procedure TestGreaterThanOrEqualToConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('>= 1', '0', 0, Should.Be.GreaterThanOrEqualTo(1));
end;

procedure TestGreaterThanOrEqualToConstraint.TestMatchesWhenEqual;
begin
  CheckMatches(4.0, Should.Be.GreaterThanOrEqualTo(4.0));
end;

procedure TestGreaterThanOrEqualToConstraint.TestMatchesWhenEqualWithEpsilon;
begin
  CheckMatches(3.75, Should.Be.GreaterThanOrEqualTo(4.0).ToWithin(0.5));
end;

procedure TestGreaterThanOrEqualToConstraint.TestMatchesWhenGreater;
begin
  CheckMatches(4.25, Should.Be.GreaterThanOrEqualTo(4.0));
end;

procedure TestGreaterThanOrEqualToConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('>= ''1''', '''0''', '0', Should.Be.GreaterThanOrEqualTo('1'));
end;

{ TestInRangeConstraint }

procedure TestInRangeConstraint.TestDoesNotMatchWhenNearlyEqualToLowerBoundWithExactComparison;
begin
  CheckDoesNotMatch(EpsilonTestValues.BaseValue,
    Should.Be.Between(EpsilonTestValues.SameAtDefaultEpsilon, EpsilonTestValues.BaseValue + 1).Exactly);
end;

procedure TestInRangeConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('in range [1, 2]', '0', 0, Should.Be.InRange(1, 2));
end;

procedure TestInRangeConstraint.TestMatchesWhenBetween;
begin
  CheckMatches(4.5, Should.Be.InRange(4.0, 5.0));
end;

procedure TestInRangeConstraint.TestMatchesWhenEqualToLowerBound;
begin
  CheckMatches(4.0, Should.Be.InRange(4.0, 5.0));
end;

procedure TestInRangeConstraint.TestMatchesWhenEqualToLowerBoundWithEpsilon;
begin
  CheckMatches(3.875, Should.Be.InRange(4.0, 5.0).ToWithin(0.25));
end;

procedure TestInRangeConstraint.TestMatchesWhenEqualToUpperBound;
begin
  CheckMatches(5.0, Should.Be.InRange(4.0, 5.0));
end;

procedure TestInRangeConstraint.TestMatchesWhenNearlyEqualToLowerBound;
begin
  CheckMatches(EpsilonTestValues.BaseValue,
    Should.Be.InRange(EpsilonTestValues.SameAtDefaultEpsilon, EpsilonTestValues.BaseValue + 1));
end;

procedure TestInRangeConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('in range [''1'', ''2'']', '''0''',
    '0', Should.Be.InRange('1', '2'));
end;

{ TestIsOfTypeConstraint }

procedure TestIsOfTypeConstraint.SetUp;
begin
  inherited;
  FBase := TBase.Create;
end;

procedure TestIsOfTypeConstraint.TearDown;
begin
  FreeAndNil(FBase);
  inherited;
end;

procedure TestIsOfTypeConstraint.TestDoesNotMatchWhenBaseType;
begin
  CheckDoesNotMatch(FBase, Should.Be.OfType(TObject));
end;

procedure TestIsOfTypeConstraint.TestDoesNotMatchWhenDescendantType;
begin
  CheckDoesNotMatch(FBase, Should.Be.OfType(TSub));
end;

procedure TestIsOfTypeConstraint.TestMatchesWhenSameType;
begin
  CheckMatches(FBase, Should.Be.OfType(TBase));
end;

{ TestLessThanConstraint }

procedure TestLessThanConstraint.TestDoesNotMatchWhenEqual;
begin
  CheckDoesNotMatch(4.0, Should.Be.LessThan(4.0));
end;

procedure TestLessThanConstraint.TestDoesNotMatchWhenEqualWithEpsilon;
begin
  CheckDoesNotMatch(3.75, Should.Be.LessThan(4.0).ToWithin(0.5));
end;

procedure TestLessThanConstraint.TestDoesNotMatchWhenGreater;
begin
  CheckDoesNotMatch(4.25, Should.Be.LessThan(4.0));
end;

procedure TestLessThanConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('< 1', '1', 1, Should.Be.LessThan(1));
end;

procedure TestLessThanConstraint.TestMatchesWhenLess;
begin
  CheckMatches(3.75, Should.Be.LessThan(4.0));
end;

procedure TestLessThanConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('< ''1''', '''1''', '1', Should.Be.LessThan('1'));
end;

{ TestLessThanOrEqualToConstraint }

procedure TestLessThanOrEqualToConstraint.TestDoesNotMatchWhenGreater;
begin
  CheckDoesNotMatch(4.25, Should.Be.LessThanOrEqualTo(4.0));
end;

procedure TestLessThanOrEqualToConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('<= 1', '2', 2, Should.Be.LessThanOrEqualTo(1));
end;

procedure TestLessThanOrEqualToConstraint.TestMatchesWhenEqual;
begin
  CheckMatches(4.0, Should.Be.LessThanOrEqualTo(4.0));
end;

procedure TestLessThanOrEqualToConstraint.TestMatchesWhenEqualWithEpsilon;
begin
  CheckMatches(4.25, Should.Be.LessThanOrEqualTo(4.0).ToWithin(0.5));
end;

procedure TestLessThanOrEqualToConstraint.TestMatchesWhenLess;
begin
  CheckMatches(3.75, Should.Be.LessThanOrEqualTo(4.0));
end;

procedure TestLessThanOrEqualToConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('<= ''1''', '''2''', '2', Should.Be.LessThanOrEqualTo('1'));
end;

{ TestNotConstraint }

procedure TestNotConstraint.TestDoesNotMatch;
begin
  CheckDoesNotMatch(4, Should.Not.Equal(4));
end;

procedure TestNotConstraint.TestDoesNotMatchWithEpsilon;
begin
  CheckDoesNotMatch(4.25, Should.Not.Equal(4).ToWithin(0.5));
end;

procedure TestNotConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('not 1', '1', 1, Should.Not.Equal(1));
end;

procedure TestNotConstraint.TestMatches;
begin
  CheckMatches(5, Should.Not.Equal(4));
end;

procedure TestNotConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('not ''1''', '''1''', '1', Should.Not.Equal('1'));
end;

{ TestRefersToConstraint }

function TestRefersToConstraint.NilInterface: IInterface;
begin
  Result := nil;
end;

function TestRefersToConstraint.NilObject: TObject;
begin
  Result := nil;
end;

procedure TestRefersToConstraint.TestDoesNotMatchInterfaces;
var
  A: IInterface;
  B: IInterface;
begin
  A := TInterfacedObject.Create;
  B := TInterfacedObject.Create;
  CheckDoesNotMatch(A, Should.ReferTo(B));
end;

procedure TestRefersToConstraint.TestDoesNotMatchObjects;
var
  OtherObject: TObject;
begin
  OtherObject := TObject.Create;
  try
    CheckDoesNotMatch(Self, Should.ReferTo(OtherObject));
  finally
    FreeAndNil(OtherObject);
  end;
end;

procedure TestRefersToConstraint.TestInterfaceDoesNotMatchNilInterface;
var
  Intf: IInterface;
begin
  Intf := TInterfacedObject.Create;
  CheckDoesNotMatch(Intf, Should.ReferTo(NilInterface));
end;

procedure TestRefersToConstraint.TestInterfaceDoesNotMatchOtherObjectInstance;
var
  Obj: TObject;
  Intf: IInterface;
begin
  Obj := TObject.Create;
  try
    Intf := TInterfacedObject.Create;
    CheckDoesNotMatch(Intf, Should.ReferTo(Obj));
  finally
    FreeAndNil(Obj);
  end;
end;

procedure TestRefersToConstraint.TestInterfaceInterfaceFailureMessage;
var
  A: IInterface;
  B: IInterface;
begin
  A := TInterfacedObject.Create;
  B := TInterfacedObject.Create;
  CheckExpectedAndActualStrings(
    Format('interface($%.8x)', [Integer(B)]),
    Format('interface($%.8x)', [Integer(A)]),
    A, Should.ReferTo(B));
end;

procedure TestRefersToConstraint.TestInterfaceMatchesObject;
var
  Obj: TInterfacedObject;
  Intf: IInterface;
begin
  Obj := TInterfacedObject.Create;
  Intf := Obj;
  CheckMatches(Intf, Should.ReferTo(Obj));
end;

procedure TestRefersToConstraint.TestMatchesDifferentInterfacesOnSameInstance;
var
  Foo: IFoo;
  Bar: IBar;
begin
  Foo := TFooBar.Create;
  Bar := Foo as IBar;
  CheckMatches(Foo, Should.ReferTo(Bar));
end;

procedure TestRefersToConstraint.TestMatchesInterfaces;
var
  Intf: IInterface;
begin
  Intf := TInterfacedObject.Create;
  CheckMatches(Intf, Should.ReferTo(Intf));
end;

procedure TestRefersToConstraint.TestMatchesObjects;
begin
  CheckMatches(Self, Should.ReferTo(Self));
end;

procedure TestRefersToConstraint.TestNilInterfaceDoesNotMatchInterface;
var
  Intf: IInterface;
begin
  Intf := TInterfacedObject.Create;
  CheckDoesNotMatch(NilInterface, Should.ReferTo(Intf));
end;

procedure TestRefersToConstraint.TestNilInterfaceMatchesNilObject;
begin
  CheckMatches(NilInterface, Should.ReferTo(NilObject));
end;

procedure TestRefersToConstraint.TestNilObjectDoesNotMatchObject;
begin
  CheckDoesNotMatch(NilObject, Should.ReferTo(Self));
end;

procedure TestRefersToConstraint.TestNilObjectMatchesNilInterface;
begin
  CheckMatches(NilObject, Should.ReferTo(NilInterface));
end;

procedure TestRefersToConstraint.TestObjectDoesNotMatchNilObject;
begin
  CheckDoesNotMatch(Self, Should.ReferTo(NilObject));
end;

procedure TestRefersToConstraint.TestObjectDoesNotMatchOtherInterfaceInstance;
var
  Obj: TObject;
  Intf: IInterface;
begin
  Obj := TObject.Create;
  try
    Intf := TInterfacedObject.Create;
    CheckDoesNotMatch(Obj, Should.ReferTo(Intf));
  finally
    FreeAndNil(Obj);
  end;
end;

procedure TestRefersToConstraint.TestObjectMatchesInterface;
var
  Obj: TInterfacedObject;
  Intf: IInterface;
begin
  Obj := TInterfacedObject.Create;
  Intf := Obj;
  CheckMatches(Obj, Should.ReferTo(Intf));
end;

procedure TestRefersToConstraint.TestObjectObjectFailureMessage;
var
  OtherObject: TObject;
begin
  OtherObject := TObject.Create;
  try
    CheckExpectedAndActualStrings(
      Format('%s($%.8x)', [ClassName, Integer(Self)]),
      Format('TObject($%.8x)', [Integer(OtherObject)]),
      OtherObject, Should.ReferTo(Self));
  finally
    FreeAndNil(OtherObject);
  end;
end;

initialization
  TestBetweenConstraint.Register;
  TestEqualConstraint.Register;
  TestGreaterThanConstraint.Register;
  TestGreaterThanOrEqualToConstraint.Register;
  TestInRangeConstraint.Register;
  TestIsOfTypeConstraint.Register;
  TestLessThanConstraint.Register;
  TestLessThanOrEqualToConstraint.Register;
  TestNotConstraint.Register;
  TestRefersToConstraint.Register;
end.
