# SketchXtract

*Transform hand-drawn face sketches into realistic AI-generated images*

## Overview

**SketchXtract** is an Android application built with Flutter that allows users to sketch rough faces of male or female culprits/criminals and instantly transform them into realistic, life-like photos. This innovative tool leverages a modified version of the DeepFaceDrawing-Jittor model for fast, GPU-accelerated sketch-to-image generation.

## Features

- **Intuitive Sketch Interface**: Draw freely on a canvas with real-time touch support and stencil guidance
- **Gender Selection**: Choose between male and female models for more accurate results
- **Real-time Processing**: Send sketches to the backend for immediate processing
- **Realistic Output**: Transform rough sketches into detailed, photorealistic face images
- **Customizable API Endpoint**: Easily configure the backend API URL
- **Undo/Redo Functionality**: Full history control for your sketches
- **Modern UI**: Beautiful, responsive interface with smooth animations

## Tech Stack

### Mobile App
- **Framework**: Flutter (Dart)
- **State Management**: Built-in StatefulWidget pattern
- **HTTP Client**: Dio for API communication
- **Storage**: path_provider, shared_preferences

### Backend
- **Framework**: Flask (Python)
- **AI Model**: Modified DeepFaceDrawing-Jittor
- **Tunneling**: ngrok for exposing local server to the internet
- **Acceleration**: GPU-optimized processing for faster results

## How It Works

1. User draws a face sketch on the app canvas
2. The sketch is sent to the Flask backend via ngrok tunnel
3. The backend processes the image using the DeepFaceDrawing-Jittor model
4. The AI generates a realistic face image based on the sketch
5. The resulting image is sent back to the app and displayed to the user

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Google Colab](https://colab.research.google.com/) account (for running the backend)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/SketchXtract.git
   cd SketchXtract
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up the backend:
   - Open the provided Google Colab notebook
   - Follow the setup instructions to initialize the DeepFaceDrawing-Jittor model
   - Start the Flask server and copy the ngrok URL

4. Update the API URL in the app (via settings menu or directly in the code):
   ```dart
   String _apiUrl = 'https://your-ngrok-url.ngrok-free.app';
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Select Gender**: Choose between male or female model
2. **Draw Sketch**: Use your finger or stylus to sketch a face on the canvas
3. **Generate Image**: Tap the generate button to process your sketch
4. **View Result**: The AI-generated realistic face image will appear on the screen
5. **Save/Share**: Save or share the generated image as needed

## Backend Setup

The backend uses a modified version of the DeepFaceDrawing-Jittor model running in Google Colab:

1. Open the Google Colab notebook
2. Run the setup cells to install dependencies
3. Initialize the DeepFaceDrawing-Jittor model
4. Start the Flask server:
   ```python
   app = Flask(__name__)
   # API endpoints defined here
   ```
5. Expose the server using ngrok:
   ```python
   ngrok_tunnel = ngrok.connect(5000)
   print('Public URL:', ngrok_tunnel.public_url)
   ```
6. Copy the ngrok URL to use in the app

## API Endpoints

- **GET `/health`**: Check if the backend is running
- **POST `/process-image`**: Process a sketch and return a realistic image
  - **Parameters**:
    - `image`: The sketch image file (PNG format)
    - `gender`: 'male' or 'female'
    - `timestamp`: Unique identifier for the request

## Troubleshooting

### Backend Connection Issues

If you encounter errors when pressing the generate button, check the following:

1. **Missing Health Endpoint**: Ensure your Flask app has a `/health` endpoint. The app checks this endpoint before sending images for processing:
   ```python
   @app.route('/health', methods=['GET'])
   def health_check():
       return {"status": "ok"}, 200
   ```

2. **ngrok Tunnel Expiration**: ngrok free tier tunnels expire after a few hours. If the app can't connect, regenerate a new ngrok URL and update it in the app.

3. **CUDA Compatibility**: If you see CUDA errors in Colab, try:
   - Using a runtime with GPU enabled
   - Restarting the runtime
   - Verifying Jittor is properly configured with CUDA

4. **Model Loading Errors**: Ensure all model files are correctly downloaded and accessible in the specified paths.

### App Issues

1. **Blank Output Images**: Ensure your sketch has clear facial features. The model works best with well-defined eyes, nose, and mouth.

2. **App Freezing**: If the app becomes unresponsive during processing, check:
   - Network connectivity
   - Backend server status
   - Timeout settings in the Dio HTTP client

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open-source and available under the MIT License.

## Acknowledgements

- [DeepFaceDrawing-Jittor](https://github.com/IGLICT/DeepFaceDrawing-Jittor) - The AI model used for face generation
- [Flutter](https://flutter.dev) - The UI framework used
- [ngrok](https://ngrok.com) - For secure tunneling

## Contact

Created by Mithil Abhiram - feel free to reach out for suggestions, issues, or collaboration!

---

Sketch your imagination to reality! ✏️🎨 
