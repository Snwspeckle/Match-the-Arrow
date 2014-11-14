//
//  GameScene.m
//  Match the Arrow
//
//  Created by Anthony on 9/15/14.
//  Copyright (c) 2014 Anthony Vella. All rights reserved.
//

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GameScene.h"
#import "GameKitHelper.h"
#import "GameViewController.h"
#import "SceneManager.h"

@interface GameScene ()

@property (strong, nonatomic) NSNumber *randomArrowToSwipeRotation;
@property (strong, nonatomic) NSNumber *randomArrowToMatchRotation;

@property (strong, nonatomic) SKLabelNode *scoreLabel;

@property (strong, nonatomic) SKSpriteNode *arrowToSwipeSprite;
@property (strong, nonatomic) SKSpriteNode *arrowToMatchSprite;

@property (strong, nonatomic) UISwipeGestureRecognizer *leftRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightRecognizer;

@property (strong, nonatomic) SceneManager *sharedSceneManager;
@property (strong, nonatomic) GameKitHelper *gameKitHelper;

@property (strong, nonatomic) SKEmitterNode *backgroundParticles;

@property (strong, nonatomic) SKAction *swipeSound;

@end

int gameScore;
float arrowToSwipeSpriteDuration;

static const uint8_t arrowSwipeCategory = 1;
static const uint8_t arrowMatchCategory = 2;

@implementation GameScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.sharedSceneManager = [SceneManager sharedSceneManager];
        self.gameKitHelper = [[GameKitHelper alloc] init];
        self.swipeSound = [SKAction playSoundFileNamed:@"swoosh.mp3" waitForCompletion:NO];
        
        self.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:235.0/255.0 blue:148.0/255.0 alpha:1.0];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        self.physicsBody.dynamic = YES;
        
        self.backgroundParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MatchParticle" ofType:@"sks"]];
        self.backgroundParticles.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        self.scoreLabel = [SceneManager createSKLabelNodeWithMenloFont];
        
        self.scoreLabel.fontSize = 50;
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        self.scoreLabel.position = CGPointMake(CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) - 60);
        
        [self setupGestureRecognizers];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Game Scene"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [SceneManager cleanupScene:self];
    
    arrowToSwipeSpriteDuration = 1.90;
    gameScore = 0;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", gameScore];
    
    self.scoreLabel.zPosition = 2.0;
    
    [self addChild:self.backgroundParticles];
    
    [self addChild:self.scoreLabel];
    
    SKAction *wait = [SKAction waitForDuration:1.3];
    SKAction *performSelector = [SKAction performSelector:@selector(showArrowToSwipe) onTarget:self];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[performSelector, wait]]]];
    
    [self.view addGestureRecognizer:self.leftRecognizer];
    [self.view addGestureRecognizer:self.rightRecognizer];
    
    [self showArrowToMatch];
}

- (void)validateGesture:(UISwipeGestureRecognizer *)sender
{
    [self runAction:self.swipeSound];
    
    float arrowRotationAngle;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if ([self.arrowToSwipeSprite.name isEqualToString:@"UP"]) {
            arrowRotationAngle = M_PI_2;
            self.arrowToSwipeSprite.name = @"LEFT";
        } else if ([self.arrowToSwipeSprite.name isEqualToString:@"LEFT"]) {
            arrowRotationAngle = M_PI;
            self.arrowToSwipeSprite.name = @"DOWN";
        } else if ([self.arrowToSwipeSprite.name isEqualToString:@"DOWN"]) {
            arrowRotationAngle = M_PI_2;
            self.arrowToSwipeSprite.name = @"LEFT";
        } else if ([self.arrowToSwipeSprite.name isEqualToString:@"RIGHT"]) {
            arrowRotationAngle = 0.001f;
            self.arrowToSwipeSprite.name = @"UP";
        }
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if ([self.arrowToSwipeSprite.name isEqualToString:@"UP"]) {
            arrowRotationAngle = (3 * M_PI) / 2;
            self.arrowToSwipeSprite.name = @"RIGHT";
        } else if ([self.arrowToSwipeSprite.name isEqualToString:@"RIGHT"]) {
            arrowRotationAngle = M_PI;
            self.arrowToSwipeSprite.name = @"DOWN";
        } else if ([self.arrowToSwipeSprite.name isEqualToString:@"DOWN"]) {
            arrowRotationAngle = (3 * M_PI) / 2;
            self.arrowToSwipeSprite.name = @"RIGHT";
        } else if ([self.arrowToSwipeSprite.name isEqualToString:@"LEFT"]) {
            arrowRotationAngle = 0.001f;
            self.arrowToSwipeSprite.name = @"UP";
        }
    }
    
    SKAction *rotateArrow = [SKAction rotateToAngle:arrowRotationAngle duration:0.10 shortestUnitArc:YES];
    [self.arrowToSwipeSprite runAction:rotateArrow];
}

