//
//  Usuario.h
//  StreetWay
//
//  Created by Fernando Dias on 23/10/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Usuario : NSObject <NSCoding>


@property(nonatomic, retain) NSString* nome;
@property(nonatomic, retain) NSString* email;
@property(nonatomic, retain) UIImage* imagem;
@property(nonatomic, retain) NSData* dadosImg;

@end
