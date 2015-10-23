//
//  FaceBookViewController.m
//  StreetWay
//
//  Created by Fernando Dias on 24/08/15.
//  Copyright (c) 2015 ___FernandoDias___. All rights reserved.
//

#import "FaceBookViewController.h"
#import <Firebase/Firebase.h>
#import "LocalDAO.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKMessageDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareAPI.h>
#import <FBSDKShareKit/FBSDKShareOpenGraphAction.h>
#import <FBSDKShareKit/FBSDKShareOpenGraphContent.h>
#import <FBSDKShareKit/FBSDKSharePhoto.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "FireBaseUtil.h"
#import "Usuario.h"
#import <MBProgressHUD/MBProgressHUD.h>




@interface FaceBookViewController ()

@property(nonatomic, strong) IBOutlet UILabel* nomeUsuarioLogado;
@property(nonatomic, strong) IBOutlet UIImageView* imageUsuario;
@property(nonatomic, strong) IBOutlet UILabel* emailUsuarioLogado;


@end

@implementation FaceBookViewController

@synthesize nomeUsuarioLogado, imageUsuario;

#define AUTENTICACAO_FACEBOOK @"LOGIN_FACEBOOK"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults* preferencias = [NSUserDefaults standardUserDefaults];
    
    if([preferencias objectForKey:AUTENTICACAO_FACEBOOK] != nil){

        
        NSData* dados = [preferencias objectForKey:AUTENTICACAO_FACEBOOK];
        
        Usuario* usuario = [NSKeyedUnarchiver unarchiveObjectWithData:dados];
        
        self.nomeUsuarioLogado.text = usuario.nome;
        self.emailUsuarioLogado.text = usuario.email;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.imageUsuario.image = [UIImage imageWithData:usuario.dadosImg];
        });
        
        
        
    }else{
    
    
    Firebase *ref = [FireBaseUtil getFireRef];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"]
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
                                        
                                        if (facebookError) {
                                            NSLog(@"Facebook login failed. Error: %@", facebookError);
                                        } else if (facebookResult.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            
                                            [ref authWithOAuthProvider:@"facebook" token:accessToken
                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                       
                                                       if (error) {
                                                           NSLog(@"Login failed. %@", error);
                                                       } else {
                                                           NSLog(@"Logged in! %@", authData);
                                                           
                                                           NSURL *imageURL = [NSURL URLWithString:authData.providerData[@"profileImageURL"]];

                                                            NSData *dadosImg = [NSData dataWithContentsOfURL:imageURL];
                                                           
                                                           Usuario* usuario = [Usuario new];
                                                           usuario.nome = authData.providerData[@"displayName"];
                                                           usuario.email = authData.providerData[@"email"];
                                                           usuario.dadosImg = dadosImg;
                                                           
                                                    
                                                           NSData* dados = [NSKeyedArchiver archivedDataWithRootObject:usuario];
                                                           
                                                           [preferencias setObject:dados forKey:AUTENTICACAO_FACEBOOK];
                                                           [preferencias synchronize];
                
                                                
                                                           self.nomeUsuarioLogado.text = authData.providerData[@"displayName"];
                                                           self.emailUsuarioLogado.text = authData.providerData[@"email"];
                                                           
                                                           
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                               NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   // Update the UI
                                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                   self.imageUsuario.image = [UIImage imageWithData:imageData];
                                                               });
                                                           });
                                                           
                                                       }
                                                   }];
                                        }
                                    }];
    }

  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
         }
     }];
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
