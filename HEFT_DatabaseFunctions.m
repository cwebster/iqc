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
        [self connectMySQL];
    }
    return self;
}


-(BOOL)connectMySQL{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mySQLServer = [defaults objectForKey:HEFTMySQLServer];
    NSString *mySQLUser = [defaults objectForKey:HEFTMySQLUsername];
    NSString *mySQLPass = [defaults objectForKey:HEFTMySQLPassword];
    NSString *mySQLSchema = [defaults objectForKey:HEFTMySQLSchema];
    
    @try {
        NSLog(@"Connecting MYSQL.....");
        self.mySQLConnection = [MysqlConnection connectToHost:mySQLServer user:mySQLUser password:mySQLPass schema:mySQLSchema flags:MYSQL_DEFAULT_CONNECTION_FLAGS];
        
        MysqlFetch *userFetch = [MysqlFetch fetchWithCommand:@"SELECT VARIABLE_NAME, VARIABLE_VALUE FROM INFORMATION_SCHEMA.GLOBAL_VARIABLES WHERE VARIABLE_NAME = 'VERSION'"
                                                onConnection:self.mySQLConnection];
        
        for (NSDictionary *userRow in userFetch.results) {
            NSString *userNumber = [userRow objectForKey:@"VARIABLE_VALUE"];
            NSLog(@"%@",userNumber);
                                                          }
        return YES;
        
    }
    @catch (NSException *exception) {
        NSString* reason = [exception reason];
        NSLog(@"Got NSException ***: %s", [reason UTF8String]);
        NSLog(@"---");
        return NO;
    }
}


-(NSArray *)runMySQLSelectQuery:(NSString *)sqlQuery{
    MysqlFetch *userFetch = [MysqlFetch fetchWithCommand:sqlQuery
                                            onConnection:self.mySQLConnection];
    
    NSLog(@"There are %ld members",[userFetch.results count]);

    return userFetch.results;
}


-(BOOL)runMySQLInsertQueries:(NSDictionary*)query tableName:(NSString *)tableName{
    
 //  HEFT_DatabaseFunctions *db = [[HEFT_DatabaseFunctions alloc]init];
    
    @try {
        NSLog(@"running queries: %@", query);
        
        if (self.mySQLConnection ==nil) {
            [self connectMySQL];
            NSLog(@"Connecting");
        }
        
        MysqlInsert *insertCommand = [MysqlInsert insertWithConnection:self.mySQLConnection];
        
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

-(NSDictionary *)logAction:(NSString *)logAction logDate:(NSString *)logDateStr{
    
    NSMutableDictionary *insertsDictionary = [[NSMutableDictionary alloc]init];
    NSDictionary *insertQuery = [NSDictionary dictionaryWithObjectsAndKeys:logAction, @"Action",logDateStr,@"Date", nil];
    [insertsDictionary setValue:insertQuery forKey:logDateStr];
    
    NSDictionary *returnDictionary = [NSDictionary dictionaryWithDictionary:insertsDictionary];
    
    return returnDictionary;
}


@end
