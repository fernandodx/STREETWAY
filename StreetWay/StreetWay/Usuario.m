//
//  Usuario.m
//  StreetWay
//
//  Created by Fernando Dias on 23/10/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "Usuario.h"

@implementation Usuario

@synthesize nome, email, imagem, dadosImg;


- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:nome forKey:@"nome"];
    [coder encodeObject:email forKey:@"email"];
    [coder encodeObject:imagem forKey:@"image"];
    [coder encodeObject:dadosImg forKey:@"dadosImg"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Usuario alloc] init];
    if (self != nil)
    {
        nome = [coder decodeObjectForKey:@"nome"];
        email = [coder decodeObjectForKey:@"email"];
        imagem = [coder decodeObjectForKey:@"image"];
        dadosImg = [coder decodeObjectForKey:@"dadosImg"];
    }
    return self;
}


@end
