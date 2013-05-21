//
//  NSDate+NSDateCategory.h
//  Quality Metrics
//
//  Created by Craig Webster on 05/11/2012.
//  Copyright (c) 2012 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MBDateCat)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate*) getFirstDateOfTheWeek:(NSString*) weekNr andYear: (NSString*) theYear;

@end