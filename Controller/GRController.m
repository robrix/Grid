// GRController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"
#import "GRController.h"
#import "GRWindowController.h"
#import <Carbon/Carbon.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import <Haxcessibility/Haxcessibility.h>

OSStatus GRControllerShortcutWasPressed(EventHandlerCallRef nextHandler, EventRef event, void *userData);

@interface GRController () <GRWindowControllerDelegate>

@property HAXWindow *windowElement;

-(void)shortcutKeyDown;

-(void)activate;
-(void)deactivate;

@property (nonatomic) NSUInteger activeControllerIndex;

@end

@implementation GRController

@synthesize windowElement;
@synthesize activeControllerIndex;

+(void)initialize {
	[[NSUserDefaults standardUserDefaults] registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"`", @"characters",
			[NSNumber numberWithInteger: 50], @"keyCode",
			[NSNumber numberWithUnsignedInteger: cmdKey + optionKey], @"modifierFlags",
		nil], @"GRShortcut",
	nil]];
}


-(void)awakeFromNib {
	NSMutableArray *tempControllers = [NSMutableArray array];
	for(NSScreen *screen in [NSScreen screens]) {
		GRWindowController *controller = [GRWindowController controllerWithScreen: screen];
		controller.delegate = self;
		[tempControllers addObject: controller];
	}
	controllers = tempControllers;
	
	EventTypeSpec eventType = {
		.eventClass = kEventClassKeyboard,
		.eventKind = kEventHotKeyPressed
	};
	InstallApplicationEventHandler(&GRControllerShortcutWasPressed, 1, &eventType, self, NULL);
	
	shortcutRecorder.canCaptureGlobalHotKeys = YES;
}


-(NSDictionary *)shortcut {
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey: @"GRShortcut"];
}

-(void)setShortcut:(NSDictionary *)shortcut {
	if(shortcut) {
		[[NSUserDefaults standardUserDefaults] setObject: shortcut forKey: @"GRShortcut"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		EventHotKeyID shortcutIdentifier = {
			.id = 1,
			.signature = 'GRSc'
		};
		
		NSInteger keyCode = [[shortcut objectForKey: @"keyCode"] integerValue];
		NSUInteger modifierFlags = [[shortcut objectForKey: @"modifierFlags"] unsignedIntegerValue];
		// if(shortcutReference) {
			UnregisterEventHotKey(shortcutReference);
		// }
		OSErr error = RegisterEventHotKey(keyCode, [shortcutRecorder cocoaToCarbonFlags: modifierFlags], shortcutIdentifier, GetApplicationEventTarget(), 0, &shortcutReference);
		if(error != noErr) {
			NSLog(@"error when registering hot key: %i", error);
		}
	}
}


-(NSUInteger)indexOfWindowControllerForWindowElementWithFrame:(CGRect)frame {
	CGPoint topLeft = CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame));
	NSUInteger index = 0;
	for(GRWindowController *controller in controllers) {
		if(CGRectContainsPoint(controller.screen.frame, topLeft))
			break;
		index++;
	}
	return index;
}


-(void)shortcutKeyDown {
	if(self.windowElement = [HAXSystem system].focusedApplication.focusedWindow) {
		CGRect frame = self.windowElement.frame;
		[self activate];
		self.activeControllerIndex = [self indexOfWindowControllerForWindowElementWithFrame: frame];
	} else {
		[self deactivate];
	}
}


-(void)activate {
	[controllers makeObjectsPerformSelector: @selector(activate)];
}

-(void)deactivate {
	[controllers makeObjectsPerformSelector: @selector(deactivate)];
}


-(void)setActiveControllerIndex:(NSUInteger)index {
	activeControllerIndex = index;
	[[controllers objectAtIndex: activeControllerIndex] showWindow: nil]; // focus on the active screen (by default, the one the window is on; can be switched with ⌘` and ⇧⌘`)
}


-(void)applicationDidResignActive:(NSNotification *)notification {
	[self deactivate];
}


-(void)windowController:(GRWindowController *)controller didSelectArea:(CGRect)selectedArea {
	selectedArea.origin.y = NSHeight(controller.screen.frame) - NSHeight(selectedArea) - selectedArea.origin.y; // flip the selected area
	NSLog(@"Resizing to %@ within %@.", NSStringFromRect(selectedArea), NSStringFromRect(controller.screen.visibleFrame));
	self.windowElement.frame = selectedArea;
}


-(IBAction)nextController:(id)sender {
	self.activeControllerIndex = (activeControllerIndex + 1) % controllers.count;
}

-(IBAction)previousController:(id)sender {
	if(activeControllerIndex > 0) {
		self.activeControllerIndex = activeControllerIndex - 1;
	} else {
		self.activeControllerIndex = controllers.count - 1;
	}
}

@end


OSStatus GRControllerShortcutWasPressed(EventHandlerCallRef nextHandler, EventRef event, void *userData) {
	GRController *controller = (GRController *)userData;
	[controller shortcutKeyDown];
	return noErr;
}


@implementation SRValidator (GRCanCaptureGlobalHotKeysIsBroken)

-(BOOL)isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags error:(NSError **)error {
	return NO;
}

@end
