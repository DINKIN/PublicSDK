//
//  GTSystemInfo.h
//  GoTenna
//
//  Created by Julietta Yaunches on 4/23/15.
//  Copyright (c) 2015 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SystemInfoResponseData;

typedef enum{
    BatteryGoodGreen,
    BatterySlightlyLowYellow,
    BatteryLowRed
} GTBatteryStatusLevel;

@interface GTSystemInfo : NSObject<NSCoding>

/**
 *  System current firmware version
 */
@property(nonatomic) double firmwareVersion;

/**
 *  System current major revision
 */
@property(nonatomic) NSNumber *majorRevision;

/**
 *  System current minor revision
 */
@property(nonatomic) NSNumber *minorRevision;

/**
 *  System current build revision
 */
@property(nonatomic) NSNumber *buildRevision;

/**
 *  System current battery level
 */
@property(nonatomic) NSNumber *batteryLevel;

/**
 *  goTenna hardware serial number
 */
@property(nonatomic, copy) NSString *goTennaSerialNumber;

+ (id)initWithSystemInfo:(SystemInfoResponseData *)incomingData;

/**
 *  Current Battery Status
 *
 *  @return returns enum denoting current battery status
 */
- (GTBatteryStatusLevel)currentBatteryStatus;

/**
 *  Firmware Printable Version
 *
 *  @return returns printable version of the firmware
 */
- (NSString *)printableVersion;

/**
 *  Firmware Printable Revision Version
 *
 *  @return returns printable revision version of the firmware
 */
- (NSString *)printableRevisionVersion;

@end
