//
//  Person.m
//  TestingThingsOut
//
//  Created by JOSHUA M MAKINDA on 3/20/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import "Person.h"

@interface Person()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *gid;
@end

@implementation Person

- (instancetype)initWithName:(NSString *)name gid:(NSNumber *)gid
{
    self = [super init];
    if (self) {
        
        if (name == nil || gid == nil) {
            [NSException raise:@"Nil Parameter Exception" format:@"Name and GID must be non-nil"];
        }
        
        self.name = name;
        self.gid = gid;
    }
    return self;
}

@end
