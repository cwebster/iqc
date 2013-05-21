//
//  HEFT_MetricsFunctions.m
//  Quality Metrics
//
//  Created by Craig Webster on 22/10/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import "HEFT_MetricsFunctions.h"

@implementation HEFT_MetricsFunctions

#pragma mark -
#pragma mark - ==== Statistics Calculations ===
#pragma mark -

- (NSDictionary *)patientMeans:(NSNumber *)dateFractionNumber
                          year:(NSNumber *)year
                  dateFraction:(NSString *)dateFraction{
    NSDictionary *patientMeans = [[NSDictionary alloc]init];
    return patientMeans;
}



-(BOOL)meansAlreadyRun:(NSDate *)dateToCheck queryType:(NSString *)queryType{
    
    HEFT_DatabaseFunctions *db = [[HEFT_DatabaseFunctions alloc]init];
    
    // Explode the supplied date into the individual components
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"w"];
    
    NSString *weekNumber = [dateFormatter stringFromDate:dateToCheck];
    NSInteger weekNumberInt = [weekNumber integerValue];
    
    [dateFormatter setDateFormat:@"M"];
    NSString *month = [dateFormatter stringFromDate:dateToCheck];
    NSInteger monthNumberInt = [month integerValue];
    
    [dateFormatter setDateFormat:@"y"];
    NSString *year = [dateFormatter stringFromDate:dateToCheck];
    NSInteger yearNumberInt = [year integerValue];

    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:dateToCheck];
    
    // Which type of log entry do we need to check ?
    
    if ([queryType isEqualToString:@"daily"]) {
        NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM meansLog where Date = '%@' AND Action ='daily'", strDate];
        
                
        NSArray  *results = [db runMySQLSelectQuery:sqlQuery];
        NSLog(@"Results: %@\n", results);
        
        if (results.count == 0) {
            return NO;
        }
        
    } else if ([queryType isEqualToString:@"weekly"]){
        
        
        NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM telepathstats.meansLog where WEEK(Date) =%ld AND YEAR(Date) = %ld", weekNumberInt, yearNumberInt];
        
        NSArray  *results = [db runMySQLSelectQuery:sqlQuery];
        NSLog(@"Results: %@\n", results);
        
        if (results.count == 0) {
            return NO;
        }
        
    } else if ([queryType isEqualToString:@"monthly"]){
        
        NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM telepathstats.meansLog where MONTH(Date) =%ld AND YEAR(Date) = %ld", monthNumberInt, yearNumberInt];
        
        
        NSArray  *results = [db runMySQLSelectQuery:sqlQuery];
        NSLog(@"Results: %@\n", results);
        
        if (results.count == 0) {
            return NO;
        }
        
    }
    
    return YES;
    
}

-(void)meansBetweenTwoDates:(NSDate *)startDate endDate:(NSDate *)endDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    [oneDay setDay: 1];
    
    for (id date = [startDate copy]; [date isEqualToDate:endDate] <= 0;
         date = [calendar dateByAddingComponents: oneDay
                                          toDate: date
                                         options: 0] ) {
             NSLog( @"%@ in [%@,%@]", date, startDate, endDate );
             
             // Get the relevant date data from the input boxes / calendar etc
             
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
             [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
             
             [dateFormatter setDateFormat:@"y"];
             NSString *year = [dateFormatter stringFromDate:date];
             NSNumber *yearNumber = [NSNumber numberWithInteger:[year integerValue]];
             
             [dateFormatter setDateFormat:@"d"];
             NSString *day = [dateFormatter stringFromDate:date];
             NSNumber *dayNumber = [NSNumber numberWithInteger:[day integerValue]];
             
             [dateFormatter setDateFormat:@"M"];
             NSString *month = [dateFormatter stringFromDate:date];
             NSNumber *monthNumber = [NSNumber numberWithInteger:[month integerValue]];
             
             [dateFormatter setDateFormat:@"w"];
             NSString *week = [dateFormatter stringFromDate:date];
             NSNumber *weekNumber = [NSNumber numberWithInteger:[week integerValue]];
             
             if ([self meansAlreadyRun:date queryType:@"daily"]==NO) {
                 NSLog(@"Id run daily means");
                 [self patientMeans:dayNumber year:yearNumber dateFraction:@"daily"];
                 
             }
             
             if ([self meansAlreadyRun:date queryType:@"weekly"]==NO){
                 NSLog(@"I'd run weekly means");
                 [self patientMeans:weekNumber year:yearNumber dateFraction:@"weekly"];
             }
             
             if ([self meansAlreadyRun:date queryType:@"monthly"]==NO){
                 NSLog(@"I'd run monthly means");
                 [self patientMeans:monthNumber year:yearNumber dateFraction:@"monthly"];
             }
         }

}



@end
