#import <Foundation/Foundation.h>


@interface CDParserSharedBase : NSObject
- (NSArray *)symbolsInFile:(NSURL *)fileUrl;

- (NSData *)obfuscatedXmlData:(NSData *)data symbols:(NSDictionary *)symbols;
@end
