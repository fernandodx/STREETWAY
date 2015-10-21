//
//  CameraViewController.h
//  StreeWay
//
//  Created by Fernando Dias on 15/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "LocalDAO.h"
#import "Local.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBSDKSharePhotoContent.h"
#import "FBSDKSharing.h"

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RateViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, FBSDKSharingDelegate>


@property(nonatomic, strong) UIImagePickerController* imagePicker;
@property(nonatomic, strong) CLLocationManager* locationManager;


-(IBAction)escolherImagemLocal:(id)sender;
-(IBAction)tirarFoto:(id)sender;
-(IBAction)salvarLocal:(id)sender;



@end
