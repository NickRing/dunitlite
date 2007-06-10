unit Values;

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
  Types,
  TypInfo,
  ValueComparers;

type
  IValue = interface;

  TFooEnum = (fooBar, fooBaz);
  TBarEnum = (barBaz, barQuux);

  TValue = record
  strict private
    FValue: IValue;
  public
    constructor Create(AValue: IValue);
    function AsString: string;
    function ComparesAs(Comparisons: TValueComparisonSet; Other: TValue;
      AComparer: IValueComparer): Boolean;
    function GetClassName: string;
    class operator Implicit(Value: Boolean): TValue;
    class operator Implicit(Value: Extended): TValue;
    class operator Implicit(Value: IInterface): TValue;
    class operator Implicit(Value: Int64): TValue;
    class operator Implicit(Value: Integer): TValue;
    class operator Implicit(Value: string): TValue;
    class operator Implicit(Value: TBarEnum): TValue;
    class operator Implicit(Value: TFooEnum): TValue;
    class operator Implicit(Value: TObject): TValue;
    class operator Implicit(Value: TPoint): TValue;
    function Inspect: string;
    function IsOfType(AClass: TClass): Boolean;
    function SameInstance(B: TValue): Boolean;
    function SameText(B: TValue): Boolean;

    property Value: IValue read FValue;
  end;

  IValue = interface
  ['{E6E94BEB-BD73-4A85-B707-780CB50AF5EE}']
    function AsString: string;
    function CompareExtendedTo(Other: Extended; AComparer: IValueComparer): TValueComparison;
    function CompareInt64To(Other: Int64): TValueComparison;
    function CompareIntegerTo(Other: Integer; AComparer: IValueComparer): TValueComparison;
    function ComparesAs(Comparisons: TValueComparisonSet; Other: IValue;
      AComparer: IValueComparer): Boolean;
    function GetClassName: string;
    function GetEnumValue(ATypeInfo: PTypeInfo): Integer;
    function get_BooleanValue: Boolean;
    function get_InterfaceValue: IInterface;
    function get_ObjectValue: TObject;
    function get_PointValue: TPoint;
    function get_StringValue: string;
    function Inspect: string;
    function IsOfType(AClass: TClass): Boolean;
    function SameInstance(Other: IValue): Boolean;
    function SameText(Other: IValue): Boolean;

    property BooleanValue: Boolean read get_BooleanValue;
    property InterfaceValue: IInterface read get_InterfaceValue;
    property ObjectValue: TObject read get_ObjectValue;
    property PointValue: TPoint read get_PointValue;
    property StringValue: string read get_StringValue;
  end;

  TBaseValue = class(TInterfacedObject, IValue)
  strict private
    procedure CheckSupportsOrdering;
  strict protected
    class function CompareInt64s(First, Second: Int64): TValueComparison; static;
    class function CompareIntegers(First, Second: Integer): TValueComparison; static;
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; virtual;
    function ExtendedValue: Extended; virtual;
    function Int64Value: Int64; virtual;
    function IntegerValue: Integer; virtual;
    function InvalidCast(TargetType: string): Exception;
    function NotSupported(MethodName: string): Exception;
    function TypeName: string; virtual;
    class function TypeSupportsOrdering: Boolean; virtual;
  public
    function AsString: string; virtual; abstract;
    function CompareExtendedTo(Other: Extended; AComparer: IValueComparer): TValueComparison;
    function CompareInt64To(Other: Int64): TValueComparison;
    function CompareIntegerTo(Other: Integer; AComparer: IValueComparer): TValueComparison; virtual;
    function ComparesAs(Comparisons: TValueComparisonSet; Other: IValue;
      AComparer: IValueComparer): Boolean;
    function GetClassName: string; virtual;
    function GetEnumValue(ATypeInfo: PTypeInfo): Integer; virtual;
    function get_BooleanValue: Boolean; virtual;
    function get_InterfaceValue: IInterface; virtual;
    function get_ObjectValue: TObject; virtual;
    function get_PointValue: TPoint; virtual;
    function get_StringValue: string; virtual;
    function Inspect: string; virtual;
    function IsOfType(AClass: TClass): Boolean; virtual;
    function SameInstance(Other: IValue): Boolean; virtual;
    function SameText(Other: IValue): Boolean;
  end;

  TBooleanValue = class(TBaseValue)
  strict private
    FValue: Boolean;
  strict protected
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; override;
  public
    constructor Create(AValue: Boolean);
    function AsString: string; override;
    function get_BooleanValue: Boolean; override;
  end;

  TEnumValue = class(TBaseValue)
  strict private
    FOrdValue: Integer;
    FTypeInfo: PTypeInfo;
  strict protected
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; override;
    function TypeName: string; override;
  public
    constructor Create(AOrdValue: Integer; ATypeInfo: PTypeInfo);
    function AsString: string; override;
    function GetEnumValue(ATypeInfo: PTypeInfo): Integer; override;
  end;

  TExtendedValue = class(TBaseValue)
  strict private
    FValue: Extended;
  strict protected
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; override;
    function ExtendedValue: Extended; override;
  public
    constructor Create(AValue: Extended);
    function AsString: string; override;
    function CompareIntegerTo(Other: Integer; AComparer: IValueComparer): TValueComparison; override;
  end;

  TInt64Value = class(TBaseValue)
  strict private
    FValue: Int64;
  strict protected
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; override;
    function Int64Value: Int64; override;
  public
    constructor Create(AValue: Int64);
    function AsString: string; override;
    function CompareIntegerTo(Other: Integer; AComparer: IValueComparer): TValueComparison; override;
  end;

  TIntegerValue = class(TBaseValue)
  strict private
    FValue: Integer;
  strict protected
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; override;
    function ExtendedValue: Extended; override;
    function Int64Value: Int64; override;
    function IntegerValue: Integer; override;
  public
    constructor Create(AValue: Integer);
    function AsString: string; override;
  end;

  TInterfaceValue = class(TBaseValue)
  strict private
    FValue: IInterface;
  public
    constructor Create(AValue: IInterface);
    function AsString: string; override;
    function get_InterfaceValue: IInterface; override;
    function SameInstance(Other: IValue): Boolean; override;
  end;

  TObjectValue = class(TBaseValue)
  strict private
    FValue: TObject;
  public
    constructor Create(AValue: TObject);
    function AsString: string; override;
    function GetClassName: string; override;
    function get_ObjectValue: TObject; override;
    function IsOfType(AClass: TClass): Boolean; override;
    function SameInstance(Other: IValue): Boolean; override;
  end;

  TPointValue = class(TBaseValue)
  strict private
    FValue: TPoint;
  strict protected
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; override;
    class function TypeSupportsOrdering: Boolean; override;
  public
    constructor Create(const AValue: TPoint);
    function AsString: string; override;
    function get_PointValue: TPoint; override;
  end;

  TStringValue = class(TBaseValue)
  strict private
    FValue: string;
  strict protected
    function CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison; override;
  public
    constructor Create(AValue: string);
    function AsString: string; override;
    function get_StringValue: string; override;
    function Inspect: string; override;
  end;

