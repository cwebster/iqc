//
//  HEFTAMSSharePreferencesViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 17/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTAMSSharePreferencesViewController.h"
#import "HEFTAppDelegate.h"

@interface HEFTAMSSharePreferencesViewController ()

@end

@implementation HEFTAMSSharePreferencesViewController
@synthesize amsServerUrlField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"HEFTAMSServerPreferencesView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        [amsServerUrlField setStringValue:[HEFTAMSSharePreferencesViewController preferenceHEFTAMSServer]];
    }
    
    return self;
}

-(void)viewDidAppear{
    [amsServerUrlField setStringValue:[HEFTAMSSharePreferencesViewController preferenceHEFTAMSServer]];

}

#pragma mark - RHPreferencesViewControllerProtocol

-(NSString*)identifier{
    return NSStringFromClass(self.class);
}
-(NSImage*)toolbarItemImage{
    return [NSImage imageNamed:@"Database"];
}
-(NSString*)toolbarItemLabel{
    return NSLocalizedString(@"AMS Server Preferences", @"AMSoolbarItemLabel");
}

-(NSView*)initialKeyView{
    
    return self.amsServerUrlField;
}


//Actions
-(IBAction)setAMSServerDefaults:(id)sender{
    NSString *amsServer = [amsServerUrlField stringValue];
    
    [HEFTAMSSharePreferencesViewController setPreferenceHEFTAMSServer:amsServer];

}


-(IBAction)testAMSServerConnection:(id)sender{
    NSImage *checkingImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OK" ofType:@"png"]];

    [amsServerStatus setHidden:YES];
    [amsServerStatus setImage:checkingImage];
    
    [self pollAMSServer];
    
}

-(void)pollAMSServer {
    
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    if (appDelegate.mountPointofAMSServer !=NULL) {
        NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OK" ofType:@"png"]];
        [amsServerStatus setImage:successImage];
        
        NSLog(@"AMS Server Mounted");
    }else{
        
        NSImage *failImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No" ofType:@"png"]];
        [amsServerStatus setImage:failImage];
    }
    [amsServerStatus setHidden:NO];
    
}

// Preferences Methods
+(NSString *)preferenceHEFTAMSServer{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *amsServer = [defaults objectForKey:AMSServerUrl];
    return amsServer;
}

+(void) setPreferenceHEFTAMSServer:(NSString *)amsServer{
    [[NSUserDefaults standardUserDefaults] setObject:amsServer forKey:AMSServerUrl];
}

@end
