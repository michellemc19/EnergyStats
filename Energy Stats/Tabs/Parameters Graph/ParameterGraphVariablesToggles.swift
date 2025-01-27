//
//  ParameterGraphVariablesToggles.swift
//  Energy Stats
//
//  Created by Alistair Priest on 02/05/2023.
//

import Energy_Stats_Core
import SwiftUI

@available(iOS 16.0, *)
struct ParameterGraphVariablesToggles: View {
    @ObservedObject var viewModel: ParametersGraphTabViewModel
    @Binding var selectedDate: Date?
    @Binding var valuesAtTime: ValuesAtTime<ParameterGraphValue>?

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.graphVariables, id: \.self) { variable in
                if variable.isSelected {
                    HStack {
                        Button(action: { viewModel.toggle(visibilityOf: variable) }) {
                            HStack(alignment: .top) {
                                Circle()
                                    .foregroundColor(variable.type.colour)
                                    .frame(width: 15, height: 15)
                                    .padding(.top, 5)

                                VStack(alignment: .leading) {
                                    let title = valuesAtTime == nil ? variable.type.title(as: .total) : variable.type.title(as: .snapshot)
                                    Text(title)

                                    if title != variable.type.description {
                                        Text(variable.type.description)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color("text_dimmed"))
                                    }
                                }

                                Spacer()

                                if let valuesAtTime, let graphValue = valuesAtTime.values.first(where: { $0.type == variable.type }) {
                                    Text(graphValue.formatted())
                                } else if let bounds = viewModel.graphVariableBounds.first(where: { $0.type == variable.type }) {
                                    ValueBoundsView(value: bounds.min, type: .min)
                                    ValueBoundsView(value: bounds.max, type: .max)
                                }
                            }
                            .opacity(variable.enabled ? 1.0 : 0.5)
                        }
                        .buttonStyle(.plain)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)

            if valuesAtTime != nil, let selectedDate {
                HStack {
                    Text(selectedDate, format: .dateTime)
                    Button("Clear graph values", action: {
                        self.valuesAtTime = nil
                        self.selectedDate = nil
                    })
                    .padding()
                }.frame(maxWidth: .infinity)
            }

        }.onChange(of: viewModel.graphVariables) { _ in
            viewModel.refresh()
        }
    }
}

#if DEBUG

@available(iOS 16.0, *)
struct GraphVariablesSelection_Previews: PreviewProvider {
    static var previews: some View {
        ParameterGraphVariablesToggles(
            viewModel: ParametersGraphTabViewModel(networking: DemoNetworking(), configManager: PreviewConfigManager()),
            selectedDate: .constant(nil),
            valuesAtTime: .constant(nil)
        )
    }
}
#endif
