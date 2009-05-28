// GRWindowController.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"

@protocol GRWindowControllerDelegate;

@interface GRWindowController : NSWindowController <GRAreaSelectionViewDelegate> {
	IBOutlet GRAreaSelectionView *areaSelectionView;
	NSScreen *screen;
	NSRange selectedHorizontalFractionRange, selectedVerticalFractionRange;
	NSUInteger selectedHorizontalFraction, selectedVerticalFraction;
	id<GRWindowControllerDelegate> delegate;
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

@end