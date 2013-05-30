//
//  HEFTImporterFunctions.m
//  IQC Importer
//
//  Created by Craig Webster on 21/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTImporterFunctions.h"

@implementation HEFTImporterFunctions
@synthesize importStatus;

-(BOOL)importCSVFile:(NSURL *)fileURL mySQLConnection:(MysqlConnection *)connection{
   
    if ( connection != Nil) {
        
        NSArray* csvData;
        NSError* error;
        int i;
        NSInteger count;
        
        //Get Application support directory for writing log file to
        HEFTAppDelegate *appDelegate = (HEFTAppDelegate *)[NSApp delegate];
        
        NSURL *appsup = [appDelegate applicationDirectory];
        
        // open CSV file into csvString
        NSString *csvString = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
        
        
        // parse CSV data into csvData array
        csvData = [csvString arrayByImportingCSV];
        
        //loop though imported CSV array for record values
        for (i = 0, count = [csvData count]; i < count; i = i + 1)
        {
            NSString *statusText = [NSString stringWithFormat:@"%d", i];
            
            [self.importStatus setStringValue:statusText];
            
            //set all field values from CSV
            
            NSDictionary *insertData = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [[csvData objectAtIndex: i] objectAtIndex: 0], @"testName", [[csvData objectAtIndex: i] objectAtIndex: 1], @"analyser", [[csvData objectAtIndex: i] objectAtIndex: 2], @"qclot",[[csvData objectAtIndex: i] objectAtIndex: 3], @"level",[[csvData objectAtIndex: i] objectAtIndex: 4], @"qcdate", [[csvData objectAtIndex: i] objectAtIndex: 5], @"qctime", [[csvData objectAtIndex: i] objectAtIndex: 6], @"result",   nil];
            
            
            @try {
                
                MysqlInsert *insertCommand = [MysqlInsert insertWithConnection:connection];
                
                insertCommand.table =@"imported_qcs";
                insertCommand.rowData=insertData;
                [insertCommand execute];
                
                NSLog(@"Imported file: %@", fileURL);
                
                
                NSFileHandle *aFileHandle;
                
                NSURL *bUrl = [appsup URLByAppendingPathComponent:@"fileimportlog.txt"];
                
                aFileHandle = [NSFileHandle fileHandleForWritingToURL:bUrl error:nil];

                [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
                
                [aFileHandle writeData:[[fileURL absoluteString] dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
                [aFileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
                
                return YES;
                
                
            }
            @catch (NSException *exception) {
                NSString* reason = [exception reason];
                NSLog(@"Got NSException:in insert: %s", [reason UTF8String]);
                NSLog(@"---");
                NSLog(@"File not imported: %@", fileURL);
                
                NSFileHandle *aFileHandle;
                
                NSURL *bUrl = [appsup URLByAppendingPathComponent:@"fileimportlog.txt"];
                
                aFileHandle = [NSFileHandle fileHandleForWritingToURL:bUrl error:nil];
                
                [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
                
                NSString *erromsg = @"\n File not imported: error : ";
                NSString *fullError = [erromsg stringByAppendingString:[fileURL absoluteString]];
                
                [aFileHandle writeData:[fullError dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
                
                return NO;
            }
            
            
            
        }

        
        
        
        
    } else{
        NSLog(@"Connection is nil apparently");
        return NO;
    }
    
}






@end
