unit Specifiers;

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
  Values;

type
  Specify = class
  public
    class procedure That(AValue: TValue; SatisfiesCondition: IConstraint;
      AMessage: string = ''); static;
  end;

  Given = Specify;

  IBeHelper = interface
  ['{786D9F88-3DB3-4B4C-905E-94A8BBD0AA11}']
    function Assigned: IConstraint;
    function AtLeast(AValue: TValue): IConstraint;
    function AtMost(AValue: TValue): IConstraint;
    function Between(ALowerBound, AUpperBound: TValue): IConstraint;
    function False: IConstraint;
    function GreaterThan(AValue: TValue): IConstraint;
    function GreaterThanOrEqualTo(AValue: TValue): IConstraint;
    function InRange(ALowerBound, AUpperBound: TValue): IConstraint;
    function LessThan(AValue: TValue): IConstraint;
    function LessThanOrEqualTo(AValue: TValue): IConstraint;
    function Null: IConstraint;
    function OfType(AType: TClass): IConstraint;
    function True: IConstraint;
  end;

  IShouldHelper = interface
  ['{A330ECD8-7B96-4EB1-AB91-6105DFBC8821}']
    function Be: IBeHelper;
    function Equal(AValue: TValue): IConstraint;
    function ReferTo(AInstance: TObject): IConstraint;
  end;

  Should = class
  public
    class function Be: IBeHelper;
    class function Equal(AValue: TValue): IConstraint; static;
    class function &Not: IShouldHelper; static;
    class function ReferTo(AInstance: TObject): IConstraint; static;
    class function Yield(AValue: TValue): IConstraint; static;
  end;

  TBeHelper = class(TInterfacedObject, IBeHelper)
  public
    function Assigned: IConstraint;
    function AtLeast(AValue: TValue): IConstraint;
    function AtMost(AValue: TValue): IConstraint;
    function Between(ALowerBound, AUpperBound: TValue): IConstraint;
    function False: IConstraint;
    function GreaterThan(AValue: TValue): IConstraint;
    function GreaterThanOrEqualTo(AValue: TValue): IConstraint;
    function InRange(ALowerBound, AUpperBound: TValue): IConstraint;
    function LessThan(AValue: TValue): IConstraint;
    function LessThanOrEqualTo(AValue: TValue): IConstraint;
    function Null: IConstraint;
    function OfType(AType: TClass): IConstraint;
    function True: IConstraint;
  end;

  TShouldNotHelper = class(TInterfacedObject, IShouldHelper, IBeHelper)
  strict private
    function Negate(AConstraint: IConstraint): IConstraint;
  public
    function Assigned: IConstraint;
    function AtLeast(AValue: TValue): IConstraint;
    function AtMost(AValue: TValue): IConstraint;
    function Be: IBeHelper;
    function Between(ALowerBound, AUpperBound: TValue): IConstraint;
    function Equal(AValue: TValue): IConstraint;
    function False: IConstraint;
    function GreaterThan(AValue: TValue): IConstraint;
    function GreaterThanOrEqualTo(AValue: TValue): IConstraint;
    function InRange(ALowerBound, AUpperBound: TValue): IConstraint;
    function LessThan(AValue: TValue): IConstraint;
    function LessThanOrEqualTo(AValue: TValue): IConstraint;
    function Null: IConstraint;
    function OfType(AType: TClass): IConstraint;
    function ReferTo(AInstance: TObject): IConstraint;
    function True: IConstraint;
  end;

implementation

uses
  TestFramework;

{ Specify }

class procedure Specify.That(AValue: TValue; SatisfiesCondition: IConstraint;
  AMessage: string);
var
  Strings: TExpectedAndActual;
  MessagePrefix: string;
  ComparerSuffix: string;
begin
  if SatisfiesCondition.Matches(AValue) then
    Exit;
  Strings := SatisfiesCondition.ExpectedAndActual(AValue);

  if SatisfiesCondition.ComparerText = '' then
    ComparerSuffix := ''
  else
    ComparerSuffix := ' (' + SatisfiesCondition.ComparerText + ')';

  if AMessage = '' then
    MessagePrefix := ''
  else
    MessagePrefix := AMessage + #13#10;

  raise ETestFailure.Create(
    MessagePrefix +
    'Expected: ' + Strings.Expected + ComparerSuffix + #13#10 +
    ' but was: ' + Strings.Actual);
end;

{ Should }

class function Should.&Not: IShouldHelper;
begin
  Result := TShouldNotHelper.Create;
end;

class function Should.ReferTo(AInstance: TObject): IConstraint;
begin
  Result := TRefersToObjectConstraint.CreateDefault(AInstance);
