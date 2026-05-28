import 'dart:convert';
import 'dart:io';

import 'package:aiopoly/utils/constants.dart';
import 'package:aiopoly/data/create_response.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

enum ServiceEndpoint { firebase, direct }

class Service {
  static void useEmulators() {
    if (kDebugMode) {
      String host = Platform.isAndroid ? "10.0.2.2" : "localhost";
      print('Running in debug. Host connecting to emulator at $host.');
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
    }
  }

  Future<List<PropertyGroup>> create(
    String theme, {
    required ServiceEndpoint endpoint,
  }) async {
    CreateResponse? response;
    switch (endpoint) {
      case ServiceEndpoint.firebase:
        {
          response = await _makeFirebaseRequest(theme);
        }
      case ServiceEndpoint.direct:
        {
          response = await _makeDirectRequest(theme);
        }
    }
    return response.groups;
  }

  Future<CreateResponse> _makeFirebaseRequest(theme) async {
    final response = await FirebaseFunctions.instance
        .httpsCallable('create')
        .call({'theme': theme});

    final data = response.data;
    dLog('Response:');
    dLogJson(data);

    return CreateResponse.fromJson(data);
  }

  Future<CreateResponse> _makeDirectRequest(String theme) async {
    // Initialize the Gemini Developer API backend service
    // Create a `GenerativeModel` instance with a model that supports your use case
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash-lite',
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          properties: {
            'groups': Schema(
              SchemaType.array,
              items: Schema(
                SchemaType.object,
                properties: {
                  'type': Schema(
                    SchemaType.string,
                    description:
                        'Type of the property group. MUST be one of: "color" (for standard street or landmark property groups), "railroad" (for transportation or travel properties that do not have a color, e.g. stations, airports, space gates), or "utility" (for services or infrastructure properties that do not have a color, e.g. power grid, waterworks, wifi network).',
                    enumValues: [
                      'color', 'railroad', 'utility',
                    ],
                  ),
                  'color': Schema(
                    SchemaType.string,
                    description:
                        'Color of the property group, for example: "Dark Blue". Required if type is "color", omit or leave null otherwise.',
                  ),
                  'hex': Schema(
                    SchemaType.string,
                    description:
                        'Hex code of the color, for example: "#295DAB". Required if type is "color", omit or leave null otherwise.',
                  ),
                  'properties': Schema(
                    SchemaType.array,
                    items: Schema(
                      SchemaType.object,
                      properties: {
                        'name': Schema(
                          SchemaType.string,
                          description:
                              'Name of the property, for example: "Park Place"',
                        ),
                        'rent': Schema(
                          SchemaType.integer,
                          description:
                              'Rent price of the property, for example: 350',
                        ),
                        'mortgageValue': Schema(
                          SchemaType.integer,
                          description:
                              'Mortgage value of the property, for example: 175',
                        ),
                        'payoffCost': Schema(
                          SchemaType.integer,
                          description:
                              'Cost to pay off the mortgage, for example: 190',
                        ),
                      },
                    ),
                  ),
                },
              ),
            ),
          },
        ),
      ),
    );

    // Provide a prompt that contains text
    final prompt = [
      Content.text(
        'Provide Monopoly board spaces for a game themed around "$theme".\n'
        'You must generate a variety of property groups. Most groups should be standard street or landmark property groups (type "color") that consist of 2-3 properties and a shared color hex. '
        'You should also include one transport/travel group (type "railroad" - typically 4 properties like depots, hubs, or stations themed around the topic) '
        'and/or one service/infrastructure group (type "utility" - typically 2 properties themed around the topic, e.g., energy grid, water recycling, or satellite comms). '
        'For railroad and utility groups, do not provide color or hex values.',
      ),
    ];

    // To generate text output, call generateContent with the text input
    final response = await model.generateContent(prompt);

    final text = response.text;
    if (text != null) {
      dLog('Response:');
      dLog(text);
      return CreateResponse.fromJson(jsonDecode(text));
    }
    throw ('Empty response from Vertex');
  }

  Future<String> generateChanceCard(String theme) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash-lite',
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    final prompt = [
      Content.text(
        'Generate a short, funny and creative Monopoly Chance card description based on the theme "$theme".\n'
        'You must return a valid A2UI JSON payload matching this exact schema:\n'
        '{\n'
        '  "version": "v0.9",\n'
        '  "updateComponents": {\n'
        '    "surfaceId": "chance_card",\n'
        '    "components": [\n'
        '      {\n'
        '        "id": "root",\n'
        '        "component": "Card",\n'
        '        "child": "layout"\n'
        '      },\n'
        '      {\n'
        '        "id": "layout",\n'
        '        "component": "Row",\n'
        '        "children": ["icon", "text"]\n'
        '      },\n'
        '      {\n'
        '        "id": "icon",\n'
        '        "component": "Icon",\n'
        '        "name": "<select one appropriate icon from: warning, payment, error, info, locationOn, help, star, calendarToday, check, delete, notifications, edit, shoppingCart>"\n'
        '      },\n'
        '      {\n'
        '        "id": "text",\n'
        '        "component": "Text",\n'
        '        "text": "<the funny chance card text>"\n'
        '      }\n'
        '    ]\n'
        '  }\n'
        '}\n'
        'Choose either "Row" or "Column" for the "layout" component to best fit the content. Return ONLY the JSON object.'
      ),
    ];

    final response = await model.generateContent(prompt);

    final text = response.text;
    if (text != null) {
      dLog('Chance Response:');
      dLog(text);
      return text;
    }
    throw ('Empty response from Vertex');
  }
}
