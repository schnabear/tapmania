//
//  Label.h
//  TapMania
//
//  Created by Alex Kremer on 5/17/09.
//  Copyright 2009 Godexsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractRenderer.h"
#import "TMEffectSupport.h"

@class Texture2D;

@interface Label : AbstractRenderer <TMEffectSupport> {
	Texture2D*			m_pTitle;
	NSString*			m_sTitle;
	
	CGRect				m_rShape;	// The points where the label is drawn	
}

- (id) initWithTitle:(NSString*)title andShape:(CGRect) shape;

- (CGPoint) getPosition;
- (void) updatePosition:(CGPoint)point;

- (BOOL) containsPoint:(CGPoint)point;

@end
