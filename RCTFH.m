#import "RCTFH.h"

#import <FH/FH.h>
#import <FH/FHResponse.h>

@implementation RCTFH

RCT_EXPORT_MODULE();

// init
RCT_EXPORT_METHOD(init:(RCTResponseSenderBlock)successCallback
                  callback:(RCTResponseSenderBlock)errorCallback) {
    
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    
    // Call a cloud side function when init finishes
    void (^success)(FHResponse *)=^(FHResponse * res) {
        // Initialisation is now complete, you can now make FHActRequest's
        NSLog(@"SDK initialised OK");
    };
    
    void (^failure)(id)=^(FHResponse * res){
        NSLog(@"Initialisation failed. Response = %@", res.rawResponse);
    };
    
    //View loaded, init the library
    [FH initWithSuccess:success AndFailure:failure];
    
    
    successCallback(@[@"init method called"]);
}

RCT_REMAP_METHOD(getCloudUrl,
                 getcloudurl_resolver:(RCTPromiseResolveBlock)resolve
                 getcloudurl_rejecter:(RCTPromiseRejectBlock)reject) {
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    @try {
        NSString *cloudAppHost = [FH getCloudHost];
        NSLog(@"getCloudUrl: %@", cloudAppHost);
        resolve(@[cloudAppHost]);
    }
    @catch ( NSException *e ) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [e reason]];
        NSLog(@"getCloudUrl call exception. Response = %@", errorMessage);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"getCloudHost failed.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please verify init process succeded", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"getcloudurl_call_failed", errorMessage, error);
    }
    @finally {
        NSLog(@"getCloudUrl finally area reached");
    }
}

RCT_EXPORT_METHOD(  cloud: (NSDictionary *) options
                  success: (RCTResponseSenderBlock) successCallback
                    error: (RCTResponseSenderBlock) errorCallback) {
    
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"options: %@", options);
    
    // Call a cloud side function when init finishes
    void (^success)(FHResponse *)=^(FHResponse * res) {
        NSLog(@"cloud call succeded");
        NSDictionary *resData = res.parsedResponse;
        
        successCallback(@[resData]);
    };
    
    void (^failure)(id)=^(FHResponse * res){
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [res.error localizedDescription]];
        NSLog(@"cloud call failed. Response = %@", errorMessage);
        errorCallback(@[errorMessage]);
    };
    
    @try {
        
        NSString *path = nil, *method = nil, *contentType = nil;
        NSNumber *timeout;
        NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if (options && [options valueForKey:@"path"]) path = [options valueForKey:@"path"];
        if (options && [options valueForKey:@"method"]) method = [options valueForKey:@"method"];
        if (options && [options valueForKey:@"contentType"]) {
            contentType = [options valueForKey:@"contentType"];
        } else {
            contentType = @"application/json";
        }
        if (options && [options valueForKey:@"timeout"]) timeout = [options valueForKey:@"timeout"];
        
        if (options && [options valueForKey:@"headers"]) {
            [headers addEntriesFromDictionary: (NSDictionary*)[options valueForKey:@"headers"]];
        }
        [headers setValue:contentType forKey:@"contentType"];
        
        if (options && [options valueForKey:@"data"]) {
            [data addEntriesFromDictionary: (NSDictionary*)[options valueForKey:@"data"]];
        }
        
        //NSLog(@">>>>>>> %@ %@ %@ %@ %@", path, method, contentType, headers, data);
        
        
        FHCloudRequest * action = (FHCloudRequest *) [FH buildCloudRequest:path
                                                                WithMethod:method
                                                                AndHeaders:headers
                                                                   AndArgs:data];
        
        // change timeout (default value: 60s)
        action.requestTimeout = 25.0;
        [action execAsyncWithSuccess: success AndFailure: failure];
    }
    @catch ( NSException *e ) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [e reason]];
        NSLog(@"cloud call exception. Response = %@", errorMessage);
        errorCallback(@[errorMessage]);
    }
    @finally {
        NSLog(@"finally area reached");
    }
    
}

