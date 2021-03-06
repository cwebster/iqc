//
//  HEFTMainWindowController.h
//  IQC Importer
//
//  Created by Craig Webster on 20/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RHPreferences/RHPreferences.h>

@class HEFTAboutWindowController;
@class HEFTDefaultStatusViewController;
@class RMSkinnedView;

@interface HEFTMainWindowController : NSWindowController {
    RHPreferencesWindowController *_preferencesWindowController;
   
}

@property (assign) IBOutlet NSToolbar *toolbarOutlet;
@property (assign) IBOutlet NSToolbarItem *preferencesToolBarItem;
@property (assign) IBOutlet NSToolbarItem *preferencesStartTimedImport;
@property (assign) IBOutlet NSToolbarItem *preferencesStopTimedImport;
@property (assign) IBOutlet NSToolbarItem *preferencesImportDirectory;
@property (assign) IBOutlet NSToolbarItem *preferencesImportFile;

@property (assign) IBOutlet NSTextField *amsServerUrlLabel;
@property (assign) IBOutlet NSImageView *amsServerStausImage;
@property (assign) IBOutlet NSImageView *sqlServerStatusImage;

@property (weak) IBOutlet RMSkinnedView *statusView;
@property (strong) HEFTDefaultStatusViewController * statusViewController;
@property (retain) RHPreferencesWindowController *preferencesWindowController;
@property (strong) HEFTAboutWindowController *aboutWindowController;
@property (strong) NSTimer *pollingTimer;
@property (assign) int fireCount;
@property (strong) IBOutlet NSWindow *mainWindow;
@property (assign) IBOutlet NSProgressIndicator *circularProgressIndicator;


// Button Actions
-(IBAction)importQCbyDirectory:(id)sender;
-(IBAction)importQCbySelectingFiles:(id)sender;
-(IBAction)showPreferencePanel:(id)sender;
-(IBAction)timedImport:(id)sender;
-(IBAction)stopTimedImport:(id)sender;
-(IBAction)quit:(id)sender;
-(IBAction)about:(id)sender;

// Test server connections
-(void)testMySQLConnection;
-(BOOL)mountAMSServer;

// Importer functions
-(void)importFiles:(NSArray *)selectedFiles;
-(NSDictionary *)getImportedFileNames;


@end
