//
//  HEFT_DatabaseFunctions.m
//  Quality Metrics
//
//  Created by Craig Webster on 02/11/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import "HEFT_DatabaseFunctions.h"

@implementation HEFT_DatabaseFunctions

@synthesize mySQLConnection;


-(id)init
{
    if (self = [super init])
    {
        /// init functions
    }
    return self;
}


-(MysqlConnection *)connectMySQL{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mySQLServer = [defaults objectForKey:HEFTMySQLServer];
    NSString *mySQLUser = [defaults objectForKey:HEFTMySQLUsername];
    NSString *mySQLPass = [defaults objectForKey:HEFTMySQLPassword];
    NSString *mySQLSchema = [defaults objectForKey:HEFTMySQLSchema];
    
    @try {
        NSLog(@"Connected MySQL");
        MysqlConnection *connection = [MysqlConnection connectToHost:mySQLServer user:mySQLUser password:mySQLPass schema:mySQLSchema flags:MYSQL_DEFAULT_CONNECTION_FLAGS];
        
        return connection;
        
    }
    @catch (NSException *exception) {
        NSString* reason = [exception reason];
        NSLog(@"Got NSException ***: %s", [reason UTF8String]);
        NSLog(@"---");
        return Nil;
    }
}


-(NSArray *)runMySQLSelectQuery:(NSString *)sqlQuery mysqlConnection:(MysqlConnection *)connection{
    
    MysqlFetch *userFetch = [MysqlFetch fetchWithCommand:sqlQuery
                                            onConnection:connection];
    
    NSLog(@"There are %ld members",[userFetch.results count]);

    return userFetch.results;
}


-(BOOL)runMySQLInsertQueries:(NSDictionary*)query tableName:(NSString *)tableName  mysqlConnection:(MysqlConnection *)connection{
    
    
    if (connection ==nil) {
        
        NSLog(@"No Connection");
        return NO;
        
    } else{
        @try {
            NSLog(@"running queries: %@", query);
            
            
            MysqlInsert *insertCommand = [MysqlInsert insertWithConnection:connection];
            
            insertCommand.table =tableName;
            insertCommand.rowData=query;
            [insertCommand execute];
            return YES;
            
        }
        @catch (NSException *exception) {
            NSString* reason = [exception reason];
            NSLog(@"Got NSException:in insert: %s", [reason UTF8String]);
            NSLog(@"---");
            return NO;
        }
        
        
    }
    
}

-(BOOL)logImportedFiles:(NSString *)filename mysqlConnection:(MysqlConnection *)connection{
    
    if (connection ==nil) {
        
        NSLog(@"No Connection");
        return NO;
        
    } else{
        @try {
            NSLog(@"Logging file as imported: %@", filename);
            
            MysqlInsert *insertCommand = [MysqlInsert insertWithConnection:connection];
            insertCommand.table =@"imported_files";
            
            insertCommand.rowData=[NSDictionary dictionaryWithObjectsAndKeys:filename,@"filename",nil];
            [insertCommand execute];
           
            return YES;
            
        }
        @catch (NSException *exception) {
            NSString* reason = [exception reason];
            NSLog(@"Got NSException:in insert: %s", [reason UTF8String]);
            NSLog(@"---");
            return NO;
        }
    
    }
    
}


@end
