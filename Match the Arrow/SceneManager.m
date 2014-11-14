//
//  SceneManager.m
//  Match the Arrow
//
//  Created by Anthony on 9/23/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

#import "SceneManager.h"

@interface SceneManager ()

@property (strong, nonatomic) NSMutableArray *possibleArrowRotationArray;

@end

@implementation SceneManager

+ (SceneManager *)sharedSceneManager
{
    static SceneManager *sharedSceneManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSceneManager = [[self alloc] init];
    });
    
    return sharedSceneManager;
}

- (void)instantiateScenes:(CGRect)frame
{    
    self.menuScene = [[MenuScene alloc] initWithSize:frame.size];
    
    self.gameScene = [[GameScene alloc] initWithSize:frame.size];
        
    self.possibleArrowRotationArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:0.001f], [NSNumber numberWithFloat:(3 * M_PI) / 2], [NSNumber numberWithFloat:M_PI], [NSNumber numberWithFloat:M_PI_2], nil];
}

- (NSMutableArray *)getPossibleArrowRotationArray
{
    return self.possibleArrowRotationArray;
}

- (void)createMenuSpriteButtons:(CGRect)frame
{
    self.menuScene.playButton = [AGSpriteButton buttonWithColor:[UIColor whiteColor] andSize:CGSizeMake(150, 62.5)];
    [self.menuScene.playButton setLabelWithText:@"Play" andFont:[UIFont fontWithName:@"Menlo" size:17] withColor:[UIColor colorWithRed:144.0/255.0 green:235.0/255.0 blue:148.0/255.0 alpha:1.0]];
    self.menuScene.playButton.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 30);
    [self.menuScene.playButton addTarget:self.menuScene selector:@selector(playButtonAction) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
    
    self.menuScene.leaderboardButton = [AGSpriteButton buttonWithColor:[UIColor whiteColor] andSize:CGSizeMake(150, 62.5)];
    [self.menuScene.leaderboardButton setLabelWithText:@"Leaderboard" andFont:[UIFont fontWithName:@"Menlo" size:17] withColor:[UIColor colorWithRed:144.0/255.0 green:235.0/255.0 blue:148.0/255.0 alpha:1.0]];
    self.menuScene.leaderboardButton.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 100);
    [self.menuScene.leaderboardButton addTarget:self.menuScene selector:@selector(leaderboardButtonAction) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
    
    self.menuScene.rateButton = [AGSpriteButton buttonWithColor:[UIColor whiteColor] andSize:CGSizeMake(150, 62.5)];
    [self.menuScene.rateButton setLabelWithText:@"Rate" andFont:[UIFont fontWithName:@"Menlo" size:17] withColor:[UIColor colorWithRed:144.0/255.0 green:235.0/255.0 blue:148.0/255.0 alpha:1.0]];
    self.menuScene.rateButton.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 170);
    [self.menuScene.rateButton addTarget:self.menuScene selector:@selector(rateButtonAction) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
    
    self.menuScene.removeAdsButton = [AGSpriteButton buttonWithColor:[UIColor colorWithRed:255.0/255.0 green:88.0/255.0 blue:84.0/255.0 alpha:1.0] andSize:CGSizeMake(150, 62.5)];
    [self.menuScene.removeAdsButton setLabelWithText:@"Remove Ads" andFont:[UIFont fontWithName:@"Menlo" size:17] withColor:[UIColor whiteColor]];
    self.menuScene.removeAdsButton.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 200);
    [self.menuScene.removeAdsButton addTarget:self.menuScene selector:@selector(rateButtonAction) withObject:nil forControlEvent:AGButtonControlEventTouchUpInside];
}

+ (SKLabelNode *)createSKLabelNodeWithMenloFont
{
    return [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
}

+ (SKLabelNode *)createSKLabelNodeWithMenloBoldFont
{
    return [SKLabelNode labelNodeWithFontNamed:@"Menlo Bold"];
}

+ (void)cleanupScene:(SKScene *)scene
{
    for (SKNode *node in scene.children) {
        [node removeFromParent];
    }
    [scene removeAllActions];
}

@end
