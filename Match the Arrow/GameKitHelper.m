//
//  GameKitHelper.m
//  Match the Arrow
//
//  Created by Anthony on 9/21/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

#import "GameKitHelper.h"

NSString *const ShowGCAuthenticationViewController = @"show_gc_authentication_view_controller";

@implementation GameKitHelper
{
    BOOL gameCenterEnabled;
}

+ (instancetype)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        gameCenterEnabled = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if ([GKLocalPlayer localPlayer].authenticated) {
            gameCenterEnabled = YES;
        } else {
            gameCenterEnabled = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    _authenticationViewController = authenticationViewController;
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowGCAuthenticationViewController object:self];
}

- (void)reportScore:(int)gameScore
{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"High_Score_Leaderboard"];
    score.value = gameScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end
