// GRWindowController.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

#import "GRAreaSelectionView.h"

@protocol GRWindowControllerDelegate;

@interface GRWindowController : NSWindowController <GRAreaSelectionViewDelegate> {
	IBOutlet GRAreaSelectionView *_areaSelectionView;
	NSScreen *_screen;
	NSRange _selectedHorizontalFractionRange;
	NSRange _selectedVerticalFractionRange;
	NSUInteger _selectedHorizontalFraction;
	NSUInteger _selectedVerticalFraction;
	id<GRWindowControllerDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet GRAreaSelectionView *areaSelectionView;

+(GRWindowController *)controllerWithScreen:(NSScreen *)screen;

@property (nonatomic, retain) NSScreen *screen;
@property (nonatomic, assign) id<GRWindowControllerDelegate> delegate;

-(void)activate;
-(void)deactivate;

@end


@protocol GRWindowControllerDelegate

// -(void)activate;
-(void)deactivate;

// handle moving the selection between screens.

-(void)windowController:(GRWindowController *)controller didSelectArea:(CGRect)selectedArea;

@end