// GRApplicationUIElement.h
// Created by Rob Rix on 2009-05-28
// Copyright 2009 Monochrome Industries

@class GRWindowUIElement;

@interface GRApplicationUIElement : NSObject {
	AXUIElementRef applicationRef;
}

+(GRApplicationUIElement *)focusedApplication;

@property (nonatomic, readonly) GRWindowUIElement *mainWindow;

@property (nonatomic, assign) AXUIElementRef applicationRef;

@end