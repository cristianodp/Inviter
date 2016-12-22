//
//  DGTAttributions.h
//  DigitsKit
//
//  Copyright © 2016 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DGTSession;
@class TWTRSessionStore;
@class DGTInviteStatus;

typedef void (^DGTRequestAttributionsResponseCompletion)(NSArray<DGTInviteStatus *> *matches, NSError *error);

@interface DGTAttributions : NSObject

/**
 *  Returns an instance of DGTAttributions if there is an existing user session. The initializer
 *  will return nil if there is no valid logged in session.
 */
- (instancetype)init;
@end
