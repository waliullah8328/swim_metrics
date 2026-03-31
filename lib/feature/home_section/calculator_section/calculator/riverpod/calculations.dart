import 'dart:convert';

class SwimSplitCalculator1 {
  static final Map<String, dynamic> ratiosScm = {"women":{"free":{"50":[0.4843,0.5157],"100":[0.2283,0.2526,0.259,0.2601],"200":[0.2332,0.2507,0.2569,0.2592],"400":[0.1157,0.1244,0.1257,0.1265,0.1265,0.1271,0.128,0.126],"800":[0.057,0.0615,0.0624,0.0629,0.0633,0.0635,0.0634,0.0635,0.0633,0.0632,0.0633,0.0632,0.0629,0.0631,0.0625,0.0611],"1500":[0.0318,0.0331,0.0333,0.0332,0.0333,0.0334,0.0333,0.0334,0.0333,0.0332,0.0334,0.0335,0.0334,0.0335,0.0334,0.0336,0.0335,0.0334,0.0335,0.0334,0.0336,0.0335,0.0334,0.0336,0.0335,0.0336,0.0335,0.0336,0.0335,0.0328]},"fly":{"50":[0.4668,0.5332],"100":[0.212,0.2525,0.2634,0.2721],"200":[0.2257,0.2519,0.26,0.2624]},"back":{"50":[0.4913,0.5087],"100":[0.2338,0.2473,0.2588,0.2601],"200":[0.2354,0.2524,0.2561,0.2563]},"breast":{"50":[0.4571,0.5429],"100":[0.2127,0.2573,0.2627,0.2673],"200":[0.2286,0.2534,0.2575,0.2606]},"im":{"100":[0.2065,0.2473,0.2991,0.2471],"200":[0.2179,0.2523,0.2883,0.2415],"400":[0.1072,0.122,0.1287,0.1268,0.141,0.144,0.1171,0.1132]}},"men":{"free":{"50":[0.4791,0.5209],"100":[0.2262,0.2513,0.2605,0.262],"200":[0.2337,0.2519,0.2565,0.2579],"400":[0.1153,0.1262,0.1274,0.1282,0.1263,0.1264,0.1261,0.1241],"800":[0.0567,0.0612,0.0622,0.0628,0.0628,0.0631,0.0632,0.0635,0.0634,0.0635,0.0634,0.0636,0.0635,0.0633,0.0632,0.061],"1500":[0.0304,0.0328,0.0331,0.0335,0.0336,0.0335,0.0336,0.0334,0.0335,0.0336,0.0335,0.0334,0.0335,0.0334,0.0335,0.0334,0.0336,0.0335,0.0336,0.0337,0.0336,0.0337,0.0336,0.0337,0.0336,0.0335,0.0336,0.0335,0.0331,0.0315]},"fly":{"50":[0.4553,0.5447],"100":[0.2134,0.2509,0.2617,0.274],"200":[0.2283,0.2536,0.2577,0.2605]},"back":{"50":[0.4906,0.5094],"100":[0.233,0.2483,0.2579,0.2608],"200":[0.2351,0.2543,0.2541,0.2565]},"breast":{"50":[0.4506,0.5494],"100":[0.2096,0.2558,0.2633,0.2713],"200":[0.225,0.2519,0.2606,0.2625]},"im":{"100":[0.2025,0.2491,0.2986,0.2498],"200":[0.2158,0.2492,0.2875,0.2475],"400":[0.1067,0.1219,0.1284,0.1264,0.1407,0.1437,0.1186,0.1136]}}};

