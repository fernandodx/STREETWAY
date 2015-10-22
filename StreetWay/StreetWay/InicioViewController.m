//
//  InicioViewController.m
//  StreeWay
//
//  Created by Fernando Dias on 13/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "InicioViewController.h"
#import "LocalDAO.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "Util.h"
#import <Firebase/Firebase.h>
#import "FireBaseUtil.h"
#import "LocalPontoAnnotation.h"
#import "MapLocalViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface InicioViewController (){

  CLLocation* localizacaoAtual;

}

@end

@implementation InicioViewController

@synthesize mapa, locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapa setDelegate:self];
    [self.mapa setMapType:MKMapTypeStandard];
    [self.mapa setZoomEnabled:YES];
    
   MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   hud.labelText = @"Carregando...";
   
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.locationManager requestWhenInUseAuthorization];

    
    NSMutableArray *listaLocais =  [NSMutableArray new];
    
    
    Firebase *fireRef = [FireBaseUtil getFireRef];
    
    [fireRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (snapshot.childrenCount == 0 ) {
            [Util alerta:@"Alerta!" ComMenssage:@"Nenhum Local Encontrado! Que tal cadastrar um agora?"];
        }
        
        FDataSnapshot* dadosEventos = [snapshot childSnapshotForPath:LOCAIS];
        
        for (FDataSnapshot* evento in dadosEventos.children) {
            
            [listaLocais addObject:[Local getLocalFire:evento]];
           
        }
        
        for (Local* local in listaLocais) {
            
            LocalPontoAnnotation* ponto = [LocalPontoAnnotation new];
            
            CLLocationCoordinate2D pinCoordinate;
            pinCoordinate.latitude = [local.latitude_local floatValue];
            pinCoordinate.longitude = [local.longitude_local floatValue];
            
            [ponto setCoordinate:pinCoordinate];
            [ponto setLocal:local];
            
            [ponto setTitle:local.nome_local];
            
            [self.mapa addAnnotation:ponto];
            
        }

        
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.mapa setShowsUserLocation:YES];
        [self.locationManager startUpdatingLocation];
    }
    
    
    if(localizacaoAtual != nil){
        MKCoordinateRegion coordenada;
        coordenada.center = [localizacaoAtual coordinate];
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        
        coordenada.span = span;
        
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:localizacaoAtual.coordinate fromEyeCoordinate:localizacaoAtual.coordinate eyeAltitude:100000];
        
        [self.mapa setCamera:camera animated:YES];
    }
    
}

//Chamado ao sair da tela
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}




#pragma mark - CLLocation

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    localizacaoAtual = [locations lastObject];
    CLLocation* location = [locations lastObject];
    
    MKCoordinateRegion coordenada;
    coordenada.center = [location coordinate];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    coordenada.span = span;
    
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:location.coordinate fromEyeCoordinate:location.coordinate eyeAltitude:100000];
    
    [self.mapa setCamera:camera animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Erro MAPA: %@", [error description]);
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
   
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
    
        if (!pinView){
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:SFAnnotationIdentifier];
        
            UIColor* vermelho =[UIColor colorWithRed:(148/255.0) green:(15/255.0) blue:(20/255.0) alpha:1];

            FAKFontAwesome* iconeLocal = [FAKFontAwesome flagCheckeredIconWithSize:25];
        
            [iconeLocal addAttribute:NSForegroundColorAttributeName value:vermelho];
        
            UIImage *flagImage = [iconeLocal imageWithSize:CGSizeMake(25, 25)];
            annotationView.image = flagImage;
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;

            //Adiciona um botão de informação no popup que subiu.
            UIButton *btPonto = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = btPonto;
        
            return annotationView;
        }else{
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    LocalPontoAnnotation* ponto = view.annotation;
    
    MapLocalViewController * map = [MapLocalViewController new];
    map.local = ponto.local;
    
    [self.navigationController pushViewController:map animated:YES];
    
   
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"=======> %@",sender);
}


@end
