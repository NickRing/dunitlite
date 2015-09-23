# Built-in types #
The following types are supported in the DUnitLite code, and can be used in all Specify.That calls:
  * Boolean
  * Extended (floating-point values)
  * IInterface
  * Int64
  * Integer
  * string
  * TObject
  * TPoint

More types will be added in future versions. Support is planned for WideString, TRect, and some of the VCL enumerated types. More may come.

# Adding support for more types #
Rather than overloading Specify.That for each of the above types, DUnitLite has a single "universal value type" called TValue, which defines the implicit operator. To support a new data type, you simply need to add another implicit operator to TValue.

Alas, this means that if you want to support, say, using Specify.That() with your own custom enum type, you'll have to modify the Values.pas file that's part of the DUnitLite distribution. But once you do, your new type will immediately work for Specify.That, Should.Equal, Should.Be.LessThan, Should.Be.AtMost, and everything else that uses TValue.

Adding support for a new enum is fairly straightforward; you'll just add a method to TValue (search for TFoo in Values.pas to see how it's done). Adding something fancier, like a record type, will require implementing an interface and writing a bit more glue code (search for TPoint in Values.pas for an example).