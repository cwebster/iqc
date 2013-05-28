//
//  HEFTAMSTimeImportPreferencesViewController.h
//  IQC Importer
//
//  Created by Craig Webster on 23/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RHPreferences/RHPreferences.h>
@class RHPreferencesWindowController;

@interface HEFTAMSTimeImportPreferencesViewController : NSViewController {
    NSTextField *timeIntervalTextField;
}

@property IBOutlet NSTextField *timeIntervalTextField;

// Preferences Methods
+(NSString *)preferenceTimeInterval;
+(void) setpreferenceTimeInterval:(NSString *)prefTime;


@end
