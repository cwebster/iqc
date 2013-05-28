//
//  HEFTTimerFunctions.m
//  IQC Importer
//
//  Created by Craig Webster on 23/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTTimerFunctions.h"

@implementation HEFTTimerFunctions

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}



@end
