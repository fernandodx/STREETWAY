//
//  Local.h
//  StreetWay
//
//  Created by Fernando Dias on 20/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Local : NSManagedObject

@property (nonatomic, retain) NSString * nome_local;
@property (nonatomic, retain) NSData * imagem_local;
@property (nonatomic, retain) NSNumber * avaliacao_local;
@property (nonatomic, retain) NSNumber * latitude_local;
@property (nonatomic, retain) NSNumber * longitude_local;

@end
