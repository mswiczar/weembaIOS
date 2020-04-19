//
//  WSCall.m
//  Detelefoongids
//
//  Created by Moises Swiczar on 4/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WSCall.h"
//#import "XMLReaderLite.h"
//#import "XMLReaderObject.h"
//#import "UChache.h"
//#import "oleoAppDelegate.h"
#import "CJSONDeserializer.h" 



@implementation WSCall

/*

+(BOOL) getdataLatitude :(float)Latitude Longitude:(float)Longitude thelocation:(NSString**) thelocation

{
	NSMutableArray* thearray = [[NSMutableArray alloc]init];
	BOOL salida;
	[thearray removeAllObjects];
	NSString * url2call = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%f%@%f&output=xml", Latitude,@"%20", Longitude];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:url2call]];
	[request setHTTPMethod:@"GET"];
	NSURLResponse *response;
	NSError *error=nil;
	// Send the synch request to server
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		// not error happend continue with the parser
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(myResponse);
		// allocation the parser to process the data and alos 
		
		XMLReaderObject *ret = [XMLReaderObject alloc];
		ret.ObjectName =@"Placemark";
		ret.products = thearray;
		if ([ret parseXML:myResponse ])
		{
			//
			NSUInteger thecant =  [thearray count];
			NSUInteger i ;
			NSMutableDictionary * theaddressobj;
			for ( i=0 ; i< thecant ; i++)
			{
				theaddressobj = [thearray objectAtIndex:i];
				NSLog([theaddressobj objectForKey:@"address"]);
				
			}
			if(thecant==0)
			{
				salida= NO;
			}
			else
			{
				theaddressobj = [thearray objectAtIndex:0];
				//*thelocation = [NSString stringWithFormat:@"%@", [theaddressobj objectForKey:@"address"]];
				*thelocation = [NSString stringWithFormat:@"%@, %@", [theaddressobj objectForKey:@"LocalityName"],
								[theaddressobj objectForKey:@"ThoroughfareName"]];

				
				//PostalCodeNumber
				
				
			}
			
			salida= YES;
			
		}
		else
		{
			salida= NO;
		}
		
		[ret release];
	}
	else
	{
		// there is an error, just return NO to the caller
		salida= NO;		
	}
	[thearray removeAllObjects];
	[thearray release];
	return salida;
}
*/

+(BOOL) callBanner:(NSMutableDictionary*)abanner
{
	/*
	Devolución de Banner.
	Llamada (parámetros por POST o GET):
	 http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0015
	
	Parámetros de solicitud:
	<usuario>: Usuario de la aplicación
	<clave>: Clave de acceso a la aplicación
	<mensaje>: 0015 // segundo mensaje búsqueda de restaurantes
	*/
	
	BOOL salida;
	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0015"]];
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSLog(@"submited: %@",string);
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				[abanner addEntriesFromDictionary:dictionary];
				salida= YES;
			}
			else 
			{
				salida= NO;
			}
		}
	}
	return salida;
	
	
	
}




+(void) saveDB:(NSString*)thename theJsonResult:(NSString*) theresult
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:thename];
	NSLog(@"%@",writableDBPath);
	NSError * therr;
	[theresult writeToFile:writableDBPath atomically:YES encoding:NSUTF32BigEndianStringEncoding error:&therr];
}



+(BOOL) callGetZonaOFFline:(NSMutableArray*)thearray
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"zonas.txt"];
	
	NSError *therr;
	NSString *myResponse = [ [NSString alloc] initWithContentsOfFile:writableDBPath encoding:NSUTF32BigEndianStringEncoding error:&therr];
	
	NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"resultados"]!=[NSNull null])
	{
		[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
	}
	return YES;
}




+(BOOL) callGetZona:(NSMutableArray*)thearray
{
	//http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0007
	
	
	[thearray removeAllObjects];
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0007"]];
	
	
	NSLog(@"%@",string);
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				if ([dictionary objectForKey:@"resultados"]!=[NSNull null])
				{
					[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
					if ([thearray count] >1)
					{
						[WSCall saveDB:@"zonas.txt" theJsonResult:myResponse];
						
					}
					salida= YES;
				}
				salida= NO;
				
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	
}


+(BOOL) callGetCocinaOFFline:(NSMutableArray*)thearray
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"cocinas.txt"];
	
	NSError *therr;
	NSString *myResponse = [ [NSString alloc] initWithContentsOfFile:writableDBPath encoding:NSUTF32BigEndianStringEncoding error:&therr];
	
	NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"resultados"]!=[NSNull null])
	{
		[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
	}
	return YES;
}

