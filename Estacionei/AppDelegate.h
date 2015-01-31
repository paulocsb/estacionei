//
//  AppDelegate.h
//  Estacionei
//
//  Created by Paulo Cesar on 11/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (void)exibirAlert:(NSString *)titulo Mensagem:(NSString *)mensagem;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
