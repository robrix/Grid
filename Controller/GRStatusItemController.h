//
//  GRStatusItemController.h
//  Grid
//
//  Created by Rob Rix on 11-09-30.
//  Copyright 2011 Rob Rix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRStatusItemController : NSObject {
	NSMenu *statusItemMenu;
	NSStatusItem *statusItem;
}

@property (nonatomic, assign) IBOutlet NSMenu *statusItemMenu;
@property (nonatomic, assign, getter=isStatusItemEnabled) BOOL statusItemEnabled;

-(IBAction)openMoreAppsFromDEVONtechnologiesURL:(id)sender;
-(IBAction)openFacebookURL:(id)sender;
-(IBAction)openTwitterURL:(id)sender;
-(IBAction)openLinkedInURL:(id)sender;

@end
