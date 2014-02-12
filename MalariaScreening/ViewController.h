//
//  ViewController.h
//  MalariaScreening
//
//  Created by Decha Tesapirat on 2/12/2557 BE.
//  Copyright (c) 2557 Decha Tesapirat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController < UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    UIImagePickerController *picker;
    UIImagePickerController *picker1;
    UIImage *image;
    IBOutlet UIImageView *imageview;
}
-(IBAction)TakePhoto;
-(IBAction)ChooseExisting;
@end
