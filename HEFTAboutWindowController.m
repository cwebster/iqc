//
//  HEFTAboutWindowController.m
//  IQC Importer
//
//  Created by Craig Webster on 30/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTAboutWindowController.h"

@interface HEFTAboutWindowController ()

@end

@implementation HEFTAboutWindowController

@synthesize aboutText;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
        NSBundle * myMainBundle = [NSBundle mainBundle];
        NSString * rtfFilePath = [myMainBundle pathForResource:@"about" ofType:@"rtf"];
        [aboutText readRTFDFromFile:rtfFilePath];
        
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSBundle * myMainBundle = [NSBundle mainBundle];
    NSString * rtfFilePath = [myMainBundle pathForResource:@"about" ofType:@"rtf"];
    [aboutText readRTFDFromFile:rtfFilePath];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
