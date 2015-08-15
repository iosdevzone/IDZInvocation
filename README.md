# IDZInvocation
A category on NSInvocation to make argument value extraction less painful.

## What does it do?
Given an `NSInvocation` object `anInvocation`, `IDZInvocation` adds an `idz_arguments` property of type `NSArray` containing the values of the arguments to the invocation.

This allows you to do things like this:
```objective-c
  NSArray *arguments = anInvocation.idz_arguments;
  for(int i = 0; i < arguments.count; ++i) 
  {
    NSLog(@"argument[%d]: %@", i, arguments[i]);
  }
```

## Umm, OK, But why did you write it?
I needed it for some testing and bug-checking I am currently doing. It's not something for production code, it's for debugging and testing. There may be some other stuff that does in on the internets, but my google-fu could not find it quicer than I could write it.

## How do I add it to my project?
Just add the files `NSInvocation+IDZInvocation.h` and `NSInvocation+IDZInvocation.m` to your project.

I will probably add Cocoapods support soon, but that does seem like overkill for a category.

## Are there any limitations?

At this time, the category does not support C arrays, structs, unions or bitfields. Since these are relatively unusual in Objective C method calls.
