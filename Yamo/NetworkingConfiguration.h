//
//  NetworkingConfiguration.h
//  Yamo
//
//  Created by Mo Moosa on 08/04/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

#ifdef USE_DEVELOP_SERVER
//#define BASE_URL @"http://yamo-internal.eu-west-1.elasticbeanstalk.com/"//@"http://localhost:8080/yamo/"
#define BASE_URL @"http://192.168.0.60:8080/"
#elif USE_ADHOC_SERVER
#define BASE_URL @"http://yamo-client.eu-west-1.elasticbeanstalk.com/"
#elif USE_RELEASE_SERVER
#define BASE_URL @"http://yamo-live.eu-west-1.elasticbeanstalk.com/"
#endif
