//
//  Board.m
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Board.h"

@interface Board (Private)
-(void)setup;
@end

@implementation Board

-(id)initWithWorld:(b2World*)world {
    if ((self = [super init])) {
        world_ = world;
        
        //left bottom to top
        halls_[0] = ccp(19,16);
        halls_[1] = ccp(13, 240);
        halls_[2] = ccp(19, 464);
        //right bottom to top
        halls_[3] = ccp(303, 15);
        halls_[4] = ccp(307, 238);
        halls_[5] = ccp(303, 464);
        
        CCSprite* board = [CCSprite spriteWithFile:@"board.png"];
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
	bodyDef.position = [Helper toMeters:[Helper screenCenter]];
	
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

-(void)setup {
    {
        //row 1, col 1
        int num = 4;
        b2Vec2 verts[] = {
            b2Vec2(-129.0f / PTM_RATIO, 226.5f / PTM_RATIO),
            b2Vec2(132.5f / PTM_RATIO, 226.5f / PTM_RATIO),
            b2Vec2(143.0f / PTM_RATIO, 238.5f / PTM_RATIO),
            b2Vec2(-136.5f / PTM_RATIO, 238.5f / PTM_RATIO),
        };
        [self createStaticBodyWithVertices:verts numVertices:num];
    }
    {
        //row 1, col 1
        int num = 4;
        b2Vec2 verts[] = {
            b2Vec2(146.5f / PTM_RATIO, 214.0f / PTM_RATIO),
            b2Vec2(147.0f / PTM_RATIO, 12.5f / PTM_RATIO),
            b2Vec2(158.0f / PTM_RATIO, 6.0f / PTM_RATIO),
            b2Vec2(158.5f / PTM_RATIO, 225.5f / PTM_RATIO),
        };
        [self createStaticBodyWithVertices:verts numVertices:num];
    }
    {
        //row 1, col 1
        int num = 4;
        b2Vec2 verts[] = {
            b2Vec2(147.0f / PTM_RATIO, -10.5f / PTM_RATIO),
            b2Vec2(147.2f / PTM_RATIO, -213.0f / PTM_RATIO),
            b2Vec2(159.0f / PTM_RATIO, -228.5f / PTM_RATIO),
            b2Vec2(159.0f / PTM_RATIO, -0.7f / PTM_RATIO),
        };
        [self createStaticBodyWithVertices:verts numVertices:num];
    }
    {
        //row 1, col 1
        int num = 4;
        b2Vec2 verts[] = {
            b2Vec2(131.7f / PTM_RATIO, -226.5f / PTM_RATIO),
            b2Vec2(-130.2f / PTM_RATIO, -227.7f / PTM_RATIO),
            b2Vec2(-141.7f / PTM_RATIO, -238.7f / PTM_RATIO),
            b2Vec2(142.7f / PTM_RATIO, -238.7f / PTM_RATIO),
        };
        [self createStaticBodyWithVertices:verts numVertices:num];
    }
    {
        //row 1, col 1
        int num = 4;
        b2Vec2 verts[] = {
            b2Vec2(-145.0f / PTM_RATIO, -213.0f / PTM_RATIO),
            b2Vec2(-145.0f / PTM_RATIO, -12.2f / PTM_RATIO),
            b2Vec2(-159.0f / PTM_RATIO, -6.5f / PTM_RATIO),
            b2Vec2(-159.0f / PTM_RATIO, -225.2f / PTM_RATIO)
        };
        [self createStaticBodyWithVertices:verts numVertices:num];
    }
    {
        //row 1, col 1
        int num = 4;
        b2Vec2 verts[] = {
            b2Vec2(-145.2f / PTM_RATIO, 214.0f / PTM_RATIO),
            b2Vec2(-158.7f / PTM_RATIO, 222.7f / PTM_RATIO),
            b2Vec2(-158.7f / PTM_RATIO, 2.2f / PTM_RATIO),
            b2Vec2(-145.2f / PTM_RATIO, 12.5f / PTM_RATIO)
        };
        [self createStaticBodyWithVertices:verts numVertices:num];
    }
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