- (void)showArrowToSwipe
{
    self.randomArrowToSwipeRotation = [self getRandomAngleFromArray];
    
    self.arrowToSwipeSprite = [self getArrowSpriteNodeWithImage];
    
    self.arrowToSwipeSprite.name = [self getArrowSpriteName:self.randomArrowToSwipeRotation];
    
    SKAction *rotateArrow = [self rotateToAngle:self.randomArrowToSwipeRotation];
    [self.arrowToSwipeSprite runAction:rotateArrow];
    
    self.arrowToSwipeSprite.position = CGPointMake(self.size.width / 2, self.size.height - (self.arrowToSwipeSprite.frame.size.height / 2) + 155);
    
    [self setPhysicsBodyProperties:self.arrowToSwipeSprite categoryBitMask:arrowSwipeCategory contactTestBitMask:arrowMatchCategory];
    
    if (arrowToSwipeSpriteDuration > 1.30) {
        arrowToSwipeSpriteDuration -= 0.01;
    }
        
    SKAction *moveArrow = [SKAction moveByX:0 y:-self.size.height duration:arrowToSwipeSpriteDuration];
    [self.arrowToSwipeSprite runAction:[SKAction repeatActionForever:moveArrow]];
    
    [self addChild:self.arrowToSwipeSprite];
}

- (void)showArrowToMatch
{
    self.randomArrowToMatchRotation = [self getRandomAngleFromArray];
    
    self.arrowToMatchSprite = [self getArrowSpriteNodeWithImage];
    
    self.arrowToMatchSprite.name = [self getArrowSpriteName:self.randomArrowToMatchRotation];
    
    SKAction *rotateArrow = [self rotateToAngle:self.randomArrowToMatchRotation];
    [self.arrowToMatchSprite runAction:rotateArrow];
    
    self.arrowToMatchSprite.position = CGPointMake(-85, 120);
    
    [self setPhysicsBodyProperties:self.arrowToMatchSprite categoryBitMask:arrowMatchCategory contactTestBitMask:arrowSwipeCategory];
    
    SKAction *moveArrow = [SKAction moveByX:(self.size.width / 2) + 85 y:0 duration:0.25];
    [self.arrowToMatchSprite runAction:moveArrow];
    
    [self addChild:self.arrowToMatchSprite];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.node.name == contact.bodyB.node.name) {
        if (contact.bodyA.node.position.y == 120) {
            SKAction *moveArrow = [SKAction moveByX:self.size.width y:0 duration:0.3];
            SKAction *fadeArrow = [SKAction fadeOutWithDuration:0.15];
            
            [contact.bodyA.node runAction:moveArrow];
            [contact.bodyB.node runAction:fadeArrow];
        } else {
            SKAction *moveArrow = [SKAction moveByX:self.size.width y:0 duration:0.3];
            SKAction *fadeArrow = [SKAction fadeOutWithDuration:0.15];
            
            [contact.bodyB.node runAction:moveArrow];
            [contact.bodyA.node runAction:fadeArrow];
        }
        [self updateScore];
        [self showArrowToMatch];
    } else {
        if (contact.bodyA.node.position.y == 120) {
            SKAction *moveArrow = [SKAction moveByX:self.size.width y:0 duration:0.3];
            SKAction *fadeArrow = [SKAction fadeOutWithDuration:0.15];
            
            [contact.bodyA.node runAction:moveArrow];
            [contact.bodyB.node runAction:fadeArrow];
        } else {
            SKAction *moveArrow = [SKAction moveByX:self.size.width y:0 duration:0.3];
            SKAction *fadeArrow = [SKAction fadeOutWithDuration:0.15];
            
            [contact.bodyB.node runAction:moveArrow];
            [contact.bodyA.node runAction:fadeArrow];
        }
        SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
        reveal.pausesIncomingScene = YES;
        [self.gameKitHelper reportScore:gameScore];
        
        self.sharedSceneManager.menuScene.gameScore = gameScore;
        self.sharedSceneManager.menuScene.isShowingGameOver = YES;
        [self.sharedSceneManager.menuScene showGameOver];
        [self.scene.view presentScene:self.sharedSceneManager.menuScene transition:reveal];
    }
    contact.bodyA.node.physicsBody = nil;
    contact.bodyB.node.physicsBody =  nil;
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

- (void)updateScore
{
    gameScore++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", gameScore];
}

- (NSNumber *)getRandomAngleFromArray
{
    int arrowRotationIndex = arc4random() % [self.sharedSceneManager getPossibleArrowRotationArray].count;
    return [[self.sharedSceneManager getPossibleArrowRotationArray] objectAtIndex:arrowRotationIndex];
}

- (void)setPhysicsBodyProperties:(SKSpriteNode *)spriteNode categoryBitMask:(uint8_t)category contactTestBitMask:(uint8_t)contact
{
    spriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteNode.frame.size];
    spriteNode.physicsBody.dynamic = YES;
    spriteNode.physicsBody.categoryBitMask = category;
    spriteNode.physicsBody.contactTestBitMask = contact;
    spriteNode.physicsBody.collisionBitMask = 0;
}

- (SKSpriteNode *)getArrowSpriteNodeWithImage
{
    return [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
}

- (SKAction *)rotateToAngle:(NSNumber *)angle
{
    return [SKAction rotateToAngle:[angle floatValue] duration:0];
}

- (NSString *)getArrowSpriteName:(NSNumber *)rotationAngle
{
    if ([rotationAngle floatValue] == 0.001f) {
        return @"UP";
    } else if ([rotationAngle floatValue] == (float) (3 * M_PI) / 2) {
        return @"RIGHT";
    } else if ([rotationAngle floatValue] == (float) M_PI) {
        return @"DOWN";
    } else if ([rotationAngle floatValue] == (float) M_PI_2) {
        return @"LEFT";
    } else {
        return nil;
    }
}

- (void)setupGestureRecognizers
{
    self.leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(validateGesture:)];
    self.rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(validateGesture:)];
    
    self.leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
}

@end
