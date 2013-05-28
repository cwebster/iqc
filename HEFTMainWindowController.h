//
//  HEFTMainWindowController.h
//  IQC Importer
//
//  Created by Craig Webster on 20/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RHPreferences/RHPreferences.h>

@class HEFTImporterProgressViewController;

@interface HEFTMainWindowController : NSWindowController {
    RHPreferencesWindowController *_preferencesWindowController;
   
}

@property (assign) IBOutlet NSToolbar *toolbarOutlet;
@property (assign) IBOutlet NSToolbarItem *preferencesToolBarItem;
@property (assign) IBOutlet NSTextField *amsServerUrlLabel;
@property (assign) IBOutlet NSImageView *amsServerStausImage;
@property (assign) IBOutlet NSImageView *sqlServerStatusImage;

@property (weak) IBOutlet NSView *statusView;
@property (strong) NSViewController * statusViewController;
@property (retain) RHPreferencesWindowController *preferencesWindowController;

@property (strong) NSTimer *pollingTimer;
@property (assign) int fireCount;

-(void)testMySQLConnection;
-(BOOL)mountAMSServer;
-(IBAction)importQCbyDirectory:(id)sender;
-(IBAction)importQCbySelectingFiles:(id)sender;
-(IBAction)showPreferencePanel:(id)sender;
-(IBAction)timedImport:(id)sender;
-(IBAction)stopTimedImport:(id)sender;

-(void)importFiles:(NSArray *)selectedFiles;
-(NSDictionary *)getImportedFileNames;


@end
