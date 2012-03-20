//
//  ContactListener.h
//  PhysicsBox2d
//
//  Created by quipu on 11/04/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"

class ContactListener : public b2ContactListener
{
private:
	void BeginContact(b2Contact* contact);
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
	void EndContact(b2Contact* contact);
};