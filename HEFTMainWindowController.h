//
//  HEFTMainWindowController.h
//  IQC Importer
//
//  Created by Craig Webster on 20/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HEFTImport_Controller;

@interface HEFTMainWindowController : NSWindowController {
    HEFTImport_Controller *importController;
}

@property IBOutlet NSToolbar *toolbarOutlet;
@property IBOutlet NSToolbarItem *preferencesToolBarItem;
@property IBOutlet NSTextField *amsServerUrlLabel;
@property IBOutlet NSImageView *amsServerStausImage;
@property IBOutlet NSImageView *sqlServerStatusImage;


-(void)testMySQLConnection;
-(BOOL)mountAMSServer;
-(IBAction)importQCbyDirectory:(id)sender;
-(IBAction)importQCbySelectingFiles:(id)sender;


@end
