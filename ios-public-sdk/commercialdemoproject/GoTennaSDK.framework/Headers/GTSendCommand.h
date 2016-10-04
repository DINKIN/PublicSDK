//
//  GTSendCommand.h
//  GoTenna
//
//  Created by JOSHUA M MAKINDA on 3/14/16.
//  Copyright © 2016 goTenna. All rights reserved.
//

#import "GTCommand.h"

@interface GTSendCommand : GTCommand


/**
 *  Command to be sent to the goTenna that is specifically used for messages. Inherits from `GTCommand`
 */

- (instancetype)initWithOutgoingData:(NSData*)outgoingData SenderGID:(NSNumber*)senderGID recipientGID:(NSNumber*)recipientGID willEncrypt:(BOOL)willEncrypt;

@property (nonatomic, readonly) NSData *outgoingData;
@property (nonatomic, readonly) NSNumber *senderGID;
@property (nonatomic, readonly) NSNumber *recipientGID;
@property (nonatomic, readonly) BOOL willEncrypt;

@end
