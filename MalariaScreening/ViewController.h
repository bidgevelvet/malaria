//
//  ViewController.h
//  MalariaScreening
//
//  Created by Decha Tesapirat on 2/12/2557 BE.
//  Copyright (c) 2557 Decha Tesapirat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController < UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIApplicationDelegate, UIScrollViewDelegate>{
    IBOutlet UILabel *showRed;
    IBOutlet UILabel *showBlue;
    IBOutlet UILabel *showGreen;
    IBOutlet UISlider *thresholdSlider;
	IBOutlet UIScrollView *myScrollView;
	IBOutlet UIImageView *imageView;
    
}



@property (weak, nonatomic) IBOutlet UIButton *roundedButton2;
@property (weak, nonatomic) IBOutlet UIButton *roundedButton;
@property (weak, nonatomic) IBOutlet UIButton *roundChoosePic;
@property (weak, nonatomic) IBOutlet UIButton *roundTakePic;
@property (weak, nonatomic) IBOutlet UIButton *Noob1;
@property (weak, nonatomic) IBOutlet UIButton *Noob2;

@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;


-(IBAction)thresholdButton:(id)sender;
-(IBAction)findContourButton:(id)sender;
-(IBAction)greyScaleButton:(id)sender;
-(IBAction)createMat:(id)sender;
@end
