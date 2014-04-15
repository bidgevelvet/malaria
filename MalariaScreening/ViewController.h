//
//  ViewController.h
//  MalariaScreening
//
//  Created by Decha Tesapirat on 2/12/2557 BE.
//  Copyright (c) 2557 Decha Tesapirat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController < UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIApplicationDelegate, UIScrollViewDelegate>{
    IBOutlet UILabel *showCount;
    IBOutlet UILabel *showCount2;
    IBOutlet UILabel *showSum;
    IBOutlet UILabel *showSum2;
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

@property (weak, nonatomic) IBOutlet UIButton *wbcCount;

@property (weak, nonatomic) IBOutlet UIButton *greenThreshold;


-(IBAction)thresholdButton:(id)sender;
-(IBAction)findContourButton:(id)sender;
-(IBAction)greyScaleButton:(id)sender;
-(IBAction)createMat:(id)sender;
-(IBAction)wbcCount:(id)sender;
-(IBAction)greenThreshold:(id)sender;
@end
