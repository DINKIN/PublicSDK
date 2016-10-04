//
//  GTFirmwareInstallationManager.h
//  GoTenna
//
//  Created by Julietta Yaunches on 1/22/15.
//  Copyright (c) 2015 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTCommandCenter;
@class GTCommandBuilder;
@class FirmwareFileParser;
@class GTSystemInfoStore;
@class SettingsTVC;
@protocol GTFirmwareInstallationProgressProtocol;
@class FirmwareInstallationHud;

@interface GTFirmwareInstallationManager : NSObject

/**
 *  Retrieves version of firmware and installs that firmware by passing in an object that conforms to GTFirmwareInstallationProgressProtocol
 *
 *  @param delegate object that conforms to GTFirmwareInstallationProgressProtocol
 */
- (void)checkAndInstallFirmwareWithFirmwareProgressDelegate:(id <GTFirmwareInstallationProgressProtocol>)delegate;

/**
 *  Returns whether or not the GTFirmwareInstallationManager is currently downloading firmware
 *
 *  @return BOOL
 */
- (BOOL)isCurrentlyDownloading;

@end
