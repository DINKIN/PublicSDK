//
//  BluetoothConnectionManager.h
//  GoTenna
//
//  Created by Julietta Yaunches on 30/05/2014.
//  Copyright (c) 2014 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BluetoothPairingProtocol;

static dispatch_queue_t GTBluetoothConnectionQueue() {
    static dispatch_queue_t bluetooth_activity_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bluetooth_activity_queue = dispatch_queue_create("com.GT.GTBluetoothConnectionQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return bluetooth_activity_queue;
}

extern NSString * const kGoTennaServiceUUID;
extern NSString * const kGoTennaDeviceInformationUUID;
extern NSString * const kGoTennaKeepAliveCharacteristicUUID;
extern NSString * const kGoTennaWriteCharacteristicUUID;
extern NSString * const kGoTennaReadCharacteristicUUID;
extern NSString * const kGoTennaBluetoothProtocolRevisionCharacteristicUUID;

/**
 *  Use this class for further information and control over connection to the goTenna, though `GTPairingManager` is the best option for connecting to a goTenna
 */

@interface BluetoothConnectionManager : NSObject<CBCentralManagerDelegate>

/**
 *  Pairing delegate that returns bluetooth state changes as they happen
 */
@property (weak, nonatomic) id<BluetoothPairingProtocol> pairingDelegate;

/**
 *  Sets the connection to be not required for certain bluetooth operations. NOTE: By default is NO and should generally remain as NO.
 */
@property(nonatomic) BOOL connectionNotRequired;

/**
 *  This class is a singleton. Use this method to get the global instance.
 *
 *  @return A shared instance
 */
+ (BluetoothConnectionManager *)shared;

/**
 *  Scan for a device
 */
- (void)scanAndConnect;

/**
 *  Stop scanning for a device
 */
- (void)stopScan;

/**
 *  Reset the central managing bluetooth object. NOTE: There is generally no reason to call this
 */
- (void)resetCentralManager;

/**
 *  Sends disconnect message if goTenna is connected, will not send message if not connected already
 */
- (void)userDisconnect;

/**
 *  Clears the saved device that was scanned
 */
- (void)clearScannedDevice;

/**
 *  Checks if scanned device is saved
 *
 *  @return Scanned device saved evaulation
 */
- (BOOL)isScannedDeviceSaved;

/**
 *  Checks if connected to a goTenna
 *
 *  @return Evaluation of connected state with goTenna
 */
- (BOOL)isConnected;

/**
 *  Checks if scanning is currently happening
 *
 *  @return Will tell you if search/scan for devices is taking place
 */
- (BOOL)isScanning;

@end
