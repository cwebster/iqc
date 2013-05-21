//
//  HEFTAMSSharePreferencesViewController.h
//  IQC Importer
//
//  Created by Craig Webster on 17/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RHPreferences/RHPreferences.h>
@class RHPreferencesWindowController;

@interface HEFTAMSSharePreferencesViewController : NSViewController <RHPreferencesViewControllerProtocol> {
    
    NSTextField *amsServerUrlField;
    
    IBOutlet NSImageView* amsServerStatus;

}

@property IBOutlet NSTextField *amsServerUrlField;

//Actions
-(IBAction)setAMSServerDefaults:(id)sender;
-(IBAction)testAMSServerConnection:(id)sender;
-(void)pollAMSServer;

// Preferences Methods
+(NSString *)preferenceHEFTAMSServer;


+(void) setPreferenceHEFTAMSServer:(NSString *)amsServer;


@end
