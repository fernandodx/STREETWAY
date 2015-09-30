//
//  DetalheViewController.m
//  StreetWay
//
//  Created by Fernando Dias on 12/08/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "DetalheViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "Util.h"

@interface DetalheViewController ()

@end

@implementation DetalheViewController

@synthesize scrollView, imageLocalSelecionado;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageLocalSelecionado];
    
    [self.scrollView setMaximumZoomScale:4];
    
    [self.scrollView setContentSize:imageView.frame.size];
    
    
    [self.scrollView addSubview:imageView];
    

    UITapGestureRecognizer *gestoDuploClique = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(scrollViewDuploClique:)];
    gestoDuploClique.numberOfTapsRequired = 2;
    gestoDuploClique.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:gestoDuploClique];
   
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 4
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // 5
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    // 6
    [self centerScrollViewContents];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDuploClique:(UITapGestureRecognizer*)recognizer {

    [Util alerta:@"Detalhes" ComMenssage:[NSString stringWithFormat:@"Tamanho da imagem: %8.0f X %8.0f", self.imageLocalSelecionado.size.width,  self.imageLocalSelecionado.size.height]];
   
}

- (void)centerScrollViewContents {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageLocalSelecionado];
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imageView.frame = contentsFrame;
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
