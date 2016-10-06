//
//  MainDeckViewController.m
//  IQTDemoProject
//
//  Created by JOSHUA M MAKINDA on 3/21/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import "MainDeckViewController.h"
#import <GoTennaSDK/GoTennaSDK.h>
#import "GroupViewController.h"

#import "Person.h"

@interface MainDeckViewController () <GTFirmwareInstallationProgressProtocol>
@property (weak, nonatomic) IBOutlet UILabel *firmwareStatusLabel;
@property (nonatomic, strong) NSDictionary *messageDeserializingDictionary;
@property (nonatomic) BOOL isEncryptionOn;

@property (nonatomic, strong) Person *sender;
@property (nonatomic, strong) Person *recipient;

@property (nonatomic, strong) NSString *greeting;
@end

@implementation MainDeckViewController

void showAlert(id instance, NSString* title, NSString* body, NSString* cancelTitle) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert= [UIAlertController alertControllerWithTitle:title message:body preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okay = [UIAlertAction
                               actionWithTitle:@"Okay"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
        [alert addAction:okay];
        [instance presentViewController:alert animated:YES completion:nil];
        
    });
}

void showTextFieldAlert(id instance, NSString* title, NSString* body, NSString* textFieldContent, NSString* placeholder, void(^operation)(NSString* urlString)) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert= [UIAlertController alertControllerWithTitle:title message:body preferredStyle:UIAlertControllerStyleAlert];
        
        __block UITextField *inputTextField;
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
            textField.text = textFieldContent;
            inputTextField = textField;
        }];
        
        UIAlertAction *okay = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                                   operation(inputTextField.text);
                               }];
        
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:nil];
        
        [alert addAction:okay];
        [alert addAction:cancel];
        
        [instance presentViewController:alert animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.greeting = @"Hello Universe";
    
    self.isEncryptionOn = YES;
    
    [self.navigationItem setHidesBackButton:YES];
    self.messageDeserializingDictionary = @{
                                            kMessageTypeTextOnly : ^GTBaseMessageData *(NSArray<TLVSection*> *dataArray, NSNumber *senderGID) {
                                                return [[GTTextOnlyMessageData alloc] initFromOrderedData:dataArray withSenderGID:senderGID];
                                            },
                                            kMessageTypeSetGroupGID : ^GTBaseMessageData *(NSArray<TLVSection*> *dataArray, NSNumber *senderGID) {
                                                return [[GTGroupCreationMessageData alloc] initFromOrderedData:dataArray withSenderGID:senderGID];
                                            },
                                            kMessageTypeFirmwarePublicKeyResponse : ^GTBaseMessageData *(NSArray<TLVSection*> *dataArray, NSNumber *senderGID) {
                                                return [[GTPublicKeyFirmwareResponseMessageData alloc] initFromOrderedData:dataArray withSenderGID:senderGID];
                                            },
                                            kMessageTypeUserPublicKeyResponse : ^GTBaseMessageData *(NSArray<TLVSection*> *dataArray, NSNumber *senderGID) {
                                                return [[GTPublicKeyUserResponseMessageData alloc] initFromOrderedData:dataArray withSenderGID:senderGID];
                                            },
                                            kMessageTypePublicKeyRequest : ^GTBaseMessageData *(NSArray<TLVSection*> *dataArray, NSNumber *senderGID) {
                                                return [[GTPublicKeyRequestMessageData alloc] initFromOrderedData:dataArray withSenderGID:senderGID];
                                            },
                                            };
    
    void(^onIncomingMessage)(GTMessageData*) = ^(GTMessageData *response) {
        
        NSArray<TLVSection*> *tlvSections = [TLVSection tlvSectionsFromData:response.commandData];
        
        if (tlvSections.count < 2) {
            return;
        }
        
        NSLog(@"INCOMING... SENDERGID: %@ ... VS MINE (%@)",response.senderGID, [UserDataStore shared].currentUser.gId);
        
        GTBaseMessageData *basicMessageData = [[GTBaseMessageData alloc] initIncoming:tlvSections withSenderGID:response.senderGID];
        GTBaseMessageData *(^buildResultBlock)(NSArray<TLVSection*> *, NSNumber *senderGID) = self.messageDeserializingDictionary[basicMessageData.messageType];
        
        if(buildResultBlock){
            
            GTBaseMessageData *baseMessageData = buildResultBlock(tlvSections, basicMessageData.senderGID);
            baseMessageData.addresseeGID = response.addressedGID;
            baseMessageData.messageSentDate = response.messageSentDate;
            
            //GTGIDType = [GIDManager gidTypeForGID:[baseMessageData addres]];
            GTGIDType type = [GIDManager gidTypeForGID:baseMessageData.addresseeGID];
            
            BOOL numberIsShoutGID = (type == ShoutGID);
            
            if (numberIsShoutGID) {
                
                showAlert(self, @"SHOUT (incoming)", baseMessageData.text, @"OK");
                return;
            }
            
            if (numberIsShoutGID == NO) {
                
                //RECEIVED NEW FIRMWARE PUBLIC KEY PUBLIC KEY => publicKeyMessageData.publicKey
                
                if ([baseMessageData isKindOfClass:[GTPublicKeyFirmwareResponseMessageData class]]) {
                    
                    GTPublicKeyFirmwareResponseMessageData *publicKeyMessageData = (GTPublicKeyFirmwareResponseMessageData*)baseMessageData;
                    PublicKeyManager *keyManager = [PublicKeyManager shared];
                    
                    NSLog(@"RECEIVED NEW FIRMWARE PUBLIC KEY PUBLIC KEY => %@ ____ SENDER => %@",publicKeyMessageData.publicKey,publicKeyMessageData.senderGID);
                    
                    [keyManager addPublicKeyWithGID:publicKeyMessageData.senderGID
                                      publicKeyData:publicKeyMessageData.publicKey
                                 userHasMyPublicKey:YES];
                    
                    [[GTDecryptionErrorManager shared] attemptToDecryptMessagesAgain];
                    
                }
                
                //RECEIVED NEW USER PUBLIC KEY => publicKeyMessageData.publicKey
                
                else if ([baseMessageData isKindOfClass:[GTPublicKeyUserResponseMessageData class]]) {
                    
                    GTPublicKeyUserResponseMessageData *publicKeyMessageData = (GTPublicKeyUserResponseMessageData*)baseMessageData;
                    PublicKeyManager *keyManager = [PublicKeyManager shared];
                    
                    [keyManager addPublicKeyWithGID:publicKeyMessageData.senderGID publicKeyData:publicKeyMessageData.publicKey];
                    
                    [[GTDecryptionErrorManager shared] attemptToDecryptMessagesAgain];
                }
                
                //RECEIVED PUBLIC KEY REQUEST FROM USER
                
                else if ([baseMessageData isKindOfClass:[GTPublicKeyRequestMessageData class]]) {
                    
                    [[GTCommandCenter shared] sendPublicKeyResponseToGID:baseMessageData.senderGID];
                }
                
                else {
                    
                    NSString *messageType = (type == GroupGID) ? @"GROUP MESSAGE" : @"ONE TO ONE";
                    showAlert(self, [NSString stringWithFormat:@"%@ (incoming)",messageType], baseMessageData.text, @"OK");
                    
                    return;
                }
            }
        }
    };
    
    void(^onIncomingGroupCreation)(GTGroupCreationMessageData*) = ^(GTGroupCreationMessageData *response) {
        
        NSArray<NSNumber*> *members = response.groupAddressees;
        NSNumber *senderGID = response.senderGID;
        NSNumber *ownGID = [UserDataStore shared].currentUser.gId;
        NSNumber *groupGID = response.groupGID;
        
        showAlert(self, @"GROUP CREATED (incoming)", [NSString stringWithFormat:@"Members: %@\nMe: %@\nCreator: %@\bGroup GID: %@",members,ownGID,senderGID,groupGID], @"OK");
    };
    
    
    [[GTCommandCenter shared] setOnIncomingMessage:onIncomingMessage];
    
    [[GTCommandCenter shared] setOnGroupCreated:onIncomingGroupCreation];
}

