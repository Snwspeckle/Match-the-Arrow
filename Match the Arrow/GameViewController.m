//
//  GameViewController.m
//  Match the Arrow
//
//  Created by Anthony on 9/15/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

@import iAd;

#import "GameViewController.h"
#import "MenuScene.h"
#import "GameKitHelper.h"
#import "SceneManager.h"

@interface GameViewController ()

@property (strong, nonatomic) SKView *gameView;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    self.gameView = (SKView *)self.view;
    
    #if DEBUG
        self.gameView.showsFPS = YES;
        self.gameView.showsNodeCount = YES;
    #endif
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.gameView.ignoresSiblingOrder = YES;
    
    self.canDisplayBannerAds = YES;
    
    SceneManager *sharedSceneManager = [SceneManager sharedSceneManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:ShowGCAuthenticationViewController object:nil];
    
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
    // Present the scene.
    [self.gameView presentScene:sharedSceneManager.menuScene];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [self presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
