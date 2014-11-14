//
//  MenuScene.m
//  Match the Arrow
//
//  Created by Anthony on 9/17/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "MenuScene.h"
#import "SceneManager.h"

@interface MenuScene ()

@property (strong, nonatomic) SceneManager *sharedSceneManager;

@property (strong, nonatomic) SKLabelNode *titleLabel;
@property (strong, nonatomic) SKLabelNode *pointScoreLabel;
@property (strong, nonatomic) SKLabelNode *pointBestScoreLabel;

@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *bestScoreLabel;

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@property (strong, nonatomic) SKEmitterNode *backgroundParticles;

@end

@implementation MenuScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.sharedSceneManager = [SceneManager sharedSceneManager];
        
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (![self.userDefaults objectForKey:@"pointsBest"]) {
            [self.userDefaults setInteger:0 forKey:@"pointsBest"];
            [self.userDefaults synchronize];
        }
        
        self.backgroundParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MatchParticle" ofType:@"sks"]];
        self.backgroundParticles.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        self.isShowingGameOver = NO;
        
        self.titleLabel = [SceneManager createSKLabelNodeWithMenloBoldFont];
        self.scoreLabel = [SceneManager createSKLabelNodeWithMenloFont];
        self.bestScoreLabel = [SceneManager createSKLabelNodeWithMenloFont];
        
        self.pointScoreLabel = [SceneManager createSKLabelNodeWithMenloBoldFont];
        self.pointBestScoreLabel = [SceneManager createSKLabelNodeWithMenloBoldFont];
        
        self.titleLabel.alpha = 0.0;
        self.scoreLabel.alpha = 0.0;
        self.bestScoreLabel.alpha = 0.0;
        
        self.pointScoreLabel.alpha = 0.0;
        self.pointBestScoreLabel.alpha = 0.0;
        
        self.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:235.0/255.0 blue:148.0/255.0 alpha:1.0];
        
        if (self.frame.size.width == 320) {
            // Device is iPhone 4S
            self.titleLabel.fontSize = 25;
            self.pointScoreLabel.fontSize = 13;
        } else if (self.frame.size.width == 375) {
            // Device is iPhone 5
            self.titleLabel.fontSize = 35;
            self.pointScoreLabel.fontSize = 15;
        } else if (self.frame.size.width == 414) {
            self.titleLabel.fontSize = 40;
            self.pointScoreLabel.fontSize = 15;
        } else {
            self.titleLabel.fontSize = 40;
            self.pointScoreLabel.fontSize = 20;
        }
        
        self.titleLabel.text = @"Match the Arrow";
        self.titleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMidY(self.frame) + 100);
        
        self.scoreLabel.text = @"Score";
        self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 90,
                                               CGRectGetMidY(self.frame) + 120);
        
        self.bestScoreLabel.text = @"Best";
        self.bestScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 90,
                                                   CGRectGetMidY(self.frame) + 120);
        
        self.pointScoreLabel.text = @"Swipe left or right to rotate arrows";
        self.pointScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                                    CGRectGetMidY(self.frame) + 70);
        
        self.pointBestScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 90,
                                                    CGRectGetMidY(self.frame) + 45);
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    if (self.isShowingGameOver) {
        [tracker set:kGAIScreenName value:@"Game Over Scene"];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"points" action:@"gameover-report" label:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:self.gameScore]] value:[NSNumber numberWithInt:self.gameScore]] build]];
        self.isShowingGameOver = NO;
    } else {
        [tracker set:kGAIScreenName value:@"Menu Scene"];
    }
    
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
    [SceneManager cleanupScene:self];
    
    [self addChild:self.backgroundParticles];
    
    [self addChild:self.titleLabel];
    [self addChild:self.scoreLabel];
    [self addChild:self.bestScoreLabel];
    
    [self addChild:self.pointScoreLabel];
    [self addChild:self.pointBestScoreLabel];
    
    SKAction *fadeInText = [SKAction fadeInWithDuration:0.75];
    [self.titleLabel runAction:fadeInText];
    [self.pointScoreLabel runAction:fadeInText];
    
    self.playButton.zPosition = 2.0;
    self.leaderboardButton.zPosition = 2.0;
    self.rateButton.zPosition = 2.0;
    
    [self addChild:self.playButton];
    [self addChild:self.leaderboardButton];
    [self addChild:self.rateButton];
    
    // In-App Purchases Temporairly Disabled
    // [self addChild:self.removeAdsButton];
}

- (void)showGameOver
{
    self.titleLabel.text = @"GAME OVER";
    
    if (self.frame.size.width == 320) {
        // Device is iPhone 4S
        self.titleLabel.fontSize = 40;
        self.pointScoreLabel.fontSize = 60;
        self.pointBestScoreLabel.fontSize = 60;
    } else {
        self.titleLabel.fontSize = 45;
        self.pointScoreLabel.fontSize = 70;
        self.pointBestScoreLabel.fontSize = 70;
    }
    
    if (self.gameScore > [[self.userDefaults objectForKey:@"pointsBest"] integerValue]) {
        [self.userDefaults setInteger:self.gameScore forKey:@"pointsBest"];
        [self.userDefaults synchronize];
    }
    
    self.titleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                              CGRectGetMidY(self.frame) + 190);
    
    self.pointScoreLabel.text = [NSString stringWithFormat:@"%d", self.gameScore];
    self.pointScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 90,
                                               CGRectGetMidY(self.frame) + 45);
    
    self.pointBestScoreLabel.text = [NSString stringWithFormat:@"%@", [self.userDefaults objectForKey:@"pointsBest"]];
    
    self.scoreLabel.alpha = 1.0;
    self.bestScoreLabel.alpha = 1.0;
    self.pointBestScoreLabel.alpha = 1.0;
}

/**
 Presents the gameScene
 */
- (void)playButtonAction
{
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    reveal.pausesIncomingScene = YES;
    [self.scene.view presentScene:[SceneManager sharedSceneManager].gameScene transition:reveal];
}

/**
 Presents the GameCenter High_Score_Leaderboard
 */
- (void)leaderboardButtonAction
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"button" action:@"leaderboard-press" label:@"Leaderboard" value:nil] build]];
    
    UIViewController *rootViewController = self.view.window.rootViewController;
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.gameCenterDelegate = self;
    
    gameCenterViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gameCenterViewController.leaderboardIdentifier = @"High_Score_Leaderboard";
    [rootViewController presentViewController:gameCenterViewController animated:YES completion:nil];
}

/**
 Presents the AppStore
 */
- (void)rateButtonAction
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"button" action:@"rate-press" label:@"Rate" value:nil] build]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id921397107"]];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
