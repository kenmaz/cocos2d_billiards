//
//  BallTracer.m
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BallTracer.h"
#import "Ball.h"

@interface BallTracer (Private)
-(void)addBallShadow;
@end

@implementation BallTracer

@synthesize ballLocation;
@synthesize touchLocation;

-(id)initWithTouchLocation:(CGPoint)_touchLocation ballLocation:(CGPoint)_ballLocation {
    if ((self = [super init])) {
        self.touchLocation = _touchLocation;
        self.ballLocation = _ballLocation;
        
        ballWidth = [Ball ballWidth];
        
        batch = [[CCSpriteBatchNode batchNodeWithFile:@"ball.png"] retain];
        [self addChild:batch];
    
        [self addBallShadow];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)dealloc {
    [batch release];
    [super dealloc];
}

+(id)newTracerWithTouchLocation:(CGPoint)_touchLocation ballLocation:(CGPoint)_ballLocation {
    return [[[BallTracer alloc] initWithTouchLocation:_touchLocation ballLocation:_ballLocation] autorelease];
}

-(void)addBallShadow {
    CCSprite* ball = [CCSprite spriteWithFile:@"ball.png"];
    ball.opacity = 128;
    [batch addChild:ball];
}

-(void) update:(ccTime)delta {
    CGFloat dx = self.ballLocation.x - self.touchLocation.x;
    CGFloat dy = self.ballLocation.y - self.touchLocation.y;
    CGFloat distance = sqrt(dx*dx + dy*dy);
    
    int shadowCount = (distance / ballWidth);
    NSLog(@"shadow req = %d, act = %d", shadowCount, [[batch children] count]);
    
    if (shadowCount > [[batch children] count]) {
        while (shadowCount > [[batch children] count]) {
            [self addBallShadow];
        }
    } else {
        while (shadowCount < [[batch children] count]) {
            CCSprite* last = [[batch children] lastObject];
            [batch removeChild:last cleanup:YES];
        }
    }
    NSLog(@"shadow req = %d, act = %d", shadowCount, [[batch children] count]);
    
    for (int i = 0; i < shadowCount; i++) {
        CCSprite* shadowSprite = [[batch children] objectAtIndex:i];
        
        float d = ballWidth * (i + 1);
        float sx = dx * (d / distance) + self.touchLocation.x;
        float sy = dy * (d / distance) + self.touchLocation.y;
        shadowSprite.position = CGPointMake(sx, sy);
    }
}

@end
