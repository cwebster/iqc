//
//  HEFTImporterProgressViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 22/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTImporterProgressViewController.h"

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
    }
    
    return self;
}

-(void)updateStatusField:(NSString *)status{
    [_statusText setStringValue:status];
}

@end
