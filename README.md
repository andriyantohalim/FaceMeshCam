# FaceMeshCam

FaceMeshApp is an iOS application that leverages ARKit and SwiftUI to provide real-time facial expression analysis using the front-facing TrueDepth camera. The app detects various facial expressions and displays them to the user in a simple and intuitive interface.


## Features

- **Real-Time Face Tracking**: Utilizes ARKit to track facial features and expressions in real-time.
- **Expression Detection**: Identifies and displays various facial expressions such as smiling, frowning, eyebrow movements, and more.
- **SwiftUI Integration**: The UI is built with SwiftUI, providing a modern and responsive design.
- **ARSCNView Rendering**: Renders a face mesh using ARSCNView, highlighting facial movements and expressions.


## Requirements

- iOS 13.0+
- Xcode 12.0+
- A device with a TrueDepth camera (iPhone X and later)

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/FaceMeshApp.git
   cd FaceMeshApp
   ```
   
2. **Open the project in Xcode**: 
   ```bash
   open FaceMeshApp.xcodeproj
   ```
   
3. **Set the development team**:
   - Go to the project settings in Xcode.
   - Set your development team under the “Signing & Capabilities” tab.
    
4. **Run the app**:
   - Select your device in the device selector.
   - Press the Run button or use Cmd + R to build and run the app on your device.   
   

## Usage

1. Permissions: On first launch, the app will request camera access. Please grant the necessary permissions for full functionality.
2. User Interface: The app displays the live camera feed along with detected facial expressions at the bottom of the screen. The expressions are dynamically updated as the user’s face moves and changes.
3. Expressions Detected:
   - Smiling: “You are smiling.”
   - Eyebrow Movements: Raised or lowered eyebrows.
   - Cheek Puff: Detection of puffed cheeks.
   - Tongue Out: Detection if the tongue is sticking out.

## Structure

- FaceTrackingViewModel: The ViewModel that handles the AR session and expression analysis.
- FaceTrackingView: A SwiftUI view that displays the ARSCNView and integrates with the ViewModel.
- ContentView: The main view that combines the FaceTrackingView and displays the analysis.


## Contributing

We welcome contributions from the community! Follow these steps to contribute:
1. Fork the repository.
2. Create a new branch:
    ```bash
    git checkout -b feature/your-feature-name
    ```
3. Commit your changes:
    ```bash
    git commit -m 'Add some feature'
    ```
4. Push to the branch:
    ```bash
    git push origin feature/your-feature-name
    ```
5. Open a pull request on GitHub.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.


## Credit
- [AppCoda](https://github.com/appcoda/Face-Mesh)
