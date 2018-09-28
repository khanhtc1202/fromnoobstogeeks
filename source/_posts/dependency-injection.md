---
title: Dependency Injection in a nutshell
date: 2018-05-21 13:13:40
tags:
- architecture
- design
- golang
---

As a developer, we write code day by day, try to handle many things, put all the thing in the right way it should be. Almost of our time is spent to googling usage of libraries (or frameworks), try to handle some incredible bugs or try to maintain some shitty things from other guys you may never ever met. All this mess made us forget about something that really have a meaning, it made us forget that our job is not just try to handle all the things, but our job is focused on `creating the new thing depend on another guy achievement`. But the reason why we are so confused lies in our purpose. Just like the picture below, sometime you realize yourself that you are just a noob and trying to handle all that mess - the mess named dependencies.

<!-- more -->

![](https://i.imgur.com/U1ahhBd.jpg)

Almost of us know about the SOLID principle, some of us understood and rare of us think about it while we write down our code (I'm not on this group T.T). We all pay our attention on something like design pattern and think about it as the easiest way to know how good your code are, but if we focus on that think too much, the thing we created will become more messed than you think (in the case you can finish what you started).

Our life will get easier if we put our attention on the right way it should be! Good code mean easier to maintain & easier to `read`, so if you want to make it easier to read, just break it into pieces. But when we have a heap of piece, create application logic like put them together and this makes them dependent on each other.

For example, in the below code block, we call `Car` class depends on `Engine` class.

```golang
type Car struct {
    Engine Engine // the car has an engine
}
```

This pattern appears so many times in our application. Everything seems to be okay, but when we start writing logic of `Car` class that have relation with `Engine of the Car`, all the change on `Engine` class can make `Car` class logic be broken. The same thing when we use external libraries, if your application depends directly on the external modules, it will be corrupted when those libraries are updated.

To avoid that dead end, we have a very useful tool named `Dependencies Injection`. Instead of directly injecting class to class, it's better to inject just the interface of injecting class to the host class (we have many ways to do this strategy).

## Dependencies Injection in sample

with `IEngine` is an interface of engine, `Car` is car class that use `IEngine`

```golang
type IEngine interface {
    Start()
}
```

### Contructor Injection

```golang
type Car struct {
    // public prop
    Engine IEngine
}

// Car Contructor
func NewCar(engine IEngine) *Car {
    return &Car{
        Engine: engine
    }
}

// usage
runByRiceEngine := NewRunByRiceEngine() // implemented IEngine interface
car := NewCar(runByRiceEngine)
```

### Property Injection

```golang
type Car struct {
    // private prop
    engine IEngine
}

// Setter
func (c *Car) SetEngine(engine IEngine) {
    c.engine = engine
}

// usage
runByRiceEngine := NewRunByRiceEngine() // implemented IEngine interface
car := Car()
car.SetEngine(runByRiceEngine)
```

### Interface Injection

In some opinion, they think that it's better if the way we inject class into another class is an interface itself. This implementation familiar with property injection, but the inject method isn't setter method. The object class we inject into itself implements the injectable forms on it.

```golang
type IEngineMountable interface {
    Mount(engine IEngine)
}

type Car struct {
    // private prop
    engine IEngine
}

// implement IEngineMountable
func (c *Car) Mount(engine IEngine) {
    c.engine = engine
}

// usage
runByRiceEngine := NewRunByRiceEngine() // implemented IEngine interface
car := Car()
car.Mount(runByRiceEngine)
```

## Dependencies Injection and Composition Root

There is some where in your application, they call its [Composition Root](http://blog.ploeh.dk/2011/07/28/CompositionRoot/). 

> A Composition Root is a (preferably) unique location in an application where modules are composed together.

It as close as possible to the application's entry point. In there, all of the object we declared through the application will be instanced and be composed together and act the application logic we wrote.

In console application, it should be placed at `main`. But on another way, it's better to make the `main` method as lightweight as possible, so we can give that mission to another guy. The below sample, we going to give this mission to the guy name `DI Container`.

### Injection with DI Container

```golang
type Builder func(con *Container) interface{}

// definition class
type Definition struct {
    Name string
    Builder Builder
}

// DI Container class
type Container struct {
    store map[string]Builder
}

func NewContainer() *Container {
    return &Container{
        store: map[string]Builder{},
    }
}

// DI Container method: register the object creation method
func (c *Container) Register(d *Definition) {
    c.store[d.Name] = d.Builder
}

// DI Container method: get object from container
func (c *Container) Get(key string) interface{} {
    builder, _ := c.store[key]
    instance = builder(c)
    return instance
}

// usage
container := NewContainer()
rd := &Definition{
    Name: "RunByRiceEngine",
    Builder: func(con *Container) interface{} {
        return NewRunByRiceEngine()
    }
}
container.Register(rd)

sd := &Definition{
    Name: "CarWithRunByRiceEngine",
    Builder: func(con *Container) interface{} {
        engine := con.Get("RunByRiceEngine").(IEngine)
        // inject by the way you want! In this case, it's constructor injection
        return NewCar(engine)
    }
}
container.Register(sd)

... // in main
car := container.Get("CarWithRunByRiceEngine")
```

We can make container store more than just the way to create new objects. For example we can use DI Container for storing object itself (something like Singleton Pattern implemented inside the container), sample code for this go [here](https://gist.github.com/khanhtc1202/88411fb3e33f7dd4c5e0b11618b87016).

to be continue...
