//
//  HEFTDefaultStatusViewController.h
//  IQC Importer
//
//  Created by Craig Webster on 30/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class RMSkinnedView;

@interface HEFTDefaultStatusViewController : NSViewController

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSTextField *statusText;
@property (assign) IBOutlet NSProgressIndicator *indeterminateProgressIndicator;
@property (assign) IBOutlet NSTextField *startTimeField;
@property (assign) IBOutlet NSTextField *pollingIntervalField;
@property (assign) IBOutlet NSTextField *countDownField;
@property (assign) IBOutlet NSTextField *noTimerFiresField;
@property (assign) IBOutlet RMSkinnedView *skinnedView;


@end
