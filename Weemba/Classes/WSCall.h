//
//  WSCall.h
//  Detelefoongids
//
//  Created by Moises Swiczar on 4/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define USERSERVICE @"iphoneUser"

#define URLSERVICE   @"http://www.guiaoleo.com.ar/interface/json/services.phtml"
#define	PASSSERVICE @"(sohcahtoa180)"


//#define URLSERVICE   @"http://developguiaoleo-ar.macacohosting.com/interface/json/services.phtml"
//#define	PASSSERVICE @"135246"


#define	UDID [[UIDevice currentDevice] uniqueIdentifier] 



@interface WSCall : NSObject {

}

/*
//+(BOOL) callGetHotspotDetail:(NSString*)theidhotspot thearray:(NSMutableArray*)thearray;


+(BOOL) callBanner:(NSMutableDictionary*)abanner;
+(BOOL) initSession:(NSMutableDictionary*)thedict;
+(NSUInteger) callRegistrarUser:(NSMutableDictionary*)thedict;
+(BOOL) callGetCercanos:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray;
+(BOOL) callGetRest:(NSString*)theid thedict:(NSMutableDictionary*)thedict;
+(BOOL) callGetRankings:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray;
+(BOOL) callGetDescuentos:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray;
+(BOOL) callGetComentarios:(NSString*)theid thearray:(NSMutableArray*)thearray;
+(NSUInteger) callRegistrarVoto:(NSMutableDictionary*)thedict;
+(BOOL) callGetSearch:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray;
+(BOOL) callGetSearchSTR:(NSMutableDictionary*)thedict thearray:(NSMutableArray*)thearray;



//online version only called when we are on WIFI never on 3G or GPRS or phone
// all this result are dumped to file

+(BOOL) callGetZona:(NSMutableArray*)thearray;
+(BOOL) callGetCocina:(NSMutableArray*)thearray;
+(BOOL) callGetCaract:(NSMutableArray*)thearray;

//offline version only called when we are  on 3G or GPRS or phone
//those result are from previous dumped version onlie data or by release resource distribution


+(BOOL) callGetCocinaOFFline:(NSMutableArray*)thearray;
+(BOOL) callGetCaractOFFline:(NSMutableArray*)thearray;
+(BOOL) callGetZonaOFFline:(NSMutableArray*)thearray;


*/




@end

