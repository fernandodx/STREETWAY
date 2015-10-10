//
//  FireBaseUtil.m
//  StreetWay
//
//  Created by Fernando Dias on 10/10/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "FireBaseUtil.h"

@implementation FireBaseUtil {
    
   
    
}




+(Firebase *)getFireRef {
    return [[Firebase alloc] initWithUrl:CAMINHO_FIRE_BASE];
}


@end
