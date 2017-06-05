//============================================================================
//
//   SSSS    tt          lll  lll       
//  SS  SS   tt           ll   ll        
//  SS     tttttt  eeee   ll   ll   aaaa 
//   SSSS    tt   ee  ee  ll   ll      aa
//      SS   tt   eeeeee  ll   ll   aaaaa  --  "An Atari 2600 VCS Emulator"
//  SS  SS   tt   ee      ll   ll  aa  aa
//   SSSS     ttt  eeeee llll llll  aaaaa
//
// Copyright (c) 1995-2016 by Bradford W. Mott, Stephen Anthony
// and the Stella Team
//
// See the file "License.txt" for information on usage and redistribution of
// this file, and for a DISCLAIMER OF ALL WARRANTIES.
//
// $Id: SettingsMACOSX.cxx 3244 2015-12-30 19:07:11Z stephena $
//============================================================================

#define BytePtr StellaBytePtr
#include "SettingsMACOSX.hxx"
#undef BytePtr
#import <Foundation/Foundation.h>

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SettingsMACOSX::SettingsMACOSX(OSystem& osystem)
  : Settings(osystem)
{
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void SettingsMACOSX::loadConfig()
{
  @autoreleasepool {
    string key, value;
    char cvalue[4096];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Read key/value pairs from the plist file
    const SettingsArray& settings = getInternalSettings();
    for(uInt32 i = 0; i < settings.size(); ++i)
    {
      NSString *key = @(settings[i].key.c_str());
      NSString *prefVal = [defaults stringForKey:key];
      if (prefVal) {
        strncpy(cvalue, [prefVal cStringUsingEncoding: NSUTF8StringEncoding], 4090);
      } else {
        cvalue[0] = 0;
      }
      if(cvalue[0] != 0)
        setInternal(settings[i].key, cvalue, i, true);
    }
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
void SettingsMACOSX::saveConfig()
{
	@autoreleasepool {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Write out each of the key and value pairs
    for(const auto& s: getInternalSettings()) {
      NSString *key = @(s.key.c_str());
      NSString *value = @(s.value.toCString());
      [defaults setValue:value forKey:key];
    }
    
    [defaults synchronize];
	}
}
