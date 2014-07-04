// GRWindowController.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

#import "GRAreaSelectionView.h"

@protocol GRWindowControllerDelegate;

@interface GRWindowController : NSWindowController <GRAreaSelectionViewDelegate>

@property (nonatomic, strong) IBOutlet GRAreaSelectionView *areaSelectionView;

+(GRWindowController *)controllerWithScreen:(NSScreen *)screen;

@property (nonatomic, strong) NSScreen *screen;
@property (nonatomic, weak) id<GRWindowControllerDelegate> delegate;

-(void)activate;
-(void)deactivate;

@end


@protocol GRWindowControllerDelegate

// -(void)activate;
-(void)deactivate;

// handle moving the selection between screens.

-(void)windowController:(GRWindowController *)controller didSelectArea:(CGRect)selectedArea;

@end