//
//  OndeEstacioneiViewController.m
//  Estacionei
//
//  Created by Paulo Cesar on 17/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "OndeEstacioneiViewController.h"
#import "AppDelegate.h"
#import "Historico.h"

@interface OndeEstacioneiViewController ()

@end

@implementation OndeEstacioneiViewController

@synthesize codigoEstacionamento;
@synthesize nomeEstacionamento;
@synthesize acessoEstacionamento;
@synthesize empreendimento;
@synthesize corEstacionamento;
@synthesize itens;
@synthesize nenhumCartao;
@synthesize btRemover;
@synthesize iAdBannerView;
@synthesize gAdBannerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Inicializa o iAd e AdMob
    [self bannerInicializar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self obterCartaoEstacionamento];
    
    if([self.itens count] > 0)
    {
        self.nenhumCartao.alpha = 0;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cartao"]];
        self.btRemover.enabled = YES;
    }
    else
    {
        self.nenhumCartao.alpha = 1;
        self.view.backgroundColor = [UIColor whiteColor];
        self.btRemover.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
- (void)obterCartaoEstacionamento
{
    @try
    {
        self.itens = [Historico obterUltimoItem];
        
        if([self.itens count] > 0)
        {
            Historico *dataSource = (Historico *)[self.itens objectAtIndex:0];
            
            self.empreendimento.text = dataSource.empreendimento;
            self.codigoEstacionamento.text = dataSource.codigo_estacionamento;
            self.nomeEstacionamento.text = dataSource.nome_estacionamento;
            self.acessoEstacionamento.text = dataSource.acesso_estacionamento;
            self.corEstacionamento.backgroundColor = [AppDelegate colorFromHexString:dataSource.cor_estacionamento];
        }
    }
    @catch (NSException *exception)
    {
        [AppDelegate exibirAlert:[exception name] Mensagem:[exception reason]];
    }
}

- (IBAction)removerCartaoEstacionamento:(id)sender
{
    @try
    {
        [Historico removerOndeEstacionei];
        [self viewWillAppear:YES];
    }
    @catch (NSException *exception)
    {
        [AppDelegate exibirAlert:[exception name] Mensagem:[exception reason]];
    }
}

#pragma mark - ADBanner
- (void)bannerInicializar
{
    CGRect contentFrame = self.view.bounds;
    CGSize bannerSize = [[ADBannerView alloc] sizeThatFits:contentFrame.size];
    iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, (contentFrame.size.height-(bannerSize.height))+1, bannerSize.width, bannerSize.height)];
    iAdBannerView.delegate = self;
    iAdBannerView.hidden = YES;
    [self.view addSubview:iAdBannerView];
    
    gAdBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, (contentFrame.size.height-(GAD_SIZE_320x50.height))+1, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    gAdBannerView.adUnitID = @"a15130f48b838fc";
    gAdBannerView.hidden = YES;
    gAdBannerView.rootViewController = self;
    [self.view addSubview:gAdBannerView];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self hideTopBanner:gAdBannerView];
    [self showTopBanner:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [gAdBannerView loadRequest:[GADRequest request]];
    [self hideTopBanner:iAdBannerView];
    [self showTopBanner:gAdBannerView];
}

- (void) adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error{
    [self hideTopBanner:banner];
}

- (void) adViewDidReceiveAd:(GADBannerView *)banner{
    if ([iAdBannerView isHidden]) {
        [self showTopBanner:banner];
    }
}

- (void)hideTopBanner:(UIView *)banner{
    if (banner && ![banner isHidden]) {
        [UIView beginAnimations:@"bannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = YES;
    }
}

- (void)showTopBanner:(UIView *)banner{
    if (banner && [banner isHidden]) {
        [UIView beginAnimations:@"bannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = NO;
    }
}

@end
