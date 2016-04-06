//
//  GroupViewController.h
//  SDKTestingStuff
//
//  Created by JOSHUA M MAKINDA on 3/16/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Person;

@interface GroupViewController : UIViewController

@property (nonatomic) BOOL isEncryptionOn;
@property (nonatomic, strong) NSNumber *groupCreatorGID;
@property (nonatomic, strong) NSArray<Person*> *otherGroupMembers;
@end
