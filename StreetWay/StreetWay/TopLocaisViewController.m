//
//  TopLocaisViewController.m
//  StreetWay
//
//  Created by Fernando Dias on 27/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "TopLocaisViewController.h"
#import "LocalTableViewCell.h"
#import "Local.h"
#import "LocalDAO.h"
#import "Util.h"
#import "FireBaseUtil.h"
#import <Firebase/Firebase.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface TopLocaisViewController ()

@property(nonatomic, strong) IBOutlet UITableView* tableViewTopLocais;
@property(nonatomic, strong) NSArray* listaTopLocais;


@end

@implementation TopLocaisViewController

@synthesize tableViewTopLocais, listaTopLocais;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewTopLocais.delegate = self;
    self.tableViewTopLocais.dataSource = self;
    
    Firebase *fireRef = [FireBaseUtil getFireRef];
    
    Firebase *locaisFire = [fireRef childByAppendingPath:LOCAIS];
    
    //Bloco para remover da lista.
    [locaisFire observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        
        Local* localAdd = [Local getLocalFire:snapshot];
        BOOL isExisteNaLista = NO;
        
        for (Local* lc in listaTopLocais) {
            if([lc.nome_local isEqualToString:localAdd.nome_local]){
                isExisteNaLista = YES;
                break;
            }
        }
        
        NSMutableArray* listaNova = [listaTopLocais mutableCopy];
        
        if(isExisteNaLista){
            for (int i=0; i < [listaNova count]; i++) {
                Local* local = [listaNova objectAtIndex:i];
                if([local.nome_local isEqualToString:localAdd.nome_local]){
                    [listaNova removeObjectAtIndex:i];
                    break;
                }
            }
        }
        
        listaTopLocais = listaNova;
     
    }];

    
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Carregando...";
    
    [fireRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (snapshot.childrenCount == 0 ) {
            [Util alerta:@"Alerta!" ComMenssage:@"Nenhum Local Encontrado! Que tal cadastrar um agora?"];
        }
        
        FDataSnapshot* dadosEventos = [snapshot childSnapshotForPath:LOCAIS];
        
        for (FDataSnapshot* evento in dadosEventos.children) {
            
            NSMutableArray *listaLocais = [NSMutableArray new];
            
            if (self.listaTopLocais) {
                listaLocais = [self.listaTopLocais mutableCopy];
            }
            
            Local* localAdd = [Local getLocalFire:evento];
            BOOL isExisteNaLista = NO;
            
            for (Local* lc in listaLocais) {
                if([lc.nome_local isEqualToString:localAdd.nome_local]){
                    isExisteNaLista = YES;
                    break;
                }
            }
            
            if(!isExisteNaLista){
                [listaLocais addObject:localAdd];
            }

            self.listaTopLocais = [listaLocais sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                Local* local1 = (Local*) obj1;
                Local* local2 = (Local*) obj2;
                
                if(local2 == nil || local2.avaliacao_local == nil){
                    return 0;
                }
                
                if(local1 == nil || local1.avaliacao_local == nil){
                    return 1;
                }
                
                return [local2.avaliacao_local compare:local1.avaliacao_local];
                
            }];
            
        }
        
        [self.tableViewTopLocais reloadData];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.listaTopLocais count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identificadorCelula = @"celulaLocal";
    
    LocalTableViewCell* localTableViewCell = [self.tableViewTopLocais dequeueReusableCellWithIdentifier:identificadorCelula];
    
    if (localTableViewCell == nil) {
        localTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"celulaLocal"
                                                           owner:self
                                                          options:nil] objectAtIndex:0];
    }
    
    
    Local* local = [self.listaTopLocais objectAtIndex:indexPath.row];
    
    localTableViewCell.labelNome.text = local.nome_local;
    localTableViewCell.labelNome.font = [UIFont fontWithName:@"stalker1" size:18];
    localTableViewCell.imageViewLocal.image = [UIImage imageWithData:local.imagem_local];
    localTableViewCell.rateView.rating = [local.avaliacao_local floatValue];
    [localTableViewCell.rateView setUserInteractionEnabled:NO];
    
    return localTableViewCell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
