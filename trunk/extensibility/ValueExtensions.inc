// Values.pas compile-time extension point
//
// To extend TValue to support additional types, you should make your own file
// named ValueExtensions.inc. Put it somewhere in your project's search path,
// and make sure DUnitLite's "extensibility" directory is not in your project
// search path. Then customize your ValueExtensions.inc file as you like.
//
// ValueExtensions.inc is included three times, with different $DEFINEs each
// time. Your file should have three sections, each within its own $IFDEF, as
// documented below.
//
// {$IFDEF VALUE_EXTENSIONS_USES}
//   Inside this section, list any used units. Separate with commas, and leave
//   a comma after the last one. Example usage: to include units that define
//   enumerated types that you want to be able to use with DUnitLite.
// {$ENDIF}
//
// {$IFDEF VALUE_EXTENSIONS_TVALUE_DECLARATION}
//   Inside this section, put any code that should go inside the TValue class
//   declaration. Example usage: to list additional "operator Implicit"s for
//   the enumerated types you want to use with DUnitLite (follow the pattern of
//   the several other enum types already supported by DUnitLite).
// {$ENDIF}
//
// {$IFDEF VALUE_EXTENSIONS_IMPLEMENTATION_SECTION}
//   Inside this section, put method implementations, or any other code that
//   should go in the implementation section in Values.pas.
// {$ENDIF}
