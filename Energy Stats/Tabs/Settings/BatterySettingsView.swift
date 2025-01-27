//
//  BatterySettingsView.swift
//  Energy Stats
//
//  Created by Alistair Priest on 08/03/2023.
//

import Energy_Stats_Core
import SwiftUI

struct BatterySettingsView: View {
    @ObservedObject var viewModel: SettingsTabViewModel
    @FocusState private var focused
    @State private var isEditingCapacity = false

    var body: some View {
        Section(
            content: {
                HStack {
                    Text("Min battery charge (SOC)")
                    Spacer()
                    Text(viewModel.minSOC, format: .percent)
                }

                HStack(alignment: .top) {
                    Text("Capacity")
                    Spacer()
                    HStack(alignment: .top) {
                        if isEditingCapacity {
                            VStack(alignment: .trailing) {
                                TextField("Capacity", text: $viewModel.batteryCapacity)
                                    .multilineTextAlignment(.trailing)
                                    .focused($focused)

                                HStack {
                                    Button("OK") {
                                        viewModel.saveBatteryCapacity()
                                        isEditingCapacity = false
                                        focused = false
                                    }.buttonStyle(.bordered)
                                    Button("Cancel") {
                                        viewModel.revertBatteryCapacityEdits()
                                        isEditingCapacity = false
                                        focused = false
                                    }.buttonStyle(.bordered)
                                }
                            }
                        } else {
                            Text(viewModel.batteryCapacity)
                                .onTapGesture {
                                    focused = true
                                    isEditingCapacity = true
                                }
                        }
                        Text(" Wh")
                    }
                }

                Button("Recalculate capacity", action: {
                    viewModel.recalculateBatteryCapacity()
                })
            }, header: {
                Text("Battery")
            }, footer: {
                Text("Calculated as ") +
                    Text("capacity = residual / (Min SOC / 100)").italic() +
                    Text(" where residual is estimated by your installation and may not be accurate. Tap the capacity above to enter a manual value.")
            }
        ).alert("Invalid Battery Capacity", isPresented: $viewModel.showAlert, actions: {
            Button("OK") {}
        }, message: {
            Text("Amount entered must be greater than 0")
        })

        Section {
            Toggle(isOn: $viewModel.showBatteryEstimate) {
                Text("Show battery full/empty estimate")
            }

        } footer: {
            Text("Empty/full battery durations are estimates based on calculated capacity, assume that solar conditions and battery charge rates remain constant.")
        }

        Section(content: {
            Toggle(isOn: $viewModel.showUsableBatteryOnly) {
                Text("Show usable battery only")
            }
        }, footer: {
            Text("Deducts the Min SOC amount from the battery charge level and percentage. Due to inaccuracies in the way battery levels are measured this may occasionally show a negative amount.")
        })

        Section {
            Toggle(isOn: $viewModel.showBatteryTemperature) {
                Text("Show battery temperature")
            }
        }
    }
}

#if DEBUG
struct BatterySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            BatterySettingsView(viewModel: SettingsTabViewModel(
                userManager: .preview(),
                config: PreviewConfigManager(),
                networking: DemoNetworking())
            )
        }
    }
}
#endif