  static final Map<String, dynamic> ratiosScy = {"men":{"free":{"50":[0.4828,0.5172],"100":[0.2233,0.2508,0.2618,0.2641],"200":[0.2297,0.2527,0.2569,0.2607],"500":[0.0912,0.1,0.1015,0.1019,0.1021,0.1021,0.1016,0.1013,0.1004,0.0979],"1000":[0.0455,0.049,0.0496,0.0498,0.05,0.0501,0.0501,0.0503,0.0503,0.0505,0.0502,0.0502,0.0507,0.0508,0.0509,0.0505,0.0507,0.0508,0.0508,0.0493],"1650":[0.0278,0.0302,0.0304,0.0306,0.0305,0.0307,0.0306,0.0306,0.0307,0.0306,0.0305,0.0306,0.0305,0.0305,0.0306,0.0305,0.0306,0.0305,0.0304,0.0303,0.0304,0.0305,0.0304,0.0306,0.0303,0.0304,0.0305,0.0303,0.0302,0.0303,0.0302,0.0299,0.0285]},"fly":{"50":[0.46,0.54],"100":[0.2121,0.2537,0.263,0.2712],"200":[0.2236,0.2539,0.2581,0.2644]},"breast":{"50":[0.448,0.552],"100":[0.211,0.2562,0.2625,0.2703],"200":[0.2237,0.2537,0.2587,0.2639]},"back":{"50":[0.483,0.517],"100":[0.2346,0.2483,0.2583,0.2588],"200":[0.234,0.2532,0.2561,0.2567]},"im":{"100":[0.205,0.249,0.299,0.247],"200":[0.2134,0.2489,0.2919,0.2458],"400":[0.1056,0.1212,0.1288,0.1257,0.1417,0.1441,0.119,0.1139]}},"women":{"free":{"50":[0.4845,0.5155],"100":[0.2264,0.2521,0.2596,0.2619],"200":[0.2346,0.2542,0.2552,0.256],"500":[0.0927,0.0999,0.1009,0.1015,0.1015,0.1014,0.1014,0.101,0.1008,0.0989],"1000":[0.0473,0.05,0.0507,0.0508,0.0505,0.0504,0.0501,0.0499,0.0502,0.05,0.0499,0.0498,0.0499,0.0501,0.0499,0.0502,0.0505,0.0503,0.0504,0.0491],"1650":[0.0279,0.03,0.0304,0.0305,0.0306,0.0307,0.0308,0.0306,0.0305,0.0304,0.0303,0.0304,0.0302,0.0303,0.0302,0.0304,0.0303,0.0304,0.0301,0.0302,0.0301,0.0301,0.0302,0.0303,0.0304,0.0305,0.0304,0.0306,0.0305,0.0306,0.0302]},"fly":{"50":[0.4692,0.5308],"100":[0.2126,0.2536,0.2635,0.2703],"200":[0.2235,0.2534,0.2584,0.2647]},"breast":{"50":[0.456,0.544],"100":[0.222,0.249,0.262,0.267],"200":[0.2328,0.2509,0.2549,0.2614]},"back":{"50":[0.488,0.512],"100":[0.2363,0.2484,0.2573,0.258],"200":[0.2328,0.2506,0.2576,0.259]},"im":{"100":[0.21,0.257,0.3,0.233],"200":[0.2159,0.2505,0.2911,0.2425],"400":[0.1096,0.1188,0.1267,0.1258,0.1398,0.1428,0.1184,0.118]}}};

  static final Map<String, dynamic> ratiosLcm = {"women":{"fly":{"100":[0.468,0.532],"200":[0.225,0.254,0.258,0.263]},"back":{"100":[0.486,0.514],"200":[0.235,0.251,0.256,0.258]},"breast":{"100":[0.465,0.535],"200":[0.232,0.251,0.257,0.26]},"free":{"100":[0.481,0.519],"200":[0.235,0.252,0.256,0.257],"400":[0.1151,0.1245,0.1262,0.1268,0.1267,0.1273,0.1278,0.1256],"800":[0.0563,0.0607,0.062,0.0628,0.0631,0.0635,0.0636,0.0634,0.0636,0.0637,0.0635,0.0632,0.063,0.063,0.0628,0.0618],"1500":[0.0301,0.0323,0.0329,0.033,0.0331,0.0333,0.0334,0.0334,0.0333,0.0335,0.0334,0.0335,0.0336,0.0337,0.0338,0.0336,0.0337,0.0335,0.0336,0.0337,0.0335,0.0338,0.0336,0.0341,0.0335,0.0339,0.0336,0.0339,0.0335,0.0322]},"im":{"200":[0.214,0.254,0.291,0.241],"400":[0.1049,0.1204,0.1285,0.1268,0.1424,0.1467,0.1188,0.1114]}},"men":{"back":{"100":[0.4832,0.5168],"200":[0.2353,0.2522,0.2556,0.2569]},"breast":{"100":[0.466,0.534],"200":[0.2282,0.2547,0.2572,0.2599]},"fly":{"100":[0.4678,0.5322],"200":[0.221,0.2534,0.2589,0.2667]},"free":{"100":[0.48,0.52],"200":[0.233,0.2532,0.2567,0.2571],"400":[0.1156,0.1249,0.1267,0.1276,0.1275,0.1276,0.1268,0.1233],"800":[0.0577,0.0617,0.0622,0.0625,0.0626,0.0627,0.0628,0.0629,0.063,0.0631,0.0632,0.0634,0.0635,0.0636,0.0633,0.0618],"1500":[0.0308,0.0329,0.0336,0.0332,0.0334,0.0333,0.0338,0.0336,0.0337,0.0336,0.0339,0.0336,0.0338,0.0336,0.0338,0.0337,0.0336,0.0334,0.0335,0.0334,0.0336,0.0335,0.0334,0.0335,0.0334,0.0335,0.0336,0.0337,0.0333,0.0302]},"im":{"200":[0.214,0.2523,0.2896,0.2441],"400":[0.1041,0.1199,0.1298,0.127,0.1421,0.1438,0.1193,0.114]}}};

