//
//  MapLocalViewController.h
//  StreetWay
//
//  Created by Fernando Dias on 31/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Local.h"

@interface MapLocalViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property(nonatomic, strong) CLLocationManager* locationManager;
@property(nonatomic, strong) Local* local;

-(IBAction)enviarAoGps:(id)sender;



@end
