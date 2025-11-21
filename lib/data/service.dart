import 'dart:convert';
import 'dart:io';

import 'package:aiopoly/utils/constants.dart';
import 'package:aiopoly/data/create_response.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

enum ServiceEndpoint {
  firebase, direct
}

class Service {
  static void useEmulators() {
    if (kDebugMode) {
      String host = Platform.isAndroid ? "10.0.2.2" : "localhost";
      print('Running in debug. Host connecting to emulator at $host.');
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
    }
  }

  Future<List<PropertyGroup>> create(String theme, {required ServiceEndpoint endpoint}) async {
    CreateResponse? response;
    switch (endpoint) {
      case ServiceEndpoint.firebase: {
        response = await _makeFirebaseRequest(theme);
      }
      case ServiceEndpoint.direct: {
        response = await _makeDirectRequest(theme);
      }
    }
    return response.groups;
  }

  Future<CreateResponse> _makeFirebaseRequest(theme) async {
    final response = await FirebaseFunctions.instance.httpsCallable('create').call({
      'theme': theme,
    });

    final data = response.data;
    dLog('Response:');
    dLogJson(data);

    return CreateResponse.fromJson(data);
  }

  Future<CreateResponse> _makeDirectRequest(String theme) async {
    // Initialize the Gemini Developer API backend service
    // Create a `GenerativeModel` instance with a model that supports your use case
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash-lite',
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          properties: {
            'groups': Schema(SchemaType.array, items: Schema(
              SchemaType.object,
              properties: {
                'color': Schema(SchemaType.string, description: 'Color of the property group, for example: "Dark Blue"'),
                'hex': Schema(SchemaType.string, description: 'Hex code of the color, for example: "#295DAB"'),
                'properties': Schema(SchemaType.array, items: Schema(
                  SchemaType.object,
                  properties: {
                    'name': Schema(SchemaType.string, description: 'Name of the property, for example: "Park Place"'),
                    'rent': Schema(SchemaType.integer, description: 'Rent price of the property, for example: 350'),
                  },
                )),
              },
            )),
          },
        ),
      ),
    );

    // Provide a prompt that contains text
    final prompt = [Content.text('Provide Monopoly board spaces for a game themed around $theme')];

    // To generate text output, call generateContent with the text input
    final response = await model.generateContent(prompt);

    final text = response.text;
    if (text != null) {
      dLog('Response:');
      dLog(text);
      return CreateResponse.fromJson(jsonDecode(text));
    }
    throw('Empty response from Vertex');
  }
}