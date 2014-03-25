//
//  ViewController.m
//  MalariaScreening
//
//  Created by Decha Tesapirat on 2/12/2557 BE.
//  Copyright (c) 2557 Decha Tesapirat. All rights reserved.
//

#import "ViewController.h"
#import "UIImageCVMatConverter.h"
@interface ViewController ()
//@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

@property UIImage *finalImage;
@property cv::Mat globalMat;

@end

@implementation ViewController
@synthesize myScrollView,imageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.capturedImages = [[NSMutableArray alloc] init];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        [toolbarItems removeObjectAtIndex:2];
        [self.toolBar setItems:toolbarItems animated:NO];
    }
    
    
    CALayer *btnLayer = [_roundedButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    CALayer *btnLayer2 = [_roundedButton2 layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:5.0f];
    
    CALayer *btnLayer3 = [_roundChoosePic layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:5.0f];
    
    CALayer *btnLayer4= [_roundTakePic layer];
    [btnLayer4 setMasksToBounds:YES];
    [btnLayer4 setCornerRadius:5.0f];
    
    CALayer *btnLayer5 = [_Noob1 layer];
    [btnLayer5 setMasksToBounds:YES];
    [btnLayer5 setCornerRadius:5.0f];

    CALayer *btnLayer6= [_Noob2 layer];
    [btnLayer6 setMasksToBounds:YES];
    [btnLayer6 setCornerRadius:5.0f];
    
    ///////

    ////

//    
//    demoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PDF-icon.png"]];
//    [myScrollView addSubview:demoImageView];
//    [myScrollView setContentSize:CGSizeMake(demoImageView.frame.size.width, demoImageView.frame.size.height)];


}


- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - Toolbar actions

- (IBAction)done:(id)sender
{
    // Dismiss the camera.
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
    }
    [self finishAndUpdate];
}


- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}


- (IBAction)delayedTakePhoto:(id)sender
{
    // These controls can't be used until the photo has been taken
    self.doneButton.enabled = NO;
    self.takePictureButton.enabled = NO;
    self.delayedPhotoButton.enabled = NO;
    self.startStopButton.enabled = NO;
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSTimer *cameraTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:cameraTimer forMode:NSDefaultRunLoopMode];
    self.cameraTimer = cameraTimer;
}


- (IBAction)startTakingPicturesAtIntervals:(id)sender
{
    /*
     Start the timer to take a photo every 1.5 seconds.
     
     CAUTION: for the purpose of this sample, we will continue to take pictures indefinitely.
     Be aware we will run out of memory quickly.  You must decide the proper threshold number of photos allowed to take from the camera.
     One solution to avoid memory constraints is to save each taken photo to disk rather than keeping all of them in memory.
     In low memory situations sometimes our "didReceiveMemoryWarning" method will be called in which case we can recover some memory and keep the app running.
     */
    self.startStopButton.title = NSLocalizedString(@"Stop", @"Title for overlay view controller start/stop button");
    [self.startStopButton setAction:@selector(stopTakingPicturesAtIntervals:)];
    
    self.doneButton.enabled = NO;
    self.delayedPhotoButton.enabled = NO;
    self.takePictureButton.enabled = NO;
    
    self.cameraTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:YES];
    [self.cameraTimer fire]; // Start taking pictures right away.
}


- (IBAction)stopTakingPicturesAtIntervals:(id)sender
{
    // Stop and reset the timer.
    [self.cameraTimer invalidate];
    self.cameraTimer = nil;
    
    [self finishAndUpdate];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        self.finalImage = [self.capturedImages objectAtIndex:0];
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
    
    ///// scroll
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    [myScrollView setCanCancelContentTouches:NO];
    myScrollView.clipsToBounds = YES;
    myScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    NSInteger width = self.finalImage.size.width;
    NSInteger height =self.finalImage.size.height;
    myScrollView.contentSize = CGSizeMake(width,height);
    ///
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
   
    ////
    NSLog(@"width = %f", self.imageView.frame.size.width);
    NSLog(@"height = %f",self.imageView.frame.size.height);
	myScrollView.maximumZoomScale = 10.0;
	myScrollView.minimumZoomScale = 0.25;
    [myScrollView setScrollEnabled:YES];
	myScrollView.delegate = self;
    
    ///
    
    [self.imageView setImage:self.finalImage];
    [myScrollView addSubview:imageView];

}


#pragma mark - Timer

// Called by the timer to take a picture.
- (void)timedPhotoFire:(NSTimer *)timer
{
    [self.imagePickerController takePicture];
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        return;
    }
    
    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(UIColor*)pixelAtXY:(NSInteger)pointX and:(NSInteger)pointY
{
    CGImageRef cgImage = self.finalImage.CGImage;
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, -pointY);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    NSLog(@"red = %f",red);
    NSLog(@"green = %f",green);
    NSLog(@"blue = %f",blue);
    //create and return UIColor
    UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return acolor;
}

- (void)findContourButton:(id)sender{
    self.finalImage = [self findContour:self.globalMat];
    [self.imageView setImage:self.finalImage];
}
- (void)greyScaleButton:(id)sender{
    self.finalImage = [self greyScaleImage:self.globalMat];
    [self.imageView setImage:self.finalImage];
}
- (void)thresholdButton:(id)sender{
    self.finalImage = [self threshold:self.globalMat];
    [self.imageView setImage:self.finalImage];
}
- (void)createMat:(id)sender{
    self.globalMat = [UIImageCVMatConverter cvMatFromUIImage:self.finalImage];
}
- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        NSLog(@"pixel count %i",ii);
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    NSLog(@"%@",result);
    return result;
}

-(UIImage*)greyScaleImage:(cv::Mat)mat
{
//    cv::cvtColor(mat, mat, CV_RGB2GRAY);
//    cv::dilate(binary,binary,cv::Mat());
//    cv::erode(binary, binary, cv::Mat());
    cv::Mat element(12,12,CV_8U,cv::Scalar(1));

    cv::dilate(mat, mat, element);
    cv::erode(mat, mat, element);
    self.globalMat = mat;
    return [UIImageCVMatConverter UIImageFromCVMat:mat];
    
}
-(UIImage*)findContour:(cv::Mat)mat
{
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mat,contours,CV_RETR_LIST,CV_CHAIN_APPROX_SIMPLE);
    cv::cvtColor(mat,mat,CV_GRAY2BGR);
    int ncont = contours.size();
    ncont--; // subtract edge
    NSLog(@"%d",ncont);
    showCount.text = [NSString stringWithFormat:@"count:%d",ncont];
    cv::Scalar color = cv::Scalar(255,0,255);
    cv::drawContours(mat, contours, -1, color);
    self.globalMat = mat;
    return [UIImageCVMatConverter UIImageFromCVMat:mat];
    
}
-(UIImage*)threshold:(cv::Mat)mat
{
    cv::cvtColor(mat, mat, CV_RGB2GRAY);
        cv::adaptiveThreshold(mat, mat, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 101, 50);
    //cv::threshold(mat,mat,thresholdSlider.value,255,cv::THRESH_BINARY);
    
    
//    cv::erode(mat, mat, element);
//    cv::dilate(mat, mat, element);
    self.globalMat = mat;
    return [UIImageCVMatConverter UIImageFromCVMat:mat];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}



@end