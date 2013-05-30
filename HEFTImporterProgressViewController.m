//
//  HEFTImporterProgressViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 22/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTImporterProgressViewController.h"
#import "HEFTAppDelegate.h"

@interface HEFTImporterProgressViewController ()

@end


@implementation HEFTImporterProgressViewController

@synthesize progressIndicator = _progressIndicator;
@synthesize statusText = _statusText;

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
        
        [_statusText setString:file];

    }
    
    return self;
}

-(void)updateStatusField:(NSString *)status{
    //Get Application support directory for writing log file to
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    NSURL *appsup = [appDelegate applicationDirectory];
    NSURL *bUrl = [appsup URLByAppendingPathComponent:@"fileimportlog.txt"];
    
    NSString *file = [NSString stringWithContentsOfURL:bUrl encoding:NSUTF8StringEncoding error:nil];
    
    if(!file) {
        
    }
    
    [_statusText setString:file];
}



@end
