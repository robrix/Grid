// GRAreaSelectionView.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

@protocol GRAreaSelectionViewDelegate;

@interface GRAreaSelectionView : NSView {
	NSResponder<GRAreaSelectionViewDelegate> *delegate;
}

@property (nonatomic, assign) NSResponder<GRAreaSelectionViewDelegate> *delegate;

@end


@protocol GRAreaSelectionViewDelegate <NSObject>

@property (nonatomic, readonly) NSUInteger maximumHorizontalFractions;
@property (nonatomic, readonly) NSUInteger maximumVerticalFractions;

@property (nonatomic, readonly) NSRange selectedHorizontalFractionRange;
@property (nonatomic, readonly) NSRange selectedVerticalFractionRange;

@property (nonatomic, readonly) NSUInteger selectedHorizontalFraction;
@property (nonatomic, readonly) NSUInteger selectedVerticalFraction;

@end