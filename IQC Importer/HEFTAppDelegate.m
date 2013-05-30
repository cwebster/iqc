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
@synthesize applicationSupportDirectory = _applicationSupportDirectory;

+ (void)initialize
{
    
    //set up user defaults
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:[NSString stringWithFormat:@"localhost"] forKey:HEFTMySQLServer];
    [defaultValues setObject:[NSString stringWithFormat:@"root"] forKey:HEFTMySQLUsername];
    [defaultValues setObject:[NSString stringWithFormat:@"de117gx"] forKey:HEFTMySQLPassword];
    [defaultValues setObject:[NSString stringWithFormat:@"qc"] forKey:HEFTMySQLSchema];
    [defaultValues setObject:[NSString stringWithFormat:@"smb://ams-server/ams/qc"] forKey:AMSServerUrl];
    [defaultValues setObject:[NSString stringWithFormat:@"5"] forKey:importTimeInterval];
    [defaultValues setObject:[NSString stringWithFormat:@"imported_files"] forKey:HEFTMySQLImportTableName];
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];                 
    [prefs registerDefaults:defaultValues];
    
    NSLog(@"Registered User defaults: %@", defaultValues);
    

    
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.myMainWindowController = [[HEFTMainWindowController alloc]
                                initWithWindowNibName:@"HEFTIQCMainWIndow"];
    [self.myMainWindowController showWindow:self];
    
    _applicationSupportDirectory = [self applicationDirectory];
    
    
    NSDate *currentDate = [NSDate date];
    
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:currentDate
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterFullStyle];
    
    
    NSFileHandle *aFileHandle;
    
    NSURL *bUrl = [_applicationSupportDirectory URLByAppendingPathComponent:@"fileimportlog.txt"];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[bUrl path]])  //Optionally check if folder already hasn't existed.
    {
        [[NSFileManager defaultManager] createFileAtPath:[bUrl path] contents:nil attributes:nil];
    }
    
    aFileHandle = [NSFileHandle fileHandleForWritingToURL:bUrl error:&error];
    
    [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
    
    NSString *s = [NSString stringWithFormat:@"\nApplication Launched: %@\n", dateStr];
    
    [aFileHandle writeData:[s dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
    
    
    
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
