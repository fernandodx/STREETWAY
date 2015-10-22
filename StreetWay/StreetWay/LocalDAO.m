//
//  LocalDAO.m
//  StreeWay
//
//  Created by Fernando Dias on 18/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "LocalDAO.h"
#import "AppDelegate.h"
#import "Util.h"
#import <Firebase/Firebase.h>
#import "FireBaseUtil.h"

@implementation LocalDAO

@synthesize ctx;


- (instancetype)init
{
    self = [super init];
    if (self) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        [self setCtx:appDelegate.managedObjectContext];
    }
    return self;
}

-(Local *)salvarLocal:(NSString *)nomeLocal ComImagem:(NSData *)data
           Eavaliacao:(float)avaliacao
            Elatitude:(float)latitude
           Elongitude:(float)longitude{
    
    Local* localSave = [NSEntityDescription insertNewObjectForEntityForName:@"Local"
                                                 inManagedObjectContext:self.ctx];
    
    [localSave setNome_local:nomeLocal];
    [localSave setAvaliacao_local:[NSNumber numberWithFloat:avaliacao]];
    [localSave setImagem_local:data];
    [localSave setLatitude_local:[NSNumber numberWithFloat:latitude]];
    [localSave setLongitude_local:[NSNumber numberWithFloat:longitude]];
    
    NSError* erro = nil;
    [self.ctx save:&erro];
    
    
    if(!erro ) {
        return localSave;
    }else{
        return nil;
    }
}

-(Firebase *)salvarLocalFirebase:(NSString *)nomeLocal ComImagem:(UIImage *)img
            Eavaliacao:(float)avaliacao
            Elatitude:(float)latitude
            Elongitude:(float)longitude{
        
    NSDictionary* localDicionario = @{
                @"nome": nomeLocal,
                @"avaliacao" : [NSNumber numberWithFloat:avaliacao],
                @"imagem" : [Util imageToStringBase64:img ],
                @"latitude" :[NSNumber numberWithFloat:latitude],
                @"longitude" : [NSNumber numberWithFloat:longitude]
                };
    
    
    Firebase *fireRef = [FireBaseUtil getFireRef];
    Firebase *fireEventos = [fireRef childByAppendingPath:LOCAIS];

    [[fireEventos childByAutoId] setValue:localDicionario];
   
    return nil;
}


-(NSArray *)consultarTodosLocais {
    
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Local"];
    
    NSSortDescriptor* ordenacao = [NSSortDescriptor sortDescriptorWithKey:@"nome_local" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[ordenacao]];
    
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nome_local BEGINSWITH %@", parametro];
//    [fetchRequest setPredicate:predicate];
    
    NSError* erro = nil;
    NSArray* resultadoQuery = [self.ctx executeFetchRequest:fetchRequest
                                                      error:&erro];
    
    if(!erro){
        if (resultadoQuery == nil || [resultadoQuery count] == 0) {
            [Util alerta:@"Alerta!" ComMenssage:@"Nenhum Local Encontrado! Que tal cadastrar um agora?"];
        }
        
        
        return resultadoQuery;
    }else{
        return nil;
    }
    
}

-(void)excluirLocal:(Local *)local {
    Firebase *fireRef = [FireBaseUtil getFireRef];
    Firebase *fireLocal = [fireRef childByAppendingPath:LOCAIS];
    Firebase *localExcluir = [fireLocal childByAppendingPath:local.key];
    
    [localExcluir removeValue];
    
    
}



@end
