//
//  HEFT_DatabaseFunctions.h
//  Quality Metrics
//
//  Created by Craig Webster on 02/11/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExceptionHandling/NSExceptionHandler.h>
#import <unistd.h>
#import "MysqlConnection.h"
#import "MysqlFetch.h"
#import "HEFTAppDelegate.h"
#import "MysqlInsert.h"

@interface HEFT_DatabaseFunctions : NSObject

@property (nonatomic,retain) MysqlConnection *mySQLConnection;

//inits
-(id)init;

//methods
-(MysqlConnection *)connectMySQL;
-(NSArray *) runMySQLSelectQuery:(NSString *)sqlQuery mysqlConnection:(MysqlConnection *)connection;
-(BOOL)runMySQLInsertQueries:(NSDictionary*)query tableName:(NSString *)tableName mysqlConnection:(MysqlConnection *)connection;
-(BOOL)logImportedFiles:(NSString *)filename mysqlConnection:(MysqlConnection *)connection;


@end
