//
//  HEFTTimedProgressViewController.h
//  IQC Importer
//
//  Created by Craig Webster on 23/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HEFTTimedProgressViewController : NSViewController

@property IBOutlet NSTextView *logTextView;
@property IBOutlet NSProgressIndicator *progressIndicator;
@property IBOutlet NSTextField *startTimeField;
@property IBOutlet NSTextField *countDownField;
@property IBOutlet NSTextField *pollingIntervalField;
@property IBOutlet NSTextField *noTimerFiresField;

@end
