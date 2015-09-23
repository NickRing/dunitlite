DUnitLite is an attempt to improve upon the [DUnit](http://dunit.sourceforge.net/) unit-testing framework for Delphi. It's currently an add-on library for DUnit (though, as the name suggests, it may someday grow to be a full lightweight testing library in its own right).

Right now, DUnitLite offers three major features over the base DUnit library:

# Readable assertions #

Most xUnit test frameworks have backwards assertion methods. They make you put the expected value first, followed by the actual value:

```
CheckEquals(4, Add(2, 2));
```

How do you read that? "Check that 4 is what you get when you add 2 and 2"? You shouldn't have to think this hard to understand what the test is doing. What if you could write it the way you would speak: "Check that 2 plus 2 is 4"?

Enter DUnitLite.

```
Specify.That(Add(2, 2), Should.Equal(4));
Specify.That(Control.Caption, Should.Equal('Close').IgnoringCase);
Specify.That(ElapsedTime, Should.Be.AtMost(500));
```

See SupportedSyntax for a list of all the different things you can do.

# More data types #

DUnit's CheckEquals() methods support a limited number of data types. The only way you can compare two enums (or two records, or...) is to write your own CheckEquals overload -- which isn't that hard, but then you need to write more code if you want CheckNotEquals, CheckGreater, CheckGreaterOrEqual...

DUnitLite has built-in support for data types DUnit doesn't (e.g. TPoint). And when you want to add more, you only have to write the code once to get the benefit everywhere.

See SupportedTypes for more details.

# String context #

When comparing really long strings, it can be hard to see where they're actually different. DUnitLite makes it easier by showing only a portion of the strings, centered around the first character that's actually different.

```
Specify.That(Query.Sql.Text, Should.Equal(ExpectedSql));

Expected: ...'.TicketID = Tickets.ID'#13#10'WHERE Component = 42 AND Status = 1 A'...
 but was: ...'.TicketID = Tickets.ID'#13#10'WHERE Tickets.Component = 42 AND Tick'...
```