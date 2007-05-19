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
  RegisterableTestCases,
  TestValues,
  Values;

type
  TConstraintTestCase = class(TRegisterableTestCase)
  strict protected
    function Between(const ALowerBound, AUpperBound: TValue): IConstraint;
    procedure CheckDoesNotMatch(const AActualValue: TValue; const Constraint: IConstraint);
    procedure CheckExpectedAndActualStrings(
      const ExpectedExpected, ExpectedActual: string;
      const AActualValue: TValue; const Constraint: IConstraint);
    procedure CheckMatches(const AActualValue: TValue; const Constraint: IConstraint);
    function EqualTo(const AExpectedValue: TValue): IConstraint;
    function GreaterThan(const AExpectedValue: TValue): IConstraint;
    function GreaterThanOrEqualTo(const AExpectedValue: TValue): IConstraint;
    function InRange(const ALowerBound, AUpperBound: TValue): IConstraint;
    function IsOfType(AType: TClass): IConstraint;
    function LessThan(const AExpectedValue: TValue): IConstraint;
    function LessThanOrEqualTo(const AExpectedValue: TValue): IConstraint;
    function NotEqualTo(const AExpectedValue: TValue): IConstraint;
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

implementation

uses
  SysUtils;

{ TConstraintTestCase }

function TConstraintTestCase.Between(const ALowerBound,
  AUpperBound: TValue): IConstraint;
begin
  Result := TRangeConstraint.CreateBetween(ALowerBound, AUpperBound);
end;

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

