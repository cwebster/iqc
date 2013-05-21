//
//  HEFT_MySQLPreferencesController.m
//  Quality Metrics
//
//  Created by Craig Webster on 06/11/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import "HEFT_MySQLPreferencesController.h"
#import "HEFTAppDelegate.h"
#import "HEFT_DatabaseFunctions.h"

@interface HEFT_MySQLPreferencesController ()

@end

@implementation HEFT_MySQLPreferencesController
@synthesize mySQLPasswordField,mySQLServerField,mySQLUsernameField, mySQLSchemaField;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"HEFT_MySQLPreferencesController" bundle:nibBundleOrNil];
    if (self){
              
        [mySQLServerField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLServer]];
        [mySQLUsernameField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLUsername]];
        [mySQLPasswordField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLPassword]];
        [mySQLSchemaField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLSchema]];
        
    }
    return self;
}

-(void)viewDidAppear{
    [mySQLServerField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLServer]];
    [mySQLUsernameField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLUsername]];
    [mySQLPasswordField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLPassword]];
    [mySQLSchemaField setStringValue:[HEFT_MySQLPreferencesController preferenceHEFTMySQLSchema]];
}

#pragma mark - RHPreferencesViewControllerProtocol

-(NSString*)identifier{
    return NSStringFromClass(self.class);
}
-(NSImage*)toolbarItemImage{
    return [NSImage imageNamed:@"Database"];
}
-(NSString*)toolbarItemLabel{
    return NSLocalizedString(@"My SQL Preferences", @"MySQLToolbarItemLabel");
}

-(NSView*)initialKeyView{
    
    return self.mySQLUsernameField;
    return self.mySQLServerField;
    return self.mySQLPasswordField;
    return self.mySQLSchemaField;
}

+(NSString *)preferenceHEFTMySQLServer{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mySQLServer = [defaults objectForKey:HEFTMySQLServer];
    return mySQLServer;
}

+(NSString *)preferenceHEFTMySQLUsername{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mySQLServerUserName = [defaults objectForKey:HEFTMySQLUsername];
    return mySQLServerUserName;
}

+(NSString *)preferenceHEFTMySQLPassword{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mySQLServerPassword = [defaults objectForKey:HEFTMySQLPassword];
    return mySQLServerPassword;
    
}

+(NSString *)preferenceHEFTMySQLSchema{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mySQLServerSchema = [defaults objectForKey:HEFTMySQLSchema];
    return mySQLServerSchema;
    
}

+(void) setPreferenceHEFTMySQLServer:(NSString *)mySQLServer{
    [[NSUserDefaults standardUserDefaults] setObject:mySQLServer forKey:HEFTMySQLServer];
}

+(void) setPreferenceHEFTMySQLUsername:(NSString *)mySQLServerUserName{
    [[NSUserDefaults standardUserDefaults] setObject:mySQLServerUserName forKey:HEFTMySQLUsername];
    
}

+(void) setPreferenceHEFTMySQLPassword:(NSString *)mySQLServerPassword{
    [[NSUserDefaults standardUserDefaults] setObject:mySQLServerPassword forKey:HEFTMySQLPassword];
    
}
+(void) setPreferenceHEFTMySQLSchema:(NSString *)mySQLServerSchema{
    [[NSUserDefaults standardUserDefaults] setObject:mySQLServerSchema forKey:HEFTMySQLSchema];
    
}


#pragma mark -
#pragma mark - ==== Button Click Actions ===
#pragma mark -

-(IBAction)setMySQLDefaults:(id)sender{
    NSString *sqlServer = [mySQLServerField stringValue];
    NSString *username = [mySQLUsernameField stringValue];
    NSString *password = [mySQLPasswordField stringValue];
    NSString *schema = [mySQLSchemaField stringValue];
    
    [HEFT_MySQLPreferencesController setPreferenceHEFTMySQLServer:sqlServer];
    [HEFT_MySQLPreferencesController setPreferenceHEFTMySQLUsername:username];
    [HEFT_MySQLPreferencesController setPreferenceHEFTMySQLPassword:password];
    [HEFT_MySQLPreferencesController setPreferenceHEFTMySQLSchema:schema];
}

-(IBAction)testMySQLConnection:(id)sender{
    
    HEFT_DatabaseFunctions *dbTest = [[HEFT_DatabaseFunctions alloc]init];
    
    if ( [dbTest connectMySQL]== YES) {
        NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OK" ofType:@"png"]];
        [mySQLConnectionStatus setImage:successImage];
    } else{
        NSImage *failImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No" ofType:@"png"]];
        [mySQLConnectionStatus setImage:failImage];
    }

}



@end