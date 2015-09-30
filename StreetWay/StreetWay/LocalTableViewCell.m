//
//  LocalTableViewCell.m
//  StreetWay
//
//  Created by Fernando Dias on 21/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "LocalTableViewCell.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "MapLocalViewController.h"
#import "LocalCollectionViewController.h"

@implementation LocalTableViewCell

@synthesize labelNome, imageViewLocal, rateView, iconeMapa, local, navigationControll;


- (void)awakeFromNib {
    
    UIColor* vermelho =[UIColor colorWithRed:(148/255.0) green:(15/255.0) blue:(20/255.0) alpha:1];
    UIColor* azul =[UIColor colorWithRed:(22/255.0) green:(179/255.0) blue:(161/255.0) alpha:1];
    UIColor* cinzaEscuro =[UIColor colorWithRed:(212/255.0) green:(215/255.0) blue:(219/255.0) alpha:1];
    
    
    FAKFontAwesome* legalCheio = [FAKFontAwesome thumbsUpIconWithSize:20];
    FAKFontAwesome* legalVazio =[FAKFontAwesome thumbsOUpIconWithSize:20];
    FAKFontAwesome* btMapa = [FAKFontAwesome mapMarkerIconWithSize:30];
    
    [legalCheio addAttribute:NSForegroundColorAttributeName value:vermelho];
    [btMapa addAttribute:NSForegroundColorAttributeName value:azul];
    [legalVazio addAttribute:NSForegroundColorAttributeName value:cinzaEscuro];
    
    
    self.rateView.notSelectedImage = [legalVazio imageWithSize:CGSizeMake(20, 20)];
    self.rateView.fullSelectedImage = [legalCheio imageWithSize:CGSizeMake(20, 20)];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    [self.iconeMapa setImage:[btMapa imageWithSize:CGSizeMake(30, 30)]
                    forState:UIControlStateNormal];
    [self.iconeMapa setTitle:@"" forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  }

-(void)abrirTelaMapa:(id)sender {
    MapLocalViewController* mapa = [MapLocalViewController new];
    mapa.local = self.local;
    
    [self.navigationControll pushViewController:mapa animated:YES];
}

-(void)abrirTelaAddFoto:(id)sender {
    [self.navigationControll performSegueWithIdentifier:@"TELA_ADD_FOTO" sender:sender];
}



- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    LocalCollectionViewController* localCollection = [LocalCollectionViewController new];
    
    [self.navigationControll pushViewController:localCollection animated:YES];
    
}






@end