+(BOOL) callGetCocina:(NSMutableArray*)thearray
{
	//http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0006
	
	
	[thearray removeAllObjects];
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0006"]];
	
	
	NSLog(@"%@",string);
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				if ([dictionary objectForKey:@"resultados"]!=[NSNull null])
				{
					[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
					if ([thearray count] >1)
					{
						[WSCall saveDB:@"cocinas.txt" theJsonResult:myResponse];
						
					}
					
					salida= YES;
				}
				salida= NO;
				
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	
}

+(BOOL) callGetCaractOFFline:(NSMutableArray*)thearray
{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"caracteristicas.txt"];
	
	
	NSError *therr;
	NSString *myResponse = [ [NSString alloc] initWithContentsOfFile:writableDBPath encoding:NSUTF32BigEndianStringEncoding error:&therr];
	
	NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	if ([dictionary objectForKey:@"resultados"]!=[NSNull null])
	{
		[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
	}
	return YES;
}
	



+(BOOL) callGetCaract:(NSMutableArray*)thearray
{
	//http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0003
	[thearray removeAllObjects];
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0003"]];
	
	
	NSLog(@"%@",string);
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				if ([dictionary objectForKey:@"resultados"]!=[NSNull null])
				{
					[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
					if ([thearray count] >1)
					{
						[WSCall saveDB:@"caracteristicas.txt" theJsonResult:myResponse];
					}
					
					salida= YES;
				}
				salida= NO;
				
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	
	
}



+(BOOL) callGetCercanos:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray
{
	/*
	Devolución de una búsqueda por medio del calculo de la distancia.
	Llamada (parámetros por POST o GET):
http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=<usuario>&clave=<clave>&mensaje=<mensaje>&&inicio=<inicio de resultados>&numero=<cantidad de resultados>&miLongitud=<longitud del usuario>&miLatitud=<latitud del usuario>
	
	Con esto podes armar la búsqueda de restaurantes mas cercanos.
	Parámetros de solicitud:
	<usuario>: Usuario de la aplicación
	<clave>: Clave de acceso a la aplicación
	<mensaje>: 0012 // segundo mensaje búsqueda de restaurantes
	<inicio de resultados>: inicio de la devolución de resultados
	<cantidad de resultados>: cantidad de resultados a devolver
	<longitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
	<latitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
	
	Saludos

	 inicio
	 numero
	 miLongitud
	 miLatitud
	 theLocationActual.latitude= -34.56802;
	 theLocationActual.longitude=-58.43083;
	 */
	
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0012"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&inicio=%@",[thedict objectForKey:@"inicio"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&numero=%@",[thedict objectForKey:@"cantidad"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLongitud=%@",[thedict objectForKey:@"longitud"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLatitud=%@",[thedict objectForKey:@"latitud"]]];
	
	
	NSLog(@"%@",string);
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				if ([dictionary objectForKey:@"resultados"]!=[NSNull null])
				{
					[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
					salida= YES;
				}
				salida= NO;

			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	
	
	
}

+(BOOL) callGetRankings:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray
{
	/*
	Ranking de Restaurantes:
http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0010&rangoPrecio=<rangoPrecio>&servicio=<ServicioAPonderar>
	http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&udid=562A2AE8-0862-5E17-B9F7-52093BB5F3F4&mensaje=0010&ServicioAPonderar=Comida
	Este mensaje es utilizado para la Ponderación de Restaurantes, según el ranking que seleccionemos.
Campos:
	<rangoPrecio> à Campo optativo, se puede seleccionar si se quiere un rango en particular, en caso de no colocarlo, devuelve 5 restaurantes para cada rango de precio
	<ServicioAPonderar > à Campo obligatorio, nombre del servicio a Ponderar.
	
	Valores posibles para <ServicioAPonderar>:
	Comida, Servicio o Ambiente.
	
	Los campos obligatorios deben completarse según el tipo y en el caso de la contraseña debe verificarse por parte del aplicativo el correcto ingreso y reingreso de la misma.
	Los campos únicos se verificara por parte del servidor que no se ingresen usuarios repetidos, esto mismo se devolverá en un mensaje de error en caso de que exista.
	
	Devuelve los campos: ID, Nombre, <nombre del servicio a ponderar>, los campos Precio, y MVotes son meramente para los cálculos.
	
Errores:
	Error => 0002 Faltan completar los datos obligatorios.
	
	Saludos
	 
	 
	 Comida, Servicio o Ambiente
	*/
	
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0010"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&servicio=%@",[thedict objectForKey:@"ponderar"]]];
	
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
				
				salida= YES;
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	

}

+(BOOL) callGetDescuentos:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray
{
	
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0014"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&inicio=%@",[thedict objectForKey:@"inicio"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&numero=%@",[thedict objectForKey:@"cantidad"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLongitud=%@",[thedict objectForKey:@"longitud"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLatitud=%@",[thedict objectForKey:@"latitud"]]];
	
	
//	NSLog(string);
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
				
				salida= YES;
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	
}




+(NSUInteger) callRegistrarUser:(NSMutableDictionary*)thedict
{

/*
 Registración de usuarios:
 http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0009&contrasena=<contraseñadelusuario>&nombre=<nombredelusuario>&apellido=<apellidodelusuario>&email=<maildelusuario>&apodo=<apododelusuario>&telefono=<telefonodelusuario>

 Este mensaje es utilizado para la registración del usuario de Óleo:
 Campos:
 <contraseñadelusuario> à Campo obligatorio, alfanumérico, asignado al inicio de session del usuario de Óleo
 <nombredelusuario> à Campo obligatorio, alfanumérico
 <apellidodelusuario> à Campo obligatorio, alfanumérico
 <maildelusuario> à Campo único y obligatorio. Asignado al inicio de session del usuario de Óleo
 <apododelusuario> à Campo único y obligatorio. Asignado al inicio de session en la comunidad de Óleo
 <telefonodelusuario> à Campo opcional, numérico.

 Los campos obligatorios deben completarse según el tipo y en el caso de la contraseña debe verificarse por parte del aplicativo el correcto ingreso y reingreso de la misma.
 Los campos únicos se verificara por parte del servidor que no se ingresen usuarios repetidos, esto mismo se devolverá en un mensaje de error en caso de que exista.

 Errores:
 Error => 0005 à Problemas en el proceso de inserción (Problemas del servidor)
 Error => 0004 à Usuario Existente
 Error => 0002 à Faltan completar los datos obligatorios.

 Saludos
 
 contrasena=<contraseñadelusuario>&nombre=<nombredelusuario>&apellido=<apellidodelusuario>&email=<maildelusuario>&apodo=<apododelusuario>&telefono=<telefonodelusuario>

 
*/
	
	NSUInteger salida;
	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0009"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&contrasena=%@",[thedict objectForKey:@"password"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&nombre=%@",[thedict objectForKey:@"nombre"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&apellido=%@",[thedict objectForKey:@"apellido"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&email=%@",[thedict objectForKey:@"email"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&apodo=%@",[thedict objectForKey:@"username"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&telefono=%@",[thedict objectForKey:@"telefono"]]];
	
	
	
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{

				
				salida= 0;
			}
			else 
			{
				//Error => 0005 à Problemas en el proceso de inserción (Problemas del servidor)
				//Error => 0004 à Usuario Existente
				//Error => 0002 à Faltan completar los datos obligatorios.
				
				if ([[dictionary objectForKey:@"Error"] isEqualToString:@"0002"])
				{
					salida= 2;
					
				}
				
				if ([[dictionary objectForKey:@"Error"] isEqualToString:@"0004"])
				{
					salida= 4;
					
				}
				
				if ([[dictionary objectForKey:@"Error"] isEqualToString:@"0005"])
				{
					salida= 5;
					
				}
				salida= 1;
			}
		}
	}
	return salida;	
	
}



+(BOOL) callGetComentarios:(NSString*)theid thearray:(NSMutableArray*)thearray
{
	
	/*
	 Devolución de los comentarios (últimos cinco).
	 http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0004&id=1
	 Con esto podes armar los comentarios en la ficha, trae los últimos cinco. Por ahora los parámetros los podes mandar por GET o por POST estoy controlando los dos, pero después saco el GET.
	 
	 Falta el calculado de las estrellas, ahora devuelve el puntaje total del usuario
	 Los campos vuelven en el orden que me pasaste y la fecha va en formato aaaa-mm-dd (avísame si te sirve)
	 Saludos
	 */
	
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0004"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&id=%@",theid]];
	
	
	
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
				
				salida= YES;
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	
	
	
	
}


+(BOOL) callGetRest:(NSString*)theid thedict:(NSMutableDictionary*)thedict
{
/*
	Devolución de la ficha del restaurante.
	http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&Mensaje=0001&id=1
	Con esto podes armar la ficha del restaurante, falta completar algunos campos calculados, como el precio y demás(te los mando harcodeados), pero el nombre, dirección y los datos básicos deberían coincidir. Por ahora los parámetros los podes mandar por GET o por POST estoy controlando los dos, pero después saco el GET.
	Por otro lado te comento dos cosas
	Imágenes siempre son 4 y la nomenclatura es la siguiente:
	<url>/guiaoleo.com.ar/images/<prefijo>_<id Restaurante>_<nro de foto>.jpg
	<url>: http://s3.amazonaws.com
	<prefijo> : thumb à en el caso de las miniaturas , vacío en caso contrario.
	<idRestaurante> à id del restaurante que me mandas como parámetro
	<nrofoto>: existen cuatro fotos por restaurantes , sucesivas, 1,2,3,4.
	Características por ahora no tenemos numeración, así que vamos a establecer una, que te la paso en un rato, si queres por ahora harcodealas.
	Mensaje de error:
	{"Error":"<código de error>"}
	0003 – Acceso denegado
	0002 – Faltan datos
	0001 – Sin Datos
	
	http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&Mensaje=0001&id=1032
	
	Usuario: usuario de la aplicación
	Password: password de acceso a la aplicación
	Mensaje: Numero de mensaje que requerimos para el llamado
	Números de Mensajes:
	0001 – Detalle de Restaurante
 */
	
	BOOL salida;
	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0001"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&id=%@",theid]];
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSLog(@"submited: %@",string);
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				[thedict addEntriesFromDictionary:dictionary];
				salida= YES;
			}
			else 
			{
				salida= NO;
			}
		}
	}
	return salida;
	
	
	

}


