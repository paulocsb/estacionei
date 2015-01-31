//
//  OndeEstacioneiViewController.h
//  Estacionei
//
//  Created by Paulo Cesar on 17/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface OndeEstacioneiViewController : UIViewController <UITabBarControllerDelegate, UITabBarDelegate, ADBannerViewDelegate, GADBannerViewDelegate>
{

}

@property (strong, nonatomic) NSArray *itens;
@property (strong, nonatomic) IBOutlet UILabel *empreendimento;
@property (strong, nonatomic) IBOutlet UILabel *codigoEstacionamento;
@property (strong, nonatomic) IBOutlet UILabel *nomeEstacionamento;
@property (strong, nonatomic) IBOutlet UILabel *acessoEstacionamento;
@property (strong, nonatomic) IBOutlet UIView *corEstacionamento;
@property (strong, nonatomic) IBOutlet UIView *nenhumCartao;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btRemover;
// ADBanner e ADMob
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

- (IBAction)removerCartaoEstacionamento:(id)sender;

@end
