unit SpecifierTests;

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
  TestSpecify = class(TRegisterableTestCase)
  strict private
    FBase: TBase;
    procedure SpecifyShouldFail(AValue: TValue; SatisfiesCondition: IConstraint;
      AExpectedExceptionMessage: string);
    procedure SpecifyShouldFailGivenMessage(AValue: TValue; SatisfiesCondition: IConstraint;
      AMessage: string; AExpectedExceptionMessage: string);
  strict protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // All specifications support messages
    procedure TestPassingWithMessage;
    procedure TestFailingWithMessage;
    // Equality: Should.Equal, including "ToWithin" and "Exactly"
    procedure TestPassingShouldEqual;
    procedure TestFailingShouldEqual;
    procedure TestPassingShouldEqualToWithin;
    procedure TestFailingShouldEqualToWithin;
    procedure TestPassingShouldEqualExactly;
    procedure TestFailingShouldEqualExactly;
    procedure TestPassingShouldNotEqual;
    procedure TestFailingShouldNotEqual;
    procedure TestPassingShouldNotEqualToWithin;
    procedure TestFailingShouldNotEqualToWithin;
    procedure TestPassingShouldNotEqualExactly;
    procedure TestFailingShouldNotEqualExactly;
    procedure TestFailingLongStringsShouldEqual;
    // Class: Should.Be.OfType
    procedure TestPassingShouldBeOfType;
    procedure TestFailingShouldBeOfType;
    procedure TestFailingShouldBeOfTypeWhenNil;
    procedure TestPassingShouldNotBeOfType;
    procedure TestPassingShouldNotBeOfTypeWhenNil;
    procedure TestFailingShouldNotBeOfType;
    // Inequality: Should.Be.AtLeast
    procedure TestPassingShouldBeAtLeast;
    procedure TestFailingShouldBeAtLeast;
    procedure TestPassingShouldNotBeAtLeast;
    procedure TestFailingShouldNotBeAtLeast;
    // Inequality: Should.Be.AtMost
    procedure TestPassingShouldBeAtMost;
    procedure TestFailingShouldBeAtMost;
    procedure TestPassingShouldNotBeAtMost;
    procedure TestFailingShouldNotBeAtMost;
    // Inequality: Should.Be.Between
    procedure TestPassingShouldBeBetween;
    procedure TestFailingShouldBeBetween;
    procedure TestPassingShouldNotBeBetween;
    procedure TestFailingShouldNotBeBetween;
    // Inequality: Should.Be.GreaterThan
    procedure TestPassingShouldBeGreaterThan;
    procedure TestFailingShouldBeGreaterThan;
    procedure TestPassingShouldNotBeGreaterThan;
    procedure TestFailingShouldNotBeGreaterThan;
    // Inequality: Should.Be.InRange
    procedure TestPassingShouldBeInRange;
    procedure TestFailingShouldBeInRange;
    procedure TestPassingShouldNotBeInRange;
    procedure TestFailingShouldNotBeInRange;
    // Inequality: Should.Be.LessThan
    procedure TestPassingShouldBeLessThan;
    procedure TestFailingShouldBeLessThan;
    procedure TestPassingShouldNotBeLessThan;
    procedure TestFailingShouldNotBeLessThan;
  end;

implementation

uses
  Specifiers,
  SysUtils,
  TestFramework;

{ TestSpecify }

procedure TestSpecify.SetUp;
begin
  inherited;
  FBase := TBase.Create;
end;

procedure TestSpecify.SpecifyShouldFail(AValue: TValue;
  SatisfiesCondition: IConstraint; AExpectedExceptionMessage: string);
begin
  SpecifyShouldFailGivenMessage(AValue, SatisfiesCondition, '', AExpectedExceptionMessage);
end;

procedure TestSpecify.SpecifyShouldFailGivenMessage(AValue: TValue;
  SatisfiesCondition: IConstraint; AMessage, AExpectedExceptionMessage: string);
var
  ExceptionMessage: string;
begin
  // can't use ExpectedException, because it doesn't work for ETestFailure
  ExceptionMessage := 'no exception';
  try
    Specify.That(AValue, SatisfiesCondition, AMessage);
  except
    on E: ETestFailure do
      ExceptionMessage := E.Message;
  end;
  CheckEquals(AExpectedExceptionMessage, ExceptionMessage);
end;

procedure TestSpecify.TearDown;
begin
  FreeAndNil(FBase);
  inherited;
end;

