//
//  HEFTAppDelegate.m
//  IQC Importer
//
//  Created by Craig Webster on 15/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTAppDelegate.h"
#import <Foundation/Foundation.h>
#import "HEFTMainWindowController.h"

@implementation HEFTAppDelegate

@synthesize mountPointofAMSServer, myMainWindowController;

+ (void)initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:[NSString stringWithFormat:@"localhost"] forKey:HEFTMySQLServer];
    [defaultValues setObject:[NSString stringWithFormat:@"root"] forKey:HEFTMySQLUsername];
    [defaultValues setObject:[NSString stringWithFormat:@"de117gx"] forKey:HEFTMySQLPassword];
    [defaultValues setObject:[NSString stringWithFormat:@"qc"] forKey:HEFTMySQLSchema];
    [defaultValues setObject:[NSString stringWithFormat:@"smb://ams-server/ams/qc"] forKey:AMSServerUrl];
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];                  // c
    [prefs registerDefaults:defaultValues];
    
    NSLog(@"Registered User defaults: %@", defaultValues);
    
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.myMainWindowController = [[HEFTMainWindowController alloc]
                                initWithWindowNibName:@"HEFTIQCMainWIndow"];
    [self.myMainWindowController showWindow:self];
    
    
}


- (NSURL*)applicationDirectory
{
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager*fm = [NSFileManager defaultManager];
    NSURL*    dirPath = nil;
    
    // Find the application support directory in the home directory.
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        // Append the bundle ID to the URL for the
        // Application Support directory
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        // If the directory does not exist, this method creates it.
        // This method call works in OS X 10.7 and later only.
        NSError*    theError = nil;
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                           attributes:nil error:&theError])
        {
            // Handle the error.
            
            return nil;
        }
    }
    
    return dirPath;
}

@end
