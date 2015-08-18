//
//  IDZInvocation.h
//  IDZInvocation
//
//  Created by iOS Developer Zone on 8/14/15.
//  Copyright (c) 2015 iOS Developer Zone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (IDZInvocation)

@property (nonatomic, readonly) NSArray* idz_arguments;
@property (nonatomic, readonly) id idz_returnValue;

@end
