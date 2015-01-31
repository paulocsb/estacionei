//
//  ScanViewController.h
//  Estacionei
//
//  Created by Paulo Cesar on 12/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController <ZBarReaderViewDelegate>
{
    ZBarReaderView *readerView;
    ZBarCameraSimulator *cameraSim;
    ZBarSymbolSet *symbolSet;
}

@property (nonatomic, retain) IBOutlet ZBarReaderView *readerView;

@end
