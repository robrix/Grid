// GRWindowUIElement.h
// Created by Rob Rix on 2009-05-28
// Copyright 2009 Monochrome Industries

@interface GRWindowUIElement : NSObject {
	AXUIElementRef windowRef;
}

@property (nonatomic, assign) AXUIElementRef windowRef;

@property (nonatomic, assign) CGRect frame;

@end