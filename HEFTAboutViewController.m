//
//  HEFTAboutViewController.m
//  IQC Importer
//
//  Created by Craig Webster on 17/05/2013.
//  Copyright (c) 2013 Craig Webster. All rights reserved.
//

#import "HEFTAboutViewController.h"

@interface HEFTAboutViewController ()

@end

@implementation HEFTAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:@"RHAboutViewController" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - RHPreferencesViewControllerProtocol

-(NSString*)identifier{
    return NSStringFromClass(self.class);
}
-(NSImage*)toolbarItemImage{
    return [NSImage imageNamed:@"person@2x.png"];
}
-(NSString*)toolbarItemLabel{
    return NSLocalizedString(@"About", @"AboutLabel");
}

-(NSView*)initialKeyView{
    
    return nil;
}


@end