/*
+(BOOL) initSession:(NSMutableDictionary*)thedict
{
	/*
	Inicio de session de usuarios:
	 http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0008&usuarioSession=<usuario de la Guia>&claveSession=<Clave perteneciente al usuario de la Guia>
	 usuario=
	 iphoneUser
	 &clave=
	 135246
	 &mensaje=0008
	 &usuarioSession=
	 &claveSession
	 Este mensaje es utilizado para el inicio de session del usuario de Oleo,
	<Usuario de la Guia>: se debe colocar un usuario valido de la Guia
	<Clave perteneciente al usuario de la Guia>: se debe colocar la clave perteneciente al usuario que intenta realizar el inicio de session en la Guia.
	 Datos de Prueba:
	 ClaveSession: iphonetest
	 usuarioSession: iphone@woonky.com
	 
	BOOL salida;
	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0008"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&usuarioSession=%@",[thedict objectForKey:@"username"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&claveSession=%@",[thedict objectForKey:@"password"]]];
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSLog(@"submited: %@",string);
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);

		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				oleoAppDelegate *appDelegate = (oleoAppDelegate *)[[UIApplication sharedApplication] delegate];
				appDelegate.theUserNick = [dictionary objectForKey:@"Usuario"];

				salida= YES;
			}
			else 
			{
				salida= NO;
			}
		}
	}
	return salida;
}
*/