implementation

uses
  Classes,
  Math,
  StringInspectors;

{ TValue }

function TValue.AsString: string;
begin
  Result := FValue.AsString;
end;

function TValue.ComparesAs(Comparisons: TValueComparisonSet; Other: TValue;
  AComparer: IValueComparer): Boolean;
begin
  Result := FValue.ComparesAs(Comparisons, Other.Value, AComparer);
end;

constructor TValue.Create(AValue: IValue);
begin
  inherited;
  FValue := AValue;
end;

function TValue.GetClassName: string;
begin
  Result := FValue.GetClassName;
end;

class operator TValue.Implicit(Value: Boolean): TValue;
begin
  Result := TValue.Create(TBooleanValue.Create(Value));
end;

class operator TValue.Implicit(Value: Extended): TValue;
begin
  Result := TValue.Create(TExtendedValue.Create(Value));
end;

class operator TValue.Implicit(Value: IInterface): TValue;
begin
  Result := TValue.Create(TInterfaceValue.Create(Value));
end;

class operator TValue.Implicit(Value: Int64): TValue;
begin
  Result := TValue.Create(TInt64Value.Create(Value));
end;

class operator TValue.Implicit(Value: Integer): TValue;
begin
  Result := TValue.Create(TIntegerValue.Create(Value));
