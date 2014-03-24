//
//  AddDeleteAppDelegate.h
//  MalariaScreening
//
//  Created by Puk on 3/24/14.
//  Copyright (c) 2014 Decha Tesapirat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddDeleteViewController;

@interface AddDeleteAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AddDeleteViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AddDeleteViewController *viewController;

@end