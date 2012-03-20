//
//  Helper.h
//  PhysicsBox2d
//
//  Created by quipu on 11/04/09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"

@interface Helper : NSObject 
{
}

+(b2Vec2) toMeters:(CGPoint)point;
+(CGPoint) toPixels:(b2Vec2)vec;

+(CGPoint) locationFromTouch:(UITouch*)touch;
+(CGPoint) locationFromTouches:(NSSet*)touches;

+(CGPoint) screenCenter;

@end