---
title: Dependency Injection in a null shell
date: 2018-04-25 13:13:40
tags:
---

As a developer, we write code day by day, try to handle many things, put all the thing in the right way it should be. Almost of our time is spent to googling usage of some libralies ( or frameworks ) , try to handle some inceribale bugs or try to maintain some shitty things from another guys you may never ever met. All this mess made us forget about something that really have a meaning, it made us forget that our job is not just try to handle all the things but our job is focus on create the "new" thing depen on another guy achievement. But the reason why we are so confused lies inside our purpose. Just like the picture bellow, sometime you relize yourself that you are just a noob and trying to handle all that mess - the mess named dependencies.

[Imgur](https://i.imgur.com/U1ahhBd.jpg)

Almost of us know about the SOLID principle, some of us understood and rare of us thing about it while we write down our code :)) We all like something `fancy` like blockchain technology, AI system, or 

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
func Car(engine IEngine) *Car {
    return &Car{
        Engine: engine
    }
}

// usage
car := Car(runByRiceEngine)
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
car := Car()
car.SetEngine(runByRiceEngine)
```

### Interface Injection

```golang
type IEngineMountable interface {
    Mount(engine IEngine)
}

// implement IEngineMountable
type Car struct {
    // private prop
    engine IEngine
}

func (c *Car) Mount(engine IEngine) {
    c.engine = engine
}

car := Car()
car.Mount(runByRiceEngine)
```

### Injection with DI Container

to be continue...