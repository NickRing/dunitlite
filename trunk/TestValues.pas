unit TestValues;

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
  RegisterableTestCases;

type
  IFoo = interface
  ['{2D8CD618-C413-4926-AA3E-325C45812AC0}']
  end;
  IBar = interface
  ['{5157E28C-B514-4811-AAB9-DE06D63B5CC1}']
  end;
  TFooBar = class(TInterfacedObject, IFoo, IBar)
  end;

  TBase = class
  end;
  TSub = class(TBase)
  end;

  EpsilonTestValues = class
  const
    BaseValue                 = 42.0;
    SameAtDefaultEpsilon      = 42.00000000001;
    DifferentAtDefaultEpsilon = 42.0000000001;
    BarelyDifferent           = 42.00000000000000001;
  end;

  TestEpsilonTestValues = class(TRegisterableTestCase)
  strict private
    FComparisonValue: Extended;
    procedure CheckBaseIsEqualAsDouble;
    procedure CheckBaseIsSameValueAsDouble;
    procedure CheckBaseIsSameValueAsExtended;
    procedure CheckBaseNotEqualAsDouble;
    procedure CheckBaseNotEqualAsExtended;
    procedure CheckBaseNotSameValueAsDouble;
    procedure CheckBaseNotSameValueAsExtended;
  published
    procedure TestSameAtDefaultEpsilon;
    procedure TestDifferentAtDefaultEpsilon;
    procedure TestBarelyDifferent;
  end;

implementation

uses
  Math;

{ TestInterestingEpsilons }

procedure TestEpsilonTestValues.CheckBaseIsEqualAsDouble;
var
  Base: Double;
  Comparison: Double;
begin
  Base := EpsilonTestValues.BaseValue;
  Comparison := FComparisonValue;
  CheckTrue(Base = Comparison, 'Should be equal at Double precision');
end;

procedure TestEpsilonTestValues.CheckBaseIsSameValueAsDouble;
var
  Base: Double;
  Comparison: Double;
begin
  Base := EpsilonTestValues.BaseValue;
  Comparison := FComparisonValue;
  CheckTrue(SameValue(Base, Comparison), 'Should be SameValue at Double precision');
end;

procedure TestEpsilonTestValues.CheckBaseIsSameValueAsExtended;
begin
  CheckTrue(SameValue(EpsilonTestValues.BaseValue, FComparisonValue),
    'Should be SameValue at Extended precision');
end;

procedure TestEpsilonTestValues.CheckBaseNotEqualAsDouble;
var
  Base: Double;
  Comparison: Double;
begin
  Base := EpsilonTestValues.BaseValue;
  Comparison := FComparisonValue;
  CheckFalse(Base = Comparison, 'Should not be equal at Double precision');
end;

procedure TestEpsilonTestValues.CheckBaseNotEqualAsExtended;
begin
  CheckFalse(EpsilonTestValues.BaseValue = FComparisonValue,
    'Should not be equal at Extended precision');
end;

procedure TestEpsilonTestValues.CheckBaseNotSameValueAsDouble;
var
  Base: Double;
  Comparison: Double;
begin
  Base := EpsilonTestValues.BaseValue;
  Comparison := FComparisonValue;
  CheckFalse(SameValue(Base, Comparison), 'Should not be SameValue at Double precision');
end;

procedure TestEpsilonTestValues.CheckBaseNotSameValueAsExtended;
begin
  CheckFalse(SameValue(EpsilonTestValues.BaseValue, FComparisonValue),
    'Should not be SameValue at Extended precision');
end;

procedure TestEpsilonTestValues.TestBarelyDifferent;
begin
  FComparisonValue := EpsilonTestValues.BarelyDifferent;
  CheckBaseIsEqualAsDouble;
  CheckBaseNotEqualAsExtended;
  CheckBaseIsSameValueAsDouble;
  CheckBaseIsSameValueAsExtended;
end;

procedure TestEpsilonTestValues.TestDifferentAtDefaultEpsilon;
begin
  FComparisonValue := EpsilonTestValues.DifferentAtDefaultEpsilon;
  CheckBaseNotEqualAsDouble;
  CheckBaseNotSameValueAsDouble;
end;

procedure TestEpsilonTestValues.TestSameAtDefaultEpsilon;
begin
  FComparisonValue := EpsilonTestValues.SameAtDefaultEpsilon;
  CheckBaseNotEqualAsDouble;
  CheckBaseIsSameValueAsDouble;
  CheckBaseNotSameValueAsExtended;
end;

initialization
  TestEpsilonTestValues.Register;
end.
