//
//  BilliardsTable.h
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"

@interface BilliardsTable : CCLayer <CCTargetedTouchDelegate> {
    b2World* world;
    ContactListener* contactListener;
    
    GLESDebugDraw* debugDraw;
}

+(id)scene;

@end
