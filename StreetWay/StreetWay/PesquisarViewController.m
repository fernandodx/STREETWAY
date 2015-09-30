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
    
    LocalDAO* dao = [[LocalDAO alloc] init];
    self.listaLocal = dao.consultarTodosLocais;
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    LocalDAO* dao = [[LocalDAO alloc] init];
    self.listaLocal = dao.consultarTodosLocais;

    
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
