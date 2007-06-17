unit Constraints;

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
  SysUtils,
  ValueComparers,
  Values;

type
  IConstraint = interface;

  TExpectedAndActual = record
    Expected: string;
    Actual: string;
  end;

  IConstraint = interface
  ['{F5019C37-6D37-4DCE-A107-BE7B6EFD1CDF}']
    function ComparerText: string;
    function Exactly: IConstraint;
    function ExpectedAndActual(AActualValue: TValue): TExpectedAndActual;
    function Matches(AActualValue: TValue): Boolean;
    function ToWithin(const AEpsilon: Extended): IConstraint;
  end;

  TBaseConstraint = class(TInterfacedObject, IConstraint)
  strict private
    FComparer: IValueComparer;
  strict protected
    function WithDifferentComparer(AComparer: IValueComparer): IConstraint; virtual; abstract;

    property Comparer: IValueComparer read FComparer;
  public
    constructor Create(AComparer: IValueComparer);
    
    function ComparerText: string;
    function Exactly: IConstraint;
    function ExpectedAndActual(AActualValue: TValue): TExpectedAndActual; virtual; abstract;
    function Matches(AActualValue: TValue): Boolean; virtual; abstract;
    function ToWithin(const AEpsilon: Extended): IConstraint;
  end;

  TComparisonConstraint = class(TBaseConstraint, IConstraint)
  strict private
    FComparisons: TValueComparisonSet;
    FExpectedValue: TValue;
    FMessagePrefix: string;
  strict protected
    function WithDifferentComparer(AComparer: IValueComparer): IConstraint; override;
  public
    constructor Create(AComparisons: TValueComparisonSet; AMessagePrefix: string;
      const AExpectedValue: TValue; AComparer: IValueComparer);

    class function CreateEqualTo(const AExpectedValue: TValue): IConstraint; static;
    class function CreateGreaterThan(const AExpectedValue: TValue): IConstraint; static;
    class function CreateGreaterThanOrEqualTo(const AExpectedValue: TValue): IConstraint; static;
    class function CreateLessThan(const AExpectedValue: TValue): IConstraint; static;
    class function CreateLessThanOrEqualTo(const AExpectedValue: TValue): IConstraint; static;

    function ExpectedAndActual(AActualValue: TValue): TExpectedAndActual; override;
    function Matches(AActualValue: TValue): Boolean; override;
  end;

  TIsOfTypeConstraint = class(TBaseConstraint, IConstraint)
  strict private
    FType: TClass;
  strict protected
    function WithDifferentComparer(AComparer: IValueComparer): IConstraint; override;
  public
    constructor Create(AType: TClass; AComparer: IValueComparer);

    class function CreateDefault(AType: TClass): IConstraint; static;

    function ExpectedAndActual(AActualValue: TValue): TExpectedAndActual; override;
    function Matches(AActualValue: TValue): Boolean; override;
  end;

  TRangeConstraint = class(TBaseConstraint, IConstraint)
  strict private
    FLowerBound: TValue;
    FLowerBoundComparisons: TValueComparisonSet;
    FLowerBracket: Char;
    FUpperBound: TValue;
    FUpperBoundComparisons: TValueComparisonSet;
    FUpperBracket: Char;
  strict protected
    function WithDifferentComparer(AComparer: IValueComparer): IConstraint; override;
  public
    constructor Create(ALowerBracket: Char;
      ALowerBoundComparisons: TValueComparisonSet; const ALowerBound: TValue;
      AUpperBoundComparisons: TValueComparisonSet; const AUpperBound: TValue;
      AUpperBracket: Char; AComparer: IValueComparer);

    class function CreateBetween(const ALowerBound, AUpperBound: TValue): IConstraint; static;
    class function CreateInRange(const ALowerBound, AUpperBound: TValue): IConstraint; static;

    function ExpectedAndActual(AActualValue: TValue): TExpectedAndActual; override;
    function Matches(AActualValue: TValue): Boolean; override;
  end;

  TNotConstraint = class(TInterfacedObject, IConstraint)
  strict private
    FInner: IConstraint;
  public
    constructor Create(AInner: IConstraint);
    function ComparerText: string;
    function Exactly: IConstraint;
    function ExpectedAndActual(AActualValue: TValue): TExpectedAndActual;
    function Matches(AActualValue: TValue): Boolean;
    function ToWithin(const AEpsilon: Extended): IConstraint;
  end;

