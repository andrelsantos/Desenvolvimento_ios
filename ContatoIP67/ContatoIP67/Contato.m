//
//  Contato.m
//  ContatoIP67
//
//  Created by ios6750 on 04/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

#import "Contato.h"

@implementation Contato
-(NSString *)description {
    return [NSString stringWithFormat: @"Nome: %@, Email: %@, Telefone: %@, Endereco: %@, Site: %@",self.nome, self.email,self.telefone,self.endereco,self.site];
}
-(CLLocationCoordinate2D) coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

-(NSString *)title {
    return self.nome;
}

-(NSString *)subtitle {
    return self.site;
}

@dynamic nome,email,telefone,endereco,site,longitude,latitude,foto;

@end
