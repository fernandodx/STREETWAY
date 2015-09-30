//
//  InicioViewController.h
//  StreeWay
//
//  Created by Fernando Dias on 13/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface InicioViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>



@property(nonatomic, strong) IBOutlet MKMapView* mapa;
@property(nonatomic, strong) CLLocationManager* locationManager;



@end
