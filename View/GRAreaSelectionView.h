// GRAreaSelectionView.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

@protocol GRAreaSelectionViewDelegate;

@interface GRAreaSelectionView : NSView

@property (nonatomic, weak) IBOutlet id<GRAreaSelectionViewDelegate> delegate;

-(CGRect)selectedAreaForBounds:(CGRect)bounds;

@end


@protocol GRAreaSelectionViewDelegate <NSObject>

@property (nonatomic, readonly) NSUInteger maximumHorizontalFractions;
@property (nonatomic, readonly) NSUInteger maximumVerticalFractions;

@property (nonatomic, readonly) NSRange selectedHorizontalFractionRange;
@property (nonatomic, readonly) NSRange selectedVerticalFractionRange;

@property (nonatomic, readonly) NSUInteger selectedHorizontalFraction;
@property (nonatomic, readonly) NSUInteger selectedVerticalFraction;

@end