//
// Created by Julietta Yaunches on 1/13/15.
// Copyright (c) 2015 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTFirmwareVersion;


@interface FirmwareFileParser : NSObject

/**
 *  Parses file using passed in file name and returns data using the contents of that filepath
 *
 *  @param filename NSString
 *
 *  @return NSData
 */
- (NSData *)parseFileToDataForVersion:(GTFirmwareVersion *)filename;
@end