//
//  GameKitHelper.h
//  Match the Arrow
//
//  Created by Anthony on 9/21/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

@import GameKit;

extern NSString *const ShowGCAuthenticationViewController;

@interface GameKitHelper : NSObject

@property (strong, nonatomic) UIViewController *authenticationViewController;

- (void)authenticateLocalPlayer;
- (void)reportScore:(int)gameScore;

+ (instancetype)sharedGameKitHelper;

@end