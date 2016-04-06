#import <Foundation/Foundation.h>
#import "GTDataTypes.h"

@class UserDataStore;
extern NSString const *EMERGENCY_GID;
extern NSString const *SHOUT_GID;

/**
 *  Used for the presentation of, and determining of, GIDs
 */

@interface GIDManager : NSObject

/**
 *  Call this to retrieve the universal shout GID
 *
 *  @return the shout GID as an `NSNumber`
 */
+ (NSNumber *)shoutGID;

/**
 *  Call this to retrieve the universal emergency GID
 *
 *  @return the emergency GID as an `NSNumber`
 */
+ (NSNumber*)emergencyGID;

/**
 *  Call this to determine what `GTGIDType` the GID is
 *
 *  @param number GID as `NSNumber` to be evaluated
 *
 *  @return `GTGIDType` of the GID
 */
+ (GTGIDType)gidTypeForGID:(NSNumber *)number;

/**
 *  Call this to return back a randomly generated GID seeded from the date passed in
 *
 *  @param date uses whichever date passed in as a seed
 *
 *  @return randomly generated GID
 */
- (NSNumber *)personalGIDFromDate:(NSDate *)date;

/**
 *  Call this to return back a randomly generated group GID seeded from the date passed in
 *
 *  @param date uses whichever date passed in as a seed
 *
 *  @return randomly generated group GID
 */
- (NSNumber *)groupGIDFromDate:(NSDate *)date;
@end