+(NSUInteger) callRegistrarVoto:(NSMutableDictionary*)thedict
{
	
	/*
	 Voto a un Restaurantes:
	 http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0011
	 
	 
	 &idrestaurante=<identificadorDelRestaurante>
	 &Apodo=<ApodoDelUsuario>
	 &fechavisita=<FechaDeVisita>
	 &horario=<Horario>
	 &precio=<Precio>
	 &comida=<Comida>
	 &servicio=<Servicio>
	 &ambiente=<Ambiente>
	 &vinos=<CarteDeVinos>
	 &comentario=<ComentariosUsuario>
	 
	 Este mensaje es utilizado para la votación a un Restaurante, para un usuario registrado en la Guía.
	 Campos:
	 <identificadorDelRestaurante>: Campo obligatorio, numérico distinto de cero,
	 <ApodoDelUsuario>: Campo obligatorio, alfanumérico, único por usuario
	 <FechaDeVisita>: Campo obligatorio, formato yyyy-mm-dd
	 <Horario>: Campo obligatorio, identificador del Horario de concurrencia al restaurante, posibles valores: 1 para Mediodía, 2 para Noche
	 <Precio>: Campo obligatorio, numérico posibles valores 0, 1, 2, 3
	 <Comida>: Campo obligatorio, numérico, posibles valores 0, 1, 2, 3
	 <Servicio>: Campo obligatorio, numérico, posibles valores 0, 1, 2, 3
	 <Ambiente>: Campo obligatorio, numérico, posibles valores 0, 1, 2, 3
	 <CarteDeVinos>: Campo obligatorio, numérico, posibles valores 0, 1, 2, 4 (4 – Sin Opinión)
	 <ComentariosUsuario>: Campo Optativo, alfanumérico
	 
	 
	 Los campos obligatorios deben completarse según el tipo.
	 
	 Errores:
	 Error => 0007 à Mensaje al usuario: 180 días del último voto a un restaurante.
	 Error => 0008 à Mensaje al usuario: Los comentarios son procesados manualmente. Estima un plazo de 3 o 4 días para ver tu comentario en la ficha del restaurante.
	 Error => 0009 à Mensaje al usuario: El precio indicado se encuentra fuera del rango permitido.
	 
	 Respuesta de ejecución correcta:
	 
	 OPERACION => 006 à El proceso se ejecuto de manera correcta.
	 
	 Saludos
	 
	 
	 */
	
	NSUInteger salida;
	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0011"]];
	
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&idrestaurante=%@",[thedict objectForKey:@"idrestaurante"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&apodo=%@",[thedict objectForKey:@"apodo"]]];
	
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&fechavisita=%@",[thedict objectForKey:@"fechavisita"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&horario=%@",[thedict objectForKey:@"horario"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&precio=%@",[thedict objectForKey:@"precio"]]];
	
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&comida=%@",[thedict objectForKey:@"comida"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&servicio=%@",[thedict objectForKey:@"servicio"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&ambiente=%@",[thedict objectForKey:@"ambiente"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&vinos=%@",[thedict objectForKey:@"vinos"]]];
	
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&comentario=%@",[thedict objectForKey:@"comentario"]]];
	
	
	
	
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				
				
				salida= 0;
			}
			else 
			{
				//Error => 0005 à Problemas en el proceso de inserción (Problemas del servidor)
				//Error => 0004 à Usuario Existente
				//Error => 0002 à Faltan completar los datos obligatorios.
				
				if ([[dictionary objectForKey:@"Error"] isEqualToString:@"0007"])
				{
					salida= 7;
					
				}
				
				if ([[dictionary objectForKey:@"Error"] isEqualToString:@"0008"])
				{
					salida= 8;
					
				}
				
				if ([[dictionary objectForKey:@"Error"] isEqualToString:@"0009"])
				{
					salida= 9;
					
				}
				salida= 1;
			}
		}
	}
	return salida;	
	
}


+(BOOL) callGetSearchSTR:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray
{
	
	/*
	Devolución de una búsqueda.
	Llamada (parámetros por POST o GET):
http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=<usuario>&clave=<clave>&mensaje=<mensaje>&strsch=<cadena a buscar>&inicio=<inicio de resultados>&numero=<cantidad de resultados>&miLongitud=<longitud del usuario>&miLatitud=<latitud del usuario>
	
	Con esto podes armar la búsqueda de restaurantes, falta completar algunos campos calculados(al igual que en la ficha), pero el nombre, dirección y los datos básicos deberían coincidir.
	Parámetros de solicitud:
	<usuario>: Usuario de la aplicación
	<clave>: Clave de acceso a la aplicación
	<mensaje>: 0002 // segundo mensaje búsqueda de restaurantes
	<strsch>: cadena de caracteres a buscar
	<inicio de resultados>: inicio de la devolución de resultados
	<cantidad de resultados>: cantidad de resultados a devolver
	<longitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
	<latitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
	
	Saludos
	*/
	
	
	
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0002"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&inicio=%@",[thedict objectForKey:@"inicio"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&numero=%@",[thedict objectForKey:@"cantidad"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLongitud=%@",[thedict objectForKey:@"longitud"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLatitud=%@",[thedict objectForKey:@"latitud"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&strsch=%@",[thedict objectForKey:@"strsch"]]];
	
	
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
				
				salida= YES;
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
}


