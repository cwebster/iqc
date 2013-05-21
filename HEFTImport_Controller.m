//
//  HEFTImport_Controller.m
//  Quality Metrics V1
//
//  Created by Craig Webster on 15/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTImport_Controller.h"

@implementation HEFTImport_Controller

@synthesize importController, selectedFiles, myProgressIndicator;

-(id)init
{
    if(![super initWithWindowNibName:@"HEFTImportWindow"])
        return nil;
    
    return self;
}

- (void)awakeFromNib;
{
    // Hook up the static progress indicator to our local one
    // that is connected in IB. This will allows us to update
    // the progress indicator in the callback.
    
    

      
}


- (void)windowDidLoad {
    [super windowDidLoad];
    NSLog(@"Nib file is loaded");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSInteger count = [self.selectedFiles count];
    
    NSString *statusString = [NSString stringWithFormat:@"Importing: %ld", (long)count];
    
    [importStatus setStringValue:statusString];
    [importStatus display];
    [myProgressIndicator startAnimation:self];
 
}


@end
