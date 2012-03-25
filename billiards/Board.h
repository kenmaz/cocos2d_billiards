//
//  Board.h
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Helper.h"
#import "Constants.h"

#define HALL_COUNT 6

@interface Board : CCNode {
    b2World* world_;
    
    CGPoint halls_[6];
}
+(id) setupBoradWithWorld:(b2World*)world;
-(BOOL)isInHall:(CGPoint)pos;
-(void)resetBalls;

@end