+(BOOL) callGetSearch:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray
{

/*
 Devolución de una búsqueda por medio de filtros avanzados.
 Llamada (parámetros por POST o GET):
 http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=iphoneUser&clave=135246&mensaje=0013&precios=1&caracteristicas=2&cocinas=3&zonas=2&inicio=1&numero=5
 
 Con esto podes armar la búsqueda de restaurantes más cercanos.
 Parámetros de solicitud:
 <usuario>: Usuario de la aplicación
 <clave>: Clave de acceso a la aplicación
 <mensaje>: 0013
 <inicio de resultados>: inicio de la devolución de resultados
 <cantidad de resultados>: cantidad de resultados a devolver
 <precios>: (opcional) identificador de rango de precios separados por comas
 <caracteristicas>: (opcional) identificador/es separados por comas
 <cocinas>: (opcional) identificador/es de los tipos de cocina, separados por comas
 <zonas>:(opcional) identificador/es de las zonas, separados por comas
 <longitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
 <latitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
 
 La devolución es igual al mensaje 0002 – Búsqueda de Restaurantes por nombres.
 
 */
	
	
	
	
	
	BOOL salida;	
	NSString *string =  [[NSString alloc] initWithString:@""];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"usuario=%@",USERSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&clave=%@",PASSSERVICE]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&udid=%@",UDID]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&mensaje=%@",@"0013"]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&inicio=%@",[thedict objectForKey:@"inicio"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&numero=%@",[thedict objectForKey:@"cantidad"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLongitud=%@",[thedict objectForKey:@"longitud"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&miLatitud=%@",[thedict objectForKey:@"latitud"]]];
	
//	string = [string stringByAppendingString:[NSString stringWithFormat:@"&nombre=%@",[thedict objectForKey:@"nombre"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&precios=%@",[thedict objectForKey:@"precios"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&zonas=%@",[thedict objectForKey:@"zonas"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&cocinas=%@",[thedict objectForKey:@"cocinas"]]];
	string = [string stringByAppendingString:[NSString stringWithFormat:@"&caracteristicas=%@",[thedict objectForKey:@"caracteristicas"]]];
	
	
	
	
	NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
	NSString *postLength = [length stringValue];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:5]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:URLSERVICE]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	salida= NO;
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		NSLog(@"%@",myResponse);
		
		NSData *jsonData = [myResponse dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSError *error = nil;
		
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		if(dictionary != nil)
		{
			if ([dictionary objectForKey:@"Error"]==nil)
			{
				[thearray  addObjectsFromArray:[dictionary objectForKey:@"resultados"]];
				
				salida= YES;
			}
			else 
			{
				salida= NO;
				
			}
		}
	}
	return salida;	
	
	

}



@end