end;

class operator TValue.Implicit(Value: string): TValue;
begin
  Result := TValue.Create(TStringValue.Create(Value));
end;

class operator TValue.Implicit(Value: TBarEnum): TValue;
begin
  Result := TValue.Create(TEnumValue.Create(Ord(Value), TypeInfo(TBarEnum)));
end;

class operator TValue.Implicit(Value: TFooEnum): TValue;
begin
  Result := TValue.Create(TEnumValue.Create(Ord(Value), TypeInfo(TFooEnum)));
end;

class operator TValue.Implicit(Value: TObject): TValue;
begin
  Result := TValue.Create(TObjectValue.Create(Value));
end;

class operator TValue.Implicit(Value: TPoint): TValue;
begin
  Result := TValue.Create(TPointValue.Create(Value));
end;

function TValue.Inspect: string;
begin
  Result := FValue.Inspect;
end;

function TValue.IsOfType(AClass: TClass): Boolean;
begin
  Result := FValue.IsOfType(AClass);
end;

function TValue.SameInstance(B: TValue): Boolean;
begin
  Result := FValue.SameInstance(B.Value);
end;

function TValue.SameText(B: TValue): Boolean;
begin
  Result := FValue.SameText(B.Value);
end;

{ TBaseValue }

procedure TBaseValue.CheckSupportsOrdering;
begin
  if not TypeSupportsOrdering then
  begin
    raise ERangeError.CreateFmt('LessThan and GreaterThan are not supported for %s',
      [TypeName]);
  end;
end;

function TBaseValue.CompareExtendedTo(Other: Extended; AComparer: IValueComparer): TValueComparison;
begin
  Result := AComparer.CompareExtendeds(Other, ExtendedValue);
end;

class function TBaseValue.CompareInt64s(First, Second: Int64): TValueComparison;
begin
  if First = Second then
    Result := vcEqual
  else if First < Second then
    Result := vcLess
  else
    Result := vcGreater;
end;

function TBaseValue.CompareInt64To(Other: Int64): TValueComparison;
begin
  Result := CompareInt64s(Other, Int64Value);
end;

class function TBaseValue.CompareIntegers(First, Second: Integer): TValueComparison;
begin
  if First = Second then
    Result := vcEqual
  else if First < Second then
    Result := vcLess
  else
    Result := vcGreater;
end;

function TBaseValue.CompareIntegerTo(Other: Integer; AComparer: IValueComparer): TValueComparison;
begin
  Result := CompareIntegers(Other, IntegerValue);
end;

function TBaseValue.ComparesAs(Comparisons: TValueComparisonSet; Other: IValue;
  AComparer: IValueComparer): Boolean;
begin
  if (Comparisons * [vcGreater, vcLess]) <> [] then
    CheckSupportsOrdering;
  Result := CompareTo(Other, AComparer) in Comparisons;
end;

function TBaseValue.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  raise NotSupported('CompareTo');
end;

function TBaseValue.ExtendedValue: Extended;
begin
  raise InvalidCast('float');
end;

function TBaseValue.GetClassName: string;
begin
  raise NotSupported('GetClassName');
end;

function TBaseValue.GetEnumValue(ATypeInfo: PTypeInfo): Integer;
begin
  raise InvalidCast(ATypeInfo.Name);
end;

function TBaseValue.get_BooleanValue: Boolean;
begin
  raise InvalidCast('Boolean');
end;

function TBaseValue.get_InterfaceValue: IInterface;
begin
  raise InvalidCast('IInterface');
end;

