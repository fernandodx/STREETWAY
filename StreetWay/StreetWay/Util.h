//
//  Util.h
//  StreeWay
//
//  Created by Fernando Dias on 19/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SIAlertView/SIAlertView.h>

@interface Util : NSObject

+ (NSData *)imageToData:(UIImage *)image;
+(void)alerta:(NSString*)titulo ComMenssage:(NSString*)menssagem;
+(UIImage *)stringBase64ToImage:(NSString *)imageBase64 ;
+(NSString *)imageToStringBase64:(UIImage *)imagem;

@end
