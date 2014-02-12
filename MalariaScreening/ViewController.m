//
//  ViewController.m
//  MalariaScreening
//
//  Created by Decha Tesapirat on 2/12/2557 BE.
//  Copyright (c) 2557 Decha Tesapirat. All rights reserved.
//

#import "ViewController.h"
//fuck you
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)TakePhoto{
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentModalViewController:picker animated:YES];
    [picker reloadInputViews];
}
- (IBAction)ChooseExisting{
    picker1 = [[UIImagePickerController alloc] init];
    picker1.delegate = self;
    [picker1 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:picker animated:YES];
    [picker1 reloadInputViews];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageview setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end