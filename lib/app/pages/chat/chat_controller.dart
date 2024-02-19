import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'dart:typed_data';

import 'package:chat_diabetes/app/models/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class ChatController extends ChangeNotifier {
  String apiKey = "AIzaSyC3armS6x0XdTKXGd8lRxdHG3cUe1pmuY8";

  GenerativeModel? model;

  late ChatSession chat;

  ChatController() {
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    chat = model!.startChat();
  }

  final List<MessageModel> messages = []; // Lista para armazenar as mensagens
  final TextEditingController inputController =
      TextEditingController(); // Controlador para o TextField

  bool isLoading = false;

  html.MediaRecorder? _recorder;
  html.Blob audioData = html.Blob([]);
  Completer<void>? _recordingCompleter;

  bool isRecording = false;

  //Controller do listview
  final scrollController = ScrollController();

  void startRecording() {
    isRecording = true;
    notifyListeners();
    html.window.navigator.mediaDevices
        ?.getUserMedia({'audio': true, 'video': false}).then((stream) {
      _recorder = html.MediaRecorder(stream);
      _recorder!.addEventListener('dataavailable', (event) {
        audioData = (event as html.BlobEvent).data!;
        _recordingCompleter?.complete();
      });
      _recorder!.start();
    });
  }

  Future<void> stopRecording() {
    _recordingCompleter = Completer<void>();
    _recorder?.stop();
    _recorder?.stream?.getAudioTracks().forEach((track) {
      track.stop();
    });
    isRecording = false;
    notifyListeners();
    return _recordingCompleter!.future;
  }

  Future<Uint8List> blobToUint8List(html.Blob blob) async {
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();
    reader.readAsDataUrl(blob);
    reader.onLoadEnd.listen((event) {
      final result = reader.result as String;
      final encoded = result.split(',').last;
      completer.complete(base64Decode(encoded));
    });
    return completer.future;
  }

  // Future<void> playAudio() async {
  //   FlutterSoundPlayer _player = FlutterSoundPlayer();
  //   final audioBytes = await blobToUint8List(audioData);

  //   _player.openPlayer();

  //   _player.startPlayer(
  //     fromDataBuffer: audioBytes,
  //     whenFinished: () {
  //       _player.stopPlayer();
  //     },
  //   );
  // }

  Future<void> sendAudio() async {
    try {
      final audioBytes = await blobToUint8List(audioData);
      final url =
          'https://speech.googleapis.com/v1p1beta1/speech:recognize?key=AIzaSyAX6mgSyB4xtnVDWShHOdDIZZnFNUmrT0o';
      final audioContent = base64Encode(audioBytes);
      final body = {
        'config': {
          'encoding': 'WEBM_OPUS',
          'languageCode': 'pt-BR',
        },
        'audio': {
          'content': audioContent,
        },
      };

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      final transcript = data['results'][0]['alternatives'][0]['transcript'];

      sendMessage(text: transcript);
    } catch (e) {
      print(e);
    }
  }

  void getChatResponse({required String message}) async {
    try {
      isLoading = true;
      notifyListeners();

      message =
          "Este chat se tratará apenas de conversas sobre diabetes. Este paciente é um paciente diabético que precisa tirar dúvidas sobre tudo relacionado a diabetes, ele também pode tirar dúvidas sobre outras coisas relacionadas a saúde que também se relacionam com a diabetes e também sobre alimentos para diabéticos portanto, caso a pergunta do não seja relacionada a diabetes, informe que não irá responder (lembrando que tudo que você disser são apenas sugestões com base no seu conhecimento). A pergunta é a seguinte (não responda nada que esteja ecrito até aqui):" +
              message;

      final content = Content.text(message);
      final response = await chat.sendMessage(content);

      MessageModel messageModel = MessageModel(
        text: response.text!,
        isUser: false,
      );

      messages.add(messageModel);
      isLoading = false;
      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToEnd();
      });
    } catch (e) {
      print(e);
    }
  }

  void sendMessage({required String text}) {
    try {
      MessageModel messageModel = MessageModel(
        text: text,
        isUser: true,
      );

      messages.add(messageModel);
      getChatResponse(message: text);
      inputController.clear();

      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToEnd();
      });
    } catch (e) {
      print(e);
    }
  }

  void scrollToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