- (IBAction)sendEcho:(id)sender {
    
    [[GTCommandCenter shared] sendEchoCommand:^(GTResponse *res) {
        
        BOOL echoSuccess = res.responseCode == GTResponsePositive;
        
        if (echoSuccess) {
            NSLog(@"ECHO, success");
        }
        else {
            NSLog(@"ECHO, failed");
        }
        
    } onError:^(NSError *error) {
        NSLog(@"ECHO, error: %@",error);
    }];
}

- (IBAction)sendGetSystemInfo:(id)sender {
    
    [[GTCommandCenter shared] sendGetSystemInfoOnSuccess:^(SystemInfoResponseData *systemInfoResponseData) {
        
        NSString *systemInfoContent = [NSString stringWithFormat:@"Firmware Version: %@\nMajor Revision: %@\nGoTenna Serial Number: %@\nBattery Level: %.2f",@(systemInfoResponseData.firmwareVersion),systemInfoResponseData.majorRevision,systemInfoResponseData.goTennaSerialNumber,systemInfoResponseData.batteryLevelPercentage.floatValue];
        
        showAlert(self, @"System Info", systemInfoContent, @"OK");
        
    } onError:^(NSError *error) {
        
        NSLog(@"GetSystemInfoError, error: %@",error);
    }];
}