  static final Map<String, dynamic> menFinalRatios = {"15m":0.24911244119887105,"25m":0.45592405358182886,"35m":0.6681239311261443};

  static final Map<String, dynamic> womenFinalRatios = {"15m":0.25710412570525365,"25m":0.4641355431704898,"35m":0.6769629887138275};

  static List<double> normalizeRatios(List<dynamic> ratios) {
    double total = ratios.fold(0.0, (sum, item) => sum + (item as num).toDouble());
    return ratios.map((item) => ((item as num).toDouble()) / total).toList();
  }

  static double mmssToSeconds(String mmss) {
    if (mmss.contains(":")) {
      List<String> parts = mmss.split(":");
      return double.parse(parts[0]) * 60 + double.parse(parts[1]);
    }
    return double.parse(mmss);
  }

  static String secondsToMmss(double seconds) {
    if (seconds < 60) {
      return seconds.toStringAsFixed(2);
    }
    int m = (seconds / 60).floor();
    double sec = seconds % 60;
    String secStr = sec < 10 ? "0${sec.toStringAsFixed(2)}" : sec.toStringAsFixed(2);
    return "$m:$secStr";
  }

  static String formatCustom(List<double> splits, String course, String goalTime, String distance, String gender, String stroke, Map<String, dynamic> resultJson) {
    List<String> output = [];
    output.add("===============");
    output.add("${gender}'s $distance $stroke $course Projection");
    double actualTotal = splits.fold(0.0, (a, b) => a + b);
    output.add("Goal Time: ${secondsToMmss(actualTotal)}");
    output.add("===============");
    output.add("Split Breakdown:");

    double cumulativeTotal = 0;
    List<double> fiftySplits = List.from(splits);
    double totalSeconds = mmssToSeconds(goalTime);
    double diff = totalSeconds - actualTotal;
    fiftySplits[fiftySplits.length - 1] += diff;

    List<Map<String, dynamic>> structuredSplits = [];

    for (int i = 0; i < fiftySplits.length; i++) {
      int idx = i + 1;
      double s = fiftySplits[i];
      cumulativeTotal += s;
      List<String> lineParts = ["${idx * 50}: ${secondsToMmss(s)}"];

      Map<String, dynamic> splitData = {
        "distance": "${idx * 50}",
        "split": secondsToMmss(s),
        "cumulative": secondsToMmss(cumulativeTotal)
      };

      lineParts.add(secondsToMmss(cumulativeTotal));

      if (idx % 2 == 0) {
        double hundredSplit = fiftySplits[idx - 2] + fiftySplits[idx - 1];
        lineParts.insert(1, secondsToMmss(hundredSplit));
        splitData["hundred_split"] = secondsToMmss(hundredSplit);
      }

      output.add(lineParts.join(" / "));
      structuredSplits.add(splitData);
    }

    output.add("===============");
    resultJson["splits"] = structuredSplits;
    return output.join("\n");
  }

