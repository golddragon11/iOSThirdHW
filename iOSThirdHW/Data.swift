import SwiftUI
import MapKit

struct Game: Identifiable {
    let id = UUID()
    var name: String = ""
    var photo: String = ""
    var character: CharacterInfo
    var region: MKCoordinateRegion
    var releaseYear: String = ""
    var location: String
}

struct CharacterInfo: Identifiable {
    let id = UUID()
    var name: String = ""
    var birthday: DateComponents = DateComponents()
    var weight: Int = 0
    var height: Int = 0
    var photo: String = ""
}

var watchdogs = [
    Game(name: "Watch dogs", photo: "watchdogs", character: CharacterInfo(name: "Aiden Pearce", birthday: DateComponents(year: 1972, month: 5, day: 2), weight: 85, height: 188, photo: "aiden"), region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)), releaseYear: "2014", location: "Chicago"),
    Game(name: "Watch dogs2", photo: "watchdogs2", character: CharacterInfo(name: "Marcus Holloway", birthday: DateComponents(year: 1992, month: 12, day: 11), weight: 73, height: 175, photo: "marcus"), region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.73, longitude: -122.3), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)), releaseYear: "2016", location: "San Francisco"),
    Game(name: "Watch dogs Legion", photo: "watchdogs3", character: CharacterInfo(name: "Create your character", birthday: DateComponents(year: 1970, month: 1, day: 1), weight: 70, height: 170, photo: "pig"), region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), releaseYear: "2020", location: "London")
]

struct test: View {
    @State private var show = false
    @State private var showSheet = false
    @State private var brightnessAmount:Double = 0
    @State private var myString:String = ""
    @State private var num:Int = 4
    @State private var selectedIndex = 0
    @State private var region = watchdogs[0].region
    @State private var showMap = false
    @State private var showCharacter = false
    @State private var selectDate = Date()
    let today = Date()
    let startDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
    var year: Int {
        Calendar.current.component(.year, from: selectDate)
    }
    var body: some View {
        Map(coordinateRegion: $region)
            .frame(height: 200)
        Button("Show game release year"){
            self.show.toggle()
        }
        .alert(isPresented: $show) { () -> Alert in
            return Alert(title: Text(String(watchdogs[selectedIndex].releaseYear)))
        }
        Form {
            HStack {
                Text("Brightness")
                Slider(value: $brightnessAmount, in: 0...1)
            }
            TextField("Default", text: $myString)
            Toggle("Show", isOn: $show)
                .onChange(of: show, perform: { value in
                    if value {
                        myString = "Hello"
                    }
                    else {
                        myString = "Bye"
                    }
                })
            Stepper(value: $num, in: 4...12) {
                Text("\(num) hours")
            }
        }
        Text("Options")
            .contextMenu {
                Button(action: {
                    // change country setting
                }) {
                    Text("Choose Country")
                    Image(systemName: "globe")
                }

                Button(action: {
                    // enable geolocation
                }) {
                    Text("Detect Location")
                    Image(systemName: "location.circle")
                }
            }
        Button("Actions") {
            self.showSheet.toggle()
        }
        .actionSheet(isPresented: $showSheet, content: {
            ActionSheet(title: Text("Show"), buttons: [.default(Text("Show Map")){showMap = true}, .default(Text("Show Characters")){showCharacter = true}, .cancel()])
        })
        .sheet(isPresented: $showMap) {
            MapView(region: $region, showMap: $showMap)
        }
    }
}

struct Data_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
