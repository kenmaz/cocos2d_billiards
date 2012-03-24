//
//  BallTracer.h
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BallTracer : CCNode {
    CCSpriteBatchNode* batch;
    float ballWidth;
}
@property CGPoint ballLocation;
@property CGPoint touchLocation;

+(id)newTracerWithTouchLocation:(CGPoint)_touchLocation ballLocation:(CGPoint)_ballLocation;
@end
