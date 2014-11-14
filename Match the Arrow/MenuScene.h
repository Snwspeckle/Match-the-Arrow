//
//  MenuScene.h
//  Match the Arrow
//
//  Created by Anthony on 9/21/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

@import GameKit;

#import <SpriteKit/SpriteKit.h>
#import "AGSpriteButton.h"

@interface MenuScene : SKScene <GKGameCenterControllerDelegate>

@property (strong, nonatomic) AGSpriteButton *playButton;
@property (strong, nonatomic) AGSpriteButton *leaderboardButton;
@property (strong, nonatomic) AGSpriteButton *rateButton;
@property (strong, nonatomic) AGSpriteButton *removeAdsButton;

@property (assign, nonatomic) int gameScore;

@property (assign, nonatomic) BOOL isShowingGameOver;

- (void)showGameOver;
- (void)playButtonAction;
- (void)leaderboardButtonAction;
- (void)rateButtonAction;

@end