implementation

uses
  StrUtils;

{ TBaseConstraint }

function TBaseConstraint.ComparerText: string;
begin
  Result := FComparer.AsString;
end;

constructor TBaseConstraint.Create(AComparer: IValueComparer);
begin
  inherited Create;
  FComparer := AComparer;
end;

function TBaseConstraint.Exactly: IConstraint;
begin
  Result := WithDifferentComparer(TExactValueComparer.Create);
end;

function TBaseConstraint.ToWithin(const AEpsilon: Extended): IConstraint;
begin
  Result := WithDifferentComparer(TEpsilonValueComparer.Create(AEpsilon));
end;

{ TComparisonConstraint }

constructor TComparisonConstraint.Create(AComparisons: TValueComparisonSet;
  AMessagePrefix: string; const AExpectedValue: TValue; AComparer: IValueComparer);
begin
  inherited Create(AComparer);
  FComparisons := AComparisons;
  FMessagePrefix := AMessagePrefix;
  FExpectedValue := AExpectedValue;
end;

class function TComparisonConstraint.CreateEqualTo(
  const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.Create([vcEqual], '', AExpectedValue,
    TDefaultValueComparer.Instance);
end;

class function TComparisonConstraint.CreateGreaterThan(
  const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.Create([vcGreater], '> ', AExpectedValue,
    TDefaultValueComparer.Instance);
end;

class function TComparisonConstraint.CreateGreaterThanOrEqualTo(
  const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.Create([vcGreater, vcEqual], '>= ', AExpectedValue,
    TDefaultValueComparer.Instance);
end;

class function TComparisonConstraint.CreateLessThan(
  const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.Create([vcLess], '< ', AExpectedValue,
    TDefaultValueComparer.Instance);
end;

class function TComparisonConstraint.CreateLessThanOrEqualTo(
  const AExpectedValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.Create([vcLess, vcEqual], '<= ', AExpectedValue,
    TDefaultValueComparer.Instance);
end;

function TComparisonConstraint.ExpectedAndActual(
  AActualValue: TValue): TExpectedAndActual;
var
  FirstDifferenceIndex: Integer;
begin
  FirstDifferenceIndex := FExpectedValue.IndexOfFirstDifference(AActualValue, Comparer);
  Result.Expected := FMessagePrefix + FExpectedValue.Inspect(FirstDifferenceIndex);
  Result.Actual := AActualValue.Inspect(FirstDifferenceIndex);
end;

function TComparisonConstraint.Matches(AActualValue: TValue): Boolean;
begin
  Result := AActualValue.ComparesAs(FComparisons, FExpectedValue, Comparer);
end;

function TComparisonConstraint.WithDifferentComparer(
  AComparer: IValueComparer): IConstraint;
begin
  Result := TComparisonConstraint.Create(FComparisons, FMessagePrefix,
    FExpectedValue, AComparer);
end;

{ TIsOfTypeConstraint }

constructor TIsOfTypeConstraint.Create(AType: TClass; AComparer: IValueComparer);
begin
  inherited Create(AComparer);
  FType := AType;
end;

class function TIsOfTypeConstraint.CreateDefault(AType: TClass): IConstraint;
begin
  Result := TIsOfTypeConstraint.Create(AType, TDefaultValueComparer.Instance);
end;

function TIsOfTypeConstraint.ExpectedAndActual(
  AActualValue: TValue): TExpectedAndActual;
begin
  Result.Expected := FType.ClassName;
  Result.Actual := AActualValue.GetClassName;
end;

function TIsOfTypeConstraint.Matches(AActualValue: TValue): Boolean;
begin
  Result := AActualValue.IsOfType(FType);
end;

function TIsOfTypeConstraint.WithDifferentComparer(
  AComparer: IValueComparer): IConstraint;
begin
  raise Exception.Create('Not specified');
end;

{ TRangeConstraint }

constructor TRangeConstraint.Create(ALowerBracket: Char;
  ALowerBoundComparisons: TValueComparisonSet; const ALowerBound: TValue;
  AUpperBoundComparisons: TValueComparisonSet; const AUpperBound: TValue;
  AUpperBracket: Char; AComparer: IValueComparer);
begin
  inherited Create(AComparer);
  FLowerBracket := ALowerBracket;
  FLowerBoundComparisons := ALowerBoundComparisons;
  FLowerBound := ALowerBound;
  FUpperBoundComparisons := AUpperBoundComparisons;
  FUpperBound := AUpperBound;
  FUpperBracket := AUpperBracket;
end;

class function TRangeConstraint.CreateBetween(const ALowerBound,
  AUpperBound: TValue): IConstraint;
begin
  Result := TRangeConstraint.Create('(', [vcGreater], ALowerBound,
    [vcLess], AUpperBound, ')', TDefaultValueComparer.Instance);
end;

class function TRangeConstraint.CreateInRange(const ALowerBound,
  AUpperBound: TValue): IConstraint;
begin
  Result := TRangeConstraint.Create('[', [vcGreater, vcEqual], ALowerBound,
    [vcLess, vcEqual], AUpperBound, ']', TDefaultValueComparer.Instance);
end;

function TRangeConstraint.ExpectedAndActual(
  AActualValue: TValue): TExpectedAndActual;
var
  FirstDifferenceIndex: Integer;
begin
  FirstDifferenceIndex := FLowerBound.IndexOfFirstDifference(AActualValue, Comparer);
  if FirstDifferenceIndex = 0 then
    FirstDifferenceIndex := FUpperBound.IndexOfFirstDifference(AActualValue, Comparer);
  Result.Expected := 'in range ' + FLowerBracket +
    FLowerBound.Inspect(FirstDifferenceIndex) + ', ' +
    FUpperBound.Inspect(FirstDifferenceIndex) + FUpperBracket;
  Result.Actual := AActualValue.Inspect(FirstDifferenceIndex);
end;

function TRangeConstraint.Matches(AActualValue: TValue): Boolean;
begin
  Result :=
    AActualValue.ComparesAs(FLowerBoundComparisons, FLowerBound, Comparer) and
    AActualValue.ComparesAs(FUpperBoundComparisons, FUpperBound, Comparer);
end;

function TRangeConstraint.WithDifferentComparer(
  AComparer: IValueComparer): IConstraint;
begin
  Result := TRangeConstraint.Create(FLowerBracket, FLowerBoundComparisons, FLowerBound,
    FUpperBoundComparisons, FUpperBound, FUpperBracket, AComparer);
end;

{ TNotConstraint }

function TNotConstraint.ComparerText: string;
begin
  Result := FInner.ComparerText;
end;

constructor TNotConstraint.Create(AInner: IConstraint);
begin
  inherited Create;
  FInner := AInner;
end;

function TNotConstraint.Exactly: IConstraint;
begin
  Result := TNotConstraint.Create(FInner.Exactly);
end;

function TNotConstraint.ExpectedAndActual(
  AActualValue: TValue): TExpectedAndActual;
begin
  Result := FInner.ExpectedAndActual(AActualValue);
  Result.Expected := 'not ' + Result.Expected;
end;

function TNotConstraint.Matches(AActualValue: TValue): Boolean;
begin
  Result := not FInner.Matches(AActualValue);
end;

function TNotConstraint.ToWithin(const AEpsilon: Extended): IConstraint;
begin
  Result := TNotConstraint.Create(FInner.ToWithin(AEpsilon));
end;

end.
