//
//  Board.m
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Board.h"
#import "Ball.h"

enum {
    kBoardCertGroupWall,
    kBoardCertGroupHall,
    kBoardCertGroupBall
};

@interface Board (Private)
-(void)setup;
@end

@implementation Board

-(id)initWithWorld:(b2World*)world {
    if ((self = [super init])) {
        world_ = world;
        
        CCSprite* board = [CCSprite spriteWithFile:@"board_side.png"];
        board.position = [Helper screenCenter];
        [self addChild:board];
        
        [self setup];
    }
    return self;
}

+(id) setupBoradWithWorld:(b2World*)world {
    return [[[Board alloc] initWithWorld:world] autorelease];
}

-(void) createStaticBodyWithVertices:(b2Vec2[])vertices numVertices:(int)numVertices {
	// Create a body definition 
	b2BodyDef bodyDef;
	bodyDef.position = [Helper toMeters:CGPointMake(0, 0)];
	
	b2PolygonShape shape;
	shape.Set(vertices, numVertices);
	
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &shape;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.2f;
	fixtureDef.restitution = 0.1f;
	
	b2Body* body = world_->CreateBody(&bodyDef);
	body->CreateFixture(&fixtureDef);
}

static const ccColor3B ccBRAWN = {110,0,0};

static ccColor3B ballColors[15] = {
    //1列目
    ccYELLOW,
    //2列目
    ccGREEN,
    ccORANGE,
    ccGREEN,
    ccBLACK,
    ccBLUE,
    //4列目
    ccORANGE,
    ccBRAWN,
    ccBRAWN,
    ccRED,
    //5列目
    ccORANGE,
    ccMAGENTA,
    ccMAGENTA,
    ccRED,
    ccBLUE,
};

-(void)setup {
    [self setupAll:YES];
}

-(void)setupAll:(BOOL)setupAll {
    b2Vec2 verts[b2_maxPolygonVertices];
    int hallIndex = 0;
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [bundle pathForResource:@"vertex" ofType:@"plist"];
    NSDictionary* vertex = [NSDictionary dictionaryWithContentsOfFile:path];;

    NSArray* fixtures = [[[vertex objectForKey:@"bodies"] objectForKey:@"board_side"] objectForKey:@"fixtures"];
    for (NSDictionary* fixture in fixtures) {
        NSNumber* groupIndex = [fixture objectForKey:@"filter_groupIndex"];
        int index = [groupIndex intValue];
        
        if (index == kBoardCertGroupWall && setupAll) {
            NSArray* polygons = [fixture objectForKey:@"polygons"];
            for (NSArray* polygon in polygons) {
                NSLog(@"polygon");
                int num = 0;
                for (NSString* polygonStr in polygon) {
                    CGPoint point = CGPointFromString(polygonStr);
                    verts[num] = b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
                    num++;
                    
                    NSLog(@"x=%f, y=%f", point.x, point.y);
                }
                [self createStaticBodyWithVertices:verts numVertices:num];
            }
        }
        else if (index == kBoardCertGroupHall && setupAll) {
            NSString* hallPos = [[fixture objectForKey:@"circle"] objectForKey:@"position"];
            halls_[hallIndex] = CGPointFromString(hallPos);
            hallIndex++;
        }
        else if (index == kBoardCertGroupBall) {
            CGPoint ballPos = CGPointFromString([[fixture objectForKey:@"circle"] objectForKey:@"position"]);
            
            NSString* ballId = [fixture objectForKey:@"id"];
            if ([ballId isEqualToString:@"main"]) {
                Ball* ball = [Ball ballWithWorld:world_ at:ballPos touchable:NO];
                ball.tag = kTagMainBall;
                [self addChild:ball];

            } else {
                int ballNumber = [ballId intValue];
                ccColor3B ballColor = ballColors[ballNumber - 1];
                [self addChild:[Ball ballWithWorld:world_ at:ballPos color:ballColor]];
                 
            }
        }
    }
}

-(void)resetBalls {
    NSMutableArray* ary = [[[NSMutableArray alloc] init] autorelease];
    for (CCNode* node in self.children) {
        if ([node isKindOfClass:[Ball class]]) {
            [ary addObject:node];
        }
    }
    for (CCNode* ball in ary) {
        [self removeChild:ball cleanup:YES];
    }
    [self setupAll:NO];
}

-(BOOL)isInHall:(CGPoint)pos {
    for (int i = 0; i < HALL_COUNT; i++) {
        CGPoint hall = halls_[i];
        float distance = sqrt(pow(pos.x - hall.x, 2) + pow(pos.y - hall.y, 2));
        if (distance < 10) {
            return YES;
        }
    }
    return NO;
}

@end
