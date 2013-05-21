//
//  ConnectionController.h
//  Telepath - Connector
//
//  Created by Craig Webster on 26/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+NSDateCategory.h"
#import "HEFT_MetricsFunctions.h"
#import "HEFT_DatabaseFunctions.h"
#import <RHPreferences/RHPreferences.h>



@class HEFTImport_Controller;
@class HEFT_PreferenceController;

@interface ConnectionController : NSObject
{
    
    NSWindow *_window;
    RHPreferencesWindowController *_preferencesWindowController;
    HEFTImport_Controller *importController;

}

@property (retain) RHPreferencesWindowController *preferencesWindowController;
@property (retain) HEFTImport_Controller *importController;
@property IBOutlet NSToolbar *toolbarOutlet;
@property IBOutlet NSToolbarItem *preferencesToolBarItem;


-(IBAction)showPreferencePanel:(id)sender;



@end
