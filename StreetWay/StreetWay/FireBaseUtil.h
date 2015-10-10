//
//  FireBaseUtil.h
//  StreetWay
//
//  Created by Fernando Dias on 10/10/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface FireBaseUtil : NSObject

 #define CAMINHO_FIRE_BASE @"https://STREETWAY.firebaseio.com"
 #define LOCAIS @"LOCAIS"


+(Firebase *) getFireRef;


@end
