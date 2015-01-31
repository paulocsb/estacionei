//
//  ResultadoViewController.h
//  Estacionei
//
//  Created by Paulo Cesar on 14/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface ResultadoViewController : UIViewController <ADBannerViewDelegate, GADBannerViewDelegate>
{

}

@property (strong, nonatomic) NSString *_empreendimento;
@property (strong, nonatomic) NSString *_codigoEstacionamento;
@property (strong, nonatomic) NSString *_infoEstacionamento;
@property (strong, nonatomic) NSString *_acessoEstacionamento;
@property (strong, nonatomic) NSString *_corEstacionamento;
@property (strong, nonatomic) IBOutlet UILabel *empreendimento;
@property (strong, nonatomic) IBOutlet UILabel *codigoEstacionamento;
@property (strong, nonatomic) IBOutlet UILabel *infoEstacionamento;
@property (strong, nonatomic) IBOutlet UILabel *acessoEstacionamento;
@property (strong, nonatomic) IBOutlet UIView *corEstacionamento;
// ADBanner e ADMob
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

@end
