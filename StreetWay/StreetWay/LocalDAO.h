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
#import <Firebase/Firebase.h>
#import <UIKit/UIKit.h>

@interface LocalDAO : NSObject

@property(nonatomic, weak) NSManagedObjectContext* ctx;

-(NSArray*) consultarTodosLocais;

-(Firebase *)salvarLocalFirebase:(NSString *)nomeLocal ComImagem:(UIImage *)img
                      Eavaliacao:(float)avaliacao
                       Elatitude:(float)latitude
                      Elongitude:(float)longitude;


@end
