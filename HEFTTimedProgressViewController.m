//
//  HEFTTimedProgressViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 23/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTTimedProgressViewController.h"
#import "HEFTAppDelegate.h"

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
        
        //Get Application support directory for writing log file to
        HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
        
        NSURL *appsup = [appDelegate applicationDirectory];
        NSURL *bUrl = [appsup URLByAppendingPathComponent:@"fileimportlog.txt"];
        
        NSString *file = [NSString stringWithContentsOfURL:bUrl encoding:NSUTF8StringEncoding error:nil];
        
        if(!file) {
            
        }
        
        [_logTextView setString:file];
    }
    
    return self;
}

@end
