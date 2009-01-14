//
//  InputEngine.m
//  TapMania
//
//  Created by Alex Kremer on 03.12.08.
//  Copyright 2008 Godexsoft. All rights reserved.
//

#import "InputEngine.h"
#import "TMGameUIResponder.h"
#import "BenchmarkUtil.h"

// This is a singleton class, see below
static InputEngine *sharedInputEngineDelegate = nil;

@implementation InputEngine

- (id) init {
	self = [super init];
	if(!self)
		return nil;
	
	subscribers = [[NSMutableArray alloc] initWithCapacity:5];
	
	return self;
}

- (void) dealloc {
	[subscribers release];
	[super dealloc];
}

- (void) subscribe:(NSObject*) handler {
	if([handler conformsToProtocol:@protocol(TMGameUIResponder)]){
		[subscribers addObject:handler];
	} else {
		NSLog(@"Passed an object which doesn't conform to TMGameUIResponder protocol. ignore.");
	}
}

- (void) unsubscribe:(NSObject*) handler {
	// Will remove the handler if found
	[subscribers removeObject:handler];
}

- (void) dispatchTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	int i;
	
	for(i=0; i<[subscribers count]; i++){
		NSObject* handler = [subscribers objectAtIndex:i];
		if([handler respondsToSelector:@selector(tmTouchesBegan:withEvent:)]){
			// BenchmarkUtil* bm = [BenchmarkUtil instanceWithName:@"Touches began"];
			[handler performSelector:@selector(tmTouchesBegan:withEvent:) withObject:touches withObject:event];
			// [bm finish];
		}
	}
}

- (void) dispatchTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	int i;
	for(i=0; i<[subscribers count]; i++){
		NSObject* handler = [subscribers objectAtIndex:i];
		if([handler respondsToSelector:@selector(tmTouchesMoved:withEvent:)]){
			[handler performSelector:@selector(tmTouchesMoved:withEvent:) withObject:touches withObject:event];
		}
	}	
}

- (void) dispatchTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	int i;
	for(i=0; i<[subscribers count]; i++){
		NSObject* handler = [subscribers objectAtIndex:i];
		if([handler respondsToSelector:@selector(tmTouchesEnded:withEvent:)]){
			[handler performSelector:@selector(tmTouchesEnded:withEvent:) withObject:touches withObject:event];
		}
	}	
}

#pragma mark Singleton stuff

+ (InputEngine *)sharedInstance {
    @synchronized(self) {
        if (sharedInputEngineDelegate == nil) {
            [[self alloc] init];
        }
    }
    return sharedInputEngineDelegate;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInputEngineDelegate	== nil) {
            sharedInputEngineDelegate = [super allocWithZone:zone];
            return sharedInputEngineDelegate;
        }
    }
	
    return nil;
}


- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
	// NOTHING
}

- (id)autorelease {
    return self;
}


@end
