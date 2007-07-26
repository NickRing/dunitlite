unit ValueComparerSpecs;

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
  ValueComparers;

type
  TValueComparerSpecification = class(TRegisterableTestCase)
  strict protected
    function GetComparer: IValueComparer; virtual; abstract;
    procedure SpecifyThatComparing(const A, B: Extended;
      SatisfiesCondition: IConstraint);
    procedure SpecifyThatIndexOfFirstDifferenceBetween(const A, B: string;
      SatisfiesCondition: IConstraint);

    property Comparer: IValueComparer read GetComparer;
  published
    procedure SpecExactlyEqual;
    procedure SpecLess;
    procedure SpecGreater;
  end;

  DefaultValueComparerSpec = class(TValueComparerSpecification)
  strict protected
    function GetComparer: IValueComparer; override;
  published
    procedure SpecCloseEnough;
    procedure SpecNotCloseEnough;
    procedure SpecAsString;
    procedure SpecIndexOfFirstDifference;
    procedure SpecIndexOfFirstDifferenceWhenFirstIsLeadingSubstring;
    procedure SpecIndexOfFirstDifferenceWhenSecondIsLeadingSubstring;
    procedure SpecIndexOfFirstDifferenceWhenStringsAreEqual;
  end;

  ExactComparerSpec = class(TValueComparerSpecification)
  strict protected
    function GetComparer: IValueComparer; override;
  published
    procedure SpecCloseButNoCigar;
    procedure SpecAsString;
  end;

  EpsilonComparerSpec = class(TValueComparerSpecification)
  strict protected
    function GetComparer: IValueComparer; override;
  published
    procedure SpecCloseEnough;
    procedure SpecNotCloseEnough;
    procedure SpecAsString;
  end;

implementation

uses
  Specifiers,
  TestValues,
  TypInfo;

{ TValueComparerSpecification }

procedure TValueComparerSpecification.SpecifyThatComparing(const A, B: Extended;
  SatisfiesCondition: IConstraint);
begin
  Specify.That(Comparer.CompareExtendeds(A, B), SatisfiesCondition);
end;

procedure TValueComparerSpecification.SpecifyThatIndexOfFirstDifferenceBetween(
  const A, B: string; SatisfiesCondition: IConstraint);
begin
  Specify.That(Comparer.IndexOfFirstDifference(A, B), SatisfiesCondition);
end;

procedure TValueComparerSpecification.SpecExactlyEqual;
begin
  SpecifyThatComparing(1, 1, Should.Yield(vcEqual));
end;

procedure TValueComparerSpecification.SpecGreater;
begin
  SpecifyThatComparing(2, 1, Should.Yield(vcGreater));
end;

procedure TValueComparerSpecification.SpecLess;
begin
  SpecifyThatComparing(1, 2, Should.Yield(vcLess));
end;

{ DefaultValueComparerSpec }

function DefaultValueComparerSpec.GetComparer: IValueComparer;
begin
  Result := TDefaultValueComparer.Instance;
end;

procedure DefaultValueComparerSpec.SpecAsString;
begin
  Specify.That(Comparer.AsString, Should.Equal(''));
end;

procedure DefaultValueComparerSpec.SpecCloseEnough;
begin
  SpecifyThatComparing(EpsilonTestValues.BaseValue, EpsilonTestValues.SameAtDefaultEpsilon,
    Should.Yield(vcEqual));
end;

procedure DefaultValueComparerSpec.SpecIndexOfFirstDifference;
begin
  SpecifyThatIndexOfFirstDifferenceBetween('abc', 'axc', Should.Equal(2));
end;

procedure DefaultValueComparerSpec.SpecIndexOfFirstDifferenceWhenFirstIsLeadingSubstring;
begin
  SpecifyThatIndexOfFirstDifferenceBetween('abc', 'abcde', Should.Equal(4));
end;

procedure DefaultValueComparerSpec.SpecIndexOfFirstDifferenceWhenSecondIsLeadingSubstring;
begin
  SpecifyThatIndexOfFirstDifferenceBetween('abcde', 'abc', Should.Equal(4));
end;

procedure DefaultValueComparerSpec.SpecIndexOfFirstDifferenceWhenStringsAreEqual;
begin
  SpecifyThatIndexOfFirstDifferenceBetween('abc', 'abc', Should.Equal(0));
end;

procedure DefaultValueComparerSpec.SpecNotCloseEnough;
begin
  SpecifyThatComparing(EpsilonTestValues.BaseValue, EpsilonTestValues.DifferentAtDefaultEpsilon,
    Should.Yield(vcLess));
end;

{ ExactComparerSpec }

function ExactComparerSpec.GetComparer: IValueComparer;
begin
  Result := TExactValueComparer.Create;
end;

procedure ExactComparerSpec.SpecAsString;
begin
  Specify.That(Comparer.AsString, Should.Equal('exactly'));
end;

procedure ExactComparerSpec.SpecCloseButNoCigar;
begin
  SpecifyThatComparing(EpsilonTestValues.BaseValue, EpsilonTestValues.BarelyDifferent,
    Should.Yield(vcLess));
end;

{ EpsilonComparerSpec }

function EpsilonComparerSpec.GetComparer: IValueComparer;
begin
  Result := TEpsilonValueComparer.Create(0.5);
end;

procedure EpsilonComparerSpec.SpecAsString;
begin
  Specify.That(Comparer.AsString, Should.Equal('to within 0.5'));
end;

procedure EpsilonComparerSpec.SpecCloseEnough;
begin
  SpecifyThatComparing(1.0, 1.5, Should.Yield(vcEqual));
end;

procedure EpsilonComparerSpec.SpecNotCloseEnough;
begin
  SpecifyThatComparing(1.0, 1.51, Should.Yield(vcLess));
end;

initialization
  DefaultValueComparerSpec.Register;
  ExactComparerSpec.Register;
  EpsilonComparerSpec.Register;
end.
