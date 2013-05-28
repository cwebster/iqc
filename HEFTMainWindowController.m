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
#import "HEFTImporterProgressViewController.h"
#import "HEFT_MySQLPreferencesController.h"
#import "HEFTAMSSharePreferencesViewController.h"
#import "HEFTAboutViewController.h"
#import "HEFTAMSTimeImportPreferencesViewController.h"
#import "HEFTTimedProgressViewController.h"


@interface HEFTMainWindowController ()

@end

@implementation HEFTMainWindowController

@synthesize toolbarOutlet, preferencesToolBarItem, amsServerUrlLabel, amsServerStausImage, sqlServerStatusImage;
@synthesize statusView = _statusView;
@synthesize statusViewController = _statusViewController;
@synthesize pollingTimer = _pollingTimer;
@synthesize fireCount = _fireCount;


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
    
    // try and mount the AMS server
    [self mountAMSServer];
    
    //set the checking images for the SQL and AMS server check boxes
    
    NSImage *checkingImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Warning-UI" ofType:@"PNG"]];
    
    [amsServerStausImage setImage:checkingImage];
    [sqlServerStatusImage setImage:checkingImage];
    
    //try and connect to the SQL server
    [self testMySQLConnection];

}


-(IBAction)showPreferencePanel:(id)sender{
    //if we have not created the window controller yet, create it now
    if (!_preferencesWindowController){
        HEFT_MySQLPreferencesController *mySQL = [[HEFT_MySQLPreferencesController alloc] init];
        HEFTAMSSharePreferencesViewController *ams = [[HEFTAMSSharePreferencesViewController alloc]init];
        HEFTAboutViewController *about = [[HEFTAboutViewController alloc] init];
        HEFTAMSTimeImportPreferencesViewController *amsTimedPreferences = [[HEFTAMSTimeImportPreferencesViewController alloc]init];
        
        
        NSArray *controllers = [NSArray arrayWithObjects:mySQL, ams, amsTimedPreferences, about, nil];
        
        _preferencesWindowController = [[RHPreferencesWindowController alloc] initWithViewControllers:controllers andTitle:NSLocalizedString(@"Preferences", @"Preferences Window Title")];
    }
    
    [_preferencesWindowController showWindow:self];
    
}


-(BOOL)mountAMSServer{
    
    // get appdelegate reference
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    
    // get the user defaults to connect to the AMS server
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
                                         
                                         NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Checkmark-UI" ofType:@"PNG"]];
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
    
    // Create a DB Functions object
    
    HEFT_DatabaseFunctions *dbTest = [[HEFT_DatabaseFunctions alloc]init];
    
    
    // Try and connect to mySQL server
    
    if ( [dbTest connectMySQL] != Nil) {
        NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Checkmark-UI" ofType:@"PNG"]];
        [sqlServerStatusImage setImage:successImage];
    } else{
        NSImage *failImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Warning-UI" ofType:@"PNG"]];
        [sqlServerStatusImage setImage:failImage];
    }
    
}

-(IBAction)importQCbyDirectory:(id)sender{
    // this function imports all files found the AMS mount point directory
    
    // get the files in that directory
    HEFT_fileutils *files = [[HEFT_fileutils alloc]init];
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    NSArray *selectedFiles = [files getFilesInDirectory:appDelegate.mountPointofAMSServer];
  
    // import those files
    [self importFiles:selectedFiles];

}

-(IBAction)importQCbySelectingFiles:(id)sender{
    
    //Select CSV file from file system
    
	HEFT_fileutils *files = [[HEFT_fileutils alloc]init];
    NSArray *selectedFiles = [files selectFiles];
    
    // import those files
    [self importFiles:selectedFiles];
    
}


-(IBAction)timedImport:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *timeInterval = [defaults objectForKey:importTimeInterval];
    
    _fireCount =0;
    [self timeImportLogUpdate];
    
    double time = [timeInterval doubleValue]*60;
    
    NSLog(@"timer interval: %f", time);
    
    _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    
    
    
}

