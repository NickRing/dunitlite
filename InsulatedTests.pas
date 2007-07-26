unit InsulatedTests;

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
  TestFramework;

type
  TTestInsulator = class(TAbstractTest)
  strict private
    FTestClass: TTestCaseClass;
    function Unexpected: Exception;
  strict protected
    procedure RunTest(TestResult: TTestResult); override;
    procedure RunWithFixture(TestResult: TTestResult); override;
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(ATestClass: TTestCaseClass; ATestName: string);

    class function CreateInsulatedSuite(ATestClass: TTestCaseClass): ITestSuite; static;

    function GetStatus: string;
    function Run: TTestResult; overload;
    procedure Run(TestResult: TTestResult); overload;
    procedure SetStatusListener(Listener: IStatusListener);
  end;

  TInsulatedTest = class(TTestCase, ITest)
  public
    class function Suite: ITestSuite; override;
  end;

implementation

uses
  Classes;

type
  TTestResultHack = class(TTestResult);

{ TTestInsulator }

constructor TTestInsulator.Create(ATestClass: TTestCaseClass; ATestName: string);
begin
  inherited Create(ATestName);
  FTestClass := ATestClass;
end;

class function TTestInsulator.CreateInsulatedSuite(
  ATestClass: TTestCaseClass): ITestSuite;
var
  MethodEnumerator: TMethodEnumerator;
  Idx: Integer;
  MethodName: string;
begin
  Result := TTestSuite.Create(ClassName);
  MethodEnumerator := TMethodEnumerator.Create(ATestClass);
  try
    for Idx := 0 to MethodEnumerator.Methodcount - 1 do
    begin
      MethodName := MethodEnumerator.NameOfMethod[Idx];
      Result.AddTest(TTestInsulator.Create(ATestClass, MethodName));
    end;
  finally
    FreeAndNil(MethodEnumerator);
  end;
end;

function TTestInsulator.GetStatus: string;
begin
  raise Unexpected;
end;

function TTestInsulator.Run: TTestResult;
begin
  raise Unexpected;
end;

procedure TTestInsulator.Run(TestResult: TTestResult);
begin
  raise Unexpected;
end;

procedure TTestInsulator.RunTest(TestResult: TTestResult);
begin
  raise Unexpected;
end;

procedure TTestInsulator.RunWithFixture(TestResult: TTestResult);
var
  ActualTest: ITest;
  TestResultHack: TTestResultHack;
begin
  Assert(Assigned(TestResult));
  TestResultHack := TTestResultHack(TestResult);
  ActualTest := FTestClass.Create(Name);
  ActualTest.GUIObject := GetGUIObject;
  if TestResultHack.ShouldRunTest(ActualTest) then
    TestResultHack.Run(ActualTest);
end;

procedure TTestInsulator.SetStatusListener(Listener: IStatusListener);
begin
  raise Unexpected;
end;

procedure TTestInsulator.SetUp;
begin
  raise Unexpected;
end;

procedure TTestInsulator.TearDown;
begin
  raise Unexpected;
end;

function TTestInsulator.Unexpected: Exception;
begin
  Result := EInvalidOperation.Create('Unexpected method called on insulator');
end;

{ TInsulatedTest }

class function TInsulatedTest.Suite: ITestSuite;
begin
  Result := TTestInsulator.CreateInsulatedSuite(Self);
end;

end.
