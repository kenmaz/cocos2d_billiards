//
//  Ball.h
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@interface Ball : BodyNode <CCTargetedTouchDelegate> {
    bool moveToFinger;
    CGPoint fingerLocation;
    float ballRadius;
    ccColor3B originalColor;
    BOOL isInHall;
}
@property BOOL isInHall;
+(id)ballWithWorld:(b2World*)world at:(CGPoint)pos touchable:(BOOL)touchable;
+(id)ballWithWorld:(b2World*)world at:(CGPoint)pos color:(ccColor3B)color;

+(CGFloat)ballWidth;
-(void)resetColor;
-(BOOL)isMainBall;
-(BOOL) isTouchForMe:(CGPoint)location;

+(void)setupBalls:(CCNode*)node world:(b2World*)world;
+(void)resetBalls:(CCNode*)board world:(b2World*)world;

@end
