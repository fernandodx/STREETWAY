//
//  LocalDAO.h
//  StreeWay
//
//  Created by Fernando Dias on 18/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Local.h"

@interface LocalDAO : NSObject

@property(nonatomic, weak) NSManagedObjectContext* ctx;

-(Local *)salvarLocal:(NSString *)nomeLocal ComImagem:(NSData *)data
           Eavaliacao:(float)avaliacao
            Elatitude:(float)latitude
           Elongitude:(float)longitude;
-(NSArray*) consultarTodosLocais;


@end
