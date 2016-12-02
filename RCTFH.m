#import "RCTFH.h"

#import <FH/FH.h>
#import <FH/FHResponse.h>

@implementation RCTFH

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(test)
{
    // Your implementation here
    NSLog(@"HI from FH!");
}

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
        
        NSLog(@">>>>>>> %@ %@ %@ %@ %@", path, method, contentType, headers, data);
        
        
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
        NSLog(@"IN FINALLY!!!!!!!!! ");
    }
    
}

RCT_REMAP_METHOD(init,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
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
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation failed.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"sdk_init_failed", errorMessage, error);
    };
    
    //View loaded, init the library
    [FH initWithSuccess:success AndFailure:failure];
}

RCT_REMAP_METHOD(cloud,
                 options: (NSDictionary *) options
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"cloud call with promise %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"options: %@", options);
    
    // Call a cloud side function when init finishes
    void (^success)(FHResponse *)=^(FHResponse * res) {
        NSLog(@"cloud call succeded, let's call resolve");
        NSDictionary *resData = res.parsedResponse;
        
        resolve(resData);
    };
    
    void (^failure)(id)=^(FHResponse * res){
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [res.error localizedDescription]];
        NSLog(@"cloud call failed, so reject. Response = %@", errorMessage);
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation failed.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
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
        
        NSLog(@">>>>>>> %@ %@ %@ %@ %@", path, method, contentType, headers, data);
        
        
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
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation failed.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"com.redhat.mobile.rctfh"
                                             code:-1
                                         userInfo:userInfo];
        reject(@"cloud_call_failed", errorMessage, error);

    }
    @finally {
        NSLog(@"IN FINALLY!!!!!!!!! ");
    }
}

@end
