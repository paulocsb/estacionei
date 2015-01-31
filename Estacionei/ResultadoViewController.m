 //
//  ResultadoViewController.m
//  Estacionei
//
//  Created by Paulo Cesar on 14/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "ResultadoViewController.h"
#import "AppDelegate.h"
#import "Historico.h"

@interface ResultadoViewController ()

@end

@implementation ResultadoViewController

@synthesize codigoEstacionamento;
@synthesize infoEstacionamento;
@synthesize acessoEstacionamento;
@synthesize empreendimento;
@synthesize corEstacionamento;
@synthesize _codigoEstacionamento;
@synthesize _infoEstacionamento;
@synthesize _acessoEstacionamento;
@synthesize _empreendimento;
@synthesize _corEstacionamento;
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cartao"]];
    
    self.empreendimento.text = self._empreendimento;
    self.codigoEstacionamento.text = self._codigoEstacionamento;
    self.infoEstacionamento.text = self._infoEstacionamento;
    self.acessoEstacionamento.text = self._acessoEstacionamento;
    self.corEstacionamento.backgroundColor = [AppDelegate colorFromHexString:self._corEstacionamento];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)salvar:(id)sender
{
    @try
    {
        NSArray *Entity = [[NSArray alloc] initWithObjects: self.codigoEstacionamento.text, self.infoEstacionamento.text, self.acessoEstacionamento.text, self.empreendimento.text, self._corEstacionamento, [NSDate date], nil];
        
        NSMutableArray *array = [self readFromPlist:@"temp.plist"];
        
        NSArray *keys = [NSArray arrayWithObjects:@"codigo", @"info", @"acesso", @"empreendimento", @"cor", @"data", nil];
        [array addObject:[NSDictionary dictionaryWithObjects:Entity forKeys:keys]];
        
        if([self writeToPlist:@"temp.plist" withData:array])
        {
            [Historico removerOndeEstacionei];
            [Historico salvar:Entity];
        
            [AppDelegate exibirAlert:@"Sucesso" Mensagem:@"O cartão do estacionamento foi salvo com sucesso!"];
            [self fecharModal:nil];
        }
        else
        {
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Não foi possível salvar o cartão de estacionamento!"
                    userInfo:nil];
        }
    }
    @catch (NSException *exception)
    {
        [AppDelegate exibirAlert:[exception name] Mensagem:[exception reason]];
        [self fecharModal:nil];
    }
}

- (BOOL) writeToPlist: (NSString*)fileName withData:(NSMutableArray *)data
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return [data writeToFile:finalPath atomically: YES];
}

- (NSMutableArray *) readFromPlist: (NSString *)fileName {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
    if (fileExists) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
        return arr;
    } else {
        return nil;
    }
}

- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText
{
    CGSize labelSize = CGSizeMake(250, 300);
    CGSize theStringSize = [theText sizeWithFont:self.acessoEstacionamento.font constrainedToSize:labelSize lineBreakMode:self.acessoEstacionamento.lineBreakMode];
    self.acessoEstacionamento.frame = CGRectMake(self.acessoEstacionamento.frame.origin.x, self.acessoEstacionamento.frame.origin.y, theStringSize.width, theStringSize.height);
    self.acessoEstacionamento.text = theText;
}

- (IBAction)fecharModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
