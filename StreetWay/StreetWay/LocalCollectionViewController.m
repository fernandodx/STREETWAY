//
//  LocalCollectionViewController.m
//  StreetWay
//
//  Created by Fernando Dias on 11/08/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "LocalCollectionViewController.h"
#import "CelulaCollectionViewCell.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "LocalDAO.h"
#import "Util.h"
#import "DetalheViewController.h"
#import <Firebase/Firebase.h>

@interface LocalCollectionViewController ()

@end

@implementation LocalCollectionViewController

@synthesize listaLocal;

static NSString * const IDENTIFICADOR_CELL = @"FOTO_LOCAL_CELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LocalDAO* dao = [[LocalDAO alloc] init];
    NSArray* listaLocalBanco = dao.consultarTodosLocais;

    self.listaLocal = [[NSMutableArray alloc] initWithArray:listaLocalBanco];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.listaLocal count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CelulaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFICADOR_CELL forIndexPath:indexPath];
    
    // Configure the cell
    
    Local* local = [self.listaLocal objectAtIndex:indexPath.row];
    
    cell.imageQuadro.image = [UIImage imageWithData:local.imagem_local];
    cell.btAbrirTelaDetalhe.imageView.image = [UIImage imageWithData:local.imagem_local];
    
   [cell.btAbrirTelaDetalhe setTitle:local.nome_local forState:UIControlStateNormal];
    cell.btAbrirTelaDetalhe.titleLabel.font = [UIFont fontWithName:@"stalker1" size:13];
    
    
    
    return cell;
}

-(void)abrirTelaDetalhe:(id)sender {
    [self performSegueWithIdentifier:@"detalhe" sender:sender];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detalhe"]) {

        DetalheViewController *detalhe = [segue destinationViewController];
        detalhe.imageLocalSelecionado = ((UIButton*)sender).imageView.image;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/



@end