/*
 
 +(BOOL) callGetSearch:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray
 {
 
 
 Devolución de una búsqueda.
 Llamada (parámetros por POST o GET):
 http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml?usuario=<usuario>&clave=<clave>&mensaje=<mensaje>&strsch=<cadena a buscar>&inicio=<inicio de resultados>&numero=<cantidad de resultados>&miLongitud=<longitud del usuario>&miLatitud=<latitud del usuario>
 
 Con esto podes armar la búsqueda de restaurantes, falta completar algunos campos calculados(al igual que en la ficha), pero el nombre, dirección y los datos básicos deberían coincidir.
 Parámetros de solicitud:
 <usuario>: Usuario de la aplicación
 <clave>: Clave de acceso a la aplicación
 <mensaje>: 0002 // segundo mensaje búsqueda de restaurantes
 <strsch>: cadena de caracteres a buscar
 <inicio de resultados>: inicio de la devolución de resultados
 <cantidad de resultados>: cantidad de resultados a devolver
 <longitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
 <latitud del usuario>: Longitud en la que se encuentra el teléfono desde donde se conecta el usuario
 
 Saludos
 
 
 NSMutableDictionary * thedictresult;
 
 
 thedictresult = [[NSMutableDictionary alloc] init];
 
 [thedictresult setObject:@"20%" forKey:@"DTO"];
 
 [thedictresult setObject:@"La Cucina de Michele" forKey:@"NOMBRE"];
 [thedictresult setObject:@"Av. Luis M. Campos 599" forKey:@"DIRECCION1"];
 [thedictresult setObject:@"Ciudad de Buenos Aires" forKey:@"DIRECCION2"];
 [thedictresult setObject:@"Italiana" forKey:@"COCINA"];
 
 
 [thedictresult setObject:@"4899-1699" forKey:@"TEL1"];
 [thedictresult setObject:@"" forKey:@"TEL2"];
 
 [thedictresult setObject:@"-34.61504" forKey:@"LAT"];
 [thedictresult setObject:@"-58.50539" forKey:@"LONG"];
 
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_3127_1.jpg" forKey:@"MINIIMAGE1"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_3127_2.jpg" forKey:@"MINIIMAGE2"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_3127_3.jpg" forKey:@"MINIIMAGE3"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_3127_4.jpg" forKey:@"MINIIMAGE4"];
 
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_3127_1.jpg" forKey:@"IMAGE1"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_3127_2.jpg" forKey:@"IMAGE2"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_3127_3.jpg" forKey:@"IMAGE3"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_3127_4.jpg" forKey:@"IMAGE4"];
 
 [thedictresult setObject:@"Martes y miércoles, de 12 a 1. Jueves a sábado, de 12 a 3. Domingo, de 12 a 1." forKey:@"HORARIOS"];
 
 [thedictresult setObject:@"23" forKey:@"VOTOCOMIDA"];
 [thedictresult setObject:@"18" forKey:@"VOTOSERVICIO"];
 [thedictresult setObject:@"11" forKey:@"VOTOAMBIENTE"];
 [thedictresult setObject:@"70" forKey:@"PRECIOD"];
 [thedictresult setObject:@"70" forKey:@"PRECION"];
 [thedictresult setObject:@"26" forKey:@"VOTOS"];
 
 [thearray addObject:thedictresult];
 [thedictresult release];
 
 
 thedictresult = [[NSMutableDictionary alloc] init];
 [thedictresult setObject:@"25%" forKey:@"DTO"];
 
 [thedictresult setObject:@"La Troupe" forKey:@"NOMBRE"];
 [thedictresult setObject:@"Jorge Newbery 1651" forKey:@"DIRECCION1"];
 [thedictresult setObject:@"Ciudad de Buenos Aires" forKey:@"DIRECCION2"];
 [thedictresult setObject:@"Parrilla" forKey:@"COCINA"];
 
 [thedictresult setObject:@"4772-9339" forKey:@"TEL1"];
 [thedictresult setObject:@"4773-8694" forKey:@"TEL2"];
 
 [thedictresult setObject:@"-34.56766" forKey:@"LAT"];
 [thedictresult setObject:@"-58.43420" forKey:@"LONG"];
 
 [thedictresult setObject:@"" forKey:@"MINIIMAGE1"];
 [thedictresult setObject:@"" forKey:@"MINIIMAGE2"];
 [thedictresult setObject:@"" forKey:@"MINIIMAGE3"];
 [thedictresult setObject:@"" forKey:@"MINIIMAGE4"];
 
 [thedictresult setObject:@"" forKey:@"IMAGE1"];
 [thedictresult setObject:@"" forKey:@"IMAGE2"];
 [thedictresult setObject:@"" forKey:@"IMAGE3"];
 [thedictresult setObject:@"" forKey:@"IMAGE4"];
 
 [thedictresult setObject:@"Todos los días, todo el día" forKey:@"HORARIOS"];
 
 [thedictresult setObject:@"22" forKey:@"VOTOCOMIDA"];
 [thedictresult setObject:@"20" forKey:@"VOTOSERVICIO"];
 [thedictresult setObject:@"17" forKey:@"VOTOAMBIENTE"];
 [thedictresult setObject:@"50" forKey:@"PRECIOD"];
 [thedictresult setObject:@"71" forKey:@"PRECION"];
 [thedictresult setObject:@"22" forKey:@"VOTOS"];
 
 [thearray addObject:thedictresult];
 [thedictresult release];
 
 thedictresult = [[NSMutableDictionary alloc] init];
 [thedictresult setObject:@"35%" forKey:@"DTO"];
 
 [thedictresult setObject:@"Chicha Baez" forKey:@"NOMBRE"];
 [thedictresult setObject:@"Baez 358" forKey:@"DIRECCION1"];
 [thedictresult setObject:@"Ciudad de Buenos Aires" forKey:@"DIRECCION2"];
 [thedictresult setObject:@"Variada" forKey:@"COCINA"];
 
 [thedictresult setObject:@"4773-8632" forKey:@"TEL1"];
 [thedictresult setObject:@"" forKey:@"TEL2"];
 
 [thedictresult setObject:@"-34.57151" forKey:@"LAT"];
 [thedictresult setObject:@"-58.43173" forKey:@"LONG"];
 
 [thedictresult setObject:@"" forKey:@"MINIIMAGE1"];
 [thedictresult setObject:@"" forKey:@"MINIIMAGE2"];
 [thedictresult setObject:@"" forKey:@"MINIIMAGE3"];
 [thedictresult setObject:@"" forKey:@"MINIIMAGE4"];
 
 [thedictresult setObject:@"" forKey:@"IMAGE1"];
 [thedictresult setObject:@"" forKey:@"IMAGE2"];
 [thedictresult setObject:@"" forKey:@"IMAGE3"];
 [thedictresult setObject:@"" forKey:@"IMAGE4"];
 
 [thedictresult setObject:@"Martes y miércoles, de 12 a 1. Jueves a sábado, de 12 a 3. Domingo, de 12 a 1." forKey:@"HORARIOS"];
 
 [thedictresult setObject:@"22" forKey:@"VOTOCOMIDA"];
 [thedictresult setObject:@"20" forKey:@"VOTOSERVICIO"];
 [thedictresult setObject:@"19" forKey:@"VOTOAMBIENTE"];
 [thedictresult setObject:@"73" forKey:@"PRECIOD"];
 [thedictresult setObject:@"87" forKey:@"PRECION"];
 [thedictresult setObject:@"16" forKey:@"VOTOS"];
 
 [thearray addObject:thedictresult];
 [thedictresult release];
 
 
 thedictresult = [[NSMutableDictionary alloc] init];
 [thedictresult setObject:@"30%" forKey:@"DTO"];
 
 [thedictresult setObject:@"Moshi Moshi" forKey:@"NOMBRE"];
 [thedictresult setObject:@"Ortega y Gasset 1707 y Soldado de la Independencia" forKey:@"DIRECCION1"];
 [thedictresult setObject:@"Ciudad de Buenos Aires" forKey:@"DIRECCION2"];
 [thedictresult setObject:@"Japonesa" forKey:@"COCINA"];
 
 [thedictresult setObject:@"4772-2005" forKey:@"TEL1"];
 [thedictresult setObject:@"4775-0225" forKey:@"TEL2"];
 
 [thedictresult setObject:@"-34.56886" forKey:@"LAT"];
 [thedictresult setObject:@"-58.43156" forKey:@"LONG"];
 
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1374_1.jpg" forKey:@"MINIIMAGE1"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1374_2.jpg" forKey:@"MINIIMAGE2"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1374_3.jpg" forKey:@"MINIIMAGE3"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1374_4.jpg" forKey:@"MINIIMAGE4"];
 
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1374_1.jpg" forKey:@"IMAGE1"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1374_2.jpg" forKey:@"IMAGE2"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1374_3.jpg" forKey:@"IMAGE3"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1374_4.jpg" forKey:@"IMAGE4"];
 
 [thedictresult setObject:@"Martes a domingo desde las 20.30" forKey:@"HORARIOS"];
 
 [thedictresult setObject:@"21" forKey:@"VOTOCOMIDA"];
 [thedictresult setObject:@"16" forKey:@"VOTOSERVICIO"];
 [thedictresult setObject:@"17" forKey:@"VOTOAMBIENTE"];
 [thedictresult setObject:@"107" forKey:@"PRECIOD"];
 [thedictresult setObject:@"107" forKey:@"PRECION"];
 [thedictresult setObject:@"74" forKey:@"VOTOS"];
 
 [thearray addObject:thedictresult];
 [thedictresult release];
 
 
 thedictresult = [[NSMutableDictionary alloc] init];
 [thedictresult setObject:@"25%" forKey:@"DTO"];
 
 [thedictresult setObject:@"Romario " forKey:@"NOMBRE"];
 [thedictresult setObject:@"Ortega y Gasset 1604 esq. Migueletes" forKey:@"DIRECCION1"];
 [thedictresult setObject:@"Ciudad de Buenos Aires" forKey:@"DIRECCION2"];
 [thedictresult setObject:@"Pizza" forKey:@"COCINA"];
 
 [thedictresult setObject:@"4511-4444" forKey:@"TEL1"];
 [thedictresult setObject:@"" forKey:@"TEL2"];
 
 [thedictresult setObject:@"-34.56802" forKey:@"LAT"];
 [thedictresult setObject:@"-58.43083" forKey:@"LONG"];
 
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1052_1.jpg" forKey:@"MINIIMAGE1"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1052_2.jpg" forKey:@"MINIIMAGE2"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1052_3.jpg" forKey:@"MINIIMAGE3"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/thumb_1052_4.jpg" forKey:@"MINIIMAGE4"];
 
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1052_1.jpg" forKey:@"IMAGE1"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1052_2.jpg" forKey:@"IMAGE2"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1052_3.jpg" forKey:@"IMAGE3"];
 [thedictresult setObject:@"http://s3.amazonaws.com/guiaoleo.com.ar/images/photo_1052_4.jpg" forKey:@"IMAGE4"];
 
 [thedictresult setObject:@"Todos los días, mediodía y noche" forKey:@"HORARIOS"];
 
 [thedictresult setObject:@"21" forKey:@"VOTOCOMIDA"];
 [thedictresult setObject:@"14" forKey:@"VOTOSERVICIO"];
 [thedictresult setObject:@"15" forKey:@"VOTOAMBIENTE"];
 [thedictresult setObject:@"25" forKey:@"PRECIOD"];
 [thedictresult setObject:@"39" forKey:@"PRECION"];
 [thedictresult setObject:@"39" forKey:@"VOTOS"];
 
 [thearray addObject:thedictresult];
 [thedictresult release];
 
 
 
 return YES;
 }
 */



