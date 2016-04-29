//
//  FaceViewController.m
//  BiaoQingBao
//
//  Created by chaowualex on 16/4/12.
//  Copyright © 2016年 maka. All rights reserved.
//

#import "FaceViewController.h"

@interface FaceViewController ()

@end

@implementation FaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self DetectFace];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DetectFace{
    
    UIImage* image = [UIImage imageNamed:@"face.jpg"];
    UIImageView* testImage = [[UIImageView alloc] initWithImage: image];
    [testImage setTransform:CGAffineTransformMakeScale(1, -1)];
//    [[[UIApplication sharedApplication] delegate].window setTransform:
//     CGAffineTransformMakeScale(1, -1)];
    [testImage setFrame:CGRectMake(0, 0, testImage.image.size.width,
                                   testImage.image.size.height)];
    [self.view addSubview:testImage];
    
    CIImage* ciimage = [CIImage imageWithCGImage:image.CGImage];
    NSDictionary* opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:opts];
    NSArray* features = [detector featuresInImage:ciimage];
    
    for (CIFaceFeature *faceFeature in features){
        
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        // add a border around the newly created UIView
        
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        [self.view addSubview:faceView];
        
        if(faceFeature.hasLeftEyePosition)
            
        {
            // create a UIView with a size based on the width of the face
            
            UIView* leftEyeView = [[UIView alloc] initWithFrame:
                                   CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15,
                                              faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor]
                                             colorWithAlphaComponent:0.3]];
            
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            
            // add the view to the window
            [self.view  addSubview:leftEyeView];
            
        }
        
        if(faceFeature.hasRightEyePosition)
            
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEye = [[UIView alloc] initWithFrame:
                               CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15,
                                          faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            
            // change the background color of the eye view
            [leftEye setBackgroundColor:[[UIColor blueColor]
                                         colorWithAlphaComponent:0.3]];
            
            // set the position of the rightEyeView based on the face
            [leftEye setCenter:faceFeature.rightEyePosition];
            
            // round the corners
            leftEye.layer.cornerRadius = faceWidth*0.15;
            
            // add the new view to the window
            [self.view  addSubview:leftEye];
        }
        
        if(faceFeature.hasMouthPosition)
        {
            
            // create a UIView with a size based on the width of the face
            UIView* mouth = [[UIView alloc] initWithFrame:
                             CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2,
                                        faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            
            // change the background color for the mouth to green
            [mouth setBackgroundColor:[[UIColor greenColor]
                                       colorWithAlphaComponent:0.3]];
            
            // set the position of the mouthView based on the face
            [mouth setCenter:faceFeature.mouthPosition];
            
            // round the corners
            mouth.layer.cornerRadius = faceWidth*0.2;
            
            // add the new view to the window
            [self.view  addSubview:mouth];
        }
        
        if (faceFeature.hasFaceAngle) {
            testImage.transform = CGAffineTransformMakeRotation(-faceFeature.faceAngle);
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
