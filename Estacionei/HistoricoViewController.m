//
//  HistoricoViewController.m
//  Estacionei
//
//  Created by Paulo Cesar on 12/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "HistoricoViewController.h"
#import "AppDelegate.h"
#import "Historico.h"
#import "ResultadoViewController.h"

@interface HistoricoViewController ()

@end

@implementation HistoricoViewController

@synthesize historicoTableView;
@synthesize dataSource;
@synthesize historicoCell;
@synthesize codigoCell;
@synthesize textoCell;
@synthesize subtituloCell;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self obterItens];
    [historicoTableView reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; // Valor fixo para apenas um seção
}

// retorna o tamanho da mutableArray
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataSource count] == 0)
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        [historicoTableView setEditing:NO animated:YES];
    }
    else
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;        
//        if(!historicoTableView.editing)
//        {
//            self.navigationItem.leftBarButtonItem.title = @"Finalizar";
//            self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
//        }
//        else
//        {
//            self.navigationItem.leftBarButtonItem = self.editButtonItem;
//        }
    }
    
    return [dataSource count];
}

// implementação das células do tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idCell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HistoricoCell" owner:self options:nil];
        
        cell = self.historicoCell;
        
        if([dataSource count] > 0)
        {
            Historico *Entity = [dataSource objectAtIndex:[indexPath row]];
            
            codigoCell.text = Entity.codigo_estacionamento;
            codigoCell.backgroundColor = [AppDelegate colorFromHexString:Entity.cor_estacionamento];
            
            textoCell.text = Entity.empreendimento;
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            
            subtituloCell.text = [DateFormatter stringFromDate:Entity.data];
        }
        
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"resultado" sender:nil];
    [historicoTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteItem:indexPath.row];
        [historicoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(IBAction)editTableForDeletingRow:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = historicoTableView.editing;
    
    [historicoTableView setEditing:!historicoTableView.editing animated:YES];
}

// Obtem no momento que muda de view atraves de push (navigation bar)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"resultado"])
    {
        ResultadoViewController *controller = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.historicoTableView indexPathForSelectedRow];
        
        NSMutableArray *item = [dataSource objectAtIndex:indexPath.row];
        
        controller._empreendimento = [item valueForKey:@"empreendimento"];
        controller._codigoEstacionamento = [item valueForKey:@"codigo_estacionamento"];
        controller._infoEstacionamento = [item valueForKey:@"nome_estacionamento"];
        controller._acessoEstacionamento = [item valueForKey:@"acesso_estacionamento"];
        controller._corEstacionamento = [item valueForKey:@"cor_estacionamento"];
    }
}

- (void)obterItens
{
    @try
    {
        dataSource = [Historico obterItens];
    }
    @catch (NSException *exception)
    {
        [AppDelegate exibirAlert:[exception name] Mensagem:[exception reason]];
    }
}

- (IBAction)deleteItem:(int)sender
{
    AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    Historico *Entity = [dataSource objectAtIndex:sender];
    
    [myAppDelegate.managedObjectContext deleteObject:Entity];
    
    NSError *error = nil;
    if(![myAppDelegate.managedObjectContext save:&error])
    {
        NSLog(@"%@", error.description);
        dataSource = nil;
    }
    
    [self obterItens];
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
    gAdBannerView.adUnitID = @"a15139ccbda359d"; //@"a15130f48b838fc";
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
