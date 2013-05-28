//
//  HEFTTimedProgressViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 23/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTTimedProgressViewController.h"

@interface HEFTTimedProgressViewController ()

@end

@implementation HEFTTimedProgressViewController

@synthesize logTextView = _logTextView;
@synthesize progressIndicator = _progressIndicator;
@synthesize startTimeField = _startTimeField;
@synthesize countDownField = _countDownField;
@synthesize pollingIntervalField = _pollingIntervalField;
@synthesize noTimerFiresField = _noTimerFiresField;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
