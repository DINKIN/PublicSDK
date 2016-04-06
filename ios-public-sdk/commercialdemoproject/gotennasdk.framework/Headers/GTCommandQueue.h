//
// Created by Julietta Yaunches on 5/06/2014.
// Copyright (c) 2014 goTenna. All rights reserved.
//


#import <Foundation/Foundation.h>

@class GTPacketPreparer;
@class GTPacket;
@class GTCommand;
@class GTCommandArray;


/**
 *  Holds queued `GTCommand` objects to be executed
 */
@interface GTCommandQueue : NSObject
@property(nonatomic, strong) GTCommand *currentCommand;

- (void)queueGTCommand:(GTCommand *)command;
- (void)queueGTCommands:(GTCommandArray *)incomingCommands;
- (void)nudgeToNextCommand;
- (void)empty;
- (NSArray *)remainingCommands;
- (void)pauseQueue;

- (void)executeUpcomingCommand;

@end