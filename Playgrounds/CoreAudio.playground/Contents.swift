// Objective-C
// https://stackoverflow.com/questions/23070442/setting-up-audio-unit-ios-with-mono-input-and-stereo-output

// CoreAudio
// What is it? A framework.
// What is it for? Use the Core Audio framework to interact with device’s audio hardware.
// Documentation: https://developer.apple.com/documentation/coreaudio
import CoreAudio

// AudioToolbox
// What is it? A framework.
// What is it for? Record or play audio, convert formats, parse audio streams, and configure your audio session.
// Documentation: https://developer.apple.com/documentation/audiotoolbox
import AudioToolbox

// CoreMedia
// What is it? a framework.
// What is it for? Use Core Media's low-level data types and interfaces to efficiently process media samples and manage queues of media data.
// Documentation: https://developer.apple.com/documentation/coremedia
import CoreMedia

// AudioComponentInstance
// What is it? A structure.
// What is it for? A component instance, or object, is an audio unit or audio codec.
// Documentation: https://developer.apple.com/documentation/audiotoolbox/audiocomponentinstance

// AudioUnit
// What is it? A typealias (which is structure).
// - typealias AudioUnit = AudioComponentInstance
// What is it for? The data type for a plug-in component that provides audio processing or audio data generation.
// Documentation: https://developer.apple.com/documentation/audiotoolbox/audiounit
var audioUnit: AudioUnit!

// AudioComponentDescription
// What is it? A structure.
// What is it for? Identifying information for an audio component.
// Definition: A structure used to describe the unique and identifying IDs of an audio component.
// Documentation: https://developer.apple.com/documentation/audiotoolbox/audiocomponentdescription
var desc: AudioComponentDescription! = AudioComponentDescription(componentType: kAudioUnitType_Output,
                                                                 componentSubType: kAudioUnitSubType_RemoteIO,
                                                                 componentManufacturer: kAudioUnitManufacturer_Apple,
                                                                 componentFlags: 0,
                                                                 componentFlagsMask: 0)

print("\nAudioComponentDescription:\(String(describing: desc))")

// AudioComponent
// What is it? A typealias (which is structure).
// What is it for? It is used as a factory from which to create instances. The instances are used to do the actual work.
// Documentation: https://developer.apple.com/documentation/audiotoolbox/audiocomponent
// This function is used to find an audio component that is the closest match to the provided values.
let inputComponent: AudioComponent? = AudioComponentFindNext(nil, &desc)
// An AudioComponent is needed to initialize an AudioUnit.

var osStatus: OSStatus = 0

print("\nAudioComponent:\(String(describing: inputComponent))")

// Create AudioUnit aka. AudioComponentInstance.
print("\nCreating audio unit...")
if let eInputComponent = inputComponent {
    osStatus = AudioComponentInstanceNew(eInputComponent, &audioUnit)
}
print("\nStatus = \(osStatus).")
print("\nAudioUnit created::\(String(describing: audioUnit)).")

print("\nCreating audio unit...")
osStatus = AudioUnitInitialize(audioUnit)
print("\nStatus = \(osStatus).")
print("\nAudioUnit initialized::\(String(describing: audioUnit)).")


var kInputBus: UInt32 = 1
var kOutputBus: UInt32 = 1

var enableInput: UInt32 = 1
// TODO: Fix 0
// Apply format to input of ioUnit
AudioUnitSetProperty(audioUnit,
                     kAudioOutputUnitProperty_EnableIO,
                     kAudioUnitScope_Input,
                     kOutputBus,
                     &enableInput,
                     UInt32(MemoryLayout.size(ofValue: enableInput)))

var monoStreamFormat = AudioStreamBasicDescription(mSampleRate: 44100.00,
                                                   mFormatID: kAudioFormatLinearPCM,
                                                   mFormatFlags: kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger,
                                                   mBytesPerPacket: 4,
                                                   mFramesPerPacket: 1,
                                                   mBytesPerFrame: 4,
                                                   mChannelsPerFrame: 1,
                                                   mBitsPerChannel: 32,
                                                   mReserved: 0)

// Apply format to input of audioUnit.
AudioUnitSetProperty(audioUnit,
                     kAudioUnitProperty_StreamFormat,
                     kAudioUnitScope_Input,
                     kOutputBus,
                     &monoStreamFormat,
                     UInt32(MemoryLayout.size(ofValue: monoStreamFormat)))

var stereoStreamFormat = AudioStreamBasicDescription(mSampleRate: 44100.00,
                                                   mFormatID: kAudioFormatLinearPCM,
                                                   mFormatFlags: kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger,
                                                   mBytesPerPacket: 8,
                                                   mFramesPerPacket: 1,
                                                   mBytesPerFrame: 8,
                                                   mChannelsPerFrame: 2,
                                                   mBitsPerChannel: 32,
                                                   mReserved: 0)

// Apply format to output of audioUnit.
AudioUnitSetProperty(audioUnit,
                     kAudioUnitProperty_StreamFormat,
                     kAudioUnitScope_Output,
                     kInputBus,
                     &stereoStreamFormat,
                     UInt32(MemoryLayout.size(ofValue: stereoStreamFormat)))

func inputCallback(
  inRefCon:UnsafeMutableRawPointer,
  ioActionFlags:UnsafeMutablePointer<AudioUnitRenderActionFlags>,
  inTimeStamp:UnsafePointer<AudioTimeStamp>,
  inBusNumber:UInt32,
  inNumberFrames:UInt32,
  ioData:UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {


    return noErr
}

func outputCallback(
  inRefCon:UnsafeMutableRawPointer,
  ioActionFlags:UnsafeMutablePointer<AudioUnitRenderActionFlags>,
  inTimeStamp:UnsafePointer<AudioTimeStamp>,
  inBusNumber:UInt32,
  inNumberFrames:UInt32,
  ioData:UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {


    return noErr
}

// AURenderCallbackStruct
// What is it? A structure.
// What is it for? Used for registering an input callback function with an audio unit.
// Documentation: https://developer.apple.com/documentation/audiotoolbox/aurendercallbackstruct?language=objc
var inputCallbackStruct: AURenderCallbackStruct = AURenderCallbackStruct()
inputCallbackStruct.inputProc = inputCallback
inputCallbackStruct.inputProcRefCon = nil

AudioUnitSetProperty(audioUnit!,
                     kAudioOutputUnitProperty_SetInputCallback,
                     kAudioUnitScope_Global,
                     kInputBus,
                     &inputCallbackStruct,
                     UInt32(MemoryLayout<AURenderCallbackStruct>.size))

var outputCallbackStruct: AURenderCallbackStruct = AURenderCallbackStruct()
outputCallbackStruct.inputProc = outputCallback
outputCallbackStruct.inputProcRefCon = nil

AudioUnitSetProperty(audioUnit!,
                     kAudioOutputUnitProperty_SetInputCallback,
                     kAudioUnitScope_Global,
                     kInputBus,
                     &outputCallbackStruct,
                     UInt32(MemoryLayout<AURenderCallbackStruct>.size))



var emptySampleBuffer: CMSampleBuffer!
var audioBufferList: AudioBufferList!
/*
osStatus = CMSampleBufferSetDataBufferFromAudioBufferList(emptySampleBuffer,
                                                          blockBufferAllocator: kCFAllocatorDefault,
                                                          blockBufferMemoryAllocator: kCFAllocatorDefault,
                                                          flags: 0,
//                                                                   bufferList: &micAudioBufferList)
                                                          bufferList: &audioBufferList)
*/
