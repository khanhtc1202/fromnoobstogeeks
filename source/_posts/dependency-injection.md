---
title: Dependency Injection in a null shell
date: 2018-04-25 13:13:40
tags:
---

As a developer, we write code day by day, try to handle many things, put all the thing in the right way it should be. Almost of our time is spent to googling usage of some libralies ( or frameworks ) , try to handle some inceribale bugs or try to maintain some shitty things from another guys you may never ever met. All this mess made us forget about something that really have a meaning, it made us forget that our job is not just try to handle all the things but our job is focus on create the "new" thing depen on another guy achievement. But the reason why we are so confused lies inside our purpose. Just like the picture bellow, sometime you relize yourself that you are just a noob and trying to handle all that mess - the mess named dependencies.

[Imgur](https://i.imgur.com/U1ahhBd.jpg)

Almost of us know about the SOLID principle, some of us understood and rare of us thing about it while we write down our code :)) We all like something `fancy` like blockchain technology, AI system, or 


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

There is some where in your application, they call it's [Composition Root](http://blog.ploeh.dk/2011/07/28/CompositionRoot/). 

> A Composition Root is a (preferably) unique location in an application where modules are composed together.

In there, all of the object we declared throw the application will be instanced and be composed together and act the application logic we wrote.

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

...
car := container.Get("CarWithRunByRiceEngine")
```

We can make container store more than just the way to create new object. For example we can use DI Container for storing object itself (something like Singleton Pattern implemented inside the container), sample code for this go [here](https://gist.github.com/khanhtc1202/a8429ffdcbd24fad41d857609e3083fb).

to be continue...