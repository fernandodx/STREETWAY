//
//  MapLocalViewController.m
//  StreetWay
//
//  Created by Fernando Dias on 31/07/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "MapLocalViewController.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "LocalCollectionViewController.h"

@interface MapLocalViewController (){
    
    CLLocation* localizacaoAtual;
    
}


@property(nonatomic, strong) IBOutlet MKMapView* mapa;
@property(nonatomic, strong) IBOutlet UIButton* btNavergarGps;



@end

@implementation MapLocalViewController

@synthesize mapa, btNavergarGps, locationManager, local;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 100;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    FAKFontAwesome* iconeMap = [FAKFontAwesome carIconWithSize:30];
    [self.btNavergarGps setImage:[iconeMap imageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.btNavergarGps setTitle:@"" forState:UIControlStateNormal];

    [self.locationManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    
    
    CLLocation* localSelecionado = [[CLLocation alloc] initWithLatitude:[self.local.latitude_local doubleValue]
                                                              longitude:[self.local.longitude_local doubleValue]];
    
    MKCoordinateRegion coordenada;
    coordenada.center = [localSelecionado coordinate];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    coordenada.span = span;
    
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:localSelecionado.coordinate fromEyeCoordinate:localSelecionado.coordinate eyeAltitude:5000];
    
    [self.mapa setCamera:camera animated:YES];
    
    MKPointAnnotation* ponto = [MKPointAnnotation new];
    [ponto setCoordinate:localSelecionado.coordinate];
    [ponto setTitle:self.local.nome_local];
    
    [self.mapa addAnnotation:ponto];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
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


-(void)enviarAoGps:(id)sender {
    
    [UIView animateWithDuration:3 animations:^{
        
        CGRect frame = self.btNavergarGps.frame;
        
        frame.origin = CGPointMake(150, 150);
        
        [self.btNavergarGps setFrame:frame];
    
    } completion:^(BOOL finished) {
        
        NSString *LocalOrigem = [NSString stringWithFormat:@"%f,%f",localizacaoAtual.coordinate.latitude, localizacaoAtual.coordinate.longitude];
        
        NSString *localDestino = [NSString stringWithFormat:@"%f,%f",[self.local.latitude_local doubleValue], [self.local.longitude_local doubleValue]];
        
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@",LocalOrigem, localDestino];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }];
    
   
    
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    localizacaoAtual = [locations lastObject];
    
}


@end
