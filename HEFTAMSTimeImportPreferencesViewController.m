//
//  HEFTAMSTimeImportPreferencesViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 23/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTAMSTimeImportPreferencesViewController.h"

@interface HEFTAMSTimeImportPreferencesViewController ()

@end

@implementation HEFTAMSTimeImportPreferencesViewController

@synthesize timeIntervalTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"HEFTAMSTimeImportPreferencesViewController" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        [timeIntervalTextField setStringValue:[HEFTAMSTimeImportPreferencesViewController preferenceTimeInterval]];
    }
    
    return self;
}

-(void)viewDidAppear{
    [timeIntervalTextField setStringValue:[HEFTAMSTimeImportPreferencesViewController preferenceTimeInterval]];

}


#pragma mark - RHPreferencesViewControllerProtocol

-(NSString*)identifier{
    return NSStringFromClass(self.class);
}
-(NSImage*)toolbarItemImage{
    return [NSImage imageNamed:@"Alarm-UI"];
}
-(NSString*)toolbarItemLabel{
    return NSLocalizedString(@"AMS Timed Preferences", @"AMSTimedPreferences");
}

-(NSView*)initialKeyView{
    
    return nil;
}


// Preferences Methods
+(NSString *)preferenceTimeInterval{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *prefTime = [defaults objectForKey:importTimeInterval];
    return prefTime;
}

+(void) setpreferenceTimeInterval:(NSString *)prefTime{
    [[NSUserDefaults standardUserDefaults] setObject:prefTime forKey:importTimeInterval];
}

-(IBAction)setTimerDefaults:(id)sender{
    NSString *timerInterval = [timeIntervalTextField stringValue];
    
    [HEFTAMSTimeImportPreferencesViewController setpreferenceTimeInterval:timerInterval];

}


@end
