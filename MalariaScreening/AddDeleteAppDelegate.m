//
//  AddDeleteAppDelegate.m
//  MalariaScreening
//
//  Created by Puk on 3/24/14.
//  Copyright (c) 2014 Decha Tesapirat. All rights reserved.
//


#import "AddDeleteAppDelegate.h"
#import "TableViewController.h"

@implementation AddDeleteAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	
	// Override point for customization after app launch
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}


@end