/*	
 caracteristics
 
 
 [thearray addObject:@"Todas"];
 
 [thearray addObject:@"Acceso para discapacitados (1489)"];
 [thearray addObject:@"Acepta American Express  (1861)"];
 [thearray addObject:@"Area no fumador (3639)"];
 [thearray addObject:@"Area fumador (1590)"];
 [thearray addObject:@"Aire acondicionado (3316)"];
 
 [thearray addObject:@"Baños para discapacitados (855)"];
 [thearray addObject:@"Barra de tragos (1793)"];
 [thearray addObject:@"Beneficio American Express  (116)"];
 
 [thearray addObject:@"Carta Braille (41)"];
 
 [thearray addObject:@"Comidas para celiacos (341)"];
 
 [thearray addObject:@"Delivery (2049)"];
 [thearray addObject:@"Descorche (459)"];
 [thearray addObject:@"Descuentos (31)"];
 
 [thearray addObject:@"Estacionamiento (936)"];
 
 [thearray addObject:@"Juegos para chicos (266)"];
 [thearray addObject:@"Menu ejecutivo (2385)"];
 [thearray addObject:@"Mesas al aire libre (1868)"];
 
 [thearray addObject:@"Reservas (2931)"];
 [thearray addObject:@"Show (653)"];
 
 [thearray addObject:@"Tenedor libre (97)"];
 [thearray addObject:@"WiFi (1419)"];
 
 */

