//
//  HEFTAppDelegate.h
//  IQC Importer
//
//  Created by Craig Webster on 15/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NetFS/NetFS.h>
#import <Foundation/Foundation.h>
@class HEFTMainWindowController;


@interface HEFTAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSURL *mountPointofAMSServer;
@property (retain) HEFTMainWindowController *myMainWindowController;
@property (assign) IBOutlet NSTextField *amsServerUrlLabel;
@property (retain) NSURL *applicationSupportDirectory;

- (NSURL*)applicationDirectory;

@end