function TBaseValue.get_ObjectValue: TObject;
begin
  raise InvalidCast('TObject');
end;

function TBaseValue.get_PointValue: TPoint;
begin
  raise InvalidCast('TPoint');
end;

function TBaseValue.get_StringValue: string;
begin
  raise InvalidCast('string');
end;

function TBaseValue.Inspect: string;
begin
  Result := AsString;
end;

function TBaseValue.Int64Value: Int64;
begin
  raise InvalidCast('Int64');
end;

function TBaseValue.IntegerValue: Integer;
begin
  raise InvalidCast('integer');
end;

function TBaseValue.InvalidCast(TargetType: string): Exception;
begin
  raise EInvalidCast.CreateFmt('Cannot cast %s to %s',
    [TypeName, TargetType]);
end;

function TBaseValue.IsOfType(AClass: TClass): Boolean;
begin
  raise NotSupported('IsOfType');
end;

function TBaseValue.NotSupported(MethodName: string): Exception;
begin
  Result := EInvalidOperation.CreateFmt('%s not supported for %s',
    [MethodName, ClassName]);
end;

function TBaseValue.SameInstance(Other: IValue): Boolean;
begin
  raise NotSupported('SameInstance');
end;

function TBaseValue.SameText(Other: IValue): Boolean;
begin
  Result := SysUtils.SameText(get_StringValue, Other.StringValue);
end;

function TBaseValue.TypeName: string;
begin
  Result := ClassName;
end;

class function TBaseValue.TypeSupportsOrdering: Boolean;
begin
  Result := True;
end;

{ TBooleanValue }

function TBooleanValue.AsString: string;
begin
  Result := BoolToStr(FValue, True);
end;

function TBooleanValue.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  if FValue = Other.BooleanValue then
    Result := vcEqual
  else if FValue < Other.BooleanValue then
    Result := vcLess
  else
    Result := vcGreater;
end;

constructor TBooleanValue.Create(AValue: Boolean);
begin
  inherited Create;
  FValue := AValue;
end;

function TBooleanValue.get_BooleanValue: Boolean;
begin
  Result := FValue;
end;

{ TEnumValue }

function TEnumValue.AsString: string;
begin
  Result := GetEnumName(FTypeInfo, FOrdValue);
end;

function TEnumValue.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  if FOrdValue = Other.GetEnumValue(FTypeInfo) then
    Result := vcEqual
  else if FOrdValue < Other.GetEnumValue(FTypeInfo) then
    Result := vcLess
  else
    Result := vcGreater;
end;

constructor TEnumValue.Create(AOrdValue: Integer; ATypeInfo: PTypeInfo);
begin
  inherited Create;
  FOrdValue := AOrdValue;
  FTypeInfo := ATypeInfo;
end;

function TEnumValue.GetEnumValue(ATypeInfo: PTypeInfo): Integer;
begin
  if ATypeInfo <> FTypeInfo then
    raise InvalidCast(ATypeInfo.Name);
  Result := FOrdValue;
end;

function TEnumValue.TypeName: string;
begin
  Result := ClassName + '<' + FTypeInfo.Name + '>';
end;

{ TExtendedValue }

function TExtendedValue.AsString: string;
begin
  Result := FloatToStr(FValue);
end;

function TExtendedValue.CompareIntegerTo(Other: Integer; AComparer: IValueComparer): TValueComparison;
begin
  Result := CompareExtendedTo(Other, AComparer);
end;

function TExtendedValue.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  Result := Other.CompareExtendedTo(ExtendedValue, AComparer);
end;

constructor TExtendedValue.Create(AValue: Extended);
begin
  inherited Create;
  FValue := AValue;
end;

function TExtendedValue.ExtendedValue: Extended;
begin
  Result := FValue;
end;

{ TInt64Value }

function TInt64Value.AsString: string;
begin
  Result := IntToStr(FValue);
end;

function TInt64Value.CompareIntegerTo(Other: Integer; AComparer: IValueComparer): TValueComparison;
begin
  Result := CompareInt64To(Other);
