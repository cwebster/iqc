//
//  HEFTImporterFunctions.h
//  IQC Importer
//
//  Created by Craig Webster on 21/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HEFT_fileutils.h"
#import "NSString+CSVUtils.h"
#import "HEFT_DatabaseFunctions.h"
#import "MysqlConnection.h"
#import "MysqlFetch.h"
#import "MysqlInsert.h"

@interface HEFTImporterFunctions : NSObject {

}

@property IBOutlet NSTextField *importStatus;


-(BOOL)importCSVFile:(NSURL *)fileURL mySQLConnection:(MysqlConnection *)connection;


@end
