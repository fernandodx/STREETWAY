//
//  LocalTableViewCell.h
//  StreetWay
//
//  Created by Fernando Dias on 21/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "Local.h"

@interface LocalTableViewCell : UITableViewCell<RateViewDelegate>

@property(nonatomic, strong) IBOutlet UILabel* labelNome;
@property(nonatomic, strong) IBOutlet UIImageView* imageViewLocal;
@property(nonatomic, strong) IBOutlet UIButton* iconeMapa;
@property(nonatomic, strong) IBOutlet RateView* rateView;
@property(nonatomic, strong) Local* local;
@property(nonatomic, strong) UINavigationController* navigationControll;


-(IBAction)abrirTelaMapa:(id)sender;


@end
