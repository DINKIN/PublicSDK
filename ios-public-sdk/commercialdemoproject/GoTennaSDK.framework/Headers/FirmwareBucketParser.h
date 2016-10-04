//
// Created by Julietta Yaunches on 5/27/15.
// Copyright (c) 2015 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FirmwareBucketParser : NSObject

/**
 *  Determines which version of the firmware to download when passing in a dictionary of versions
 *
 *  @param dictionary NSDictionary
 *
 *  @return NSString denoting the firmware version
 */
- (NSString *)determineVersionToDownload:(NSArray *)dictionary;

@end