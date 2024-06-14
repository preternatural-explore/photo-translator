# PhotoTranslator: Generate Creative Sentences in a Foreign Language from a Photo
The PhotoTranslator app leverages OpenAI's Vision API to bring translations into the user's surroundings seamlessly. Users can simply take a photo, and the app, using an on-device YOLO model, identifies objects within the image. Then, creative sentences in the target language are generated about the picture in general and each object specifically along with the foreign language audio using ElevenLabs API, making learning a new language an engaging and immersive experience.

## Installation

To run the Photo Translator app: 

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
*Bug: Note that there is currently a bug where the photo is flipped 90 degrees on the phone and iPad.*

<img width="413" alt="phototranslationdescription" src="https://github.com/preternatural-explore/photo-translator/assets/1157147/41f472f5-769e-4ff6-aa55-697aba1cd711">
<img width="413" alt="exportA25BFD02-B306-4936-87A7-FB421D9F21F1" src="https://github.com/preternatural-explore/photo-translator/assets/1157147/553e0bbb-5035-4790-968f-c21221a53c19">

