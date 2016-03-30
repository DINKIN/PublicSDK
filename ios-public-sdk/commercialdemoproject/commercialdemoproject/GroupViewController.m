//
//  GroupViewController.m
//  SDKTestingStuff
//
//  Created by JOSHUA M MAKINDA on 3/16/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import <GoTennaSDK/GoTennaSDK.h>
#import "GroupViewController.h"
#import "Person.h"
#import "MainDeckViewController.h"

@interface GroupViewController ()
@property (weak, nonatomic) IBOutlet UILabel *memberGIDLabel1;
@property (weak, nonatomic) IBOutlet UILabel *memberStatusLabel1;
@property (weak, nonatomic) IBOutlet UILabel *memberGIDLabel2;
@property (weak, nonatomic) IBOutlet UILabel *memberStatusLabel2;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *resend1Button;
@property (weak, nonatomic) IBOutlet UIButton *resend2Button;

@property (nonatomic, strong) NSDictionary<NSNumber*,UILabel*> *gidToGIDLabel;
@property (nonatomic, strong) NSDictionary<NSNumber*,UIButton*> *gidToResendButton;

@property (nonatomic) NSUInteger verifiedMemberCount;
@property (nonatomic) BOOL aMemberHasBeenFoundAvailable;

@property (nonatomic, strong) NSNumber *groupGID;

@property (nonatomic, strong) NSString *greeting;
@end

NSString *statusLooking = @"Searching...";
NSString *statusFound = @"Found";
NSString *statusNotFound = @"Not Found";

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.greeting = @"Hello Universe";
    
    [self hidePostButton];
    self.resend1Button.hidden = YES;
    self.resend2Button.hidden = YES;
    
    self.verifiedMemberCount = 0;
    self.aMemberHasBeenFoundAvailable = NO;
    
    Person *person1 = self.otherGroupMembers.firstObject;
    Person *person2 = self.otherGroupMembers.lastObject;
    
    self.memberGIDLabel1.text = [person1.gid stringValue];
    self.memberGIDLabel2.text = [person2.gid stringValue];
    
    self.gidToGIDLabel = @{
                           person1.gid:self.memberStatusLabel1,
                           person2.gid:self.memberStatusLabel2
                           };
    self.gidToResendButton = @{
                               person1.gid:self.resend1Button,
                               person2.gid:self.resend2Button
                               };
    
    
    //all gids filtered from the Person objects
    NSArray<NSNumber*> *memberGIDs = [self.otherGroupMembers valueForKey:@"gid"];
    
    self.groupGID = [[GTCommandCenter shared] createGroupWithGIDs:memberGIDs encrypt:self.isEncryptionOn
                                 onMemberResponse:^(GTResponse *response, NSNumber *memberGID) {
                                     
                                     if (response.responseCode == GTResponsePositive) {
                                         [self markMemberVerifiedForGID:memberGID verified:YES];
                                     }
                                     else {
                                         [self markMemberVerifiedForGID:memberGID verified:NO];
                                     }
    } fromGID:self.groupCreatorGID onError:^(NSError *error, NSNumber *memberGID) {
        
        [self markMemberVerifiedForGID:memberGID verified:NO];
    }];
    
    self.memberStatusLabel1.text = statusLooking;
    self.memberStatusLabel2.text = statusLooking;
}

#pragma mark - MEMBER VERIFICATION METHOD

- (void)markMemberVerifiedForGID:(NSNumber*)gid verified:(BOOL)verified {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel *status = self.gidToGIDLabel[gid];
        
        if (verified) {
            status.text = statusFound;
            status.textColor = [UIColor greenColor];
            self.aMemberHasBeenFoundAvailable = YES;
        }
        else {
            status.text = statusNotFound;
            status.textColor = [UIColor lightGrayColor];
            UIButton *resend = self.gidToResendButton[gid];
            resend.hidden = NO;
        }
        
        self.verifiedMemberCount += 1;
        
        if ((self.verifiedMemberCount >= self.otherGroupMembers.count) && (self.aMemberHasBeenFoundAvailable == YES)) {
            
            [self showPostButton];
        }
    });
}

#pragma mark - ACTIONS

- (IBAction)postGroupMessage:(id)sender {
    
    if (self.groupGID) {
        
        void(^onResponse)(GTResponse* res) = ^(GTResponse* res){};
        void(^onError)(NSError*) = ^(NSError* err){ showAlert(self, @"Error", err.description, @"OK"); };
        
        NSError *error = nil;
        
        GTTextOnlyMessageData *messageData = [[GTTextOnlyMessageData alloc] initOutgoingWithText:self.greeting onError:&error];
        
        [[GTCommandCenter shared] sendMessage:messageData.serializeToBytes
                                      encrypt:self.isEncryptionOn
                                        toGID:self.groupGID
                                      fromGID:[UserDataStore shared].currentUser.gId
                                   onResponse:onResponse
                                      onError:onError];
    }
}

- (IBAction)resendGID1:(id)sender {
    
    self.memberStatusLabel1.text = statusLooking;
    self.memberStatusLabel1.textColor = [UIColor blackColor];
    
    Person *person = self.otherGroupMembers.firstObject;
    [self resendAvailabilityRequestToGID:person.gid];
    
    UIButton *resend = self.gidToResendButton[person.gid];
    resend.hidden = YES;
}

- (IBAction)resentGID2:(id)sender {
    
    self.memberStatusLabel2.text = statusLooking;
    self.memberStatusLabel2.textColor = [UIColor blackColor];
    
    Person *person = self.otherGroupMembers.lastObject;
    [self resendAvailabilityRequestToGID:person.gid];
    
    UIButton *resend = self.gidToResendButton[person.gid];
    resend.hidden = YES;
}

#pragma mark - RESEND METHOD

- (void)resendAvailabilityRequestToGID:(NSNumber*)gid {
    
    void(^onResponse)(GTResponse*) =  ^(GTResponse *response) {
        
        if (response.responseCode == GTResponsePositive) {
            [self markMemberVerifiedForGID:gid verified:YES];
        }
        else {
            [self markMemberVerifiedForGID:gid verified:NO];
        }
    };
    
    void(^onError)(NSError*) =  ^(NSError *err) {
        [self markMemberVerifiedForGID:gid verified:NO];
    };
    
    
    NSError *error = nil;
    NSData *sharedSecret = [[GroupSecretManager shared] getSharedSecretForGroup:self.groupGID];
    
    NSArray<NSNumber*> *allMembers = [@[self.groupCreatorGID] arrayByAddingObjectsFromArray:self.otherGroupMembers];
    
    GTGroupCreationMessageData *message = [[GTGroupCreationMessageData alloc] initWithGroupGID:self.groupGID andAddressees:allMembers andSharedSecret:sharedSecret onError:&error];
    
    NSData *combinedMsgData = [message serializeToBytes];
    
    [[GTCommandCenter shared] sendMessage:combinedMsgData
                                  encrypt:self.isEncryptionOn
                                    toGID:gid
                                  fromGID:message.senderGID
                               onResponse:onResponse
                                  onError:onError];
}

#pragma mark - UI HELPERS

- (void)showPostButton {
    self.postButton.enabled = YES;
    self.postButton.alpha = 1.0f;
}

- (void)hidePostButton {
    self.postButton.enabled = NO;
    self.postButton.alpha = 0.35f;
}

@end
