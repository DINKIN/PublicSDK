//
//  TLVTypes.h
//  GoTennaSDK
//
//  Created by JOSHUA M MAKINDA on 9/30/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const TLV_TYPE_MESSAGE_TYPE;
extern int const  TLV_TYPE_SENDER_INITIALS;
extern int const  TLV_TYPE_TEXT;
extern int const  TLV_TYPE_RECEIVING_GID;
extern int const  TLV_TYPE_LOCATION_MESSAGE_DATA;

// LocationMessageData
extern int const  TLV_TYPE_LOCATION_NAME;
extern int const  TLV_TYPE_LOCATION_LATITUDE;
extern int const  TLV_TYPE_LOCATION_LONGITUDE;
extern int const  TLV_TYPE_LOCATION_TYPE;

// GroupCreationMessageData
extern int const  TLV_TYPE_GROUP_GID;
extern int const  TLV_TYPE_GROUP_MEMBER_LIST;
extern int const  TLV_TYPE_GROUP_SHARED_SECRET;


// For File Transfer
extern int const  TLV_TYPE_FILE_TRANSFER_NAME;
extern int const  TLV_TYPE_FILE_TRANSFER_SIZE;
extern int const  TLV_TYPE_FILE_TRANSFER_UUID;
extern int const  TLV_TYPE_FILE_TRANSFER_STATUS;
extern int const  TLV_TYPE_FILE_TRANSFER_DATA;

extern int const  TLV_TYPE_LOCATION_GPS_TIMESTAMP;

// For extended TLV sections
extern int const  TLV_TYPE_ENCRYPTION_INFO;

// For Public Key Exchange
extern int const  TLV_TYPE_PUBLIC_KEY_DATA;

extern int const  TLV_TYPE_EXTENDER_JACKET_2B;
extern int const  TLV_TYPE_EXTENDER_JACKET_3B;
extern int const  TLV_TYPE_EXTENDER_JACKET_4B;


@interface TLVTypes : NSObject
@end

