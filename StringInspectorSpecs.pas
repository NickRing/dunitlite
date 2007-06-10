unit StringInspectorSpecs;

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
  StringInspectors,
  RegisterableTestCases;

type
  SpecStringInspector = class(TRegisterableTestCase)
  strict private
    FInspector: IStringInspector;
    function Apostrophes(Count: Integer): string;
    procedure SpecifyThatInspecting(AStringToInspect: string; AConstraint: IConstraint);
  strict protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure SpecEmptyString;
    procedure SpecSingleNormalCharacter;
    procedure SpecMultipleNormalCharacters;
    procedure SpecSingleLowAsciiCharacter;
    procedure SpecMultipleLowAsciiCharacters;
    procedure SpecSingleApostrophe;
    procedure SpecMultipleApostrophes;
    procedure SpecNormalCharactersThenLowAscii;
    procedure SpecLowAsciiThenNormalCharacters;
    procedure SpecLowAsciiThenApostrophe;
  end;

implementation

uses
  Specifications;

{ TestStringInspector }

function SpecStringInspector.Apostrophes(Count: Integer): string;
begin
  Result := StringOfChar(Apostrophe, Count);
end;

procedure SpecStringInspector.SetUp;
begin
  inherited;
  FInspector := TStringInspector.Create;
end;

procedure SpecStringInspector.SpecifyThatInspecting(AStringToInspect: string;
  AConstraint: IConstraint);
begin
  Specify.That(FInspector.Inspect(AStringToInspect), AConstraint);
end;

procedure SpecStringInspector.TearDown;
begin
  FInspector := nil;
  inherited;
end;

procedure SpecStringInspector.SpecEmptyString;
begin
  SpecifyThatInspecting('', Should.Yield(Apostrophes(2)));
end;

procedure SpecStringInspector.SpecLowAsciiThenApostrophe;
begin
  SpecifyThatInspecting(#9 + Apostrophe, Should.Yield('#9' + Apostrophes(4)));
end;

procedure SpecStringInspector.SpecLowAsciiThenNormalCharacters;
begin
  SpecifyThatInspecting(#9'ab', Should.Yield('#9' + Apostrophe + 'ab' + Apostrophe));
end;

procedure SpecStringInspector.SpecMultipleApostrophes;
begin
  SpecifyThatInspecting(Apostrophes(2), Should.Yield(Apostrophes(6)));
end;

procedure SpecStringInspector.SpecMultipleLowAsciiCharacters;
begin
  SpecifyThatInspecting(#13#10, Should.Yield('#13#10'));
end;

procedure SpecStringInspector.SpecMultipleNormalCharacters;
begin
  SpecifyThatInspecting('ab', Should.Yield(Apostrophe + 'ab' + Apostrophe));
end;

procedure SpecStringInspector.SpecNormalCharactersThenLowAscii;
begin
  SpecifyThatInspecting('ab'#13#10, Should.Yield(Apostrophe + 'ab' + Apostrophe + '#13#10'));
end;

procedure SpecStringInspector.SpecSingleApostrophe;
begin
  SpecifyThatInspecting(Apostrophe, Should.Yield(Apostrophes(4)));
end;

procedure SpecStringInspector.SpecSingleLowAsciiCharacter;
begin
  SpecifyThatInspecting(#0, Should.Yield('#0'));
end;

procedure SpecStringInspector.SpecSingleNormalCharacter;
begin
  SpecifyThatInspecting('a', Should.Yield(Apostrophe + 'a' + Apostrophe));
end;

initialization
  SpecStringInspector.Register;
end.
