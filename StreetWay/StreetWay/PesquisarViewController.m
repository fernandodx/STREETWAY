//
//  PesquisarViewController.m
//  StreeWay
//
//  Created by Fernando Dias on 14/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "PesquisarViewController.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "Local.h"
#import "LocalDAO.h"
#import "LocalTableViewCell.h"
#import "Util.h"
#import "FireBaseUtil.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface PesquisarViewController (){
    BOOL isPesquisado;
}

@property(nonatomic, strong) IBOutlet UITableView* tableViewLocais;
@property(nonatomic, strong) IBOutlet UISearchBar* barraPesquisa;

@property(nonatomic, strong) NSArray* listaLocal;
@property(nonatomic, strong) NSArray* listaLocalEncontrado;



@end

@implementation PesquisarViewController


@synthesize listaLocal, listaLocalEncontrado, barraPesquisa;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewLocais.delegate = self;
    self.tableViewLocais.dataSource = self;
    self.barraPesquisa.delegate = self;
    
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Carregando...";
    
    Firebase *fireRef = [FireBaseUtil getFireRef];
    Firebase *locaisFire = [fireRef childByAppendingPath:LOCAIS];
    
    //Bloco para remover da lista.
    [locaisFire observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        
            Local* localAdd = [Local getLocalFire:snapshot];
            BOOL isExisteNaLista = NO;
        
            for (Local* lc in self.listaLocal) {
                if([lc.nome_local isEqualToString:localAdd.nome_local]){
                    isExisteNaLista = YES;
                    break;
                }
            }
            
            NSMutableArray* listaNova = [self.listaLocal mutableCopy];
            
            if(isExisteNaLista){
                for (int i=0; i < [listaNova count]; i++) {
                    Local* local = [listaNova objectAtIndex:i];
                    if([local.nome_local isEqualToString:localAdd.nome_local]){
                        [listaNova removeObjectAtIndex:i];
                        break;
                    }
                }
            }
            
        self.listaLocal = [[NSArray alloc] initWithArray:listaNova];
        
        [self.tableViewLocais reloadData];
    }];
    
    
   //Bloco para add na lista
    [fireRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (snapshot.childrenCount == 0 ) {
            [Util alerta:@"Alerta!" ComMenssage:@"Nenhum Local Encontrado! Que tal cadastrar um agora?"];
        }
        
        NSMutableArray *listaLocais = [NSMutableArray new];
        
        FDataSnapshot* dadosEventos = [snapshot childSnapshotForPath:LOCAIS];
        
        for (FDataSnapshot* evento in dadosEventos.children) {
            
            if (self.listaLocal) {
                listaLocais = [self.listaLocal mutableCopy];
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

            self.listaLocal = [[NSArray alloc] initWithArray:listaLocais];

        }
        
        [self.tableViewLocais reloadData];

    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
        
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}



#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(isPesquisado){
        return [self.listaLocalEncontrado count];
    }
    
    return [self.listaLocal count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentificador = @"celulaLocal";
    
    LocalTableViewCell* celula = [self.tableViewLocais dequeueReusableCellWithIdentifier:cellIndentificador];
    
    if (celula == nil) {
        celula = [[[NSBundle mainBundle] loadNibNamed:@"celulaLocal"
                                                owner:self
                                              options:nil] objectAtIndex:0];
    }
    
    Local* local = nil;
    
    if(isPesquisado){
        local = [self.listaLocalEncontrado objectAtIndex:indexPath.row];
    }else{
        local = [self.listaLocal objectAtIndex:indexPath.row];
    }
    
    celula.labelNome.text = local.nome_local;
    celula.labelNome.font = [UIFont fontWithName:@"stalker1" size:18];
    celula.imageViewLocal.image = [UIImage imageWithData:local.imagem_local];
    celula.rateView.rating = [local.avaliacao_local floatValue];
    
    celula.local = local;
    celula.navigationControll = self.navigationController;
    
    [celula.rateView setUserInteractionEnabled:NO];
    
    return celula;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) filtroParaBuscarTexto:(NSString*) texto {
    
    if (self.barraPesquisa.text.length > 0) {
        isPesquisado = YES;
    }else{
        isPesquisado = NO;
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"nome_local contains[c] %@", texto];
    self.listaLocalEncontrado = [self.listaLocal filteredArrayUsingPredicate:predicate];
    
    [self.tableViewLocais reloadData];
    
}


// Override to support editing the table view.
//adicionado por VINICIUS 07/10/2015
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Local *localSelecionado=nil;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(isPesquisado){
            localSelecionado = [self.listaLocalEncontrado objectAtIndex:indexPath.row];
        }else{
            localSelecionado = [self.listaLocal objectAtIndex:indexPath.row];
        }
//        LocalDAO *dao=[[LocalDAO alloc]init];
       // [dao excluirLocal:localSelecionado];
        
        Firebase *fireRef = [FireBaseUtil getFireRef];
        Firebase *fireLocal = [fireRef childByAppendingPath:LOCAIS];
        Firebase *localExcluir = [fireLocal childByAppendingPath:localSelecionado.key];
        
        
        
       
        
//        
//        if(isPesquisado){
//            self.listaLocalEncontrado=[dao consultarTodosLocais];
//            
//        }else{
//            self.listaLocal=[dao consultarTodosLocais];
//            
//        }
        
        //self.listaLocalEncontrado=[dao consultarTodosLocais];
        
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [localExcluir removeValue];
        
//         [self.tableViewLocais reloadData];
    }
}
// fim VINICIUS 07/10/2015



#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.barraPesquisa setShowsCancelButton:YES animated:YES];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.barraPesquisa setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES]; //Esconde o teclado.
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filtroParaBuscarTexto:searchBar.text];
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
