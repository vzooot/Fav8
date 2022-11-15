//
//  ContentView.swift
//  Fav8
//
//  Created by Administrator on 11/13/22.
//

import Combine
import RadioStationsAPI
import SwiftUI

struct RadioStation: Identifiable {
    var id = UUID()
    var name: String
    var url: String
}

class ViewModel: ObservableObject {
    @Published var radioStations: [RadioStation] = []

    var cancelables = Set<AnyCancellable>()

    init() {
        fetchStations()
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { radioStations in
                self.radioStations = radioStations
            })
            .store(in: &cancelables)
    }

    func fetchStations() -> AnyPublisher<[RadioStation], Error> {
        StationsAPI.getAllRadioStations()
            .map { $0.map { RadioStation(name: $0.name , url: $0.url ) }}
            .eraseToAnyPublisher()
    }
}

struct ContentView: View {
    @StateObject var vm: ViewModel = .init()

    var body: some View {
        VStack {
            ForEach(vm.radioStations) { station in
                HStack {
                    Text(station.name)
                    Text(station.url)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
