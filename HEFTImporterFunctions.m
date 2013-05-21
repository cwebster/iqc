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

-(void)importQCdata:(NSArray *)selectedFiles{
    
    //variables
	NSArray* csvData;
	NSError* error;
    int i;
	NSInteger count;
    double maxVal;
    
    count = [selectedFiles count];
    maxVal = count;
    
    NSLog(@"count: %ld:", (long)count);
    
    MysqlConnection *mySQLConnection = [self connectMySQL];
    
    NSEnumerator *e = [selectedFiles objectEnumerator];
    id object;
    
    // [importController.importStatus setStringValue:statusText];
    
    while (object = [e nextObject]) {
        // do something with object
        
        // open CSV file into csvString
        NSString *csvString = [NSString stringWithContentsOfURL:object encoding:NSUTF8StringEncoding error:&error];
        
        
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
                
                MysqlInsert *insertCommand = [MysqlInsert insertWithConnection:mySQLConnection];
                
                insertCommand.table =@"qc";
                insertCommand.rowData=insertData;
                [insertCommand execute];
                
                
            }
            @catch (NSException *exception) {
                NSString* reason = [exception reason];
                NSLog(@"Got NSException:in insert: %s", [reason UTF8String]);
                NSLog(@"---");
                
            }
            
        }
        
        
    }
    
    NSLog(@"Import Complete");
}

-(MysqlConnection *)connectMySQL{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mySQLServer = [defaults objectForKey:HEFTMySQLServer];
    NSString *mySQLUser = [defaults objectForKey:HEFTMySQLUsername];
    NSString *mySQLPass = [defaults objectForKey:HEFTMySQLPassword];
    NSString *mySQLSchema = [defaults objectForKey:HEFTMySQLSchema];
    
    @try {
        NSLog(@"Connecting MYSQL.....");
        MysqlConnection *mySQLConnection = [MysqlConnection connectToHost:mySQLServer user:mySQLUser password:mySQLPass schema:mySQLSchema flags:MYSQL_DEFAULT_CONNECTION_FLAGS];
        
        MysqlFetch *userFetch = [MysqlFetch fetchWithCommand:@"SELECT VARIABLE_NAME, VARIABLE_VALUE FROM INFORMATION_SCHEMA.GLOBAL_VARIABLES WHERE VARIABLE_NAME = 'VERSION'"
                                                onConnection:mySQLConnection];
        
        for (NSDictionary *userRow in userFetch.results) {
            NSString *userNumber = [userRow objectForKey:@"VARIABLE_VALUE"];
            NSLog(@"%@",userNumber);
        }
        return mySQLConnection;
        
    }
    @catch (NSException *exception) {
        NSString* reason = [exception reason];
        NSLog(@"Got NSException ***: %s", [reason UTF8String]);
        NSLog(@"---");
        return Nil;
    }
}



@end
