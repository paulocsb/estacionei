//
//  ScanViewController.m
//  Estacionei
//
//  Created by Paulo Cesar on 12/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "ScanViewController.h"
#import "ResultadoViewController.h"
#import "Base64.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

@synthesize readerView;

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
    
    // the delegate receives decode results
    readerView.readerDelegate = self;
    
    [[readerView scanner] setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
    [[readerView scanner] setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
    
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc] initWithViewController: self];
        cameraSim.readerView = readerView;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [readerView start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [readerView stop];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    // auto-rotation is supported
    return YES;
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient duration: (NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    [readerView willRotateToInterfaceOrientation: orient duration: duration];
}

- (void)readerView:(ZBarReaderView*) view didReadSymbols:(ZBarSymbolSet*) syms fromImage:(UIImage*) img
{
    symbolSet = syms;
    
    [self performSegueWithIdentifier:@"resultado" sender:nil];
}

// Obtem no momento que muda de view atraves de push (navigation bar)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"resultado"])
    {
        ResultadoViewController *controller = [segue destinationViewController];

        NSData *data = [[NSData alloc] init];
        
        for(ZBarSymbol *sym in symbolSet) {
            data = [Base64 decode:sym.data];
            break;
        }
        
        NSString * stringQrCode = [[NSString alloc] initWithData:data encoding:NSShiftJISStringEncoding];
        
        NSArray *dataQrCode = [[NSArray alloc] init];
        dataQrCode = [stringQrCode componentsSeparatedByString:@";"];
        
        controller._empreendimento = [[NSString alloc] initWithCString:[[dataQrCode objectAtIndex:0] cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        controller._codigoEstacionamento = [[NSString alloc] initWithCString:[[dataQrCode objectAtIndex:1] cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        controller._infoEstacionamento = [[NSString alloc] initWithCString:[[dataQrCode objectAtIndex:2] cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        controller._acessoEstacionamento = [[NSString alloc] initWithCString:[[dataQrCode objectAtIndex:3] cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        controller._corEstacionamento = [dataQrCode objectAtIndex:4];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
