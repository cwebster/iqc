//
//  HEFT_MetricsFunctions.h
//  Quality Metrics
//
//  Created by Craig Webster on 22/10/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExceptionHandling/NSExceptionHandler.h>
#import <unistd.h>
#import "MysqlConnection.h"
#import "MysqlFetch.h"
#import "HEFT_DatabaseFunctions.h"
#import "MysqlInsert.h"

@interface HEFT_MetricsFunctions : NSObject {
}



- (NSDictionary *)patientMeans:(NSNumber *)dateFractionNumber
                          year:(NSNumber *)year
                  dateFraction:(NSString *)dateFraction;


-(BOOL) meansAlreadyRun:(NSDate *)meansAlreadyRun queryType:(NSString *)queryType;
-(void) meansBetweenTwoDates:(NSDate *)startDate endDate:(NSDate *)endDate;



@end
