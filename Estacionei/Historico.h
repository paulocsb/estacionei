//
//  Historico.h
//  Estacionei
//
//  Created by Paulo Cesar on 14/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Historico : NSManagedObject

@property (nonatomic, retain) NSString * empreendimento;
@property (nonatomic, retain) NSString * codigo_estacionamento;
@property (nonatomic, retain) NSString * nome_estacionamento;
@property (nonatomic, retain) NSString * acesso_estacionamento;
@property (nonatomic, retain) NSString * cor_estacionamento;
@property (nonatomic, retain) NSDate * data;
@property (nonatomic) BOOL is_atual;

+ (NSArray *)obterItens;
+ (NSArray *)obterUltimoItem;
+ (void)salvar:(NSArray *)Item;
+ (void)removerOndeEstacionei;

@end
