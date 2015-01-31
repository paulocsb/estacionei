//
//  CartaoEstacionamentoViewController.h
//  Estacionei
//
//  Created by Paulo Cesar on 12/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface HistoricoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate, GADBannerViewDelegate>
{
    NSArray *dataSource;
    IBOutlet UITableView *historicoTableView;
    UITableViewCell *historicoCell;
    IBOutlet UILabel *textoCell;
    IBOutlet UILabel *subtituloCell;
    IBOutlet UILabel *codigoCell;
}

@property(nonatomic,strong) NSArray *dataSource;
@property(nonatomic,strong) IBOutlet UITableView *historicoTableView;
@property(nonatomic,strong) IBOutlet UITableViewCell *historicoCell;
@property(nonatomic,strong) IBOutlet UILabel *textoCell;
@property(nonatomic,strong) IBOutlet UILabel *subtituloCell;
@property(nonatomic,strong) IBOutlet UILabel *codigoCell;
// ADBanner e ADMob
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

-(IBAction)editTableForDeletingRow:(id)sender;

@end