end;

class function Should.Yield(AValue: TValue): IConstraint;
begin
  Result := Equal(AValue);
end;

class function Should.Be: IBeHelper;
begin
  Result := TBeHelper.Create;
end;

class function Should.Equal(AValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateEqualTo(AValue);
end;

{ TBeHelper }

function TBeHelper.Assigned: IConstraint;
begin
  Result := Should.Not.Be.Null;
end;

function TBeHelper.AtLeast(AValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateGreaterThanOrEqualTo(AValue);
end;

function TBeHelper.AtMost(AValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateLessThanOrEqualTo(AValue);
end;

function TBeHelper.Between(ALowerBound, AUpperBound: TValue): IConstraint;
begin
  Result := TRangeConstraint.CreateBetween(ALowerBound, AUpperBound);
end;

function TBeHelper.False: IConstraint;
begin
  Result := Should.Equal(System.False);
end;

function TBeHelper.GreaterThan(AValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateGreaterThan(AValue);
end;

function TBeHelper.GreaterThanOrEqualTo(AValue: TValue): IConstraint;
begin
  Result := AtLeast(AValue);
end;

function TBeHelper.InRange(ALowerBound, AUpperBound: TValue): IConstraint;
begin
  Result := TRangeConstraint.CreateInRange(ALowerBound, AUpperBound);
end;

function TBeHelper.LessThan(AValue: TValue): IConstraint;
begin
  Result := TComparisonConstraint.CreateLessThan(AValue);
end;

function TBeHelper.LessThanOrEqualTo(AValue: TValue): IConstraint;
begin
  Result := AtMost(AValue);
end;

function TBeHelper.Null: IConstraint;
begin
  Result := Should.ReferTo(nil);
end;

function TBeHelper.OfType(AType: TClass): IConstraint;
begin
  Result := TIsOfTypeConstraint.CreateDefault(AType);
end;

function TBeHelper.True: IConstraint;
begin
  Result := Should.Equal(System.True);
end;

{ TShouldNotHelper }

function TShouldNotHelper.Assigned: IConstraint;
begin
  Result := Should.Be.Null;
end;

function TShouldNotHelper.AtLeast(AValue: TValue): IConstraint;
begin
  Result := Negate(Should.Be.AtLeast(AValue));
end;

function TShouldNotHelper.AtMost(AValue: TValue): IConstraint;
begin
  Result := Negate(Should.Be.AtMost(AValue));
end;

function TShouldNotHelper.Be: IBeHelper;
begin
  Result := Self;
end;

function TShouldNotHelper.Between(ALowerBound,
  AUpperBound: TValue): IConstraint;
begin
  Result := Negate(Should.Be.Between(ALowerBound, AUpperBound));
end;

function TShouldNotHelper.Equal(AValue: TValue): IConstraint;
begin
  Result := Negate(Should.Equal(AValue));
end;

function TShouldNotHelper.False: IConstraint;
begin
  Result := Negate(Should.Be.False);
end;

function TShouldNotHelper.GreaterThan(AValue: TValue): IConstraint;
begin
  Result := Negate(Should.Be.GreaterThan(AValue));
end;

function TShouldNotHelper.GreaterThanOrEqualTo(AValue: TValue): IConstraint;
begin
  Result := Negate(Should.Be.GreaterThanOrEqualTo(AValue));
end;

function TShouldNotHelper.InRange(ALowerBound,
  AUpperBound: TValue): IConstraint;
begin
  Result := Negate(Should.Be.InRange(ALowerBound, AUpperBound));
end;

function TShouldNotHelper.LessThan(AValue: TValue): IConstraint;
begin
  Result := Negate(Should.Be.LessThan(AValue));
end;

function TShouldNotHelper.LessThanOrEqualTo(AValue: TValue): IConstraint;
begin
  Result := Negate(Should.Be.LessThanOrEqualTo(AValue));
end;

function TShouldNotHelper.Negate(AConstraint: IConstraint): IConstraint;
begin
  Result := TNotConstraint.Create(AConstraint);
end;

function TShouldNotHelper.Null: IConstraint;
begin
  Result := Negate(Should.Be.Null);
end;

function TShouldNotHelper.OfType(AType: TClass): IConstraint;
begin
  Result := Negate(Should.Be.OfType(AType));
end;

function TShouldNotHelper.ReferTo(AInstance: TObject): IConstraint;
begin
  Result := Negate(Should.ReferTo(AInstance));
end;

function TShouldNotHelper.True: IConstraint;
begin
  Result := Negate(Should.Be.True);
end;

end.