RCT_REMAP_METHOD(init,
                 init_resolver:(RCTPromiseResolveBlock)resolve
                 init_rejecter:(RCTPromiseRejectBlock)reject)
{
    
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    
    // Call a cloud side function when init finishes
    void (^success)(FHResponse *)=^(FHResponse * res) {
        // Initialisation is now complete, you can now make FHActRequest's
        NSLog(@"SDK initialised OK");
        resolve(@"SUCCESS");
    };
    
    void (^failure)(id)=^(FHResponse * res){
        NSString *errorMessage = [NSString stringWithFormat:@"ERROR: %@", [res.error localizedDescription]];
        NSLog(@"Initialisation failed. Response = %@", errorMessage);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Init operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString( [res.error localizedDescription], nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please verify fhconfig.plist", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"sdk_init_failed", errorMessage, error);
    };
    
    //View loaded, init the library
    [FH initWithSuccess:success AndFailure:failure];
}

RCT_REMAP_METHOD(auth,
                 authPolicy: (NSString*) authPolicy
                 username: (NSString*) username
                 password: (NSString*) password
                 auth_resolver:(RCTPromiseResolveBlock)resolve
                 auth_rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"auth call with promise %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Call a cloud side function when init finishes
    void (^success)(FHResponse *)=^(FHResponse * res) {
        NSLog(@"auth call succeded check status");
        NSDictionary *resData = res.parsedResponse;
        
        NSLog(@"parsed response %@ type=%@",res.parsedResponse,[res.parsedResponse class]);
        //if ([[[res parsedResponse] valueForKey:@"status"] isEqualToString:@"error"]) {
        if ([res responseStatusCode] != 200) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [res parsedResponse]];
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Authentication failed.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please verify credentials and try again", nil)
                                       };
            NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                                 code:-1
                                             userInfo:userInfo];
            reject(@"auth_call_failed", errorMessage, error);
            
        } else {
            NSLog(@"auth call authentication succeded");
            resolve(resData);
        }
    };
    
    void (^failure)(id)=^(FHResponse * res){
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [res.error localizedDescription]];
        NSLog(@"auth call failed, so reject. Response = %@", errorMessage);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString([res.error localizedDescription], nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please verify fhconfig.plist file", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"auth_call_failed", errorMessage, error);
    };
    
    @try {
        
        if (!authPolicy || !username || !password) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error authPolicy, username, password cannot empty"];
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Wrong parameters.", nil)
                                       };
            NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                                 code:-1
                                             userInfo:userInfo];
            reject(@"auth_call_failed", errorMessage, error);
            return;
        }
        
        
        NSLog(@"Policy: %@ username: %@", authPolicy, username);
        
        
        FHAuthRequest* authRequest = [FH buildAuthRequest];
        [authRequest authWithPolicyId:authPolicy UserId:username Password:password];
        
        [authRequest execAsyncWithSuccess:success AndFailure:failure];
    }
    @catch ( NSException *e ) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [e reason]];
        NSLog(@"cloud call exception. Response = %@", errorMessage);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString([e reason], nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"cloud_call_failed", errorMessage, error);
        
    }
    @finally {
        NSLog(@"finally area reached");
    }
}


RCT_REMAP_METHOD(cloud,
                 options: (NSDictionary *) options
                 cloud_resolver:(RCTPromiseResolveBlock)resolve
                 cloud_rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"cloud call with promise %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"options: %@", options);
    
    // Call a cloud side function when init finishes
    void (^success)(FHResponse *)=^(FHResponse * res) {
        NSLog(@"cloud call succeded");
        NSDictionary *resData = res.parsedResponse;
        
        resolve(resData);
    };
    
    void (^failure)(id)=^(FHResponse * res){
        NSString *errorMessage = [NSString stringWithFormat:@"%@", [res.error localizedDescription]];
        NSLog(@"cloud call failed, so reject. Response = %@", errorMessage);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString([res.error localizedDescription], nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please confirm API endpoints and parameters", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"cloud_call_failed", errorMessage, error);
    };
    
    @try {
        
        NSString *path = nil, *method = nil, *contentType = nil;
        NSNumber *timeout;
        NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if (options && [options valueForKey:@"path"]) path = [options valueForKey:@"path"];
        if (options && [options valueForKey:@"method"]) method = [options valueForKey:@"method"];
        if (options && [options valueForKey:@"contentType"]) {
            contentType = [options valueForKey:@"contentType"];
        } else {
            contentType = @"application/json";
        }
        if (options && [options valueForKey:@"timeout"]) timeout = [options valueForKey:@"timeout"];
        
        if (options && [options valueForKey:@"headers"]) {
            [headers addEntriesFromDictionary: (NSDictionary*)[options valueForKey:@"headers"]];
        }
        [headers setValue:contentType forKey:@"contentType"];
        
        if (options && [options valueForKey:@"data"]) {
            [data addEntriesFromDictionary: (NSDictionary*)[options valueForKey:@"data"]];
        }
        
        //NSLog(@"path: %@ method: %@ contentType: %@ headers: %@ data: %@", path, method, contentType, headers, data);
        
        
        FHCloudRequest * action = (FHCloudRequest *) [FH buildCloudRequest:path
                                                                WithMethod:method
                                                                AndHeaders:headers
                                                                   AndArgs:data];
        
        // change timeout (default value: 60s)
        action.requestTimeout = 25.0;
        [action execAsyncWithSuccess: success AndFailure: failure];
    }
    @catch ( NSException *e ) {
        NSString *errorMessage = [NSString stringWithFormat:@"", [e reason]];
        NSLog(@"cloud call exception. Response = %@", errorMessage);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString([e reason], nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"cloud_call_failed", errorMessage, error);

    }
    @finally {
        NSLog(@"finally area reached");
    }
}

@end
