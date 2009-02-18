//
//  OptionsMenuRenderer.m
//  TapMania
//
//  Created by Alex Kremer on 06.11.08.
//  Copyright 2008 Godexsoft. All rights reserved.
//

#import "TapMania.h"
#import "EAGLView.h"

#import "OptionsMenuRenderer.h"
#import "MainMenuRenderer.h"

@implementation OptionsMenuRenderer

- (id) init {
	self = [super init];
	if(!self)
		return nil;

	// TODO: define some menu items

	return self;
}

- (void)render:(NSNumber*) fDelta {
	// CGRect	bounds = [TapMania sharedInstance].glView.bounds;
	
	//Draw background
	/*
	[[[TexturesHolder sharedInstance] getTexture:kTexture_] drawInRect:bounds];
	 */
}	

# pragma mark Touch handling
- (void) backPress:(id)sender {
	TMLog(@"Enter main menu (back from options)...");
}

@end