  static String project(String goalTime, List<dynamic> rawRatioList, String unit, String courseDisplay, String distanceDisplay, String genderDisplay, String strokeDisplay, Map<String, dynamic> resultJson) {
    double totalSeconds;
    try {
      totalSeconds = mmssToSeconds(goalTime);
    } catch (e) {
      return "Invalid time format. Please use mm:ss or ss.ss.";
    }

    List<double> ratioList = normalizeRatios(rawRatioList);
    List<double> splits = ratioList.map((r) => totalSeconds * r).toList();

    if (["400", "500", "800", "1000", "1500", "1650"].contains(distanceDisplay)) {
      return formatCustom(splits, courseDisplay, goalTime, distanceDisplay, genderDisplay, strokeDisplay, resultJson);
    }

    List<String> output = [];
    output.add("===============");
    output.add("${genderDisplay}'s $distanceDisplay $strokeDisplay $courseDisplay Projection");

    double actualTotal = splits.fold(0.0, (a, b) => a + b);
    output.add("Goal Time: ${secondsToMmss(actualTotal)}");
    output.add("===============");

    List<Map<String, dynamic>> structuredSplits = [];

    if (distanceDisplay == "50") {
      output.add("25: ${secondsToMmss(splits[0])} / ${secondsToMmss(splits[0])}");
      output.add("50: ${secondsToMmss(splits[1])} / ${secondsToMmss(splits[0] + splits[1])}");
      structuredSplits.add({"distance": "25", "split": secondsToMmss(splits[0]), "cumulative": secondsToMmss(splits[0])});
      structuredSplits.add({"distance": "50", "split": secondsToMmss(splits[1]), "cumulative": secondsToMmss(splits[0] + splits[1])});
    } else if (distanceDisplay == "100") {
      double cumulativeTotal = 0;
      if (["SCY", "SCM"].contains(courseDisplay)) {
        for (int i = 0; i < 4; i++) {
          cumulativeTotal += splits[i];
          if (i == 3) {
            double combinedLastTwo = splits[2] + splits[3];
            double sumFirstFour = splits.sublist(0, 4).fold(0.0, (a, b) => a + b);
            output.add("100: ${secondsToMmss(splits[i])} / ${secondsToMmss(combinedLastTwo)} / ${secondsToMmss(sumFirstFour)}");
            structuredSplits.add({"distance": "100", "split": secondsToMmss(splits[i]), "combined_last_two": secondsToMmss(combinedLastTwo), "cumulative": secondsToMmss(sumFirstFour)});
          } else {
            output.add("${(i+1)*25}: ${secondsToMmss(splits[i])} / ${secondsToMmss(cumulativeTotal)}");
            structuredSplits.add({"distance": "${(i+1)*25}", "split": secondsToMmss(splits[i]), "cumulative": secondsToMmss(cumulativeTotal)});
          }
        }
      } else {
        for (int i = 0; i < splits.length; i++) {
          cumulativeTotal += splits[i];
          output.add("${(i+1)*50}: ${secondsToMmss(splits[i])} / ${secondsToMmss(cumulativeTotal)}");
          structuredSplits.add({"distance": "${(i+1)*50}", "split": secondsToMmss(splits[i]), "cumulative": secondsToMmss(cumulativeTotal)});
        }
      }
    } else if (distanceDisplay == "200") {
      double cumulativeTotal = 0;
      for (int i = 0; i < 4; i++) {
        cumulativeTotal += splits[i];
        if (i == 3) {
          double combinedLastTwo = splits[2] + splits[3];
          double sumFirstFour = splits.sublist(0, 4).fold(0.0, (a, b) => a + b);
          output.add("200: ${secondsToMmss(splits[i])} / ${secondsToMmss(combinedLastTwo)} / ${secondsToMmss(sumFirstFour)}");
          structuredSplits.add({"distance": "200", "split": secondsToMmss(splits[i]), "combined_last_two": secondsToMmss(combinedLastTwo), "cumulative": secondsToMmss(sumFirstFour)});
        } else {
          output.add("${(i+1)*50}: ${secondsToMmss(splits[i])} / ${secondsToMmss(cumulativeTotal)}");
          structuredSplits.add({"distance": "${(i+1)*50}", "split": secondsToMmss(splits[i]), "cumulative": secondsToMmss(cumulativeTotal)});
        }
      }
    } else {
      int increment = 50;
      double cumulativeTotal = 0;
      for (int i = 0; i < splits.length; i++) {
        cumulativeTotal += splits[i];
        output.add("${(i+1)*increment}: ${secondsToMmss(splits[i])} / ${secondsToMmss(cumulativeTotal)}");
        structuredSplits.add({"distance": "${(i+1)*increment}", "split": secondsToMmss(splits[i]), "cumulative": secondsToMmss(cumulativeTotal)});
      }
    }

    output.add("===============");
    resultJson["splits"] = structuredSplits;
    return output.join("\n");
  }

