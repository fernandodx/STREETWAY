//
//  AlterarLocalViewController.m
//  StreetWay
//
//  Created by Fernando Dias on 21/10/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "AlterarLocalViewController.h"

@interface AlterarLocalViewController ()


@end

@implementation AlterarLocalViewController

@synthesize imageLocal, imagemSelecionada;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageLocal.image = self.imagemSelecionada;
    
    
    // Do any additional setup after loading the view.
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
