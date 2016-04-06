//
//  GTMessageResponseProcessor.h
//  GoTenna
//
//  Created by Julietta Yaunches on 1/8/15.
//  Copyright (c) 2015 goTenna. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTResponse;
@class SystemInfoResponseData;
@class GTMessageData;
@class GTGroupCreationMessageData;
@protocol GTMessageDataProtocol;
@class GTCommand;
@class GTBaseMessageData;
@class PacketVerifier;


/**
 *  Serialization of data. NOTE: this is used internally, and automatically functions for messaging processess
 */
@interface GTDataSerializer : NSObject

/**
 *  Used for unpacking data for a group communication scenario, extraction includes encryption shared secret and group GID. NOTE: handled internally by the `GTDataSerializer`
 *
 *  @param data message data object, if related to group activities will be unpacked
 *
 *  @return returns non-nil object if data coming in was relevant
 */
+ (GTGroupCreationMessageData *)deserializeGroupMessageDataObj:(GTMessageData *)data;

/**
 *  Called to unpack a response from the goTenna, holding system information
 *
 *  @param response goTenna information filled response object
 *
 *  @return system info object that holds information about the goTenna
 */
+ (SystemInfoResponseData *)deserializeSystemInfo:(GTResponse *)response;

/**
 *  Called when building a response object to be used for retrieve information after a command message is received
 *
 *  @param data    message data serialized
 *  @param command command object relating to the message data
 *
 *  @return response object holding information for the
 */
+ (GTResponse *)deserializeMessage:(NSData *)data forCommand:(GTCommand *)command;

/**
 *  Returns the app token data that was passed in for use of the SDK
 *
 *  @return app token as data
 */
+ (NSData *)appTokenData;

/**
 *  Parses all relevant content for an incoming message
 *
 *  @param response               response object used for the incoming message
 *  @param onIncomingMessage      registered `onIncoming` response block for the message
 *  @param onGroupAdded           registered `onGroupAdded` response block for the message
 *  @param lastMessageDelete      `lastMessageDelete` block used within the `GTCommandBuilder`
 *  @param isDecryptionErrorRetry whether this is to be retried for a decryption error
 *
 *  @return returns back whether success was possible with this parsing
 */
+ (BOOL)parseAndHandleGetMessageResponse:(GTResponse *)response
                               onIncoming:(void (^)(GTMessageData *))onIncomingMessage
                           onGroupCreated:(void (^)(GTGroupCreationMessageData *))onGroupAdded
               onSuccessLastMessageDelete:(void (^)())lastMessageDelete
                   isDecryptionErrorRetry:(BOOL)isDecryptionErrorRetry;
@end
