//
//  Util.m
//  StreeWay
//
//  Created by Fernando Dias on 19/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSData *)imageToData:(UIImage *)image {
    
   // CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
   // return CFBridgingRelease(CGDataProviderCopyData(provider));
    
    return UIImagePNGRepresentation(image);
    
}

+(void)alerta:(NSString*)titulo ComMenssage:(NSString*)menssagem {
    SIAlertView* alerta = [[SIAlertView alloc] initWithTitle:titulo
                                                  andMessage:menssagem];
    
    [alerta addButtonWithTitle:@"OK"
                          type:SIAlertViewButtonTypeDestructive
                       handler:^(SIAlertView* alerta) {
                           
                                                 }];
    [alerta show];

}

+(UIImage *)stringBase64ToImage:(NSString *)imageBase64 {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:imageBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+(NSString *)imageToStringBase64:(UIImage *)imagem {
  return [UIImagePNGRepresentation(imagem) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
