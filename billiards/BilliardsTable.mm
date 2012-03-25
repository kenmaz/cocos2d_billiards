//
//  BilliardsTable.m
//  billiards
//
//  Created by Matsumae Kentaro on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BilliardsTable.h"
#import "Constants.h"
#import "Helper.h"
#import "Ball.h"
#import "Board.h"

@interface BilliardsTable (Private) 
-(void)initBox2dWorld;
-(void) enableBox2dDebugDrawing;
@end

@implementation BilliardsTable {
    Board* board;
}

+(id)scene {
    CCScene* scene = [CCScene node];
    BilliardsTable* layer = [BilliardsTable node];
    [scene addChild:layer];
    return scene;
}

-(id)init {
    if ((self = [super init])) {
        
        [self initBox2dWorld];
        //[self enableBox2dDebugDrawing];
        
        // a bright background is desireable for this pinball table
		CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(222, 222, 222, 255)];
		[self addChild:colorLayer z:-3];

        board = [Board setupBoradWithWorld:world];
        [self addChild:board z:-2 tag:kTagBoard];
        
        //[Ball setupBalls:board world:world];

        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)dealloc {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super dealloc];
}

-(void) initBox2dWorld
{
	// Construct a world object, which will hold and simulate the rigid bodies.
	b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
	bool allowBodiesToSleep = true;
	world = new b2World(gravity, allowBodiesToSleep);
	
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);
	
	// Define the static container body, which will provide the collisions at screen borders.
	b2BodyDef containerBodyDef;
	b2Body* containerBody = world->CreateBody(&containerBodyDef);
	
	// for the ground body we'll need these values
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	float widthInMeters = screenSize.width / PTM_RATIO;
	float heightInMeters = screenSize.height / PTM_RATIO;
	b2Vec2 lowerLeftCorner = b2Vec2(0, 0);
	b2Vec2 lowerRightCorner = b2Vec2(widthInMeters, 0);
	b2Vec2 upperLeftCorner = b2Vec2(0, heightInMeters);
	b2Vec2 upperRightCorner = b2Vec2(widthInMeters, heightInMeters);
	
	// Create the screen box' sides by using a polygon assigning each side individually.
	b2PolygonShape screenBoxShape;
	
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &screenBoxShape;
    fixtureDef.density = 1.0f;
    fixtureDef.restitution = 1.0f;
    fixtureDef.friction = 1.0f;
    
	// left side
	screenBoxShape.SetAsEdge(upperLeftCorner, lowerLeftCorner);
	containerBody->CreateFixture(&fixtureDef);
	
	// right side
	screenBoxShape.SetAsEdge(upperRightCorner, lowerRightCorner);
	containerBody->CreateFixture(&fixtureDef);

	// top
	screenBoxShape.SetAsEdge(upperLeftCorner, upperRightCorner);
	containerBody->CreateFixture(&fixtureDef);
	
	// bottom
	screenBoxShape.SetAsEdge(lowerLeftCorner, lowerRightCorner);
	containerBody->CreateFixture(&fixtureDef);
}

-(void) enableBox2dDebugDrawing
{
	// Debug Draw functions
	debugDraw = new GLESDebugDraw(PTM_RATIO);
	world->SetDebugDraw(debugDraw);
	
	uint32 flags = 0;
	flags |= b2DebugDraw::e_shapeBit;
	flags |= b2DebugDraw::e_jointBit;
	//flags |= b2DebugDraw::e_aabbBit;
	//flags |= b2DebugDraw::e_pairBit;
	//flags |= b2DebugDraw::e_centerOfMassBit;
	debugDraw->SetFlags(flags);		
}

-(void) update:(ccTime)delta
{
    for (CCNode* node in [board children]) {
        if ([node isKindOfClass:[Ball class]]) {
            Ball* ball = (Ball*)node;
            if (ball.isInHall) {
                [board removeChild:ball cleanup:YES];
                if ([ball isMainBall]) {
                    [board resetBalls];
                    break;
                }
            }
        }
    }
    
	// The number of iterations influence the accuracy of the physics simulation. With higher values the
	// body's velocity and position are more accurately tracked but at the cost of speed.
	// Usually for games only 1 position iteration is necessary to achieve good results.
	float timeStep = 0.03f;
	int32 velocityIterations = 8;
	int32 positionIterations = 8;
	world->Step(timeStep, velocityIterations, positionIterations);
	
	// for each body, get its assigned BodyNode and update the sprite's position
	for (b2Body* body = world->GetBodyList(); body != nil; body = body->GetNext())
	{
		BodyNode* bodyNode = (BodyNode*)body->GetUserData();
		if (bodyNode != NULL && bodyNode.sprite != nil)
		{
			// update the sprite's position to where their physics bodies are
			bodyNode.sprite.position = [Helper toPixels:body->GetPosition()];
			float angle = body->GetAngle();
			bodyNode.sprite.rotation = -(CC_RADIANS_TO_DEGREES(angle));
		}
	}
}

#ifdef DEBUG
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}
#endif

#pragma mark CCTargetedTouchDelegate

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [Helper locationFromTouch:touch];
    Ball* mainBall = (Ball*)[board getChildByTag:kTagMainBall];
    
    if ([mainBall isTouchForMe:location]) {
        return [mainBall ccTouchBegan:touch withEvent:event];
    }
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    Ball* mainBall = (Ball*)[board getChildByTag:kTagMainBall];
    [mainBall ccTouchMoved:touch withEvent:event];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    Ball* mainBall = (Ball*)[board getChildByTag:kTagMainBall];
    [mainBall ccTouchEnded:touch withEvent:event];
}


@end