  /// The main function exposing JSON output as instructed
  static String calculateSplits({
    required String course,
    required String gender,
    required String stroke,
    required String distance,
    required String goalTime,
  }) {
    course = course.trim().toLowerCase();
    gender = gender.trim().toLowerCase();
    stroke = stroke.trim().toLowerCase();
    distance = distance.trim();
    goalTime = goalTime.trim();

    Map<String, dynamic> outputJson = {
      "success": true,
      "course": course.toUpperCase(),
      "gender": gender.substring(0, 1).toUpperCase() + gender.substring(1),
      "stroke": stroke.substring(0, 1).toUpperCase() + stroke.substring(1),
      "distance": distance,
      "goal_time": goalTime,
      "is_speed_chart": false,
      "formatted_text": "",
      "splits": [],
      "disclaimer": ""
    };

    if (course.isEmpty || gender.isEmpty || stroke.isEmpty || distance.isEmpty || goalTime.isEmpty) {
      outputJson["success"] = false;
      outputJson["error"] = "Please fill all fields.";
      return jsonEncode(outputJson);
    }

    if (course == "lcm" && distance == "50" && ["free", "fly", "back", "breast"].contains(stroke)) {
      double targetTime;
      try {
        targetTime = mmssToSeconds(goalTime);
      } catch (e) {
        outputJson["success"] = false;
        outputJson["error"] = "Please enter a valid time (mm:ss or ss.ss).";
        return jsonEncode(outputJson);
      }

      Map<String, dynamic> ratios;
      if (gender == "men") {
        ratios = menFinalRatios;
      } else if (gender == "women") {
        ratios = womenFinalRatios;
      } else {
        outputJson["success"] = false;
        outputJson["error"] = "Invalid gender selection.";
        return jsonEncode(outputJson);
      }

      List<double> splits = [
        targetTime * ratios["15m"],
        targetTime * ratios["25m"],
        targetTime * ratios["35m"],
        targetTime
      ];
      List<String> labels = ["15m", "25m", "35m", "Total time"];

      List<String> textOut = [];
      textOut.add("===============");
      textOut.add("${outputJson["gender"]} 50m ${outputJson["stroke"]} LCM (15/25/35 Avg Model)");
      textOut.add("Goal Time: ${targetTime.toStringAsFixed(2)}");
      textOut.add("===============");

      List<Map<String, dynamic>> structuredSplits = [];
      for (int i = 0; i < labels.length; i++) {
        textOut.add("${labels[i]}: ${splits[i].toStringAsFixed(2)}");
        structuredSplits.add({
          "label": labels[i],
          "split": splits[i].toStringAsFixed(2)
        });
      }
      textOut.add("===============");

      outputJson["is_speed_chart"] = true;
      outputJson["formatted_text"] = textOut.join("\n");
      outputJson["splits"] = structuredSplits;
      return jsonEncode(outputJson);
    }

    Map<String, dynamic>? ratioSource;
    if (course == "scy") ratioSource = ratiosScy;
    else if (course == "scm") ratioSource = ratiosScm;
    else if (course == "lcm") ratioSource = ratiosLcm;

    if (ratioSource == null || !ratioSource.containsKey(gender) || !ratioSource[gender].containsKey(stroke) || ratioSource[gender][stroke][distance] == null) {
      outputJson["success"] = false;
      outputJson["error"] = "Ratios not defined for this event.";
      return jsonEncode(outputJson);
    }

    List<dynamic> rawRatioList = ratioSource[gender][stroke][distance];
    String unit = distance == "50" ? "25" : "50";

    String formattedResult = project(goalTime, rawRatioList, unit, outputJson["course"], distance, outputJson["gender"], outputJson["stroke"], outputJson);

    if (stroke == "im") {
      String disclaimer = "\n⚠️ Does not account for best/worst stroke.";
      formattedResult += disclaimer;
      outputJson["disclaimer"] = "⚠️ Does not account for best/worst stroke.";
    }

    outputJson["formatted_text"] = formattedResult;
    return jsonEncode(outputJson);
  }
}



