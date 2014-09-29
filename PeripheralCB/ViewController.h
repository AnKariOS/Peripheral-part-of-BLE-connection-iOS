//
//  ViewController.h
//  PeripheralCB
//
//  Created by Andrey Karaban on 21/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferService.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBPeripheralManagerDelegate>


@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;


- (IBAction)sendData:(id)sender;

@end
