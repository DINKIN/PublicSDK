//
//  Person.h
//  TestingThingsOut
//
//  Created by JOSHUA M MAKINDA on 3/20/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (instancetype)initWithName:(NSString *)name gid:(NSNumber *)gid;

- (NSString*)name;
- (NSNumber*)gid;
@end
