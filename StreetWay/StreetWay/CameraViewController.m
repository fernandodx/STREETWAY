//
//  CameraViewController.m
//  StreeWay
//
//  Created by Fernando Dias on 15/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "CameraViewController.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <BTRatingView/BTRatingView.h>
#import <SIAlertView/SIAlertView.h>
#import "Util.h"
#import <pop/POP.h>
#import <FBSDKShareKit/FBSDKMessageDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareAPI.h>
#import <FBSDKShareKit/FBSDKShareOpenGraphAction.h>
#import <FBSDKShareKit/FBSDKShareOpenGraphContent.h>
#import <FBSDKShareKit/FBSDKSharePhoto.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "FBSDKAccessToken.h"
#import "FBSDKGraphRequest.h"
#import "FBSDKSharePhotoContent.h"




@interface CameraViewController ()

@property (nonatomic, strong) IBOutlet UIImageView* imagemLocal;
@property(nonatomic, strong) IBOutlet UIButton* btEscolherFoto;
@property(nonatomic, strong) IBOutlet UIButton* btTirarFoto;
@property(nonatomic, strong) IBOutlet UIButton* btSalvar;
@property(nonatomic, strong) IBOutlet UITextField* nomeLocal;
@property(nonatomic, strong) IBOutlet RateView* rateView;
@property(nonatomic, strong) IBOutlet MKMapView* mapa;
@property(nonatomic, assign) float avaliacao;
@property(nonatomic, strong) IBOutlet UILabel *lbLocal;
@property(nonatomic, strong) IBOutlet UILabel *lbLocalizacao;
@property(nonatomic, strong) IBOutlet UILabel *lbMapa;
@property(nonatomic, strong) IBOutlet UIImageView* logoFace;
@property(nonatomic, strong) IBOutlet UISwitch* publicarFacebook;


@end

@implementation CameraViewController {
    CLLocation* location;
}


