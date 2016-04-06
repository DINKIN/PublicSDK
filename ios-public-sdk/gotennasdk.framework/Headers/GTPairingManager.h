//
//  GTPairingManager.h
//  GoTenna
//
//  Created by Julietta Yaunches on 11/25/14.
//  Copyright (c) 2014 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "GTPairingConnectionState.h"

@protocol GTPairingHandlerProtocol <NSObject>
- (void)updateState:(GTConnectionState)state;
@end

@protocol BluetoothPairingProtocol <NSObject>
- (void)didConnectToPeripheral;
- (void)bluetoothConnectionNotAvailable:(CBCentralManagerState)state;
- (void)canNotConnectToPeripheral;
- (void)bluetoothPoweredOn;
- (void)nonUserDisconnectionOccurred;
@end

/// Main class to use when connecting to a goTenna
@interface GTPairingManager : NSObject <BluetoothPairingProtocol>

/**
 *  Set another class as delegate to receive updates on the connected state of the goTenna
 */
@property(nonatomic) id<GTPairingHandlerProtocol> pairingHandler;

/**
 *  Set to yes if you should keep trying to rescan after failing or disconnecting
 */
@property(nonatomic) BOOL shouldReconnect;

/**
 *  This class is a singleton. Use this method to get the global instance.
 *
 *  @return A shared instance
 */
+ (GTPairingManager *)shared;

/**
 *  Call this to disconnect a connected goTenna
 */
- (void)initiateDisconnect;

/**
 *  Call this to connect to your goTenna. NOTE: before calling this, ensure to set the pairingHandler delegate to get callbacks on when the state changes to connected or any other possible states
 */
- (void)initiateScanningConnect;

/**
 *  Stop scanning for a device
 */
- (void)stopScanningConnect;

/**
 *  Remove any internal scanned saved device
 */
- (void)clearSavedScannedDevice;

/**
 *  Use this method to get the current connection status of your goTenna
 *
 *  @return Connection states enum
 */
- (GTConnectionState)connectingState;

/**
 *  Determines whether a scanned device is saved
 *
 *  @return Evaluation of whether saved device is present or not
 */
- (BOOL)isScannedDeviceSaved;

@end
