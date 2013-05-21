//
//  HEFTMainWindowController.m
//  IQC Importer
//
//  Created by Craig Webster on 20/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTMainWindowController.h"
#import "HEFTAppDelegate.h"
#import "HEFT_DatabaseFunctions.h"
#import "HEFT_fileutils.h"
#import "HEFTImporterFunctions.h"

#import "HEFTImport_Controller.h"

@interface HEFTMainWindowController ()

@end

@implementation HEFTMainWindowController

@synthesize toolbarOutlet, preferencesToolBarItem, amsServerUrlLabel, amsServerStausImage, sqlServerStatusImage;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
        

    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // Set up tool bar items
    
    [self mountAMSServer];
    
    NSImage *checkingImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Application" ofType:@"png"]];
    
    [amsServerStausImage setImage:checkingImage];
    [sqlServerStatusImage setImage:checkingImage];
    [self testMySQLConnection];

}


-(BOOL)mountAMSServer{
    
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *amsServer = [defaults objectForKey:AMSServerUrl];
    
    // Mounts ams seerver via SMB
  
    
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *mountPath = [appDelegate applicationDirectory];
    
    
    NSError*    theError = nil;
    NSURL* dirPath = [mountPath URLByAppendingPathComponent:@"qc"];
    
    if (![fileManager createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                                attributes:nil error:&theError])
    {
        // Handle the error.
        return NO;
        
    }
    
    // self.mountPointofAMSServer = dirPath;
    
    CFURLRef volumeURL = (__bridge CFURLRef)[NSURL URLWithString:amsServer];
    CFURLRef mountURL = (__bridge CFURLRef)dirPath;
    
    AsyncRequestID requestID = NULL;
    dispatch_queue_t queue = dispatch_get_current_queue();
    
    OSStatus err= NetFSMountURLAsync(volumeURL, mountURL, CFSTR("username"),
                                     CFSTR("password"), NULL, NULL,
                                     &requestID,
                                     queue, ^(int status, AsyncRequestID requestID, CFArrayRef mountpoints) {
                                         
                                         NSArray *fp = [(__bridge NSArray *) mountpoints mutableCopy];
                                         NSString *urlstr = [fp objectAtIndex:0];
                                         
                                         NSURL *url =[NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                         
                                         appDelegate.mountPointofAMSServer = url;
                                         
                                         if (url != Nil) {
                                             [amsServerUrlLabel setStringValue:[url absoluteString]];
                                         }
                                         
                                         NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OK" ofType:@"png"]];
                                         [amsServerStausImage setImage:successImage];
                                         
                                         NSLog(@"mounted url: %@", url);
                                     });
    
    if(err != noErr){
        NSLog( @"some kind of error in FSMountServerVolumeSync - %d", err );
        return NO;
    }
    
    return YES;
    
}


-(void)testMySQLConnection{
    
    HEFT_DatabaseFunctions *dbTest = [[HEFT_DatabaseFunctions alloc]init];
    
    if ( [dbTest connectMySQL]== YES) {
        NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OK" ofType:@"png"]];
        [sqlServerStatusImage setImage:successImage];
    } else{
        NSImage *failImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"No" ofType:@"png"]];
        [sqlServerStatusImage setImage:failImage];
    }
    
}

-(IBAction)importQCbyDirectory:(id)sender{
    
    //is import panel open?
    if (!importController){
        importController = [[HEFTImport_Controller alloc]init];
    }
    [importController showWindow:self];
    
    HEFTImporterFunctions *importer = [[HEFTImporterFunctions alloc]init];
    
    HEFT_fileutils *files = [[HEFT_fileutils alloc]init];
    
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    NSArray *selectedFiles = [files getFilesInDirectory:appDelegate.mountPointofAMSServer];
    importController.selectedFiles = selectedFiles;
    [importer importQCdata:selectedFiles];
    [importController close];
}

-(IBAction)importQCbySelectingFiles:(id)sender{
    
    //is import panel open?
    if (!importController){
        importController = [[HEFTImport_Controller alloc]init];
    }
    
    
    HEFTImporterFunctions *importer = [[HEFTImporterFunctions alloc]init];
    
    //Select CSV file
    
	HEFT_fileutils *files = [[HEFT_fileutils alloc]init];
    
    NSArray *selectedFiles = [files selectFiles];
    importController.selectedFiles = selectedFiles;
    
    [importController showWindow:self];
    
    [importController.myProgressIndicator startAnimation:self];
	
	[importer importQCdata:selectedFiles];
    
    [importController close];
    
}

@end
