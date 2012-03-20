//
//  BodyNode.mm
//  PhysicsBox2d
//
//  Created by quipu on 11/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BodyNode.h"

@implementation BodyNode

@synthesize body;
@synthesize sprite;

-(void) createBodyInWorld:(b2World*)world bodyDef:(b2BodyDef*)bodyDef fixtureDef:(b2FixtureDef*)fixtureDef spriteFrameName:(NSString*)spriteFrameName
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteFrameName != nil, @"spriteFrameName is nil!");
	
	[self removeSprite];
	[self removeBody];
	/*
	CCSpriteBatchNode* batch = [[PinballTable sharedTable] getSpriteBatch];
	sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	[batch addChild:sprite];
	
	body = world->CreateBody(bodyDef);
	body->SetUserData(self);
	
	if (fixtureDef != NULL)
	{
		body->CreateFixture(fixtureDef);
	}
     */
}

-(void) createBodyInWorld:(b2World*)world 
                  bodyDef:(b2BodyDef*)bodyDef 
               fixtureDef:(b2FixtureDef*)fixtureDef 
          spriteFileName:(NSString*)spriteFileName
{
	NSAssert(world != NULL, @"world is null!");
	NSAssert(bodyDef != NULL, @"bodyDef is null!");
	NSAssert(spriteFileName != nil, @"spriteFileName is nil!");
	
	[self removeSprite];
	[self removeBody];

    sprite = [[CCSprite spriteWithFile:spriteFileName] retain];
    [self addChild:sprite];
    
    body = world->CreateBody(bodyDef);
    body->SetUserData(self);
     
    if (fixtureDef != NULL) {
        body->CreateFixture(fixtureDef);
    }
}

-(void) removeSprite {
    [sprite release];
    /*
	CCSpriteBatchNode* batch = [[PinballTable sharedTable] getSpriteBatch];
	if (sprite != nil && [batch.children containsObject:sprite])
	{
		[batch.children removeObject:sprite];
		sprite = nil;
	}
     */
}

-(void) removeBody
{
	if (body != NULL)
	{
		body->GetWorld()->DestroyBody(body);
		body = NULL;
	}
}

-(void) dealloc
{
	[self removeSprite];
	[self removeBody];
	
	[super dealloc];
}

@end