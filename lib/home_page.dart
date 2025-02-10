import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  final String _viewId = 'image-container';
  bool _isMenuOpen = false;
  html.Element? _currentImage;
  bool _isFullscreen = false;
  

  @override
  void initState() {
    super.initState();
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => html.DivElement()..id = _viewId,
    );
    html.document.onFullscreenChange.listen((_) {
      setState(() {
        _isFullscreen = html.document.fullscreenElement != null;
      });
       
    });
  }

  void _loadImage() {
    final url = _urlController.text;
    if (url.isEmpty) return;

    final container = html.document.getElementById(_viewId);
    container?.children.clear();

    container?.style.display = 'flex';
    container?.style.justifyContent = 'center';
    container?.style.alignItems = 'center';
    container?.style.width = '100%';
    container?.style.height = '100%';

    // Create a wrapper div for the image and exit button
    final wrapper = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.position = 'relative';

    final image = html.ImageElement()
      ..src = url
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..onDoubleClick.listen((_) => _toggleFullscreen());

    // Create exit fullscreen button (HTML)
    final exitButton = html.ButtonElement()
      ..text = 'Exit Fullscreen'
      ..style.position = 'absolute'
      ..style.bottom = '20px'
      ..style.left = '50%'
      ..style.transform = 'translateX(-50%)'
      ..style.padding = '10px 20px'
      ..style.backgroundColor = 'rgba(255, 255, 255, 0.8)'
      ..style.border = 'none'
      ..style.borderRadius = '5px'
      ..style.cursor = 'pointer'
      
      ..onClick.listen((_) => _exitFullscreen());

    wrapper.append(image);
    wrapper.append(exitButton);
    container?.append(wrapper);

    _currentImage = wrapper;
  }

  void _toggleFullscreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen();
    } else {
      _currentImage?.requestFullscreen();
    }
  }

  void _enterFullscreen() {
    if (html.document.fullscreenElement == null) {
      _currentImage?.requestFullscreen();
    }
  }

  void _exitFullscreen() {
    if (html.document.fullscreenElement != null) {
      html.document.exitFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen ? null : AppBar(),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_isMenuOpen) setState(() => _isMenuOpen = false);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: HtmlElementView(viewType: _viewId),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          decoration:
                              const InputDecoration(hintText: 'Image URL'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _loadImage,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
          if (_isMenuOpen && !_isFullscreen)
            GestureDetector(
              onTap: () => setState(() => _isMenuOpen = false),
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black38,
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      right: 16,
                      bottom: 80,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).cardColor,
                        child: IntrinsicWidth(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(
                                  _isFullscreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: _isFullscreen ? Colors.black87 : null,
                                ),
                                title: Text(
                                  _isFullscreen
                                      ? 'Exit fullscreen'
                                      : 'Enter fullscreen',
                                  style: _isFullscreen
                                      ? const TextStyle(color: Colors.white)
                                      : null,
                                ),
                                tileColor: _isFullscreen ? Colors.black : null,
                                onTap: () {
                                  if (_isFullscreen) {
                                    _exitFullscreen();
                                  } else {
                                    _enterFullscreen();
                                  }
                                  setState(() => _isMenuOpen = false);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _isFullscreen
          ? null
          : AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                boxShadow: [
                  if (_isMenuOpen)
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _isFullscreen
                    ? _exitFullscreen
                    : () => setState(() => _isMenuOpen = !_isMenuOpen),
                elevation: _isMenuOpen ? 8 : 4,
                backgroundColor: _isFullscreen
                    ? const Color.fromARGB(255, 186, 18, 18)
                    : (_isMenuOpen ? Colors.blue.shade400 : null),
                child: Icon(
                  _isFullscreen ? Icons.fullscreen_exit : Icons.add,
                  color: _isFullscreen ? Colors.black87 : null,
                ),
              ),
            ),
    );
  }
}