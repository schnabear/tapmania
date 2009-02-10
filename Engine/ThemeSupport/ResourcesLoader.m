//
//  ResourcesLoader.m
//  TapMania
//
//  Created by Alex Kremer on 06.02.09.
//  Copyright 2008-2009 Godexsoft. All rights reserved.
//

#import "ResourcesLoader.h"
#import "TMResource.h"

#import <syslog.h>

@interface ResourcesLoader (Private)
- (void) loadResourceFromPath:(NSString*) path intoNode:(NSDictionary*) node;
- (NSObject*) lookUpNode:(NSString*) key;
@end


@implementation ResourcesLoader

@synthesize m_idDelegate;

- (id) initWithPath:(NSString*) rootPath andDelegate:(id) delegate {
	self = [super init];
	if(!self)
		return nil;
	
	m_idDelegate = delegate;
	m_pRoot = [[NSMutableDictionary alloc] init];
	
	m_sRootPath = rootPath;
	TMLog(@"Loading resources from root path at '%@'!!!", m_sRootPath);
	[self loadResourceFromPath:m_sRootPath intoNode:m_pRoot];
	TMLog(@"Loaded resources.");
	
	return self;
}

- (TMResource*) getResource:(NSString*) path {
	NSObject* node = [self lookUpNode:path];
	
	if(node && [node isKindOfClass:[TMResource class]]) {
		
		if(!((TMResource*)node).isLoaded) {
			[(TMResource*)node loadResource];
		}
		
		// Should be loaded now if above code worked
		return (TMResource*)node;		
	} else {
		NSException* ex = [NSException exceptionWithName:@"Can't get resources." 
												  reason:[NSString stringWithFormat:@"The path is not a resource. it seems to be a directory: %@", path] userInfo:nil];
		@throw ex;
	}
}

- (void) preLoad:(NSString*) path {
	NSObject* node = [self lookUpNode:path];
	if(!node) {
		NSException* ex = [NSException exceptionWithName:@"Can't load resources." 
										reason:[NSString stringWithFormat:@"The path is not loaded: %@", path] userInfo:nil];
		@throw ex;
	}
	
	// If it's a leaf
	if([node isKindOfClass:[TMResource class]]) {
		[(TMResource*)node loadResource];
		
	} else {
		// It's a directory. preload everything inside...
	}
}

- (void) preLoadAll {
}

- (void) unLoad:(NSString*) path {
	NSObject* node = [self lookUpNode:path];
	if(!node) {
		TMLog(@"The resources on path '%@' are not loaded...", path);
	}
	
	// TODO: release resources
}

- (void) unLoadAll {
}

/* Private methods */
- (void) loadResourceFromPath:(NSString*) path intoNode:(NSDictionary*) node {
	NSArray* dirContents = [[NSFileManager defaultManager] directoryContentsAtPath:path];
	
	// List all files and dirs there
	int i;
	for(i = 0; i<[dirContents count]; i++) {	
		NSString* itemName = [dirContents objectAtIndex:i];
		NSString* curPath = [path stringByAppendingPathComponent:itemName];
		
		BOOL isDirectory;
		
		if([[NSFileManager defaultManager] fileExistsAtPath:curPath isDirectory:&isDirectory]) {
			// is dir?
			if(isDirectory) {
				TMLog(@"[+] Found directory: %@", itemName);
				
				// Create new dictionary
				NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
				TMLog(@"Start loading into '%@'", itemName);
				[self loadResourceFromPath:curPath intoNode:dict];
				
				TMLog(@"------");
				
				// Add that new dict node to the node specified in the arguments
				[node setValue:dict forKey:itemName];
				TMLog(@"Stop adding there");
				
			} else {
				// file. check type
				if( m_idDelegate != nil && [m_idDelegate resourceTypeSupported:itemName] ) {
					TMLog(@"[Supported] %@", itemName);
					TMResource* resource = [[TMResource alloc] initWithPath:curPath andItemName:itemName];
					
					// Add that resource
					[node setValue:resource forKey:resource.componentName];										
					TMLog(@"Added it to current node at key = '%@'", resource.componentName);
				}
			}
		}
	}
}

// This method is looking up the resource in the hierarchy
- (NSObject*) lookUpNode:(NSString*) key {
	
	// Key is of format: "SomeRootElement SomeInnerElement SomeEvenMoreInnerElement TheResource"
	NSArray* pathChunks = [key componentsSeparatedByString:@" "];
	
	NSObject* tmp = m_pRoot;
	int i;
	
	for(i=0; i<[pathChunks count]-1; ++i) {
		if(tmp != nil && [tmp isKindOfClass:[NSMutableDictionary class]]) {
			// Search next component
			tmp = [(NSMutableDictionary*)tmp objectForKey:[pathChunks objectAtIndex:i]];
		}
	}
	
	if(tmp != nil) {
		tmp = [[(NSMutableDictionary*)tmp objectForKey:[pathChunks lastObject]] retain];
	}
	
	return tmp;	// nil or not
}

@end
