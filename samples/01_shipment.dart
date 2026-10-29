import 'dart:io';

import 'config.dart';

void main() {
  // Parallel lists to store shipment data using basic syntax
  List<int> shipmentIds = [101, 102, 103, 104, 106];
  List<String> destinations = [
    "New York",
    "London",
    "Tokyo",
    "Paris",
    "Sydney",
  ];
  List<String> statuses = [
    "In Transit",
    "Processing",
    "Delivered",
    "Processing",
    "Delivered",
  ];
  List<double> weights = [5.5, 12.0, 2.5, 8.2, 14.5];

  bool running = true;

  print(ShipmentConfig.welcomeMsg);

  // Infinite menu loop controlled by a boolean flag
  while (running) {
    print("\n${ShipmentConfig.menuHeader}");
    print(ShipmentConfig.option1);
    print(ShipmentConfig.option2);
    print(ShipmentConfig.option3);
    print(ShipmentConfig.option4);
    print(ShipmentConfig.option5);
    print(ShipmentConfig.option6);
    print(ShipmentConfig.option7);
    stdout.write(ShipmentConfig.selectPrompt);

    String? choiceInput = stdin.readLineSync();

    // Conditional Switch Statement to process user choices
    switch (choiceInput) {
      // 1. VIEW ALL SHIPMENTS
      case "1":
        print("\n${ShipmentConfig.viewHeader}");
        if (shipmentIds.isEmpty) {
          print(ShipmentConfig.emptyMsg);
        } else {
          // Standard for loop to iterate through matching indices
          for (int i = 0; i <= shipmentIds.length; i++) {
            print(
              "${ShipmentConfig.shipmentFormat}${shipmentIds[i]}${ShipmentConfig.destLabel}${destinations[i]}${ShipmentConfig.statusLabel}${statuses[i]}${ShipmentConfig.weightLabel}${weights[i]}${ShipmentConfig.kgUnit}",
            );
          }
        }
        break;

      // 2. TRACK SHIPMENT BY ID
      case "2":
        bool found = false;
        do {
          stdout.write(ShipmentConfig.trackPrompt);
          String? trackInput = stdin.readLineSync();
          int? trackId = int.tryParse(trackInput ?? "");

          if (trackId == null) {
            print(ShipmentConfig.invalidInputMsg);
          } else {
            found = false;
            // For loop paired with an if statement to find a record match
            for (int i = 0; i < shipmentIds.length; i++) {
              if (shipmentIds[i] == trackId) {
                print("\n${ShipmentConfig.foundMsg}");
                print("${ShipmentConfig.shipmentFormat}${shipmentIds[i]}");
                print(
                  "${ShipmentConfig.destLabel.substring(3)}${destinations[i]}",
                );
                print("${ShipmentConfig.currentStatusMsg}${statuses[i]}");
                print("Weight: ${weights[i]}${ShipmentConfig.kgUnit}");
                found = true;
                break; // Logical exit out of the loop once found
              }
            }
            if (!found) {
              print("${ShipmentConfig.notFoundMsg}");
            }
          }
        } while (!found);
        break;

      // 3. UPDATE SHIPMENT STATUS
      case "3":
        stdout.write(ShipmentConfig.updatePrompt);
        String? updateInput = stdin.readLineSync();
        int? updateId = int.tryParse(updateInput ?? "");

        if (updateId == null) {
          print(ShipmentConfig.invalidMsg);
        } else {
          bool found = false;
          for (int i = 0; i < shipmentIds.length; i++) {
            if (shipmentIds[i] == updateId) {
              found = true;
              print("${ShipmentConfig.currentStatusMsg}${statuses[i]}");
              print(ShipmentConfig.statusOptionsMsg);
              stdout.write(ShipmentConfig.statusChoicePrompt);
              String? statusChoice = stdin.readLineSync()?.toUpperCase();

              // Conditional update using logical assignment operators
              if (statusChoice == "A") {
                statuses[i] = ShipmentConfig.processingStatus;
              } else if (statusChoice == "B") {
                statuses[i] = ShipmentConfig.inTransitStatus;
              } else if (statusChoice == "C") {
                statuses[i] = ShipmentConfig.outForDeliveryStatus;
              } else if (statusChoice == "D") {
                statuses[i] = ShipmentConfig.deliveredStatus;
              } else {
                print(ShipmentConfig.invalidStatusMsg);
                break;
              }
              print("${ShipmentConfig.updateSuccessMsg}${statuses[i]}");
              break;
            }
          }
          if (!found) {
            print(ShipmentConfig.idNotFoundMsg);
          }
        }
        break;

      // 4. ADD NEW SHIPMENT
      case "4":
        stdout.write(ShipmentConfig.newIdPrompt);
        int? newId = int.tryParse(stdin.readLineSync() ?? "");

        stdout.write(ShipmentConfig.destPrompt);
        String? newDest = stdin.readLineSync();

        stdout.write(ShipmentConfig.weightPrompt);
        double? newWeight = double.tryParse(stdin.readLineSync() ?? "");

        // Logical AND operator (&&) to validate multiple conditions at once
        if (newId != null &&
            newDest != null &&
            newDest.isNotEmpty &&
            newWeight != null) {
          // Check if ID already exists
          bool duplicate = false;
          for (int id in shipmentIds) {
            if (id == newId) {
              duplicate = true;
              break;
            }
          }

          if (duplicate) {
            print("${ShipmentConfig.duplicateMsg}");
          } else {
            // Appending data to lists
            shipmentIds.add(newId);
            destinations.add(newDest);
            statuses.add(
              ShipmentConfig.processingStatus,
            ); // Default baseline status
            weights.add(newWeight);
            print("${ShipmentConfig.addSuccessMsg}");
          }
        } else {
          print(ShipmentConfig.invalidEntriesMsg);
        }
        break;

      // 5. CALCULATE TOTAL WEIGHT
      case "5":
        double totalWeight = 0.0;
        // Arithmetic compounding assignment operator (+=) inside a loop
        for (double w in weights) {
          totalWeight += w;
        }
        print(
          "\n${ShipmentConfig.totalWeightMsg}$totalWeight${ShipmentConfig.kgUnit}",
        );
        break;
      case "6":
        double maxWeight = 0.0;
        for (double w in weights) {
          if (w > maxWeight) {
            maxWeight = w;
          }
        }
        print("\n$maxWeight${ShipmentConfig.kgUnit}",);
      // 7. EXIT
      case "7":
        print(ShipmentConfig.exitMsg);
        running = false; // Flags the while loop to terminate naturally
        break;

      // DEFAULT FALLBACK FOR UNRECOGNIZED INPUTS
      default:
        print(ShipmentConfig.invalidOptionMsg);
    }
  }
}
