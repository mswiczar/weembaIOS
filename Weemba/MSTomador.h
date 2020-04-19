//
//  MSTomador.h
//  weembra
//
//  Created by Moises Swiczar on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAutorizaciones.h"

@interface MSTomador : UIViewController {
	IBOutlet UILabel *pendientes;
	IBOutlet UILabel *aceptadas;
	IBOutlet UILabel *rechazadas;

	IBOutlet UILabel *proyectospublicados;
	IBOutlet UILabel *comentariosenforos;
	IBOutlet UILabel *montototalpublicado;
	id root;
	MSAutorizaciones * theautorizaciones;
	UIImageView *navImageView;
}

@property (nonatomic,assign) id root;
-(IBAction) clickpendientes:(id)aobj;
-(IBAction) clickpublicados:(id)aobj;
-(IBAction) clickforos:(id)aobj;



@end