-(void)timeImportLogUpdate{
    // Set up status view to display progress of import
    
    [[_statusViewController view]removeFromSuperview];
    
    HEFTTimedProgressViewController *vc = [[HEFTTimedProgressViewController alloc]initWithNibName:@"HEFTTimedProgressViewController" bundle:nil];
    _statusViewController = vc;
    
    [_statusView addSubview:[vc view]];
    [[vc view]setFrame:[_statusView bounds]];
    [[vc view]setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    [[vc progressIndicator] setHidden:NO];
    [[vc progressIndicator] startAnimation:self ];
    [[vc logTextView] setString:@"Started timer"];
    
    
    //set start date
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    
    [[vc startTimeField] setStringValue:dateString];
    
    // Get prefs for polling interval
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *prefTime = [defaults objectForKey:importTimeInterval];
    
    [[vc pollingIntervalField] setStringValue:prefTime];
    
    
    NSDate *currentDate = [NSDate date];
    NSDate *datePlusPollInterval = [currentDate dateByAddingTimeInterval:60*[prefTime doubleValue]];
    
    NSString *pollIntervalStr = [NSDateFormatter localizedStringFromDate:datePlusPollInterval
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterFullStyle];
    
    [[vc countDownField] setStringValue:pollIntervalStr];
    
    NSString *str;
    str = [NSString stringWithFormat:@"%d",_fireCount];
    
    [[vc noTimerFiresField]setStringValue:str];
    
    
}

- (void)timerTicked:(NSTimer*)timer {
    _fireCount++;
    NSLog(@"fire count: %d", _fireCount);
    [self timeImportLogUpdate];
    [self importQCbyDirectory:self];

}

-(IBAction)stopTimedImport:(id)sender{
    [_pollingTimer invalidate];
    _pollingTimer = nil;
}


-(void)importFiles:(NSArray *)selectedFiles{
    
    // Set up status view to display progress of import
    
    [[_statusViewController view]removeFromSuperview];
    
    HEFTImporterProgressViewController *vc = [[HEFTImporterProgressViewController alloc]initWithNibName:@"HEFTImporterProgressViewController" bundle:nil];
    _statusViewController = vc;
    
    [_statusView addSubview:[vc view]];
    [[vc view]setFrame:[_statusView bounds]];
    [[vc view]setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    
    [[vc progressIndicator]setMaxValue:[selectedFiles count]];
    
    // Get list of already imported filenames
    NSDictionary *alreadyImportedFile = [self getImportedFileNames];
    
    // Database functions class provides MYSQL connection and select and insert functions
    HEFT_DatabaseFunctions *dbFunctions = [[HEFT_DatabaseFunctions alloc]init];
    
    //get a database connection
    MysqlConnection *connection = [dbFunctions connectMySQL];
    
    if (connection==nil) {
        NSLog(@"Connection is nil");
    }
    
    double count = 0;
    
    [[vc progressIndicator] setHidden:NO];
    
    [[vc progressIndicator]setDoubleValue:count];
    
    // run whole loop in thread using GCD so UI can be updated
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSEnumerator *e = [selectedFiles objectEnumerator];
        id object;
        
        double count = 0;
        
        [[vc progressIndicator] setHidden:NO];
        
        [[vc progressIndicator]setDoubleValue:count];
        
        while (object = [e nextObject]) {
            
            // Importer functions class creates CSV file and imports it into database
            HEFTImporterFunctions *importer = [[HEFTImporterFunctions alloc]init];
            
            // do something with object
            //have we imported file before?
            
            if ([alreadyImportedFile objectForKey:[object absoluteString]]) {
                // dont import file, its already been done
                
            } else{
                
                // go ahead and import the filw
                NSLog(@"Import File");
                NSString *statText = [[NSString alloc]initWithFormat:@"Importing file: %@", [object absoluteString]];
                NSLog(@"Import File: %@", statText);
                [vc updateStatusField:statText];
                [[vc view]needsDisplay];
                
                if ([importer importCSVFile:object mySQLConnection:connection] == YES) {
                    NSLog(@"Successful Import");
                    
                    //log successful import
                    [dbFunctions logImportedFiles:[object absoluteString] mysqlConnection:connection];
                    
                } else {
                    // There's been an import problem
                    NSLog(@"Import Problem");
                }
            }
            
            count++;
            
            //update the UI
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[vc progressIndicator]setDoubleValue:count];
                NSString *statText = [[NSString alloc]initWithFormat:@"Importing file: %@", [object absoluteString]];
                [vc updateStatusField:statText];
            });
            
            importer = nil;
        }
    });
    
    [[vc progressIndicator] setHidden:YES];
    [vc updateStatusField:@"Import Done"];
}

-(NSDictionary *)getImportedFileNames{
    
    //get a database functions object
    HEFT_DatabaseFunctions *datebase = [[HEFT_DatabaseFunctions alloc]init];
    
    //get a database connection  --- May need to put in some error checking here
    MysqlConnection *connection = [datebase connectMySQL];
    
    
    // create SQL string to select file namges
    NSString *sql = @"select * from imported_files";
    
    
    //run the sql query which will return an array of filenames
    NSArray *returnedFiles = [datebase runMySQLSelectQuery:sql mysqlConnection:connection];
    
    //for performance purposese - create a dicitonary from the array
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for(int i=0; i<[returnedFiles count]; i++){
        
        NSDictionary *val =  [returnedFiles objectAtIndex:i];
        NSString *filename = [val valueForKey:@"filename"];
        
        [dic setObject:filename forKey:filename];
    }

    connection = nil;
    
    //return a dictionary of filenames with keys of filename
    return dic;
}


@end
