//
//  GRStatusItemController.h
//  Grid
//
//  Created by Rob Rix on 11-09-30.
//  Copyright 2011 Rob Rix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRStatusItemController : NSObject

@property (nonatomic, strong) IBOutlet NSMenu *statusItemMenu;
@property (nonatomic, assign, getter=isStatusItemEnabled) BOOL statusItemEnabled;

@end
