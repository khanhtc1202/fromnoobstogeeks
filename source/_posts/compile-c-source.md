---
title: Compile C program in manual way
date: 2018-03-26 01:09:47
tags: 
- compiler
- manual
- C/C++
---

After hard coding your program hour by hour (sometime, it becomes year by year :) ), one of the most uncomfortable time is compiling it into executable file. As usually, we are going to compile a program by the hardest way to do it, just because it will make us knows that in some case, `gcc` is really a hero :))

The post's content is about compiling a C program by manual way. In that program, we use an external lib, defined by yourself.

<!-- more -->

## Using static libraries

Create new static library as following steps:

1. Create new header file `.h` (where we declare functions).
2. Create new source file `.c` (where we define functions, the name of source file and header file has no relation convention, but it's better if they have the same name).
3. Compile lib to binary file
```bash
$ gcc -c lib_mylib.c -o lib_mylib.o
```
4. Create static library
```bash
$ ar rcs lib_mylib.a lib_mylib.o 
```
5. Using this compiled static lib in another C source code by using `#include`. More about compile go [here](#manual-compile-c-source-file).

Note: the name of static libary follows this name convention: `lib_namegohere.a`

## Using dynamic libraries

Dynamic Linking doesn’t require the code to be copied, it is done by just placing name of the library in the binary file. The actual linking happens when the program is run, when both the binary file and the library are in memory. Examples of Dynamic libraries (libraries which are linked at run-time) are, `.so` in Linux and `.dll` in Windows.

## Manual compile C source file

Compile a program written by C follows the 4 steps:

1. Preprocessing
2. Assembly Code Compiling
3. Machine Code Compiling
4. Linking

As usually we run `gcc source.c -o exec-bin-file` to compile the C program. It makes the result of 3 steps above come unseen, we can run this step by step as below.

```bash
$ gcc -E source.c -o source.i
$ gcc -S source.i -o source.s
$ as source.s -o source.o
$ ld source.o -o exec more-config-flag-go-here
```

Note the `more-config-flag-go-here` mean that if we manual linking object file, we must specific some input params to make sure that we pointed to needed libs.

We can using `gcc` command with `--save-temps` param to get the result of 3 steps above.

```bash
$ gcc --save-temps -o exec source.c
```

## Compile C source file with exeternal libs

As above, we can compile the C program as usually till `step 4`. We must link the external libs to C source compiled o-code file.

```bash
$ gcc -c source.c -o source.o
$ gcc -o exec source.o -L. -l_mylib
```

with
- `-L.` mean the dir which have static compiled libs (in this case it `./`)
- `-l_mylib` mean the needed lib's name is `lib_mylib.a` as the above convention.

Note: after the command create `.o` file be completed, we don't need header files any more, all are compiled and compressed into `.o` file. So in this opinion, the header file just like `interface` in oop language, we declare what we need, implementation will be written in another source file and compiled to libs, we linking it to main `.o` file and build executable file later.

So if we are going to use an external lib, we just download header files, include it into source code. In compile time, we download binary file of libs, and give it to `gcc` to link libs in linking step.

The above is the way we make an compiled executable file with static libs, the executable itself can run, no need any other libs link to it in run time. We also have the way to make this with dynamic libs (mean that in runtime, the exec file call some external libs to get implementation of needed funtions). Both of strategies have advantages and disadvantages points, so just think about it before compile your program.

Source code sample go [here](https://github.com/khanhtc1202/c-advance/tree/master/tricks/libs-build).

Reference to:
- https://kipalog.com/posts/Thu-thuc-hien-4-Stage-khi-Compile-C-bang-GCC
- https://www.geeksforgeeks.org/static-vs-dynamic-libraries/
- https://www.geeksforgeeks.org/working-with-shared-libraries-set-1/
- https://www.geeksforgeeks.org/working-with-shared-libraries-set-2/