#import "CDCoreDataModelProcessor.h"
#import "CDCoreDataModelParser.h"


@implementation CDCoreDataModelProcessor

- (NSArray *)coreDataModelSymbolsToExclude {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSURL *directoryURL = [NSURL URLWithString:@"."];

    NSDirectoryEnumerator *enumerator = [fileManager
        enumeratorAtURL:directoryURL
        includingPropertiesForKeys:keys
        options:0
        errorHandler:^(NSURL *url, NSError *error) {
            // Handle the error.
            // Return YES if the enumeration should continue after the error.
            return YES;
    }];

    NSMutableArray *coreDataModelSymbols = [NSMutableArray array];
    CDCoreDataModelParser *parser = [[CDCoreDataModelParser alloc] init];
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;

        if ([url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error] && [isDirectory boolValue]) {
            if ([url.absoluteString hasSuffix:@".xcdatamodel/"]) {
                NSURL *xcdatamodelContents = [url URLByAppendingPathComponent:@"contents"];

                [coreDataModelSymbols addObjectsFromArray:[parser symbolsInFile:xcdatamodelContents]];
            }
        }
    }

    return coreDataModelSymbols;
}

@end
