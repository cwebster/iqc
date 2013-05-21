//
//  NSDate+NSDateCategory.m
//  Quality Metrics
//
//  Created by Craig Webster on 05/11/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import "NSDate+NSDateCategory.h"

@implementation NSDate (MBDateCat)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}


+(NSDate*) getFirstDateOfTheWeek:(NSString*) weekNr andYear: (NSString*) theYear {
    int intYear = [theYear intValue];
    int intWeek = [weekNr intValue];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents * comp = [[NSDateComponents alloc] init];
    [comp setYear:intYear];
    [comp setWeek:intWeek];
    [comp setWeekday:intWeek];
    
    NSDate *dateOfFirstDay = [gregorian dateFromComponents:comp];
    NSDateComponents *dateComponents =
    //[gregorian components:NSWeekdayCalendarUnit|NSWeekCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit fromDate:dateOfFirstDay];
    
    [gregorian components:NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit fromDate:dateOfFirstDay];
    
//    int year = [dateComponents year];
//    int month = [dateComponents month];
//    int day = [dateComponents day];
    
    dateOfFirstDay= [gregorian dateFromComponents:dateComponents];
    return dateOfFirstDay;
}

@end