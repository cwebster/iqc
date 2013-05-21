//
//  ConnectionController.m
//  Telepath - Connector
//
//  Created by Craig Webster on 26/03/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ConnectionController.h"
#import "HEFT_MySQLPreferencesController.h"
#import "HEFTImport_Controller.h"
#import "HEFTAMSSharePreferencesViewController.h"
#import "HEFTAboutViewController.h"


@implementation ConnectionController

@synthesize importController;

- (id)init
{
    self = [super init];
    if (self) {
        HEFTAMSSharePreferencesViewController *testAMS = [[HEFTAMSSharePreferencesViewController alloc]init];
        [testAMS pollAMSServer];
        
    }
    
    return self;
}

#pragma mark -
#pragma mark === Preference Controllers etc ===
#pragma mark -

-(IBAction)showPreferencePanel:(id)sender{
    //if we have not created the window controller yet, create it now
    if (!_preferencesWindowController){
        HEFT_MySQLPreferencesController *mySQL = [[HEFT_MySQLPreferencesController alloc] init];
        HEFTAMSSharePreferencesViewController *ams = [[HEFTAMSSharePreferencesViewController alloc]init];
        HEFTAboutViewController *about = [[HEFTAboutViewController alloc] init];
        
        
        NSArray *controllers = [NSArray arrayWithObjects:mySQL, ams, about, nil];
        
        _preferencesWindowController = [[RHPreferencesWindowController alloc] initWithViewControllers:controllers andTitle:NSLocalizedString(@"Preferences", @"Preferences Window Title")];
    }
    
    [_preferencesWindowController showWindow:self];

}




@end
