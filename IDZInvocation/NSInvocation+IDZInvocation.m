//
//  IDZInvocation.m
//  IDZInvocation
//
//  Created by iOS Developer Zone on 8/14/15.
//  Copyright (c) 2015 iOS Developer Zone. All rights reserved.
//
#import "NSInvocation+IDZInvocation.h"

@interface NSInvocation (IDZInvocationPrivate)
- (id)idz_boxType:(const char*)pType withValueFetcher:(void (^)(void *, size_t))fetchValue;
@end

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
        [arguments addObject:[self idz_boxType:pType withValueFetcher:^(void *pValue, size_t valueBytes) {
            [self getArgument:pValue atIndex:a];
        }]];
    }
    return arguments;
}

- (id)idz_returnValue
{
    return [self idz_boxType:self.methodSignature.methodReturnType withValueFetcher:^(void *pValue, size_t valueBytes) {
        [self getReturnValue:pValue];
    }];
}
@end

@implementation NSInvocation (IDZInvocationPrivate)
- (id)idz_boxType:(const char*)pType withValueFetcher:(void (^)(void *, size_t))fetchValue
{
    id boxedValue = nil;
    switch(pType[0]) {
        case 'c':
        {
            char value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithChar:value];
            break;
        }
        case 'i':
        {
            int value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithInt:value];
            break;
        }
        case 's':
        {
            short value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithShort:value];
            break;
        }
        case 'l':
        {
            long value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithLong:value];
            break;
        }
        case 'q':
        {
            long long value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithLongLong:value];
            break;
        }
            // Unsigned
        case 'C':
        {
            unsigned char value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithUnsignedChar:value];
            break;
        }
        case 'I':
        {
            unsigned int value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithUnsignedInt:value];
            break;
        }
        case 'S':
        {
            unsigned short value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithUnsignedShort:value];
            break;
        }
        case 'L':
        {
            unsigned long value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithUnsignedLong:value];
            break;
        }
        case 'Q':
        {
            unsigned long long value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithUnsignedLongLong:value];
            break;
        }
            // Floating Point Types
        case 'f':
        {
            float value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithFloat:value];
            break;
        }
        case 'd':
        {
            double value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithDouble:value];
            break;
        }
        case 'B': // C++ bool or C99 _Bool
        {
            NSAssert(sizeof(BOOL) == sizeof(_Bool), @"BOOL and _Bool are of same size.");
            _Bool value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSNumber numberWithBool:value];
            break;
        }
        case 'v':
        {
            NSAssert(NO, @"Void does not appear in isolation.");
        }
        case '*':
        {
            char *value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSValue valueWithPointer:value];
            break;
        }
        case '@':
        {
            __unsafe_unretained id value;
            fetchValue(&value, sizeof(value));
            boxedValue = value;
            break;
        }
        case '#': // Class
        {
            //__unsafe_unretained id clazz;
            Class value;
            fetchValue(&value, sizeof(value));
            boxedValue = value;
            break;
        }
        case ':': // SEL
        {
            SEL value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSValue valueWithPointer:value];
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
            void *value;
            fetchValue(&value, sizeof(value));
            boxedValue = [NSValue valueWithPointer:value];
            break;
        }
        case '?': // Unknown type (used for function pointer, etc.)
            NSAssert(NO, @"Bitfield handling is not implemented (yet).");
        default:
            NSAssert(NO, @"Argument type is handled. (Type '%s')", pType);
    }
    return boxedValue;
}





@end
