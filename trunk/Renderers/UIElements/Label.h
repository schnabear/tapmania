//
//  Label.h
//  TapMania
//
//  Created by Alex Kremer on 5/17/09.
//  Copyright 2009 Godexsoft. All rights reserved.
//

#import "TMControl.h"

@class Texture2D;

@interface Label : TMControl {
	Texture2D*			m_pTitle;
	float				m_fFontSize;
	NSString*			m_sFontName;
	UITextAlignment		m_Align;
	NSString*			m_sTitle;
}

- (id) initWithTitle:(NSString*)title andShape:(CGRect) shape;
- (id) initWithTitle:(NSString*)title fontSize:(float)fontSize andShape:(CGRect) shape;

- (void) initTextualProperties:(NSString*)inMetricsKey;

- (void) setName:(NSString*)inName;	// For name command
- (void) setFont:(NSString*)inName;	// For font command
- (void) setFontSize:(NSNumber*)inSize;	// For fontsize command
- (void) setAlignment:(NSString*)inAlign;	// For alignment command

@end