//
//  HEFTImport_Controller.h
//  Quality Metrics V1
//
//  Created by Craig Webster on 15/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>




@interface HEFTImport_Controller : NSWindowController {

    IBOutlet NSTextField *importStatus;
    
}


@property (retain) HEFTImport_Controller *importController;
@property NSArray *selectedFiles;
@property NSProgressIndicator *myProgressIndicator;




@end
