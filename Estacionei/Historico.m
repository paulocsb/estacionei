//
//  Historico.m
//  Estacionei
//
//  Created by Paulo Cesar on 14/02/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "Historico.h"
#import "AppDelegate.h"


@implementation Historico

@dynamic empreendimento;
@dynamic codigo_estacionamento;
@dynamic nome_estacionamento;
@dynamic acesso_estacionamento;
@dynamic cor_estacionamento;
@dynamic data;
@dynamic is_atual;

+ (void)salvar:(NSArray *)Item
{
    @try
    {
        AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        Historico *Entity = (Historico *)[NSEntityDescription insertNewObjectForEntityForName:@"Historico" inManagedObjectContext:myAppDelegate.managedObjectContext];

        [Entity setCodigo_estacionamento:[Item objectAtIndex:0]];
        [Entity setNome_estacionamento:[Item objectAtIndex:1]];
        [Entity setAcesso_estacionamento:[Item objectAtIndex:2]];
        [Entity setEmpreendimento:[Item objectAtIndex:3]];
        [Entity setCor_estacionamento:[Item objectAtIndex:4]];
        [Entity setData:[Item objectAtIndex:5]];
        [Entity setIs_atual:YES];
        
        NSError *error = nil;
        if(![myAppDelegate.managedObjectContext save:&error])
        {
            NSLog(@"%@", error.description);
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Ocorreu um erro, tente novamente!"
                    userInfo:nil];
        }
    }
    @catch (NSException *exception)
    {
        @throw exception;
    }
}

+ (NSArray *)obterItens
{
    @try
    {
        AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Historico" inManagedObjectContext:myAppDelegate.managedObjectContext];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]];
        
        NSError *error = nil;
        
        return [myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
        
        if(error)
        {
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Não foi possível obter os dados."
                    userInfo:nil];
        }
    }
    @catch (NSException *exception)
    {
        @throw exception;
    }
}

+ (NSArray *)obterUltimoItem
{
    @try
    {
        AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Historico" inManagedObjectContext:myAppDelegate.managedObjectContext];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]];
        [request setFetchLimit:1];
        [request setPredicate:[NSPredicate predicateWithFormat:@"is_atual=%@",@"1"]];
        
        NSError *error = nil;
        
        return [myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
        
        if(error)
        {
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Não foi possível obter os dados."
                    userInfo:nil];
        }
    }
    @catch (NSException *exception)
    {
        @throw exception;
    }
}

+ (void)removerOndeEstacionei
{
    @try
    {
        AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        Historico *historico = nil;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Historico" inManagedObjectContext:myAppDelegate.managedObjectContext];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]];
        [request setFetchLimit:1];
        [request setPredicate:[NSPredicate predicateWithFormat:@"is_atual=%@",@"1"]];
        
        NSError *error = nil;
        
        historico = [[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] lastObject];
        
        if(error)
        {
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Não foi possível completar a operação."
                    userInfo:nil];
        }
        
        if(historico != nil)
        {
            [historico setIs_atual:NO];
            
            error = nil;
            if (![myAppDelegate.managedObjectContext save:&error])
            {
                @throw [[NSException alloc]
                        initWithName:@"Erro"
                        reason:@"Não foi possível completar a operação."
                        userInfo:nil];
            }
        }
    }
    @catch (NSException *exception)
    {
        @throw exception;
    }
}

@end
