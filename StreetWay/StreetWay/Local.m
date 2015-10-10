//
//  Local.m
//  StreetWay
//
//  Created by Fernando Dias on 20/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "Local.h"
#import "Util.h"


@implementation Local

@synthesize nome_local, imagem_local, avaliacao_local, latitude_local, longitude_local;



+(Local *) getLocalFire:(FDataSnapshot *) dados {
    
    Local *local = [Local new];
    local.nome_local = dados.value[@"nome"];
    local.avaliacao_local = dados.value[@"avaliacao"];
    local.longitude_local = dados.value[@"longitude"];
    local.latitude_local = dados.value[@"latitude"];
    local.imagem_local = [Util imageToData: [Util stringBase64ToImage:dados.value[@"imagem"]]];
    
    return local;
}


@end
