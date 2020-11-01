import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @State private var selectedIndex = 0
    @State private var region = watchdogs[0].region
    @State private var tcolor = Color.blue
    @State private var showSheet = false
    @State private var showCover = false
    var body: some View {
        NavigationView {
            VStack {
                Image(watchdogs[selectedIndex].photo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 416)
                ColorPicker("Set picker color", selection: $tcolor)
                    .padding(.horizontal)
                Picker(selection: $selectedIndex, label: Text("Select game")) {
                    ForEach(watchdogs.indices) { (index) in
                        Text("\(watchdogs[index].name)")
                    }
                }
                .frame(height: 100)
                .background(tcolor)
                .clipped()
                .cornerRadius(30)
                .onChange(of: selectedIndex, perform: { value in
                    region = watchdogs[selectedIndex].region
                })
                NavigationLink(destination: CharacterView(index: selectedIndex, region: watchdogs[selectedIndex].region)){
                    Text((selectedIndex < 2) ? "Main Character" : "Your Character")
                }
            }
            .navigationTitle("Watch Dogs")
            .navigationBarItems(leading: Image(systemName: "photo").imageScale(.large).foregroundColor(.blue)
                                    .contextMenu {
                                        Button(action: {
                                            self.showCover.toggle()
                                        }) {
                                            Text("Cover Photo")
                                        }
                                    },
                                trailing: Button(action: {self.showSheet.toggle()}){Image(systemName: "globe").imageScale(.large)})
            .actionSheet(isPresented: $showSheet, content: {
                ActionSheet(title: Text("Open Website"), buttons:
                                [.default(Text("Ubisoft")){openURL(URL(string: "https://www.ubisoft.com.tw")!)},
                                 .default(Text("Wikipidea")){openURL(URL(string: "https://en.wikipedia.org/wiki/Watch_Dogs")!)},
                                 .cancel()])})
            .fullScreenCover(isPresented: $showCover, content: CoverPhoto.init)

        }
    }
}

struct CoverPhoto: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            ForEach(watchdogs.indices) { index in
                Image(watchdogs[index].photo)
                    .resizable()
                    .scaledToFit()
            }
        }
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CharacterView: View {
    @State var index: Int
    @State var region: MKCoordinateRegion
    @State var showAlert = false
    @State var showDetail = false
    @State private var showEdit = false
    var body: some View {
        let year = "\(watchdogs[index].character.birthday.year!)"
        VStack {
            Image(watchdogs[index].character.photo)
                .resizable()
                .scaledToFit()
            Text(watchdogs[index].character.name)
            Button("Show game release year"){
                self.showAlert.toggle()
            }
            .alert(isPresented: $showAlert) { () -> Alert in
                return Alert(title: Text(String(watchdogs[index].releaseYear)))
            }
            Toggle("Show detail", isOn: $showDetail)
            DisclosureGroup(
                isExpanded: $showDetail,
                content: {
                    VStack {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text("\(watchdogs[index].character.name)")
                        }
                        HStack {
                            Text("Birthday")
                            Spacer()
                            Text("\(year)/\(watchdogs[index].character.birthday.month!)/\(watchdogs[index].character.birthday.day!)")
                        }
                        HStack {
                            Text("Weight")
                            Spacer()
                            Text("\(watchdogs[index].character.weight) kg")
                        }
                        HStack {
                            Text("Height")
                            Spacer()
                            Text("\(watchdogs[index].character.height) cm")
                        }
                        HStack {
                            Text("Story Location")
                            Spacer()
                            Text("\(watchdogs[index].location)")
                        }
                    }
                },
                label: { Text("Detail") })
                .padding(.horizontal)
            Map(coordinateRegion: $region)
        }
        .navigationTitle(Text("\(watchdogs[index].name)"))
        .navigationBarItems(trailing: Button((index == 2) ? "Edit" : ""){self.showEdit.toggle()})
        .sheet(isPresented: $showEdit){
            EditView(showEdit: $showEdit)
        }
        .onChange(of: showEdit){value in}
    }
}

struct EditView: View {
    @Binding var showEdit: Bool
    @State private var myString = ""
    @State private var selectDate = Date()
    @State private var weight = 65
    @State private var height = 170.0
    let today = Date()
    let startDate = Date(timeIntervalSince1970: 0)
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $myString)
                DatePicker("Birthday", selection: $selectDate, in: startDate...today, displayedComponents: .date)
                Stepper(value: $weight, in: 48...120) {
                    Text("\(weight) kg")
                }
                HStack {
                    Text("Height")
                    Slider(value: $height, in: 140...210)
                    Text("\(Int(height))")
                }
                Button("Randomize height and weight") {
                    height = Double.random(in: 140...210)
                    weight = Int.random(in: 48...120)
                }
            }
            Button("Done") {
                showEdit = false
                watchdogs[2].character.name = myString
                watchdogs[2].character.weight = weight
                watchdogs[2].character.height = Int(height)
                watchdogs[2].character.birthday = Calendar.current.dateComponents([.year, .month, .day], from: selectDate)
            }
        }
    }
}

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var showMap: Bool
    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
            Button("Close") {
                showMap = false
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .preferredColorScheme(.dark)
    }
}
