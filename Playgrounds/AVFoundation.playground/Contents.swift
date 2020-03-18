// AVFoundation
// What is it? A framework.
// What is it for? Work with audiovisual assets, control device cameras, process audio, and configure system audio interactions.
// Documentation: https://developer.apple.com/documentation/avfoundation/avaudioengine
import AVFoundation


// AVAudioEngine
// What is it? A class (of NSObject).
// What is it for? Connect audio node objects used to generate and process audio signals and perform audio input and output.
// Documentation: https://developer.apple.com/documentation/avfoundation/avaudioengine

let audioEngine = AVAudioEngine()
// audioEngine.attach(<#T##node: AVAudioNode##AVAudioNode#>)

// NODE TYPES
// https://developer.apple.com/documentation/avfoundation/audio_track_engineering/audio_engine_building_blocks

// AVAudioPlayerNode
// What is it? A class (of NSObject).
// What is it for? A class that plays buffers or segments of audio files.
// Documentation: https://developer.apple.com/documentation/avfoundation/avaudioplayernode
let inputNode1 = AVAudioPlayerNode()
// ...
let inputNodeN = AVAudioPlayerNode()

// inputNode1.scheduleBuffer(<#T##buffer: AVAudioPCMBuffer##AVAudioPCMBuffer#>, completionHandler: nil)

// AVAudioMixerNode
// What is it? A class (of NSObject).
// What is it for? A class that mixes its inputs to a single output.
// Documentation: https://developer.apple.com/documentation/avfoundation/avaudiomixernode
let mixerNode1 = AVAudioMixerNode()
// ...
let mixerNodeN = AVAudioMixerNode()

// inputNode1.scheduleBuffer(<#T##buffer: AVAudioPCMBuffer##AVAudioPCMBuffer#>, completionHandler: nil)



