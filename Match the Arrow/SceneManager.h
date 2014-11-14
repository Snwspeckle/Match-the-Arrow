//
//  SceneManager.h
//  Match the Arrow
//
//  Created by Anthony on 9/23/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "MenuScene.h"

@interface SceneManager : NSObject

@property (strong, nonatomic) GameScene     *gameScene;
@property (strong, nonatomic) MenuScene     *menuScene;

+ (SceneManager *)sharedSceneManager;
- (void)instantiateScenes:(CGRect)frame;
+ (SKLabelNode *)createSKLabelNodeWithMenloFont;
+ (SKLabelNode *)createSKLabelNodeWithMenloBoldFont;
- (NSMutableArray *)getPossibleArrowRotationArray;
- (void)createMenuSpriteButtons:(CGRect)frame;
+ (void)cleanupScene:(SKScene *)scene;

@end
