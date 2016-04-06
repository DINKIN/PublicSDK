//
//  AppDelegate.m
//  ConsumerDemoProject
//
//  Created by JOSHUA M MAKINDA on 3/23/16.
//  Copyright © 2016 JOSHUA M MAKINDA. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"http://dev2.apppartner.com/goTenna/scripts/SdkTokenValidator.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReturnCacheDataDontLoad
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = @{@"sdk_token":@"i6i61v4k4hehip3q6q06bu6gas91asa5"};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSLog(@"MAP DATA: %@",mapData);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *err = nil;
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
        
        NSLog(@"POST REQUEST => %@\n",response);
        
        if (res.statusCode == 200 && error == nil) {
            
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            NSNumber *validToken = [jsonDictionary objectForKey:@"isValidToken"];
            
            NSLog(@"JSON DICT: %@",jsonDictionary);
            NSLog(@"IS VERIFIED APP ID TOKEN??? %@",[validToken boolValue] ? @"YES" : @"NO");
            
            //[weakSelf setIsVerified:validToken.boolValue];
        }
    }];
    
    [postDataTask resume];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
