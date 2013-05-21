//
//  HEFT_MySQLPreferencesController.h
//  Quality Metrics
//
//  Created by Craig Webster on 06/11/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RHPreferences/RHPreferences.h>
@class RHPreferencesWindowController;

@interface HEFT_MySQLPreferencesController : NSViewController <RHPreferencesViewControllerProtocol> {
    NSSecureTextField *mySQLPasswordField;
    NSTextField *mySQLUsernameField;
    NSTextField *mySQLServerField;
    NSTextField *mySQLSchemaField;
    
    IBOutlet NSImageView* mySQLConnectionStatus;


}

@property IBOutlet NSTextField *mySQLUsernameField;
@property IBOutlet NSTextField *mySQLServerField;
@property IBOutlet NSSecureTextField *mySQLPasswordField;
@property IBOutlet NSTextField *mySQLSchemaField;

//Actions
-(IBAction)setMySQLDefaults:(id)sender;
-(IBAction)testMySQLConnection:(id)sender;

// Preferences Methods
+(NSString *)preferenceHEFTMySQLServer;
+(NSString *)preferenceHEFTMySQLUsername;
+(NSString *)preferenceHEFTMySQLPassword;
+(NSString *)preferenceHEFTMySQLSchema;

+(void) setPreferenceHEFTMySQLServer:(NSString *)mySQLServer;
+(void) setPreferenceHEFTMySQLUsername:(NSString *)mySQLServerUserName;
+(void) setPreferenceHEFTMySQLPassword:(NSString *)mySQLServerPassword;
+(void) setPreferenceHEFTMySQLSchema:(NSString *)mySQLServerSchema;

@end
