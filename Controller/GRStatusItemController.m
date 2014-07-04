//
//  GRStatusItemController.m
//  Grid
//
//  Created by Rob Rix on 11-09-30.
//  Copyright 2011 Rob Rix. All rights reserved.
//

#import "GRStatusItemController.h"

@interface GRStatusItemController ()

@property (nonatomic, retain) NSStatusItem *statusItem;

@end

@implementation GRStatusItemController

+(void)initialize {
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:(id)kCFBooleanTrue forKey:@"GRShowInMenuBar"]];
}


-(void)awakeFromNib {
	self.statusItemEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"GRShowInMenuBar"];
}


-(BOOL)isStatusItemEnabled {
	return self.statusItem != nil;
}

-(void)setStatusItemEnabled:(BOOL)statusItemEnabled {
	if(statusItemEnabled && (self.statusItem == nil)) {
		NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
		
		NSImage *statusItemImage = [NSImage imageNamed:@"GRStatusItem"];
		statusItemImage.template = YES;
		statusItem.image = statusItemImage;
		
		statusItem.menu = self.statusItemMenu;
		statusItem.toolTip = @"Grid";
		statusItem.highlightMode = YES;
		
		self.statusItem = statusItem;
	} else if(!statusItemEnabled && (self.statusItem != nil)) {
		[[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
		self.statusItem = nil;
	}
	[[NSUserDefaults standardUserDefaults] setBool:statusItemEnabled forKey:@"GRShowInMenuBar"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


-(IBAction)openMoreAppsFromDEVONtechnologiesURL:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.devontechnologies.com/redirect.html?id=appstore"]];
}

-(IBAction)openFacebookURL:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.devontechnologies.com/redirect.html?id=facebook"]];
}

-(IBAction)openTwitterURL:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.devontechnologies.com/redirect.html?id=twitter"]];
}

@end
