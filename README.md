> [!IMPORTANT]
> Created by [Preternatural AI](https://preternatural.ai/), an exhaustive client-side AI infrastructure for Swift.<br/>
> This project and the frameworks used are presently in alpha stage of development.

# PhotoTranslator: Generate Creative Sentences in a Foreign Language from a Photo
The PhotoTranslator app leverages OpenAI's Vision API to bring translations into the user's surroundings seamlessly. Users can simply take a photo, and the app, using an on-device YOLO model, identifies objects within the image. Then, creative sentences in the target language are generated about the picture in general and each object specifically along with the foreign language audio using ElevenLabs API, making learning a new language an engaging and immersive experience.
<br/><br/>
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/PreternaturalAI/AI/blob/main/LICENSE)

## Table of Contents
- [Usage](#usage)
- [Key Concepts](#key-concepts)
- [Preternatural Frameworks](#preternatural-frameworks)
- [Technical Specifications](#technical-specifications)
- [License](#license)
  
## Usage
#### Supported Platforms
<!-- macOS-->
<p align="left">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg">
  <img alt="macos" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg" height="24">
</picture>&nbsp;

<!--iPhone-->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios-active.svg">
  <img alt="ios" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ios-active.svg" height="24">
</picture>&nbsp;

<!-- iPad-->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados-active.svg">
  <img alt="ipados" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/ipados-active.svg" height="24">
</picture>&nbsp;

</p>

To install and run the PhotoTranslator app:

1. Download and open the project
2. Add your OpenAI API Key in the `LLMClientManager`  file:

```swift
// AIManagers/LLMClientManager
private static let client: any LLMRequestHandling = OpenAI.Client(
    apiKey: "YOUR_API_KEY"
)
```

*You can get the OpenAI API key on the [OpenAI developer website](https://platform.openai.com/). Note that you have to set up billing and add a small amount of money for the API calls to work (this will cost you less than 1 dollar).* 

3. Add your ElevenLabs API Key in the `TTSClientManager` file: 

```swift
// AIManagers/TTSClientManager
static let client = ElevenLabs.Client(apiKey: "YOUR_API_KEY")
```

ElevenLabs is a “Text-to-Speech” service which is used in the PhotoTranslator app to generate the audio of the translated sentence in a foreign language. You can get your ElevenLabs API Key on the [ElevenLabs website](https://elevenlabs.io/). The API key is located in your user profile: 

<img width="256" alt="Screenshot_2024-05-24_at_8_21_03 PM" src="https://github.com/preternatural-explore/photo-translator/assets/1157147/ce7ff99f-a719-4390-8104-78c74efbd69b">

5. Select the target language for translation. The app is currently set to Hindi.
```swift
// AIManagers/LLMClientManager
private static let targetLanguage = "Hindi"
```

6. Create the target language speaker in `AIManagers/Speakers`. The app is currently set to a `HindiSpeaker`
```swift
// AIManagers/Speakers
// change the speaker to your target language
// you can find the voice for your target language on the ElevenLabs website
struct HindiSpeaker: Speaker { 
    let speakerName: String = "Akshay"
    let elevenLabsVoiceID = "qO2mI1DuN2aagyvZHwwt"
}

```

7. Run the app on device - either iPhone, iPad or Mac as the camera is required to take a photo.
8. Take a photo and wait for the app to generate creative sentences about the photo in your target language, with English translation.<br />

<p align="center">
  <img width="413" alt="phototranslationdescription" src="https://github.com/preternatural-explore/photo-translator/assets/1157147/41f472f5-769e-4ff6-aa55-697aba1cd711">
  <img width="413" alt="phototranslationdetails" src="https://github.com/preternatural-explore/photo-translator/assets/1157147/553e0bbb-5035-4790-968f-c21221a53c19">
</p>

*Bug: Note that there is currently a bug where the photo is flipped 90 degrees on the phone and iPad.*<br/>

## Key Concepts
The PhotoTranslator app is developed to demonstrate the the following key concepts:

- Using OpenAI's Vision API
- Function calling to get structured data from LLMs
- Integrating ElevenLabs Multilingual Audio generation

## Preternatural Frameworks
The following Preternatural Frameworks were used in this project: 
- [AI](https://github.com/PreternaturalAI/AI): The definitive, open-source Swift framework for interfacing with generative AI.
- [Media](https://github.com/vmanot/Media): Media makes it stupid simple to work with media capture & playback in Swift.

## Technical Specifications
The PhotoTranslator uses several AI frameworks in the following steps: 
1. The user captures a photo
2. The photo is analyzed by the [YOLOv8](https://github.com/ultralytics/ultralytics) on-device model, which detects and identifies individual objects within the image. Each object is highlighted with uniquely colored, numbered boxes. See `PhotoObjectDetectionManager` for the implementation. 
3. The processed photo is sent to OpenAI using the completion API with function calling. This step involves generating creative sentences in the apps's target language about the picture as a whole and each individual object identified in the picture. Transliteration and english translation is also provided for each sentence. See `LLMClientManager` for implementation. 
4. Finally, the translated text is converted into spoken audio using ElevenLabs' voice synthesis technology, so the user can learn how to say the sentence in the app's target foreign language. See `TTSClientManager` for implementation.

As a result, the PhotoTranslator app exemplifies the effective integration of diverse AI technologies to create a comprehensive and interactive language learning tool. 

## License

This package is licensed under the [MIT License](https://github.com/PreternaturalAI/AI/blob/main/LICENSE).

