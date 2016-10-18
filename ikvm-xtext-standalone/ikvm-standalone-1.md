# Language development on .NET with Xtext <br/> - Part 1: Overview
## Introduction
Developing a textual DSL in .NET is a tedious process consisting of manually defining data structures and writing a grammar with actions to construct syntax trees, symbol tables, basic validations and so on.

[Xtext](http://www.xtext.org) automatizes a a large part of the process of DSL creation:
By writing an Xtext grammar, one doesn't only get a parser and a serializer, but also abstract syntax trees and the corresponding classes, syntax validations and cross-references to other EMF models.
Apart from the generated classes, Xtext includes a runtime library which provides an extensive infrastructure of re-usable, customizable services for handling DSL models.

This blog series will illustrate the integration of a simple Xtext DSL within a .NET command-line application written in C# by using the Java-to-.NET translator [IKVM.NET](https://www.ikvm.net/).

In the first part of this series, we will give an overview of the example use case, a command-line calculator.

## Use case overview
To demonstrate the integration, we start with a DSL developed with Xtext, in this case a language for simple arithmetical expressions and functions.
A snippet of this language's grammar is listed below.

[//]: # "TODO: Herausgerissenes Blatt"
![C# Interpreter](grammar.png)

From the grammar Xtext generates a parser which maps DSL instances to Java objects.
For example, the parser would map the expression ``1 + 2`` to an instance of the generated class ``Plus`` whose ``left`` and ``right`` properties are ``NumberLiteral``s with ``value = 1`` and ``value = 2``, respectively.

Now we will write a C# interpreter for evaluating the arithmetical expressions of our DSL and a command-line interface to the interpreter, in order to show that it's possible to embed Xtext DSLs in .NET applications by consuming them in C# programs and thus avoid most of the tedious work connected with parser development.

In order to realize this embedding, we first convert the DSL's generated Java classes and the runtime libraries to a .NET assembly.
To do this, we build an [Uber JAR](http://stackoverflow.com/a/11947093/512227) containing all these classes and their dependencies using Maven and the [Maven Shade Plugin](https://maven.apache.org/plugins/maven-shade-plugin/), and then invoke IKVM.NET from Maven to create a DLL from the JAR.
Then, we can reference this DLL from a C# project and use the classes originally written in Java in our C# application.

![C# Interpreter](csharp-interpreter.png)

The figure above illustrates the integration of the Xtext DSL in C# - it shows a part of the interpreter, whose purpose is to evaluate an arithmetical expression (input parameter type ``Expression``), with a number (``BigDecimal``) as result.
In the ``evaluate`` method, we dispatch by expression class, such that for a ``Plus``, first the left and right summand are evaluated and the results are added with ``add``, and similarly for ``Minus`` and so on.

## Running the example
In order to run the example, download the [binary distribution](https://stadlerb.github.io/ikvm-arithmetics-cli/download/calculate.zip) and unzip it, e.g. to ``C:\apps`` on Windows.
The execulable file is called ``calculate.exe``.
It can be used either with in-line expressions using the ``-e`` switch or with input files using the ``-f`` switch.
For importing modules, the files containing the module have to be added using the ``-i`` switch (multiple files separated by colons).

Examples:

        C:\apps\calculate>calculate.exe -e "2 + 3"
        - 2 + 3: 5

        C:\apps\calculate>calculate.exe -i example\polynomialexample.calc:example\linearexample.calc -e "examplepolynomial(4,7) ; examplepolynomial(weightedsum(3, 4), 19)"
        - examplepolynomial(4, 7): 73
        - examplepolynomial(weightedsum(3, 4), 19): 1665

        C:\apps\calculate>calculate.exe -i example\linearexample.calc -f example\evaluation.calc
        - weightedsum(10, 12): 80
        - weightedsum(0, 1): 5
        - (weightedsum(1, 0)): 2
        - 15 * 44 + 12: 672

## Conclusion
In this post we have sketched a way of integrating Xtext developed DSLs into the .NET platform by using IKVM.NET, which allows to consume Xtext generated classes in a C# program.
The following blog entries of this series will provide more detail regarding the creation of the .NET assembly and the integration into the C# application.
