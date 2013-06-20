//
//  HEFTDefaultStatusViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 30/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTDefaultStatusViewController.h"
#import "RMSkinnedView.h"

@interface HEFTDefaultStatusViewController ()

@end

@implementation HEFTDefaultStatusViewController

@synthesize progressIndicator = _progressIndicator;
@synthesize statusText = _statusText;
@synthesize indeterminateProgressIndicator = _indeterminateProgressIndicator;
@synthesize startTimeField = _startTimeField;
@synthesize pollingIntervalField = _pollingIntervalField;
@synthesize countDownField = _countDownField;
@synthesize noTimerFiresField = _noTimerFiresField;
@synthesize skinnedView = _skinnedView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [_statusText setStringValue:@"Import Started"];
        [_skinnedView setColorString:@"255,128,0,0.5"];
    }
    
    return self;
}

@end
