//
//  IDZInvocation.m
//  IDZInvocation
//
//  Created by iOS Developer Zone on 8/14/15.
//  Copyright (c) 2015 iOS Developer Zone. All rights reserved.
//
#import "NSInvocation+IDZInvocation.h"

@implementation NSInvocation (IDZInvocation)
@dynamic idz_arguments;

- (NSArray*)idz_arguments
{
    NSMethodSignature *signature = self.methodSignature;
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    // The first two arguments are self and _cmd.
    for(int a = 2; a < signature.numberOfArguments; ++a)
    {
        const char *pType = [signature getArgumentTypeAtIndex:a];
        NSAssert(pType, @"Argument type is not nil");
        switch(pType[0]) {
            case 'c':
            {
                char c;
                [self getArgument:&c atIndex:a];
                [arguments addObject:[NSNumber numberWithChar:c]];
                break;
            }
            case 'i':
            {
                int i;
                [self getArgument:&i atIndex:a];
                [arguments addObject:[NSNumber numberWithInt:i]];
                break;
            }
            case 's':
            {
                short s;
                [self getArgument:&s atIndex:a];
                [arguments addObject:[NSNumber numberWithShort:s]];
                break;
            }
            case 'l':
            {
                long l;
                [self getArgument:&l atIndex:a];
                [arguments addObject:[NSNumber numberWithLong:l]];
                break;
            }
            case 'q':
            {
                long long ll;
                [self getArgument:&ll atIndex:a];
                [arguments addObject:[NSNumber numberWithLongLong:ll]];
                break;
            }
            // Unsigned
            case 'C':
            {
                unsigned char uc;
                [self getArgument:&uc atIndex:a];
                [arguments addObject:[NSNumber numberWithUnsignedChar:uc]];
                break;
            }
            case 'I':
            {
                unsigned int ui;
                [self getArgument:&ui atIndex:a];
                [arguments addObject:[NSNumber numberWithInt:ui]];
                break;
            }
            case 'S':
            {
                short us;
                [self getArgument:&us atIndex:a];
                [arguments addObject:[NSNumber numberWithUnsignedShort:us]];
                break;
            }
            case 'L':
            {
                unsigned long ul;
                [self getArgument:&ul atIndex:a];
                [arguments addObject:[NSNumber numberWithUnsignedLong:ul]];
                break;
            }
            case 'Q':
            {
                unsigned long long ull;
                [self getArgument:&ull atIndex:a];
                [arguments addObject:[NSNumber numberWithLongLong:ull]];
                break;
            }
            // Floating Point Types
            case 'f':
            {
                float f;
                [self getArgument:&f atIndex:a];
                [arguments addObject:[NSNumber numberWithFloat:f]];
                break;
            }
            case 'd':
            {
                double d;
                [self getArgument:&d atIndex:a];
                [arguments addObject:[NSNumber numberWithDouble:d]];
                break;
            }
            case 'B': // C++ bool or C99 _Bool
            {
                _Bool b;
                NSAssert(sizeof(BOOL) == sizeof(_Bool), @"BOOL and _Bool are of same size.");
                [self getArgument:&b atIndex:a];
                [arguments addObject:[NSNumber numberWithBool:b]];
                break;
            }
            case 'v':
            {
                NSAssert(NO, @"Void does not appear in isolation.");
            }
            case '*':
            {
                char *pChar = nil;
                [self getArgument:&pChar atIndex:a];
                [arguments addObject:[NSValue valueWithPointer:pChar]];
                break;
            }
            
            case '@':
            {
                __unsafe_unretained id object;
                [self getArgument:&object atIndex:a];
                [arguments addObject:object];
                break;
            }
            case '#': // Class
            {
                //__unsafe_unretained id clazz;
                Class clazz;
                [self getArgument:&clazz atIndex:a];
                [arguments addObject:clazz];
                break;
            }
            case ':': // SEL
            {
                SEL selector;
                [self getArgument:&selector atIndex:a];
                [arguments addObject:[NSValue valueWithPointer:selector]];
                break;
            }
            case '{': // C struct {<name>=<type>+}
            case '[': // C array [<type>]
            case '(': // C union (<name>=<type>)
                NSAssert(NO, @"C struct, array and union handing is not implmented (yet).");
            case 'b': // bit field b<num>
                NSAssert(NO, @"Bitfield handling is not implemented (yet).");
            case '^': // ^<type> pointer to type
            {
                void *p = nil;
                [self getArgument:&p atIndex:a];
                [arguments addObject:[NSValue valueWithPointer:p]];
                break;
            }
            case '?': // Unknown type (used for function pointer, etc.)
                NSAssert(NO, @"Bitfield handling is not implemented (yet).");
            default:
                NSAssert(NO, @"Argument type is handled. (Type '%s')", pType);
        }
    }
    return arguments;
}

@end
