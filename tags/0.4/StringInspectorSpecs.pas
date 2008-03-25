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
  Specifications,
  StringInspectors;

type
  TStringInspectorSpecification = class(TRegisterableSpecification)
  strict protected
    procedure SpecifyThatInspecting(AStringToInspect: string;
      SatisfiesCondition: IConstraint);
    procedure SpecifyThatInspectingSubstring(AStringToInspect: string;
      AStartIndex, ALength: Integer; SatisfiesCondition: IConstraint);
  end;

  StringInspectorSpec = class(TStringInspectorSpecification)
  strict private
    function Apostrophes(Count: Integer): string;
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

  StringInspectorSubstringSpec = class(TStringInspectorSpecification)
  published
    procedure SpecEntireString;
    procedure SpecSkipFirstCharacter;
    procedure SpecSkipLastCharacter;
    procedure SpecMiddleOfString;
    procedure SpecOffBeginningOfString;
    procedure SpecOffEndOfString;
  end;

implementation

{ TStringInspectorSpecification }

procedure TStringInspectorSpecification.SpecifyThatInspecting(
  AStringToInspect: string; SatisfiesCondition: IConstraint);
begin
  SpecifyThatInspectingSubstring(AStringToInspect, 1, Length(AStringToInspect),
    SatisfiesCondition);
end;

procedure TStringInspectorSpecification.SpecifyThatInspectingSubstring(
  AStringToInspect: string; AStartIndex, ALength: Integer;
  SatisfiesCondition: IConstraint);
begin
  Specify.That(TStringInspector.Inspect(AStringToInspect, AStartIndex, ALength),
    SatisfiesCondition);
end;

{ TestStringInspector }

function StringInspectorSpec.Apostrophes(Count: Integer): string;
begin
  Result := StringOfChar(Apostrophe, Count);
end;

procedure StringInspectorSpec.SpecEmptyString;
begin
  SpecifyThatInspecting('', Should.Yield(Apostrophes(2)));
end;

procedure StringInspectorSpec.SpecLowAsciiThenApostrophe;
begin
  SpecifyThatInspecting(#9 + Apostrophe, Should.Yield('#9' + Apostrophes(4)));
end;

procedure StringInspectorSpec.SpecLowAsciiThenNormalCharacters;
begin
  SpecifyThatInspecting(#9'ab', Should.Yield('#9' + Apostrophe + 'ab' + Apostrophe));
end;

procedure StringInspectorSpec.SpecMultipleApostrophes;
begin
  SpecifyThatInspecting(Apostrophes(2), Should.Yield(Apostrophes(6)));
end;

procedure StringInspectorSpec.SpecMultipleLowAsciiCharacters;
begin
  SpecifyThatInspecting(#13#10, Should.Yield('#13#10'));
end;

procedure StringInspectorSpec.SpecMultipleNormalCharacters;
begin
  SpecifyThatInspecting('ab', Should.Yield(Apostrophe + 'ab' + Apostrophe));
end;

procedure StringInspectorSpec.SpecNormalCharactersThenLowAscii;
begin
  SpecifyThatInspecting('ab'#13#10, Should.Yield(Apostrophe + 'ab' + Apostrophe + '#13#10'));
end;

procedure StringInspectorSpec.SpecSingleApostrophe;
begin
  SpecifyThatInspecting(Apostrophe, Should.Yield(Apostrophes(4)));
end;

procedure StringInspectorSpec.SpecSingleLowAsciiCharacter;
begin
  SpecifyThatInspecting(#0, Should.Yield('#0'));
end;

procedure StringInspectorSpec.SpecSingleNormalCharacter;
begin
  SpecifyThatInspecting('a', Should.Yield(Apostrophe + 'a' + Apostrophe));
end;

{ StringInspectorSubstringSpec }

procedure StringInspectorSubstringSpec.SpecEntireString;
begin
  SpecifyThatInspectingSubstring('abc', 1, 3, Should.Yield('''abc'''));
end;

procedure StringInspectorSubstringSpec.SpecMiddleOfString;
begin
  SpecifyThatInspectingSubstring('abc', 2, 1, Should.Yield('...''b''...'));
end;

procedure StringInspectorSubstringSpec.SpecOffBeginningOfString;
begin
  SpecifyThatInspectingSubstring('abc', 0, 2, Should.Yield('''ab''...'));
end;

procedure StringInspectorSubstringSpec.SpecOffEndOfString;
begin
  SpecifyThatInspectingSubstring('abc', 2, 99, Should.Yield('...''bc'''));
end;

procedure StringInspectorSubstringSpec.SpecSkipFirstCharacter;
begin
  SpecifyThatInspectingSubstring('abc', 2, 2, Should.Yield('...''bc'''));
end;

procedure StringInspectorSubstringSpec.SpecSkipLastCharacter;
begin
  SpecifyThatInspectingSubstring('abc', 1, 2, Should.Yield('''ab''...'));
end;

initialization
  StringInspectorSpec.Register;
  StringInspectorSubstringSpec.Register;
end.