procedure TestSpecify.TestFailingLongStringsShouldEqual;
begin
  SpecifyShouldFail(StringOfChar('<', 100) + '1' + StringOfChar('>', 100),
    Should.Equal(StringOfChar('<', 100) + '2' + StringOfChar('>', 100)),
    'Expected: ...''<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<2>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>''...'#13#10 +
    ' but was: ...''<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<1>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>''...');
end;

procedure TestSpecify.TestFailingShouldBeAtLeast;
begin
  SpecifyShouldFail(1, Should.Be.AtLeast(2), 'Expected: >= 2'#13#10' but was: 1');
end;

procedure TestSpecify.TestFailingShouldBeAtMost;
begin
  SpecifyShouldFail(2, Should.Be.AtMost(1), 'Expected: <= 1'#13#10' but was: 2');
end;

procedure TestSpecify.TestFailingShouldBeBetween;
begin
  SpecifyShouldFail(0, Should.Be.Between(1, 3),
    'Expected: in range (1, 3)'#13#10' but was: 0');
end;

procedure TestSpecify.TestFailingShouldBeGreaterThan;
begin
  SpecifyShouldFail(2, Should.Be.GreaterThan(2),
    'Expected: > 2'#13#10' but was: 2');
end;

procedure TestSpecify.TestFailingShouldBeInRange;
begin
  SpecifyShouldFail(4, Should.Be.InRange(1, 3),
    'Expected: in range [1, 3]'#13#10' but was: 4');
end;

procedure TestSpecify.TestFailingShouldBeLessThan;
begin
  SpecifyShouldFail(3, Should.Be.LessThan(3),
    'Expected: < 3'#13#10' but was: 3');
end;

procedure TestSpecify.TestFailingShouldBeOfType;
begin
  SpecifyShouldFail(FBase, Should.Be.OfType(TObject),
    'Expected: TObject'#13#10' but was: TBase');
end;

procedure TestSpecify.TestFailingShouldBeOfTypeWhenNil;
begin
  SpecifyShouldFail(nil, Should.Be.OfType(TObject),
    'Expected: TObject'#13#10' but was: nil object');
end;

procedure TestSpecify.TestFailingShouldEqual;
begin
  SpecifyShouldFail(1, Should.Equal(2), 'Expected: 2'#13#10' but was: 1');
end;

procedure TestSpecify.TestFailingShouldEqualExactly;
begin
  SpecifyShouldFail(EpsilonTestValues.BaseValue,
    Should.Equal(EpsilonTestValues.BarelyDifferent).Exactly,
    'Expected: 42 (exactly)'#13#10' but was: 42');
end;

procedure TestSpecify.TestFailingShouldEqualToWithin;
begin
  SpecifyShouldFail(1.0, Should.Equal(1.75).ToWithin(0.5),
    'Expected: 1.75 (to within 0.5)'#13#10' but was: 1');
end;

procedure TestSpecify.TestFailingShouldNotBeAtLeast;
begin
  SpecifyShouldFail(1, Should.Not.Be.AtLeast(1),
    'Expected: not >= 1'#13#10' but was: 1');
  SpecifyShouldFail(2, Should.Not.Be.AtLeast(1),
    'Expected: not >= 1'#13#10' but was: 2');
end;

procedure TestSpecify.TestFailingShouldNotBeAtMost;
begin
  SpecifyShouldFail(1, Should.Not.Be.AtMost(1),
    'Expected: not <= 1'#13#10' but was: 1');
  SpecifyShouldFail(1, Should.Not.Be.AtMost(2),
    'Expected: not <= 2'#13#10' but was: 1');
end;

procedure TestSpecify.TestFailingShouldNotBeBetween;
begin
  SpecifyShouldFail(2, Should.Not.Be.Between(1, 3),
    'Expected: not in range (1, 3)'#13#10' but was: 2');
end;

procedure TestSpecify.TestFailingShouldNotBeGreaterThan;
begin
  SpecifyShouldFail(3, Should.Not.Be.GreaterThan(2),
    'Expected: not > 2'#13#10' but was: 3');
end;

procedure TestSpecify.TestFailingShouldNotBeInRange;
begin
  SpecifyShouldFail(3, Should.Not.Be.InRange(1, 3),
    'Expected: not in range [1, 3]'#13#10' but was: 3');
end;

procedure TestSpecify.TestFailingShouldNotBeLessThan;
begin
  SpecifyShouldFail(2, Should.Not.Be.LessThan(3),
    'Expected: not < 3'#13#10' but was: 2');
end;

procedure TestSpecify.TestFailingShouldNotBeOfType;
begin
  SpecifyShouldFail(FBase, Should.Not.Be.OfType(TBase),
    'Expected: not TBase'#13#10' but was: TBase');
end;

procedure TestSpecify.TestFailingShouldNotEqual;
begin
  SpecifyShouldFail(1, Should.Not.Equal(1), 'Expected: not 1'#13#10' but was: 1');
end;

procedure TestSpecify.TestFailingShouldNotEqualExactly;
begin
  SpecifyShouldFail(1.0, Should.Not.Equal(1.0).Exactly,
    'Expected: not 1 (exactly)'#13#10' but was: 1');
end;

procedure TestSpecify.TestFailingShouldNotEqualToWithin;
begin
  SpecifyShouldFail(1.0, Should.Not.Equal(1.25).ToWithin(0.5),
    'Expected: not 1.25 (to within 0.5)'#13#10' but was: 1');
end;

procedure TestSpecify.TestFailingWithMessage;
begin
  SpecifyShouldFailGivenMessage(2, Should.Equal(1), 'One',
    'One'#13#10'Expected: 1'#13#10' but was: 2');
end;

procedure TestSpecify.TestPassingShouldBeAtLeast;
begin
  Specify.That(1, Should.Be.AtLeast(1));
  Specify.That(2, Should.Be.AtLeast(1));
end;

procedure TestSpecify.TestPassingShouldBeAtMost;
begin
  Specify.That(1, Should.Be.AtMost(1));
  Specify.That(1, Should.Be.AtMost(2));
end;

procedure TestSpecify.TestPassingShouldBeBetween;
begin
  Specify.That(2, Should.Be.Between(1, 3));
end;

procedure TestSpecify.TestPassingShouldBeGreaterThan;
begin
  Specify.That(3, Should.Be.GreaterThan(2));
end;

procedure TestSpecify.TestPassingShouldBeInRange;
begin
  Specify.That(3, Should.Be.InRange(1, 3));
end;

procedure TestSpecify.TestPassingShouldBeLessThan;
begin
  Specify.That(2, Should.Be.LessThan(3));
end;

procedure TestSpecify.TestPassingShouldBeOfType;
begin
  Specify.That(FBase, Should.Be.OfType(TBase));
end;

procedure TestSpecify.TestPassingShouldEqual;
begin
  Specify.That(1, Should.Equal(1));
end;

procedure TestSpecify.TestPassingShouldEqualExactly;
begin
  Specify.That(1.0, Should.Equal(1.0).Exactly);
end;

procedure TestSpecify.TestPassingShouldEqualToWithin;
begin
  Specify.That(1.0, Should.Equal(1.25).ToWithin(0.5));
end;

procedure TestSpecify.TestPassingShouldNotBeAtLeast;
begin
  Specify.That(1, Should.Not.Be.AtLeast(2));
end;

procedure TestSpecify.TestPassingShouldNotBeAtMost;
begin
  Specify.That(2, Should.Not.Be.AtMost(1));
end;

procedure TestSpecify.TestPassingShouldNotBeBetween;
begin
  Specify.That(0, Should.Not.Be.Between(1, 3));
end;

procedure TestSpecify.TestPassingShouldNotBeGreaterThan;
begin
  Specify.That(2, Should.Not.Be.GreaterThan(2));
end;

procedure TestSpecify.TestPassingShouldNotBeInRange;
begin
  Specify.That(4, Should.Not.Be.InRange(1, 3));
end;

procedure TestSpecify.TestPassingShouldNotBeLessThan;
begin
  Specify.That(3, Should.Not.Be.LessThan(3));
end;

procedure TestSpecify.TestPassingShouldNotBeOfType;
begin
  Specify.That(FBase, Should.Not.Be.OfType(TObject));
end;

procedure TestSpecify.TestPassingShouldNotBeOfTypeWhenNil;
begin
  Specify.That(nil, Should.Not.Be.OfType(TObject));
end;

procedure TestSpecify.TestPassingShouldNotEqual;
begin
  Specify.That(1, Should.Not.Equal(2));
end;

procedure TestSpecify.TestPassingShouldNotEqualExactly;
begin
  Specify.That(EpsilonTestValues.BaseValue,
    Should.Not.Equal(EpsilonTestValues.BarelyDifferent).Exactly);
end;

procedure TestSpecify.TestPassingShouldNotEqualToWithin;
begin
  Specify.That(1.0, Should.Not.Equal(1.75).ToWithin(0.5));
end;

procedure TestSpecify.TestPassingWithMessage;
begin
  Specify.That(1, Should.Equal(1), 'Message');
end;

initialization
  TestSpecify.Register;
end.
