//
//  InicioTabBarController.m
//  StreeWay
//
//  Created by Fernando Dias on 11/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "InicioTabBarController.h"
#import <FontAwesomeKit/FontAwesomeKit.h>


@interface InicioTabBarController ()

@end

@implementation InicioTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FAKFontAwesome* iconeHome = [FAKFontAwesome homeIconWithSize:30];
    FAKFontAwesome* iconeCamera = [FAKFontAwesome cameraRetroIconWithSize:30];
    FAKFontAwesome* iconeTop = [FAKFontAwesome thumbsOUpIconWithSize:30];
    FAKFontAwesome* iconeFacebook = [FAKFontAwesome facebookSquareIconWithSize:30];
    FAKFontAwesome* iconePesquisa = [FAKFontAwesome searchIconWithSize:30];
    FAKFontAwesome* iconeGlobal = [FAKFontAwesome globeIconWithSize:30];
    
    UITabBarItem* abaInicio = [self.tabBar.items objectAtIndex:0];
    UITabBarItem* abaPesquisa = [self.tabBar.items objectAtIndex:1];
    UITabBarItem* abaCamera = [self.tabBar.items objectAtIndex:2];
    UITabBarItem* abaTop = [self.tabBar.items objectAtIndex:3];
    UITabBarItem* abaFacebook = [self.tabBar.items objectAtIndex:4];
    UITabBarItem* abaFotosGlobal = [self.tabBar.items objectAtIndex:5];
    
    [abaInicio setImage:[iconeHome imageWithSize:CGSizeMake(30, 30)]];
    [abaPesquisa setImage:[iconePesquisa imageWithSize:CGSizeMake(30, 30)]];
    [abaCamera setImage:[iconeCamera imageWithSize:CGSizeMake(30, 30)]];
    [abaTop setImage:[iconeTop imageWithSize:CGSizeMake(30, 30)]];
    [abaFacebook setImage:[iconeFacebook imageWithSize:CGSizeMake(30, 30)]];
    [abaFotosGlobal setImage:[iconeGlobal imageWithSize:CGSizeMake(30, 30)]];
    
    [self.tabBar setTintColor:[UIColor orangeColor]];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
