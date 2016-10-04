//
//  GTDecryptionErrorManager.h
//  GoTenna
//
//  Created by Thomas Colligan on 2/16/16.
//  Copyright © 2016 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTDecryptionErrorItem.h"

/**
 * When a decryption error occurs, we save the message info in here so that we can try to decrypt it later
 * when we receive a new public key from another user.
 */
@interface GTDecryptionErrorManager : NSObject

@property (nonatomic, strong) NSMutableSet *decryptionErrorItems;

/**
 *  Returns a shared instance
 *
 *  @return shared instance to be used
 */
+ (instancetype)shared;

/**
 *  Add `GTDecryptionErrorItem` objects to be later decrypted. NOTE: automatically added by the `GTDataSerializer`
 *
 *  @param decryptionErrorItem decryption error item holds references to the information about the message previously attempted
 */
- (void)addDecryptionErrorItem:(GTDecryptionErrorItem *)decryptionErrorItem;

/**
 *  Attempts to decrypt stored `GTDecryptionErrorItem` objects
 */
- (void)attemptToDecryptMessagesAgain;

@end
