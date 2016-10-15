# Language development on .NET with Xtext - Part 1
## Introduction
Developing a textual DSL in .NET is a tedious process consisting of manually defining data structures and writing a grammar with actions to construct syntax trees, symbol tables, basic validations etc.

In order to automatize a large part of the process of DSL creation, you could use Xtext:
By writing an Xtext grammar, you don't only get a parser and a serializer, but also abstract syntax trees and the corresponding classes, syntax validations and cross-references to other EMF models, for free! 

Xtext can be easily integrated into .NET applications using IKVM, which allows to convert Java libraries to .NET assemblies.

In the following, we will illustrate the use of a simple Xtext DSL within a .NET command-line application written in C#.

## Example
Let's say we already created a DSL with Xtext, in this case a language for simple arithmetical expressions and functions:

[//]: # "TODO: Herausgerissenes Blatt"

        Definition:
            'def' name=ID ('(' args+=DeclaredParameter (',' args+=DeclaredParameter)* ')')? ':' expr=Expression ';';

        Expression:
            Addition;

        Addition returns Expression:
            PrimaryExpression (({Plus.left=current} '+' | {Minus.left=current} '-') right=PrimaryExpression)*;

        PrimaryExpression returns Expression:
            '(' Expression ')' |
            {NumberLiteral} value=NUMBER |
            {FunctionCall} func=[AbstractDefinition] ('(' args+=Expression (',' args+=Expression)* ')')?;

From the grammar listed above, Xtext generates a parser which maps DSL instances to Java objects.
For example, the parser would map the expression ``1 + 2`` to an instance of the generated class ``Plus`` whose ``left`` and ``right`` properties are ``NumberLiteral``s with ``value = 1`` and ``value = 2``, respectively.

Apart from these generated classes, Xtext includes a runtime library which provides an extensive  infrastructure of re-usable, customizable services for handling DSL models. 

Now, I would like to write a C# interpreter for evaluating the arithmetical expressions of our DSL and a command-line interface to the interpreter, in order to show that it's possible to embed Xtext DSLs in .NET applications by consuming them in C# programs and thus avoid most of the tedious work connected with parser development.

In order to implement this embedding, we have to convert the DSL's generated Java classes and the runtime libraries to a .NET assembly.
To do this, we can build a Uber JAR containing all these classes and their dependencies using Maven and the Shade plugin, and then invoke IKVM from Maven to create a DLL from the JAR.
Then, we can reference this DLL from a C# project and use the classes originally written in Java in our C# application.

![C# Interpreter](csharp-interpreter.png)

In the figure above you can see a part of the interpreter, whose purpose is to evaluate an arithmetical expression (input parameter type ``Expression``), with a number (``BigDecimal``) as result.
We dispatch by expression class, such that for a ``Plus``, first the left and right summand are evaluated and the results are added with ``add``, and similarly for ``Minus`` and so on.

[//]: # "Wie setze ich sowas auf?"
[//]: # "Konkretes Beispiel"

[//]: # " - Konkrete Beispiel-DSL + Interpreter"
[//]: # " - Projektstruktur"
[//]: # " - Maven Build"
[//]: # "    - Shade "
[//]: # "	- Aufruf IKVM"
[//]: # " - 'Integrationshemmnisse'"

[//]: # "Diagramme"

## Conclusion
In this post, we have seen that it's possible to use the uncomplicated Xtext way of developing DSLs on the .NET platform by using IKVM to consume Xtext generated classes in a C# program.  

The example code is [available](https://github.com/stadlerb/ikvm-arithmetics-cli) on Github.
