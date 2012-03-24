//
//  Ball.m
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#import "Board.h"
#import <math.h>
#import "BallTracer.h"

@interface Ball (Private)
-(void)createBallInWorld:(b2World*)world at:(CGPoint)pos color:(ccColor3B)color;
@end

@implementation Ball {
    BallTracer* ballTracer;
}

@synthesize isInHall;

-(id)initWithWorld:(b2World*)world at:(CGPoint)pos touchable:(BOOL)touchable color:(ccColor3B)color {
    if ((self = [super init])) {
        [self createBallInWorld:world at:pos color:color];
        if (touchable) {
            [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        }
        [self scheduleUpdate];
    }
    return self;
}

+(id)ballWithWorld:(b2World*)world at:(CGPoint)pos touchable:(BOOL)touchable {
    return [[[self alloc] initWithWorld:world at:pos touchable:touchable color:ccWHITE] autorelease];
}

+(id)ballWithWorld:(b2World*)world at:(CGPoint)pos color:(ccColor3B)color {
    return [[[self alloc] initWithWorld:world at:pos touchable:NO color:color] autorelease];
}

-(void)delloc {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super dealloc];
}

+(CGFloat)ballWidth {
    CCSprite* tmpSprite = [CCSprite spriteWithFile:@"ball.png"];
    return tmpSprite.contentSize.width;
}

-(void)resetColor {
    sprite.color = originalColor;
}

static const ccColor3B ccBRAWN = {110,0,0};

+(void)setupBalls:(CCNode*)node world:(b2World*)world {
    CGPoint cp = [Helper screenCenter];
    float bw = [Ball ballWidth];
    float dy = 0.83;
    
    Ball* ball = [Ball ballWithWorld:world at:ccp(cp.x, cp.y - 120) touchable:NO];
    ball.tag = kTagMainBall;
    [node addChild:ball];

    //1列目
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x            ,cp.y + 90) color:ccYELLOW]];
    //2列目
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x - bw*0.5   ,cp.y + 90 + (bw * dy)) color:ccGREEN]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x + bw*0.5   ,cp.y + 90 + (bw * dy)) color:ccORANGE]];
    //3列目
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x            ,cp.y + 90 + (bw * dy)*2) color:ccGREEN]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x + bw       ,cp.y + 90 + (bw * dy)*2) color:ccBLACK]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x - bw       ,cp.y + 90 + (bw * dy)*2) color:ccBLUE]];
    //4列目
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x - bw*0.5   ,cp.y + 90 + (bw * dy)*3) color:ccORANGE]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x + bw*0.5   ,cp.y + 90 + (bw * dy)*3) color:ccBRAWN]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x - bw*1.5   ,cp.y + 90 + (bw * dy)*3) color:ccBRAWN]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x + bw*1.5   ,cp.y + 90 + (bw * dy)*3) color:ccRED]];
    //5列目
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x            ,cp.y + 90 + (bw * dy)*4) color:ccORANGE]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x + bw       ,cp.y + 90 + (bw * dy)*4) color:ccMAGENTA]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x - bw       ,cp.y + 90 + (bw * dy)*4) color:ccMAGENTA]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x + bw*2     ,cp.y + 90 + (bw * dy)*4) color:ccRED]];
    [node addChild:[Ball ballWithWorld:world at:ccp(cp.x - bw*2     ,cp.y + 90 + (bw * dy)*4) color:ccBLUE]];
}

+(void)resetBalls:(Board*)board world:(b2World*)world {
    
    NSMutableArray* ary = [[[NSMutableArray alloc] init] autorelease];
    for (CCNode* node in board.children) {
        if ([node isKindOfClass:[Ball class]]) {
            [ary addObject:node];
        }
    }
    for (CCNode* ball in ary) {
        [board removeChild:ball cleanup:YES];
    }
    [self setupBalls:board world:world];
}

-(void)createBallInWorld:(b2World*)world at:(CGPoint)pos color:(ccColor3B)color {
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = [Helper toMeters:pos];
    
    //移動／回転の減衰率
    bodyDef.angularDamping = 0.3f;
    bodyDef.linearDamping = 0.3f;
    
    ballRadius = [Ball ballWidth] * 0.5f;
    float radiusInMeters = (ballRadius / PTM_RATIO) ;
    
    b2CircleShape shape;
    shape.m_radius = radiusInMeters;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 0.5f;
    fixtureDef.friction = 1.0f;
    fixtureDef.restitution = 1.0f;
    
    [super createBodyInWorld:world bodyDef:&bodyDef fixtureDef:&fixtureDef spriteFileName:@"ball.png"];
    
    sprite.position = pos;
    sprite.color = color;
    
    originalColor = color;
}

-(void) applyForceTowardsFinger {
	b2Vec2 bodyPos = body->GetWorldCenter();
	b2Vec2 fingerPos = [Helper toMeters:fingerLocation];
	
	b2Vec2 bodyToFinger = fingerPos - bodyPos;
	
	b2Vec2 force = 5.0f * bodyToFinger;
	body->ApplyForce(force, body->GetWorldCenter());
}

-(void) update:(ccTime)delta {
    CGPoint pos = sprite.position;
    Board* board = (Board*)self.parent;
    if ([board isInHall:pos]) {
        isInHall = true;
    }
    
    /*
    b2Vec2 linerVelocity = body->GetLinearVelocity();
    float32 linerDumping = body->GetLinearDamping();
    float32 angularVelocity = body->GetAngularVelocity();
    float32 angularDamping = body->GetAngularDamping();

    NSLog(@"lvelocity:x=%f,y=%f ldumping=%f aVelocity=%f aDumping=%f", linerVelocity.x, linerVelocity.y, linerDumping, angularVelocity, angularDamping);
*/}

-(BOOL) isTouchForMe:(CGPoint)location {
    return abs(sprite.position.x - location.x) < ballRadius*2 && abs(sprite.position.y - location.y) < ballRadius*2;
}

-(BOOL)isMainBall {
    return self.tag == kTagMainBall;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [Helper locationFromTouch:touch];
    moveToFinger = YES;
    fingerLocation = location;

    //強制的にボールを止める
    body->SetLinearVelocity(b2Vec2(0.0f, 0.0f));
    body->SetAngularVelocity(0.0f);

    Ball* mainBall = (Ball*)[[self parent] getChildByTag:kTagMainBall];
    ballTracer = [BallTracer newTracerWithTouchLocation:fingerLocation ballLocation:mainBall.sprite.position];
    [[self parent] addChild:ballTracer];
    
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (moveToFinger) {
        fingerLocation = [Helper locationFromTouch:touch];
        ballTracer.touchLocation = fingerLocation;
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (moveToFinger) {
        [self applyForceTowardsFinger];
        moveToFinger = NO;
        
        [[self parent] removeChild:ballTracer cleanup:YES];
    }
}


@end
