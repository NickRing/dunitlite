program DUnitAssertions;

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

uses
  GuiTestRunner,
  TestFramework,
  Constraints in 'Constraints.pas',
  ConstraintTests in 'ConstraintTests.pas',
  RegisterableTestCases in 'RegisterableTestCases.pas',
  Specifiers in 'Specifiers.pas',
  SpecifierTests in 'SpecifierTests.pas',
  StringInspectors in 'StringInspectors.pas',
  StringInspectorSpecs in 'StringInspectorSpecs.pas',
  TestValues in 'TestValues.pas',
  ValueComparers in 'ValueComparers.pas',
  ValueComparerSpecs in 'ValueComparerSpecs.pas',
  Values in 'Values.pas',
  ValueTests in 'ValueTests.pas';

{$R *.res}

begin
  GuiTestRunner.RunRegisteredTests;
end.
