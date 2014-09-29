//
//  ViewController.m
//  PeripheralCB
//
//  Created by Andrey Karaban on 21/07/14.
//  Copyright (c) 2014 AkA. All rights reserved.
//

#import "ViewController.h"


#define NOTIFY_MTU      20

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.peripheralManager stopAdvertising];
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Peripheral Methods

/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unsupported Device's Bluetooth specification" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"POWERED ON EPTA!!!!");
    
    // ... so build our service.
    
    // Start with the CBMutableCharacteristic
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    
    // Then the service
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                       primary:YES];
    
    // Add the characteristic to the service
    transferService.characteristics = @[self.transferCharacteristic];
    
    // And add it to the peripheral manager
    [self.peripheralManager addService:transferService];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central subscribed to characteristic");
    [_peripheralManager stopAdvertising];
    
}

/** Recognise when the central unsubscribes
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central unsubscribed from characteristic");
}

//- (void)sendData
//{
//    // First up, check if we're meant to be sending an EOM
//    static BOOL sendingEOM = NO;
//    
//    if (sendingEOM) {
//        
//        // send it
//        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
//        
//        // Did it send?
//        if (didSend) {
//            
//            // It did, so mark it as sent
//            sendingEOM = NO;
//            
//            NSLog(@"Sent: EOM");
//        }
//        
//        // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
//        return;
//        NSLog(@"F A I L ____S U K A!!!!!");
//    }
//    
//    // We're not sending an EOM, so we're sending data
//    
//    // Is there any left to send?
//    
//    if (self.sendDataIndex >= self.dataToSend.length) {
//        
//        // No data left.  Do nothing
//        return;
//    }
//    
//    // There's data left, so send until the callback fails, or we're done.
//    
//    BOOL didSend = YES;
//    
//    while (didSend) {
//        
//        // Make the next chunk
//        
//        // Work out how big it should be
//        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
//        
//        // Can't be longer than 20 bytes
//        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
//        
//        // Copy out the data we want
//        NSString *stringToSend = @"EOM";
//        NSData *chunk = [stringToSend dataUsingEncoding:NSUTF8StringEncoding];
//        
//        // Send it
//        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
//        
//        // If it didn't work, drop out and wait for the callback
//        if (!didSend) {
//            return;
//        }
//        
//        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
//        NSLog(@"Sent: %@", stringFromData);
//        
//        // It did send, so update our index
//        self.sendDataIndex += amountToSend;
//        
//        // Was it the last one?
//        if (self.sendDataIndex >= self.dataToSend.length) {
//            
//            // It was - send an EOM
//            
//            // Set this so if the send fails, we'll send it next time
//            sendingEOM = YES;
//            
//            // Send it
//            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
//            
//            if (eomSent) {
//                // It sent, we're all done
//                sendingEOM = NO;
//                
//                NSLog(@"Sent: EOM");
//            }
//            
//            return;
//        }
//    }
//}
//
//- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
//{
//    // Start sending again
//    [self sendData];
//}


#pragma mark - SendData Action

- (IBAction)sendData:(id)sender
{
    //[self sendData];
    [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
    NSLog(@"PO RN STYLE");
}
@end