@synthesize imagePicker, imagemLocal, btEscolherFoto, btSalvar, btTirarFoto, rateView, avaliacao, locationManager, lbLocal, lbLocalizacao, lbMapa, logoFace, publicarFacebook;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    
    FAKFontAwesome* iconeCamera = [FAKFontAwesome cameraRetroIconWithSize:30];
    FAKFontAwesome* iconeAlbum = [FAKFontAwesome filePhotoOIconWithSize:30];
    FAKFontAwesome* iconeSalvar = [FAKFontAwesome saveIconWithSize:30];
    FAKFontAwesome* imageTemplete = [FAKFontAwesome imageIconWithSize:260];
    FAKFontAwesome* iconeFacebook = [FAKFontAwesome facebookSquareIconWithSize:30];
    
    
    imagemLocal.image = [imageTemplete imageWithSize:CGSizeMake(530, 260)];
    self.logoFace.image = [iconeFacebook imageWithSize:CGSizeMake(30, 30)];
    
    
    [btEscolherFoto setImage:[iconeAlbum imageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [btEscolherFoto setTitle:@"" forState:UIControlStateNormal];
    
    [btTirarFoto setImage:[iconeCamera imageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [btTirarFoto setTitle:@"" forState:UIControlStateNormal];
    
    [btSalvar  setImage:[iconeSalvar imageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [btSalvar setTitle:@"" forState:UIControlStateNormal];
    
    FAKFontAwesome* legalCheio = [FAKFontAwesome thumbsUpIconWithSize:20];
    FAKFontAwesome* legalVazio =[FAKFontAwesome thumbsOUpIconWithSize:20];
    
    
    UIColor* vermelho =[UIColor colorWithRed:(148/255.0) green:(15/255.0) blue:(20/255.0) alpha:1];
    
    [legalCheio addAttribute:NSForegroundColorAttributeName value:vermelho];
    [legalVazio addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    
    self.rateView.notSelectedImage = [legalVazio imageWithSize:CGSizeMake(20, 20)];
    self.rateView.fullSelectedImage = [legalCheio imageWithSize:CGSizeMake(20, 20)];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    BOOL existeAcessoCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if(!existeAcessoCamera){
         NSLog(@" Não tem acesso a camera!");
    }
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 100;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    
    lbLocal.font = [UIFont fontWithName:@"stalker1" size:18];
    lbLocalizacao.font = [UIFont fontWithName:@"stalker1" size:18];
    lbMapa.font = [UIFont fontWithName:@"stalker1" size:12];

    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.locationManager requestWhenInUseAuthorization];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setRateView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)escolherImagemLocal:(id)sender {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)tirarFoto:(id)sender {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(UIImage*) getImageTemplate {
    FAKFontAwesome* imageTemplete = [FAKFontAwesome imageIconWithSize:260];
    return [imageTemplete imageWithSize:CGSizeMake(530, 260)];
}

-(void) limparCampos {
    imagemLocal.image = [self getImageTemplate];
    self.nomeLocal.text = nil;
    self.rateView.rating = 0;
    self.avaliacao = 0;
}

-(BOOL) validarCamposObrigatorios {
    //Fazer o celular vibrar.
    
    
    POPSpringAnimation* animacao;
    
    POPSpringAnimation* tremer = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    tremer.springBounciness = 20;
    tremer.velocity = @(3000);
    
    NSData* img = UIImagePNGRepresentation(self.imagemLocal.image);
    NSData* imgTemplate = UIImagePNGRepresentation([self getImageTemplate]);
    
    if([img isEqualToData:imgTemplate]) {
        if((animacao = [self.imagemLocal.layer pop_animationForKey:@"TREMER"])){
            return NO;
        }
        [self.imagemLocal.layer pop_addAnimation:tremer forKey:@"TREMER"];
        return NO;
    }

    
    if(self.nomeLocal == nil || [self.nomeLocal.text length] == 0){
        if((animacao = [self.nomeLocal.layer pop_animationForKey:@"TREMER"])){
            return NO;
        }
        [self.nomeLocal.layer pop_addAnimation:tremer forKey:@"TREMER"];
        return NO;
    }
    
        return YES;
}



-(void)salvarLocal:(id)sender {
    
   // BOOL isOK = [self validarCamposObrigatorios];
    
   // if(isOK){
    if(YES){
        //LocalDAO* dao = [[LocalDAO alloc] init];
//        [dao salvarLocalFirebase:self.nomeLocal.text
//                                   ComImagem:self.imagemLocal.image
//                                  Eavaliacao:self.avaliacao
//                                   Elatitude:location.coordinate.latitude
//                                  Elongitude:location.coordinate.longitude];
//        
        
        
            if(self.publicarFacebook.on) {
              
                if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
                   
                    NSString *LocalOrigem = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude, location.coordinate.longitude];
                    
                    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@",LocalOrigem];
                    
                    
                    [[[FBSDKGraphRequest alloc]
                      initWithGraphPath:@"me/feed"
                      parameters: @{ @"message" : @"Adicionei um novo Local para se andar de Skate com o StreetWay.", @"link" : url, @"name" : self.nomeLocal.text, @"caption": @"Baixe o app StreetWay na AppleStore.", @"title": [NSString stringWithFormat:@"%@ esta com %@ Pontos", self.nomeLocal.text, [NSNumber numberWithFloat:self.avaliacao] ]}
                      HTTPMethod:@"POST"]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"Post id:%@", result[@"id"]);
                         }
                     }];
                }
                
                
//                UIImage *someImage = self.imagemLocal.image;
//                FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//                content.photos = @[[FBSDKSharePhoto photoWithImage:someImage userGenerated:YES] ];
//                // Assuming self implements <FBSDKSharingDelegate>
//                [FBSDKShareAPI shareWithContent:content delegate:self];
            
                
                
                
                
                
//                NSDictionary *properties = @{
//                                             
//                                             @"og:type": @"books.book",
//                                             
//                                             @"og:title": @"Novo Local adicionado",
//                                             
//                                             @"og:description": @"Adicionei um novo Local.",
//                                             
//                                             @"books:isbn": @"0-553-57340-3",
//                                             
//                                             };
//                
//                FBSDKShareOpenGraphObject *object = [FBSDKShareOpenGraphObject objectWithProperties:properties];
//                
//                
//                
//                // Create an action
//                
//                FBSDKShareOpenGraphAction *action = [[FBSDKShareOpenGraphAction alloc] init];
//                
//                action.actionType = @"books.reads";
//                
//                [action setObject:object forKey:@"books:book"];
//                
//                
//                
//                
//                
//                // Create the content
//                
//                FBSDKShareOpenGraphContent *content = [[FBSDKShareOpenGraphContent alloc] init];
//                
//                content.action = action;
//                
//                content.previewPropertyName = @"books:book";
//                
//                
//                
//                [FBSDKShareDialog showFromViewController:[self.navigationController.viewControllers lastObject]
//                 
//                                             withContent:content
//                 
//                                                delegate:nil];
            }
        
            
            SIAlertView* alerta = [[SIAlertView alloc] initWithTitle:@"Sucesso!" andMessage:@"Parabéns novo local Salvo com Sucesso!"];
            
            [alerta addButtonWithTitle:@"OK"
                                  type:SIAlertViewButtonTypeDestructive
                               handler:^(SIAlertView* alerta) {
                                   
                                   NSLog(@"Limpar background");
                                   [self limparCampos];
                                   
                               }];
            [alerta show];
            
        }
//    }

}

#pragma mark - Protocolo BTRatingDelegate
-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    NSLog(@" RATING %@",[NSString stringWithFormat:@"Rating: %f", rating]);
    
    self.avaliacao = rating;
}



#pragma mark - Protocolo UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *imagemRecuperada = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    imagemLocal.image = imagemRecuperada;
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    location = [locations lastObject];
    
    MKCoordinateRegion coordenada;
    coordenada.center = [location coordinate];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    coordenada.span = span;
    
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:location.coordinate fromEyeCoordinate:location.coordinate eyeAltitude:1000];
    
    [self.mapa setCamera:camera animated:YES];
    
    MKPointAnnotation* ponto = [MKPointAnnotation new];
    [ponto setCoordinate:location.coordinate];
    [ponto setTitle:@"Você esta aqui!"];
    
    [self.mapa addAnnotation:ponto];
    
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
