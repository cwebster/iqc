//
//  HEFTImporterProgressViewController.h
//  IQC Importer
//
//  Created by Craig Webster on 22/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HEFTImporterProgressViewController : NSViewController

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *statusText;


-(void)updateStatusField:(NSString *)status;


@end