function TConstraintTestCase.EqualTo(const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateEqualTo(AExpectedValue);
end;

function TConstraintTestCase.GreaterThan(const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateGreaterThan(AExpectedValue);
end;

function TConstraintTestCase.GreaterThanOrEqualTo(
  const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateGreaterThanOrEqualTo(AExpectedValue);
end;

function TConstraintTestCase.InRange(const ALowerBound,
  AUpperBound: TValue): IConstraint;
begin
  Result := TRangeConstraint.CreateInRange(ALowerBound, AUpperBound);
end;

function TConstraintTestCase.IsOfType(AType: TClass): IConstraint;
begin
  Result := TIsOfTypeConstraint.CreateDefault(AType);
end;

function TConstraintTestCase.LessThan(const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateLessThan(AExpectedValue);
end;

function TConstraintTestCase.LessThanOrEqualTo(const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateLessThanOrEqualTo(AExpectedValue);
end;

function TConstraintTestCase.NotEqualTo(const AExpectedValue: TValue): IConstraint;
begin
  Result := TNotConstraint.Create(EqualTo(AExpectedValue));
end;

{ TestBetweenConstraint }

procedure TestBetweenConstraint.TestDoesNotMatchWhenEqualToLowerBound;
begin
  CheckDoesNotMatch(4.0, Between(4.0, 5.0));
end;

procedure TestBetweenConstraint.TestDoesNotMatchWhenEqualToLowerBoundWithEpsilon;
begin
  CheckDoesNotMatch(4.125, Between(4.0, 5.0).ToWithin(0.25));
end;

procedure TestBetweenConstraint.TestDoesNotMatchWhenEqualToUpperBound;
begin
  CheckDoesNotMatch(5.0, Between(4.0, 5.0));
end;

procedure TestBetweenConstraint.TestDoesNotMatchWhenNearlyEqualToLowerBound;
begin
  CheckDoesNotMatch(EpsilonTestValues.SameAtDefaultEpsilon,
    Between(EpsilonTestValues.BaseValue, EpsilonTestValues.BaseValue + 1));
end;

procedure TestBetweenConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('in range (1, 2)', '0', 0, Between(1, 2));
end;

procedure TestBetweenConstraint.TestMatches;
begin
  CheckMatches(4.5, Between(4.0, 5.0));
end;

procedure TestBetweenConstraint.TestMatchesWhenNearlyEqualToLowerBoundWithExactComparison;
begin
  CheckMatches(EpsilonTestValues.SameAtDefaultEpsilon,
    Between(EpsilonTestValues.BaseValue, EpsilonTestValues.BaseValue + 1).Exactly);
end;

procedure TestBetweenConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('in range (''1'', ''2'')', '''0''',
    '0', Between('1', '2'));
end;

{ TestEqualConstraint }

procedure TestEqualConstraint.TestDoesNotMatch;
begin
  CheckDoesNotMatch(5, EqualTo(4));
end;

procedure TestEqualConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('1', '2', 2, EqualTo(1));
end;

procedure TestEqualConstraint.TestMatches;
begin
  CheckMatches(4, EqualTo(4));
end;

procedure TestEqualConstraint.TestMatchesWithEpsilon;
begin
  CheckMatches(4.25, EqualTo(4).ToWithin(0.5));
end;

procedure TestEqualConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('''1''', '''2''', '2', EqualTo('1'));
end;

{ TestGreaterThanConstraint }

procedure TestGreaterThanConstraint.TestDoesNotMatchWhenEqual;
begin
  CheckDoesNotMatch(4.0, GreaterThan(4.0));
end;

procedure TestGreaterThanConstraint.TestDoesNotMatchWhenEqualWithEpsilon;
begin
  CheckDoesNotMatch(4.25, GreaterThan(4.0).ToWithin(0.5));
end;

procedure TestGreaterThanConstraint.TestDoesNotMatchWhenLess;
begin
  CheckDoesNotMatch(3.75, GreaterThan(4.0));
end;

procedure TestGreaterThanConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('> 1', '1', 1, GreaterThan(1));
end;

procedure TestGreaterThanConstraint.TestMatchesWhenGreater;
begin
  CheckMatches(4.25, GreaterThan(4.0));
end;

procedure TestGreaterThanConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('> ''1''', '''1''', '1', GreaterThan('1'));
end;

{ TestGreaterThanOrEqualToConstraint }

procedure TestGreaterThanOrEqualToConstraint.TestDoesNotMatchWhenLess;
begin
  CheckDoesNotMatch(3.75, GreaterThanOrEqualTo(4.0));
end;

procedure TestGreaterThanOrEqualToConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('>= 1', '0', 0, GreaterThanOrEqualTo(1));
end;

procedure TestGreaterThanOrEqualToConstraint.TestMatchesWhenEqual;
begin
  CheckMatches(4.0, GreaterThanOrEqualTo(4.0));
end;

procedure TestGreaterThanOrEqualToConstraint.TestMatchesWhenEqualWithEpsilon;
begin
  CheckMatches(3.75, GreaterThanOrEqualTo(4.0).ToWithin(0.5));
end;

procedure TestGreaterThanOrEqualToConstraint.TestMatchesWhenGreater;
begin
  CheckMatches(4.25, GreaterThanOrEqualTo(4.0));
end;

procedure TestGreaterThanOrEqualToConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('>= ''1''', '''0''', '0', GreaterThanOrEqualTo('1'));
end;

{ TestInRangeConstraint }

procedure TestInRangeConstraint.TestDoesNotMatchWhenNearlyEqualToLowerBoundWithExactComparison;
begin
  CheckDoesNotMatch(EpsilonTestValues.BaseValue,
    Between(EpsilonTestValues.SameAtDefaultEpsilon, EpsilonTestValues.BaseValue + 1).Exactly);
end;

procedure TestInRangeConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('in range [1, 2]', '0', 0, InRange(1, 2));
end;

procedure TestInRangeConstraint.TestMatchesWhenBetween;
begin
  CheckMatches(4.5, InRange(4.0, 5.0));
end;

procedure TestInRangeConstraint.TestMatchesWhenEqualToLowerBound;
begin
  CheckMatches(4.0, InRange(4.0, 5.0));
end;

procedure TestInRangeConstraint.TestMatchesWhenEqualToLowerBoundWithEpsilon;
begin
  CheckMatches(3.875, InRange(4.0, 5.0).ToWithin(0.25));
end;

procedure TestInRangeConstraint.TestMatchesWhenEqualToUpperBound;
begin
  CheckMatches(5.0, InRange(4.0, 5.0));
end;

procedure TestInRangeConstraint.TestMatchesWhenNearlyEqualToLowerBound;
begin
  CheckMatches(EpsilonTestValues.BaseValue,
    InRange(EpsilonTestValues.SameAtDefaultEpsilon, EpsilonTestValues.BaseValue + 1));
end;

procedure TestInRangeConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('in range [''1'', ''2'']', '''0''',
    '0', InRange('1', '2'));
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
  CheckDoesNotMatch(FBase, IsOfType(TObject));
end;

procedure TestIsOfTypeConstraint.TestDoesNotMatchWhenDescendantType;
begin
  CheckDoesNotMatch(FBase, IsOfType(TSub));
end;

procedure TestIsOfTypeConstraint.TestMatchesWhenSameType;
begin
  CheckMatches(FBase, IsOfType(TBase));
end;

{ TestLessThanConstraint }

procedure TestLessThanConstraint.TestDoesNotMatchWhenEqual;
begin
  CheckDoesNotMatch(4.0, LessThan(4.0));
end;

procedure TestLessThanConstraint.TestDoesNotMatchWhenEqualWithEpsilon;
begin
  CheckDoesNotMatch(3.75, LessThan(4.0).ToWithin(0.5));
end;

procedure TestLessThanConstraint.TestDoesNotMatchWhenGreater;
begin
  CheckDoesNotMatch(4.25, LessThan(4.0));
end;

procedure TestLessThanConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('< 1', '1', 1, LessThan(1));
end;

procedure TestLessThanConstraint.TestMatchesWhenLess;
begin
  CheckMatches(3.75, LessThan(4.0));
end;

procedure TestLessThanConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('< ''1''', '''1''', '1', LessThan('1'));
end;

{ TestLessThanOrEqualToConstraint }

procedure TestLessThanOrEqualToConstraint.TestDoesNotMatchWhenGreater;
begin
  CheckDoesNotMatch(4.25, LessThanOrEqualTo(4.0));
end;

procedure TestLessThanOrEqualToConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('<= 1', '2', 2, LessThanOrEqualTo(1));
end;

procedure TestLessThanOrEqualToConstraint.TestMatchesWhenEqual;
begin
  CheckMatches(4.0, LessThanOrEqualTo(4.0));
end;

procedure TestLessThanOrEqualToConstraint.TestMatchesWhenEqualWithEpsilon;
begin
  CheckMatches(4.25, LessThanOrEqualTo(4.0).ToWithin(0.5));
end;

procedure TestLessThanOrEqualToConstraint.TestMatchesWhenLess;
begin
  CheckMatches(3.75, LessThanOrEqualTo(4.0));
end;

procedure TestLessThanOrEqualToConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('<= ''1''', '''2''', '2', LessThanOrEqualTo('1'));
end;

{ TestNotConstraint }

procedure TestNotConstraint.TestDoesNotMatch;
begin
  CheckDoesNotMatch(4, NotEqualTo(4));
end;

procedure TestNotConstraint.TestDoesNotMatchWithEpsilon;
begin
  CheckDoesNotMatch(4.25, NotEqualTo(4).ToWithin(0.5));
end;

procedure TestNotConstraint.TestIntegerFailureMessage;
begin
  CheckExpectedAndActualStrings('not 1', '1', 1, NotEqualTo(1));
end;

procedure TestNotConstraint.TestMatches;
begin
  CheckMatches(5, NotEqualTo(4));
end;

procedure TestNotConstraint.TestStringFailureMessage;
begin
  CheckExpectedAndActualStrings('not ''1''', '''1''', '1', NotEqualTo('1'));
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
end.