- (IBAction)setGID:(id)sender {
    
    Person *person1 = [[Person alloc] initWithName:@"Alice" gid:@123456789];
    Person *person2 = [[Person alloc] initWithName:@"Bob" gid:@987654321];
    
    void(^onError)(NSError*) = ^(NSError *error) {
        showAlert(self, @"GID SET ERROR", @"GID not set", @"OK");
    };
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Set GID"
                                                                   message:@"Select GID to Set"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *title1 = [NSString stringWithFormat:@"%@ - %@",person1.name,person1.gid];
    UIAlertAction *setFirstGID = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [[GTCommandCenter shared] setgoTennaGID:person1.gid withUsername:nil onError:onError];
        _recipient = person2;
    }];
    [sheet addAction:setFirstGID];
    
    NSString *title2 = [NSString stringWithFormat:@"%@ - %@",person2.name,person2.gid];
    UIAlertAction *setSecondGID = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [[GTCommandCenter shared] setgoTennaGID:person2.gid withUsername:person2.name onError:onError];
        _recipient = person1;
    }];
    
    [sheet addAction:setSecondGID];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (IBAction)sendPrivateMessage:(id)sender {
    
    if (self.recipient == nil) {
        return;
    }
    
    User *me = [UserDataStore shared].currentUser;
    
    void(^onResponse)(GTResponse* res) = ^(GTResponse*res){ };
    void(^onError)(NSError*) = ^(NSError *err) { showAlert(self, @"Error", err.description, @"OK"); };
    
    NSError *error = nil;
    GTTextOnlyMessageData *messageData = [[GTTextOnlyMessageData alloc] initOutgoingWithText:self.greeting onError:&error];
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Send Private" message:@"To GID" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *title = [NSString stringWithFormat:@"%@ - %@",self.recipient.name,self.recipient.gid];
    UIAlertAction *sendTo = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [[GTCommandCenter shared] sendMessage:messageData.serializeToBytes
                                      encrypt:self.isEncryptionOn
                                        toGID:self.recipient.gid
                                      fromGID:me.gId
                                   onResponse:onResponse
                                      onError:onError];
    }];
    [sheet addAction:sendTo];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (IBAction)sendBroadcast:(id)sender {
    
    void(^onResponse)(GTResponse* res) = ^(GTResponse* res){ };
    void(^onError)(NSError*) = ^(NSError *err) { showAlert(self, @"Error", err.description, @"OK"); };
    
    NSError *error = nil;
    GTTextOnlyMessageData *messageData = [[GTTextOnlyMessageData alloc] initOutgoingWithText:self.greeting onError:&error];
    
    [[GTCommandCenter shared] sendBroadcast:messageData.serializeToBytes
                                      toGID:[GIDManager shoutGID]
                                 onResponse:onResponse
                                    onError:onError];
}

- (IBAction)sendDisconnect:(id)sender {
    [[GTPairingManager shared] initiateDisconnect];
}

- (IBAction)updateFirmware:(id)sender {
    
    id<GTFirmwareRetrieveProtocol> retriever = [GTFirmwareRetrieverFactory firmwareRetrieverAmazon];
    
    [[GTFirmwareDownloadTaskManager manager] retrieveAndStoreFirmwareUsingRetriever:retriever onCompletion:^{
        
        [[GTFirmwareDownloadTaskManager manager] downloadLastRetrievedFirmwareWithProgressDelegate:self];
    }];
}

- (NSString *)parseURLForTitle:(NSString *)urlString {
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    return [array lastObject];
}

- (void)initializeComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.firmwareStatusLabel.text = @"INITIALIZE COMPLETE";
    });
}
- (void)finalizeComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.firmwareStatusLabel.text = @"FINALIZE COMPLETE";
    });
}
- (void)newProgressAmount:(float)progress {
    
    NSLog(@"Progress: %.3f%%",progress * 100.0f);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.firmwareStatusLabel.text = [NSString stringWithFormat:@"DOWNLOADING ~ %.3f%%",(progress * 100.0f)];
    });
}
- (void)updateComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.firmwareStatusLabel.text = @"UPDATE COMPLETE";
        [self.firmwareStatusLabel performSelector:@selector(setText:) withObject:@"" afterDelay:3.0f];
        self.view.userInteractionEnabled = YES;
    });
}
- (void)updateFailed {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.firmwareStatusLabel.text = @"UPDATE FAILED";
        self.view.userInteractionEnabled = YES;
    });
}
- (void)updateInitialized {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.firmwareStatusLabel.text = @"UPDATE INITIALIZING ..";
        self.view.userInteractionEnabled = NO;
    });
}

#pragma mark - NAVIGATION

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Person *person1 = [[Person alloc] initWithName:@"Alice" gid:@123456789];
    Person *person2 = [[Person alloc] initWithName:@"Bob" gid:@987654321];
    Person *person3 = [[Person alloc] initWithName:@"Carol" gid:@1123581321];
    
    NSNumber *senderGID = [UserDataStore shared].currentUser.gId;
    
    NSPredicate *removeSenderGIDFilter = [NSPredicate predicateWithFormat:@"SELF.gid != %@",senderGID];
    
    NSArray<Person*> *members = [@[person1,person2,person3] filteredArrayUsingPredicate:removeSenderGIDFilter];
    
    
    if ([segue.identifier isEqualToString:@"group"]) {
        
        GroupViewController *gvc = (GroupViewController*)[segue destinationViewController];
        gvc.isEncryptionOn = self.isEncryptionOn;
        gvc.groupCreatorGID = senderGID;
        gvc.otherGroupMembers = members;
    }
}

@end
