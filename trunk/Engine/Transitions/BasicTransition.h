//
//  BasicTransition.h
//  TapMania
//
//  Created by Alex Kremer on 02.12.08.
//  Copyright 2008 Godexsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractRenderer.h"
#import "TMSingleTimeTask.h"

@interface BasicTransition : NSObject <TMSingleTimeTask> {
	AbstractRenderer *from, *to;
}

- (id) initFromScreen:(AbstractRenderer*)fromScreen toScreen:(AbstractRenderer*)toScreen;

@end
