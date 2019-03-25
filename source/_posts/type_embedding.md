---
title: Type embedding not inheritance
date: 2019-03-25 23:00:13
tags:
- oop
- golang
---

Since we don’t have classes in go, you can say `struct` will do a job to make objects. So how 4 principles of object-oriented programming represent in golang? In this post, we will discuss about the principle of OOP that make golang more better than other object oriented programming language: __inheritance__.

<!-- more -->

A simple question, how does Golang represent inheritance principle even if it doesn't have `extends`? We can easily find out the answer of this question: __embedding type__

```golang
type Parent struct {
    ...
}

type Child struct {
    Parent
}
```

Using the above code snippet, class Child can uses all Parent's properties and methods directly, just like inheritance right? But with me it more better than inheritance! Everyone who familiar with OOP thinking know about __composition over inheritance__ principle, which we `design objects that are simplified by identifying system object behaviors in separate interfaces instead of creating a hierarchical relationship to distribute behaviors among business-domain classes via inheritance`.

The key of this design principle is that we implement `has-a` relationship in classes instead of `is-a` relationship. This way of thinking similar with the way we think about embedding type: just embed what we want where we want it!

On the other hand, the interesting part is that we can embed as much as we want (not like inheritance, we can only extends one class due to the truth that we can only answer `is-a` question once).

```golang
type Men struct {}
func (m *Men) drink() string { return "beer" }

type Women struct {}
func (w *Women) drink() string { return "wine" }

type Child struct {
    Man
    Women
}
func (c *Child) drink() string { return "coke" }
```

As above example, we can embed as much as we want! If the embedded classes lead us to the diamond problem, just implement that method to point out which implementation you want compiler use in that case.
