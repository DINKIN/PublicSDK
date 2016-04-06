//
//  ViewController.m
//  ConsumerDemoProject
//
//  Created by JOSHUA M MAKINDA on 3/23/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import "ViewController.h"
#import <GoTennaSDK/GoTennaSDK.h>

@interface ViewController () <GTPairingHandlerProtocol>
@property (nonatomic) BOOL rememberGoTennaDevice;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rememberGoTennaDevice = NO;
    
    [[GTPairingManager shared] setPairingHandler:self];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f],
                                                                    NSForegroundColorAttributeName: [UIColor colorWithRed:1.0f green:0.4f blue:0.4f alpha:1.0f]};
}

- (IBAction)rememberGoTennaSwitched:(UISwitch*)sender {
    
    self.rememberGoTennaDevice = sender.on;
}

- (IBAction)startScanningForGoTennaPressed:(id)sender {
    
    [[GTPairingManager shared] initiateScanningConnect];
}

- (void)updateState:(GTConnectionState)state {
    
    switch (state) {
        case BluetoothOff:
            NSLog(@"BLUETOOTH OFF");
            break;
        case Connecting:
            NSLog(@"CONNECTING...");
            break;
        case Connected: {
            
            NSLog(@"CONNECTED");
            
            [GoTenna setApplicationToken:@"rnd0scu0v0s73mjsqd36t7o67qj7mgfg"];
            
            if (self.rememberGoTennaDevice == NO) {
                
                if ([[GTPairingManager shared] isScannedDeviceSaved]) {
                    [[GTPairingManager shared] clearSavedScannedDevice];
                }
            }
        }
            break;
        default:
            break;
    }
}

@end