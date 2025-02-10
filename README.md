# Image Viewer

A simple Flutter web application that allows users to view images by entering a URL. The app supports fullscreen mode, ensuring a seamless image viewing experience.

## Features

- Load an image from a given URL.
- Display the image in a responsive container.
- Double-click on the image to enter fullscreen mode.
- Floating action button (FAB) to toggle fullscreen mode.
- Always-visible exit fullscreen button with high contrast.



## Getting Started

### Prerequisites

- Flutter SDK installed ([Download Flutter](https://flutter.dev/docs/get-started/install))
- A code editor like Visual Studio Code or Android Studio

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/image-viewer.git
   cd image-viewer
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the application:
   ```sh
   flutter run -d chrome
   ```

## Usage

1. Enter an image URL in the text field.
2. Click the **load** button to display the image.
3. Double-click on the image to toggle fullscreen mode.
4. Use the floating action button to manually enter or exit fullscreen mode.
5. The exit fullscreen button is always visible for easy navigation.

## Technologies Used

- Flutter
- Dart
- HTML (via `dart:html` for web integration)

## Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

