//
//  LocalPontoAnnotation.h
//  StreetWay
//
//  Created by Fernando Dias on 14/10/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Local.h"

@interface LocalPontoAnnotation : MKPointAnnotation

@property(nonatomic, retain) Local* local;


@end
