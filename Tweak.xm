#import <CoreText/CoreText.h>
#import <substrate.h>

static CTFontRef (*original_CTFontCreateWithFontDescriptor)(CTFontDescriptorRef descriptor, CGFloat size, const CGAffineTransform *matrix);

CTFontRef custom_CTFontCreateWithFontDescriptor(CTFontDescriptorRef descriptor, CGFloat size, const CGAffineTransform *matrix) {
	CTFontRef resultFont = NULL;
	
	CFDictionaryRef traitsAttributes = (CFDictionaryRef) CTFontDescriptorCopyAttribute(descriptor, kCTFontTraitsAttribute);
	if (traitsAttributes != NULL) {
		CFNumberRef symbolicTraitsNumber = (CFNumberRef) CFDictionaryGetValue(traitsAttributes, kCTFontSymbolicTrait);
		CTFontSymbolicTraits symbolicTraits = 0;
		if (symbolicTraitsNumber != NULL) {
			CFNumberGetValue(symbolicTraitsNumber, kCFNumberSInt32Type, &symbolicTraits);
		}
		
		if ((symbolicTraits & kCTFontBoldTrait) == 0) {
			CTFontDescriptorRef lightDescriptor = CTFontDescriptorCreateWithNameAndSize(CFSTR("STHeitiSC-Light"), size);
			const void *descriptors[] = { lightDescriptor };
			CFArrayRef cascadeList = CFArrayCreate(kCFAllocatorDefault, descriptors, 1, &kCFTypeArrayCallBacks);
			
			const CFStringRef keys[] = { kCTFontCascadeListAttribute };
			const CFTypeRef values[] = { cascadeList };
			CFDictionaryRef extraAttributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **) &keys, (const void **) &values, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
			
			CTFontDescriptorRef newDescriptor = CTFontDescriptorCreateCopyWithAttributes(descriptor, extraAttributes);
			resultFont = original_CTFontCreateWithFontDescriptor(newDescriptor, size, matrix);
			
			CFRelease(newDescriptor);
			CFRelease(extraAttributes);
			CFRelease(cascadeList);
			CFRelease(lightDescriptor);
		}
		
		CFRelease(traitsAttributes);
	}
	
	if (resultFont == NULL) {
		resultFont = original_CTFontCreateWithFontDescriptor(descriptor, size, matrix);
	}
	
	return resultFont;
}

%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    MSHookFunction(CTFontCreateWithFontDescriptor, custom_CTFontCreateWithFontDescriptor, &original_CTFontCreateWithFontDescriptor);

    [pool release];
}
