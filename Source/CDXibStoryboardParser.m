#import "CDXibStoryboardParser.h"
#import "GDataXMLNode.h"


@implementation CDXibStoryboardParser

- (void)addSymbolsFromNode:(GDataXMLElement *)xmlDictionary toArray:(NSMutableArray *)symbolsArray {
    NSArray *childNodes = xmlDictionary.children;

    // Check if element contains a custom class element and add it to obfuscated classes list
    GDataXMLNode *attribute = [xmlDictionary attributeForName:@"customClass"];
    if (attribute) {
        [symbolsArray addObject:attribute.stringValue];
    }

    // Check if element contains an outlet to obfuscate
    if ([xmlDictionary.name isEqualToString:@"outlet"]) {
        GDataXMLNode *propertyName = [xmlDictionary attributeForName:@"property"];
        if (propertyName) {
            [symbolsArray addObject:propertyName.stringValue];
        }
    }

    for (GDataXMLElement *childNode in childNodes) {
        // Skip comments
        if ([childNode isKindOfClass:[GDataXMLElement class]]) {
            [self addSymbolsFromNode:childNode toArray:symbolsArray];
        }
    }
}

- (void)obfuscateElement:(GDataXMLElement *)element usingSymbols:(NSDictionary *)symbols {
    NSArray *childNodes = element.children;

    // Check if element contains a custom class element and add it to obfuscated classes list
    GDataXMLNode *attribute = [element attributeForName:@"customClass"];
    if (attribute && symbols[attribute.stringValue]) {
        [attribute setStringValue:symbols[attribute.stringValue]];
    }

    // Check if element contains an outlet to obfuscate
    if ([element.name isEqualToString:@"outlet"]) {
        GDataXMLNode *propertyName = [element attributeForName:@"property"];
        if (propertyName && symbols[propertyName.stringValue]) {
            [propertyName setStringValue:symbols[propertyName.stringValue]];
        }
    }

    for (GDataXMLElement *childNode in childNodes) {
        // Skip comments
        if ([childNode isKindOfClass:[GDataXMLElement class]]) {
            [self obfuscateElement:childNode usingSymbols:symbols];
        }
    }
}

@end
