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

@interface Ball (Private)
-(void)createBallInWorld:(b2World*)world at:(CGPoint)pos color:(ccColor3B)color;
@end

@implementation Ball

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
	//float distance = bodyToFinger.Normalize();
	
	// "Real" gravity falls off by the square over distance. Feel free to try it this way:
	//float distanceSquared = distance * distance;
	//b2Vec2 force = ((1.0f / distanceSquared) * 20.0f) * bodyToFinger;
	
	b2Vec2 force = 10.0f * bodyToFinger;
	body->ApplyForce(force, body->GetWorldCenter());
}

-(void) update:(ccTime)delta {
    CGPoint pos = sprite.position;
    Board* board = (Board*)[self.parent getChildByTag:kTagBoard];
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

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [Helper locationFromTouch:touch];
    if ([self isTouchForMe:location]) {
        moveToFinger = YES;
        fingerLocation = location;
        return YES;
    }
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (moveToFinger) {
        fingerLocation = [Helper locationFromTouch:touch];
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (moveToFinger) {
        [self applyForceTowardsFinger];
        moveToFinger = NO;
    }
}


@end
