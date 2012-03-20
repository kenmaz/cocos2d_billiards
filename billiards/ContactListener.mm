//
//  ContactListener.mm
//  PhysicsBox2d
//
//  Created by quipu on 11/04/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactListener.h"
#import "BodyNode.h"
#import "Ball.h"

void ContactListener::BeginContact(b2Contact* contact) {/*
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	BodyNode* bodyNodeA = (BodyNode*)bodyA->GetUserData();
	BodyNode* bodyNodeB = (BodyNode*)bodyB->GetUserData();
    
	// start plunger on contact
	if ([bodyNodeA isKindOfClass:[Ball class]] && [bodyNodeB isKindOfClass:[Ball class]]) {
        bodyNodeA.sprite.color = ccYELLOW;
        bodyNodeB.sprite.color = ccYELLOW;
	}
*/}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
}

void ContactListener::EndContact(b2Contact* contact) {/*
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	BodyNode* bodyNodeA = (BodyNode*)bodyA->GetUserData();
	BodyNode* bodyNodeB = (BodyNode*)bodyB->GetUserData();
    
	// start plunger on contact
	if ([bodyNodeA isKindOfClass:[Ball class]] && [bodyNodeB isKindOfClass:[Ball class]]) {
        [(Ball*)bodyNodeA resetColor]; 
        [(Ball*)bodyNodeB resetColor]; 
	}
*/}