/*
 cocinas
 [thearray addObject:@"Todas"];
 
 [thearray addObject:@"Alemana (31)"];
 [thearray addObject:@"Arabe (31)"];
 [thearray addObject:@"Armenia (15)"];
 [thearray addObject:@"Autóctona (126)"];
 [thearray addObject:@"Brasilera (4)"];
 [thearray addObject:@"Casera (93)"];
 [thearray addObject:@"Chilena (2)"];
 [thearray addObject:@"China (49)"];
 [thearray addObject:@"Colombiana (1)"];
 [thearray addObject:@"Coreana (4)"];
 [thearray addObject:@"Croata (1)"];
 [thearray addObject:@"Cubana (5)"];
 [thearray addObject:@"De autor (352)"];
 [thearray addObject:@"Deli (73)"];
 [thearray addObject:@"Española (88)"];
 [thearray addObject:@"Francesa (43)"];
 [thearray addObject:@"Griega (2)"];
 [thearray addObject:@"Húngara (3)"];
 [thearray addObject:@"India (12)"];
 [thearray addObject:@"Inglesa (2)"];
 [thearray addObject:@"Internacional (457)"];
 [thearray addObject:@"Irlandesa (11)"];
 [thearray addObject:@"Italiana (202)"];
 [thearray addObject:@"Japonesa (170)"];
 [thearray addObject:@"Judía (5)"];
 [thearray addObject:@"Kosher (10)"];
 [thearray addObject:@"Latinoamericana (18)"];
 [thearray addObject:@"Macrobiótica (5)"];
 [thearray addObject:@"Mediterránea (170)"];
 [thearray addObject:@"Mexicana (44)"];
 [thearray addObject:@"Natural (74)"];
 [thearray addObject:@" Nórdica (3)"];
 [thearray addObject:@"Norteamericana (41)"];
 [thearray addObject:@"Parrilla (633)"];
 [thearray addObject:@"Peruana (44)"];
 [thearray addObject:@"Pescados y Mariscos (42)"];
 [thearray addObject:@"Pizza (477)"];
 [thearray addObject:@"Polaca (2)"];
 [thearray addObject:@"Porteña (595)"];
 [thearray addObject:@"Rusa (2)"];
 [thearray addObject:@"Sudeste asiático (25)"];
 [thearray addObject:@"Suiza (3)"];
 [thearray addObject:@"Uruguaya (4)"];
 [thearray addObject:@"Variada (1020)"];
 [thearray addObject:@"Vasca (7)"];

 */


/*
 Zonas
 [thearray removeAllObjects];
 [thearray addObject:@"Todas"];	
 [thearray addObject:@"Abasto (33)"];
 [thearray addObject:@"Almagro (127)"];
 [thearray addObject:@"Barrio Norte (92)"];
 [thearray addObject:@"Belgrano (217)"];
 [thearray addObject:@"Boedo (42)"];
 [thearray addObject:@"Caballito (144)"];
 [thearray addObject:@"Campana (7)"];
 [thearray addObject:@"Centro (464)"];
 [thearray addObject:@"Chacarita-Agronomía (43)"];
 [thearray addObject:@"Colegiales (33)"];
 [thearray addObject:@"Congreso (93)"];
 [thearray addObject:@"Costanera (20)"];
 [thearray addObject:@"Flores (54)"];
 [thearray addObject:@"La Boca (34)"];
 [thearray addObject:@"Las Cañitas (86)"];
 [thearray addObject:@"Liniers-Mataderos (47)"];
 [thearray addObject:@"Lugano-Soldati (1)"];
 [thearray addObject:@"Núñez (60)"];
 [thearray addObject:@"Palermo (741)"];
 [thearray addObject:@"Parque Chacabuco (14)"];
 [thearray addObject:@"Paternal-Villa del Parque (38)"];
 [thearray addObject:@"Puerto Madero (84)"];
 [thearray addObject:@"Recoleta (250)"];
 [thearray addObject:@"Región Sur (21)"];
 [thearray addObject:@"San Telmo (149)"];
 [thearray addObject:@"Sin asignar (1)"];
 [thearray addObject:@"Villa Crespo (75)"];
 [thearray addObject:@"Villa Devoto (55)"];
 [thearray addObject:@"Villa Urquiza (51)"];
 [thearray addObject:@"Zona Norte (459)"];
 [thearray addObject:@"Zona Oeste (186)"];
 [thearray addObject:@"Zona Sur (267)"];
 
 */

 

/*
 +(BOOL) DownloadtheBanner:(NBanner *) thebanner
 {
 if (thebanner.UrlImage==nil)
 {
 return NO;
 }
 
 NSError *error=nil;
 NSData* theimage = [UChache  cachedIconFromURL:thebanner.UrlImage]; 
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 
 srand ( time(NULL) );
 
 double r = (   (double)rand() / ((double)(5680978)+(double)(1)) );
 int arandim  = (r * 17000);
 
 NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",arandim]];
 // writing the received stream to disk
 // as i read it auto deaocated 
 // need to check it
 [theimage writeToFile:writableDBPath options:0 error:&error];
 thebanner.Imagefileindevice =writableDBPath;
 return YES;
 }
 */