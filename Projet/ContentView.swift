//
//  ContentView.swift
//  Projet
//
//  Created by goldorak (Souleymane DIOP & Eric WU) on 14/02/2022.
//

import SwiftUI

struct ContentView: View {
    var allDaysEvents: [Event] = EventTestdata.testEvents.filter { $0.isAllDay == true }
    var timedEvents: [Event] = EventTestdata.testEvents.filter { $0.isAllDay == false }
    var scale: CGFloat = 50
    
    let color: Color = Color(UIColor.systemGreen)
    
    @State var clickedEvent: Event?
    @State var showDetailView: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(spacing: scale) {
                        ForEach(0..<25) { i in
                            HStack(spacing: 5) {
                                Text("\(i):00")
                                Rectangle()
                                    .frame(height: 1)
                            }
                            .foregroundColor(.gray)
                            .frame(height: 10)
                            .padding(.leading, 3)
                        }
                    }
                    .offset(y: CGFloat(allDaysEvents.count) * 30 + 10)
//                    VStack {
                    ZStack(alignment: .top) {
                        ForEach(timedEvents.indices, id: \.self) { event in
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(color)
                                    .opacity(0.5)
                                    .overlay {
                                        HStack {
                                            Capsule()
                                                .frame(width: 8)
                                                .foregroundColor(color)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(timedEvents[event].title)
                                                    .font(.headline)
                                                Text(timedEvents[event].location)
                                                    .font(.caption)
                                                if timedEvents[event].duration > 1 {
                                                    Text(timedEvents[event].notes != "" ? "Notes: \(timedEvents[event].notes)" : "")
                                                        .font(.footnote)
                                                }
                                                Spacer()
                                            }
                                            .padding(.vertical, 5)
                                            Spacer()
                                        }
                                    }
                                    .padding(.leading, 50)
                                    .padding(.trailing, 5)
                                    .frame(height: (scale + 10) * timedEvents[event].duration)
                                    .offset(y: timedEvents[event].startTime * (scale + 10) - 500 + CGFloat(allDaysEvents.count) * 30)//this sets the offset for each event block
                                    .onTapGesture {
                                        clickedEvent = timedEvents[event]
                                        showDetailView = true
                                    }
                            }
                        }
                    VStack {
                        ForEach(allDaysEvents.indices, id: \.self) { allDayEvent in
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundColor(color)
                                .opacity(0.8)
                                .frame(height: 30)
                                .overlay {
                                    HStack {
                                        Text(allDaysEvents[allDayEvent].title)
                                            .font(.headline)
                                        Spacer()
                                        Text("All day")
                                            .font(.caption)
                                            .foregroundColor(Color(UIColor.secondaryLabel))
                                            .padding(.all, 3)
                                            .background {
                                                RoundedRectangle(cornerRadius: 3)
                                                    .foregroundColor(Color(UIColor.systemBackground))
                                                    .opacity(0.8)
                                            }
                                    }
                                    .padding(.horizontal, 10)
                                }
                                .padding(.horizontal, 5)
                                .onTapGesture {
                                    clickedEvent = allDaysEvents[allDayEvent]
                                    showDetailView = true
                                }
                        }
                        Spacer()
                    }
                }
                .padding(.bottom, 50)
                .ignoresSafeArea(.all)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(Date().formatted(date: .long, time: .omitted))
            .sheet(isPresented: $showDetailView) {
                NewDetailView(showDetailView: $showDetailView, clickedEvent: $clickedEvent)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewDetailView: View {
    @Binding var showDetailView: Bool
    @Binding var clickedEvent: Event?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Location")
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Spacer()
                    Text(clickedEvent!.location)
                }
                .padding(.horizontal, 10)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                }
                VStack {
                    HStack {
                        Text("Date")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        Spacer()
                        Text(clickedEvent!.date.formatted(date: .long, time: .omitted))
                    }
                    Divider()
                    HStack {
                        Text("Time")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        Spacer()
                        Text(clickedEvent!.isAllDay ? "All day" : "\(Int(clickedEvent!.startTime)):00 - \(Int(clickedEvent!.startTime) + Int(clickedEvent!.duration)):00")
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Notes")
                            .foregroundColor(Color(UIColor.systemOrange))
                            .font(.caption)
                        Text(clickedEvent!.notes == "" ? "No notes" : clickedEvent!.notes)
                    }
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitle(clickedEvent!.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDetailView = false
                    }) {
                        Text("Done")
                    }
                }
            }
        }
    }
}

struct Event: Hashable {
    var title: String
    var location: String
    var isAllDay: Bool
    var date: Date
    var startTime: CGFloat//Start time in hours
    var duration: CGFloat
    var notes: String
}

class EventTestdata {
    static let testEvents: [Event] = [
        Event(title: "Breakfast!", location: "Home", isAllDay: false, date: Date(), startTime: 5, duration: 1, notes: ""),
        Event(title: "Meeting 1", location: "Study Room", isAllDay: false, date: Date(), startTime: 8, duration: 3, notes: "Study math with Lisa"),
        Event(title: "Meeting 2", location: "Mathematics", isAllDay: false, date: Date(), startTime: 12, duration: 1, notes: "Class with Dr. Denver"),
        Event(title: "Reminder", location: "", isAllDay: true, date: Date(), startTime: 0, duration: 0, notes: "Take the trash out!"),
        Event(title: "Dinner with Family", location: "Italien Restaurant", isAllDay: false, date: Date(), startTime: 19, duration: 2.5, notes: "")
        ]
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
