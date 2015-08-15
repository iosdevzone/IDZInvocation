//
//  IDZInvocationTests.m
//  IDZInvocationTests
//
//  Created by iOS Developer Zone on 8/14/15.
//  Copyright (c) 2015 iOS Developer Zone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSInvocation+IDZInvocation.h"

typedef struct NestedStructTag {
    CGPoint from;
    CGPoint to;
} NestedStruct;
/*
 * See: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 * for a list of the types that we need to cover.
 */
@protocol TestMethods <NSObject>
@optional
- (void)voidChar:(char)c;
- (void)voidInt:(int)i;
- (void)voidShort:(short)s;
- (void)voidLong:(long)l;
- (void)voidLongLong:(long long)ll;
- (void)voidUnsignedChar:(unsigned char)uc;
- (void)voidUnsignedInt:(unsigned int)ui;
- (void)voidUnsignedShort:(unsigned short)us;
- (void)voidUnsignedLong:(unsigned long)ul;
- (void)voidUnsignedLongLong:(unsigned long long)ull;
- (void)voidFloat:(float)f;
- (void)voidDouble:(double)d;
// ObjC BOOL, C++ bool and C99 _Bool all seem to generate 'B'
// in the method signature. This was not clear from the docs.
- (void)voidBool:(_Bool)b;
- (void)voidObjCBool:(BOOL)b;
- (void)voidCharStar:(char *)p;
- (void)voidObject:(id)o;
- (void)voidClass:(Class)c;
- (void)voidSelector:(SEL)s;

- (void)voidStruct:(CGPoint)point;
- (void)voidNestedStruct:(NestedStruct)nestedStruct;

// This is to test the ^<type> signature.
- (void)voidVoidStar:(void*)pointer;
@end

@interface TestMethodInvoker : NSObject<TestMethods>
@property (nonatomic, readonly) NSInvocation *lastInvocation;
@property (nonatomic, readonly) id<TestMethods> delegate;

- (instancetype)initWithDelegate:(id<TestMethods>)delegate;
@end

@implementation TestMethodInvoker
@synthesize lastInvocation = mLastInvocation;
@synthesize delegate = mDelegate;

- (instancetype)initWithDelegate:(id<TestMethods>)delegate
{
    if(self = [super init])
    {
        mDelegate = delegate;
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{

    if([self.delegate respondsToSelector:anInvocation.selector])
        [anInvocation invokeWithTarget:self.delegate];
    mLastInvocation = anInvocation;
}

@end

@interface IDZInvocationTests : XCTestCase
{
    TestMethodInvoker *mInvoker;
}

@end

@implementation IDZInvocationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    mInvoker = [[TestMethodInvoker alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Signed Integer Types
- (void)testVoidChar {
    char c = (char)(arc4random() & 0xff);
    [mInvoker voidChar:c];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).charValue == c);
}

- (void)testVoidInt {
    int i = (int)arc4random();
    [mInvoker voidInt:i];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).intValue == i);
}

- (void)testVoidShort {
    short s = (short)(arc4random() & 0xffff);
    [mInvoker voidShort:s];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).shortValue == s);
}

- (void)testVoidLong {
    long l = (long)arc4random();
    [mInvoker voidLong:l];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).longValue == l);
}

- (void)testVoidLongLong {
    long long ll = (long long)arc4random();
    [mInvoker voidLongLong:ll];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).longLongValue == ll);
}

#pragma mark - Unsigned Integer Types

- (void)testVoidUnsignedChar {
    unsigned char uc = (char)(arc4random() & 0xff);
    [mInvoker voidUnsignedChar:uc];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).unsignedCharValue == uc);
}

- (void)testVoidUnsignedInt {
    unsigned int ui = (int)arc4random();
    [mInvoker voidUnsignedInt:ui];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).unsignedIntValue == ui);
}

- (void)testVoidUnsignedShort {
    unsigned short us = (short)(arc4random() & 0xffff);
    [mInvoker voidUnsignedShort:us];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).unsignedShortValue == us);
}

- (void)testVoidUnsignedLong {
    unsigned long ul = (long)arc4random();
    [mInvoker voidUnsignedLong:ul];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).unsignedLongValue == ul);
}

- (void)testVoidUnsignedLongLong {
    unsigned long long ull = (long long)arc4random();
    [mInvoker voidUnsignedLongLong:ull];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).unsignedLongLongValue == ull);
}

#pragma mark - Floating Point Types
- (void)testVoidFloat {
    float f = (float)arc4random() / (float)UINT32_MAX;
    [mInvoker voidFloat:f];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).floatValue == f);
}

- (void)testVoidDouble {
    double d = (double)arc4random() / (double)UINT32_MAX;
    [mInvoker voidDouble:d];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert(((NSNumber*)arguments[0]).doubleValue == d);
}

#pragma mark - Miscellaneous C Types
- (void)testVoidBool {
    _Bool b = true;
    [mInvoker voidBool:b];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert((_Bool)((NSNumber*)arguments[0]).boolValue == b);
    b = false;
    [mInvoker voidBool:b];
    arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert((_Bool)((NSNumber*)arguments[0]).boolValue == b);
}

- (void)testVoidObjCBool {
    BOOL b = YES;
    [mInvoker voidBool:b];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert((_Bool)((NSNumber*)arguments[0]).boolValue == b);
    b = NO;
    [mInvoker voidBool:b];
    arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSNumber class]]);
    XCTAssert((_Bool)((NSNumber*)arguments[0]).boolValue == b);
}

- (void)testVoidCharStar {
    char *p = "Hello, World!";
    [mInvoker voidCharStar:p];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSValue class]]);
    XCTAssert((char *)((NSValue*)arguments[0]).pointerValue == p);
}

#pragma mark - Objective C Types
- (void)testVoidObject {
    NSString *o = @"Hello, World!";
    [mInvoker voidObject:o];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[o class]]);
    XCTAssert([arguments[0] isEqual:o]);
}

- (void)testVoidClass {
    Class clazz = [self class];
    [mInvoker voidClass:clazz];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isEqual:clazz]);
}

- (void)testVoidSelector {
    SEL selector = @selector(testVoidSelector);
    NSString *selectorString = NSStringFromSelector(selector);
    
    [mInvoker voidSelector:selector];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    
    SEL outputSelector = (SEL)((NSValue*)arguments[0]).pointerValue;
    XCTAssert(outputSelector == selector);
    
    NSString* outputSelectorString = NSStringFromSelector(outputSelector);
    XCTAssert([selectorString isEqualToString:outputSelectorString]);
}

#if 0
- (void)testVoidStruct {
    CGPoint point = CGPointMake(-1.0, 1.0);
    [mInvoker voidStruct:point];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
}

- (void)testVoidNestedStruct {
    NestedStruct line = { { 0,0 }, { 1, -1}};
    [mInvoker voidNestedStruct:line];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
}
#endif

- (void)testVoidVoidStar {
    void *p = (void *)"Hello";
    [mInvoker voidVoidStar:p];
    NSArray *arguments = mInvoker.lastInvocation.idz_arguments;
    XCTAssert(arguments.count == 1);
    XCTAssert([arguments[0] isKindOfClass:[NSValue class]]);
    XCTAssert(((NSValue*)arguments[0]).pointerValue == p);
}
@end