end;

function TInt64Value.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  Result := Other.CompareInt64To(FValue);
end;

constructor TInt64Value.Create(AValue: Int64);
begin
  inherited Create;
  FValue := AValue;
end;

function TInt64Value.Int64Value: Int64;
begin
  Result := FValue;
end;

{ TIntegerValue }

function TIntegerValue.AsString: string;
begin
  Result := IntToStr(FValue);
end;

function TIntegerValue.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  Result := Other.CompareIntegerTo(FValue, AComparer);
end;

constructor TIntegerValue.Create(AValue: Integer);
begin
  inherited Create;
  FValue := AValue;
end;

function TIntegerValue.ExtendedValue: Extended;
begin
  Result := FValue;
end;

function TIntegerValue.Int64Value: Int64;
begin
  Result := FValue;
end;

function TIntegerValue.IntegerValue: Integer;
begin
  Result := FValue;
end;

{ TInterfaceValue }

function TInterfaceValue.AsString: string;
begin
  if FValue <> nil then
    Result := 'interface($' + IntToHex(Integer(FValue), 8) + ')'
  else
    Result := 'nil interface';
end;

constructor TInterfaceValue.Create(AValue: IInterface);
begin
  inherited Create;
  FValue := AValue;
end;

function TInterfaceValue.get_InterfaceValue: IInterface;
begin
  Result := FValue;
end;

function TInterfaceValue.SameInstance(Other: IValue): Boolean;
var
  CanonicalValue: IInterface;
  CanonicalOther: IInterface;
begin
  CanonicalValue := FValue as IInterface;
  CanonicalOther := Other.InterfaceValue as IInterface;
  Result := CanonicalValue = CanonicalOther;
end;

{ TObjectValue }

function TObjectValue.AsString: string;
begin
  if FValue <> nil then
    Result := FValue.ClassName + '($' + IntToHex(Integer(FValue), 8) + ')'
  else
    Result := 'nil object';
end;

constructor TObjectValue.Create(AValue: TObject);
begin
  inherited Create;
  FValue := AValue;
end;

function TObjectValue.GetClassName: string;
begin
  if FValue <> nil then
    Result := FValue.ClassName
  else
    Result := 'nil object';
end;

function TObjectValue.get_ObjectValue: TObject;
begin
  Result := FValue;
end;

function TObjectValue.IsOfType(AClass: TClass): Boolean;
begin
  Result := (FValue <> nil) and (FValue.ClassType = AClass);
end;

function TObjectValue.SameInstance(Other: IValue): Boolean;
begin
  Result := FValue = Other.ObjectValue;
end;

{ TPointValue }

function TPointValue.AsString: string;
begin
  raise Exception.Create('Not specified');
end;

function TPointValue.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  if (Other.PointValue.X = FValue.X) and (Other.PointValue.Y = FValue.Y) then
    Result := vcEqual
  else
    Result := vcUnorderedAndNotEqual;
end;

constructor TPointValue.Create(const AValue: TPoint);
begin
  inherited Create;
  FValue := AValue;
end;

function TPointValue.get_PointValue: TPoint;
begin
  Result := FValue;
end;

class function TPointValue.TypeSupportsOrdering: Boolean;
begin
  Result := False;
end;

{ TStringValue }

function TStringValue.AsString: string;
begin
  Result := FValue;
end;

function TStringValue.CompareTo(Other: IValue; AComparer: IValueComparer): TValueComparison;
begin
  if FValue = Other.StringValue then
    Result := vcEqual
  else if FValue < Other.StringValue then
    Result := vcLess
  else
    Result := vcGreater;
end;

constructor TStringValue.Create(AValue: string);
begin
  inherited Create;
  FValue := AValue;
end;

function TStringValue.get_StringValue: string;
begin
  Result := FValue;
end;

function TStringValue.Inspect: string;
var
  Inspector: IStringInspector;
begin
  Inspector := TStringInspector.Create;
  Result := Inspector.Inspect(FValue);
end;

end.
