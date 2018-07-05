//
//  Contato.h
//  ContatoIP67
//
//  Created by ios6750 on 04/07/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreData/CoreData.h>

@interface Contato : NSManagedObject
//nosso objeto contato
@property (strong) NSString *nome;
@property (strong) NSString *email;
@property (strong) NSString *telefone;
@property (strong) NSString *endereco;
@property (strong) NSString *site;
@property (strong) UIImage *foto;
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;


@end
