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
#import "StatHat.h"
#import "HEFTAboutWindowController.h"


@interface HEFTMainWindowController ()

@end

@implementation HEFTMainWindowController

@synthesize toolbarOutlet, preferencesToolBarItem, amsServerUrlLabel, amsServerStausImage, sqlServerStatusImage;
@synthesize statusView = _statusView;
@synthesize statusViewController = _statusViewController;
@synthesize pollingTimer = _pollingTimer;
@synthesize fireCount = _fireCount;
@synthesize aboutWindowController = _aboutWindowController;


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
    
    NSImage *checkingImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"binoculars@2x" ofType:@"png"]];
    
    [amsServerStausImage setImage:checkingImage];
    [sqlServerStatusImage setImage:checkingImage];
    
    //try and connect to the SQL server
    [self testMySQLConnection];
    
    
    //add a default view to status area
    
    [[_statusViewController view]removeFromSuperview];
    
    HEFTTimedProgressViewController *vc = [[HEFTTimedProgressViewController alloc]initWithNibName:@"HEFTDefaultStatusViewController" bundle:nil];
    _statusViewController = vc;
    
    [_statusView addSubview:[vc view]];
    [[vc view]setFrame:[_statusView bounds]];
    [[vc view]setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

}

#pragma mark -
#pragma mark - ==== IBActions ===
#pragma mark -

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

-(IBAction)quit:(id)sender{
    [[NSApplication sharedApplication] terminate:nil];
    
}

-(IBAction)about:(id)sender{
    
    if (self.aboutWindowController==nil){
        self.aboutWindowController= [[HEFTAboutWindowController alloc] initWithWindowNibName:@"HEFTAboutWindowController"];
    }
    
    [self.aboutWindowController showWindow:nil];
    
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

-(IBAction)stopTimedImport:(id)sender{
    [_pollingTimer invalidate];
    _pollingTimer = nil;
    NSLog(@"Timer Stopped");
}

#pragma mark -
#pragma mark - ==== AMS and MySQL Functions ===
#pragma mark -

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
                                             NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-check" ofType:@"png"]];
                                             [amsServerStausImage setImage:successImage];
                                             
                                             NSLog(@"mounted url: %@", url);
                                         } else{
                                             NSImage *failImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no-entry" ofType:@"png"]];
                                             [amsServerStausImage setImage:failImage];
                                             
                                             NSLog(@"AMS Server Not Mounted");
                                         }
                                         
                                         
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
        NSImage *successImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box-check" ofType:@"png"]];
        [sqlServerStatusImage setImage:successImage];
    } else{
        NSImage *failImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no-entry" ofType:@"png"]];
        [sqlServerStatusImage setImage:failImage];
    }
    
}

#pragma mark -
#pragma mark - ==== Import Functions ===
#pragma mark -

// Timed import log update loads in the timer progress view and updates stats on the timer performance

-(void)timeImportLogUpdate{
    // Set up status view to display progress of import
    
    [[_statusViewController view]removeFromSuperview];
    
    HEFTTimedProgressViewController *vc = [[HEFTTimedProgressViewController alloc]initWithNibName:@"HEFTTimedProgressViewController" bundle:nil];
    _statusViewController = vc;
    
    //Get Application support directory for writing log file to
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    NSURL *appsup = [appDelegate applicationDirectory];
    NSURL *bUrl = [appsup URLByAppendingPathComponent:@"fileimportlog.txt"];
    
    NSString *file = [NSString stringWithContentsOfURL:bUrl encoding:NSUTF8StringEncoding error:nil];
    
    if(!file) {
        
    }
    
    [_statusView addSubview:[vc view]];
    [[vc view]setFrame:[_statusView bounds]];
    [[vc view]setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    [[vc progressIndicator] setHidden:NO];
    [[vc progressIndicator] startAnimation:self ];
    [[vc logTextView] setString:file];
    
    
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

// When timer ticks, look in the AMS directory and import anynew files

- (void)timerTicked:(NSTimer*)timer {
    //Get Application support directory for writing log file to
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    NSURL *appsup = [appDelegate applicationDirectory];
    
    NSFileHandle *aFileHandle;
    
    NSURL *bUrl = [appsup URLByAppendingPathComponent:@"fileimportlog.txt"];
    
    aFileHandle = [NSFileHandle fileHandleForWritingToURL:bUrl error:nil];
    
    [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
    
    
    NSString *s = [NSString stringWithFormat:@"\nCounter Fired: Fire Number: %d\n", _fireCount];
    
    [aFileHandle writeData:[s dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
    
    // Fire count holds the number of times the timer has ticked
    
    _fireCount++;
    NSLog(@"fire count: %d", _fireCount);
    
    //update stats on stathat
    [StatHat postEZStat:@"fire-count" withCount: 1.0
                forUser:@"craig.webster@heartofengland.nhs.uk" delegate:nil];
    
    // Set the status view to show timeed import interface
    [self timeImportLogUpdate];
    
    // Trigger the import
    [self importQCbyDirectory:self];
    
 
    // Return the status view to the timed import update
    // [self timeImportLogUpdate];

}


// Import Files takes an array of selected files and then iterates through them and decides if already imported. If not already imported, imports file into MySQL database

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
        
        int file_import_count =0;
        
        [[vc progressIndicator] setHidden:NO];
        
        [[vc progressIndicator]setDoubleValue:count];
        
        while (object = [e nextObject]) {
            
            // Importer functions class creates CSV file and imports it into database
            HEFTImporterFunctions *importer = [[HEFTImporterFunctions alloc]init];
            
            // do something with object
            //have we imported file before?
            
            NSString *filename = [object lastPathComponent];
    
            
            if ([alreadyImportedFile objectForKey:filename]) {
                // dont import file, its already been done
                
            } else{
                
                // go ahead and import the filw
                NSString *statText = [[NSString alloc]initWithFormat:@"Importing file: %@", [object absoluteString]];
                NSLog(@"Import File: %@", statText);
                [vc updateStatusField:statText];
                [[vc view]needsDisplay];
                
                if ([importer importCSVFile:object mySQLConnection:connection] == YES) {
                    NSLog(@"Successful Import");
                    file_import_count ++;
                    NSLog(@"file import count: %d", file_import_count);
                    
                    //log successful import
                    [dbFunctions logImportedFiles:[object lastPathComponent] mysqlConnection:connection];
                    
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
            //update stats on stathat
            
            [StatHat postEZStat:@"qc-import-files" withValue:file_import_count
                        forUser:@"craig.webster@heartofengland.nhs.uk" delegate:nil];
            importer = nil;
        }
    });
    
    [[vc progressIndicator] setHidden:YES];
    [vc updateStatusField:@"Import Done"];
    
    HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
    
    NSURL *appsup = [appDelegate applicationDirectory];
    NSURL *bUrl = [appsup URLByAppendingPathComponent:@"fileimportlog.txt"];
    
    NSString *file = [NSString stringWithContentsOfURL:bUrl encoding:NSUTF8StringEncoding error:nil];
    
    if(!file) {
        
    }
    [[vc statusText] setString:file];
    
    alreadyImportedFile = nil;
    dbFunctions = nil;
    connection = nil;
    
}


// Get imported filenames returns a dictionary of filenames already imported from MySQL database

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
