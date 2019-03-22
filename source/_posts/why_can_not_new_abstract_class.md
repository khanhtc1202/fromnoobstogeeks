---
title: Why cann't new abstract class (java)
date: 2019-03-23 01:50:54
tags:
- oop
- thinking
- design
---

Abstract class and Interface is one of the most be confused problem when the first time I learnt Java. In which case we should use Abstract class and which case we should use Interface? Let's take a look deeper in this two of concepts.

<!-- more -->

By defination, the Abstract class (java) is a __class but unlike a simple java class, it's may not only contain regular defined methods but may also contain abstract methods or a mix of regular and abstract methods.__ Some of Abstract class's properties that make is different from Interface can be listed are:

1. Methods of Interfaces cannot have implementations. In other words, they can have only abstract or non-concrete methods. Abstract classes can have both abstract methods and concrete methods. Interface cannot provide any code at all. Abstract class can provide complete code, default code, and/or stubs that have to be overwritten.

2. Interfaces can contain only final variables(by default all variables are final). There may be final variables in abstract classes.

3. Methods of interface are public by default. Methods of abstract class can have modifiers such as public, private...

4. Interface can extend another interface only but cannot extend any type of class. Abstract class can extend another java class, implement multiple java interfaces and extend only one abstract class.

Any times I read that above list, the only thing I see is that Abstract class has power in share `source code` through inheritance (of course we all know that inheritance is not good, we will discuss about this in another post), unlike Interface that share the `contract` through method declaration. All other features of Abstract class are just for support that responsibility.

On the other hand, we knew that object oriented programming is programming, in which we represent real objects by create the object blueprint call `class`. __So every class should be existed to help us make object from it!!!__ In case of Abstract classes, since we can't create object from them, why do they still exist? Is this a bug in the design of Java where the main responsibility of Abstract class is not supporting object oriented programming but supporting `class oriented programming`?
