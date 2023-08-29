//
//  ContentView.swift
//  BetterRest
//
//  Created by Shomil Singh on 06/06/23.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleephours:Double=8
    @State private var wakeUp=deafaulttime
    @State private var coffeeamount=1
    @State private var alertmessage=""
    @State private var alertText=""
    @State private var showingalert=false
    @State private var bedtime:Date=Date.now
    var cup = Array(1...20)
    static var deafaulttime:Date{
        var components=DateComponents()
        components.hour=7
        components.minute=00
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        VStack{
            
            NavigationStack{
                
                Form{
                    
                    Section{
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Select Time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
//                            .padding()
                    }
                    
                    Section{
                        Text("Enter ampunt of sleep")
                            .font(.headline)
                        Stepper("\(sleephours.formatted()) hours", value: $sleephours ,in: 1...24,step: 0.25)
                          
                        
            
//                            .padding()
                    }
                    VStack{
                        Text("Coffee intake per day")
                            .font(.headline)

                        Picker(coffeeamount == 1 ? "1 cup" : "\(coffeeamount) cups", selection: $coffeeamount)
                        {
                            ForEach(cup,id: \.self)
                            {
                                Text("\($0)")
//                                calculateBedtime()
                            }
                           
                            
                        }
                       
                        
                    }
                    
                    Section{
                        Text("Recommended bedtime:")
                            .font(.headline)
                        Text("\(alertmessage)")
                    }
                    
                    
                }
                .navigationTitle("BetterRest")
                
               
                .onChange(of: coffeeamount, perform: { _ in calculateBedtime()
                })
                .onChange(of: sleephours, perform: { _ in calculateBedtime()
                })
                .onChange(of: wakeUp, perform: { _ in calculateBedtime()
                })
                
                
              
            }
           
            
            
            
            
        }
       
        
    }
    func calculateBedtime()
    {
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components=Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour=(components.hour ?? 0) * 60 * 60
            let minute=(components.minute ?? 0) * 60
            
            let prediction=try model.prediction(wake: Double(hour+minute), estimatedSleep: sleephours, coffee: Double(coffeeamount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertText="Your ideal bedtime is..."
            alertmessage=sleepTime.formatted(date: .omitted, time: .standard)
            
        }
        catch{
            alertText="Error!"
            alertmessage="Something went wrong!"
            
            
            
        }
        showingalert=true
        
    }
    
    func TrivialExample(){
        var components=DateComponents()
        components.hour=9
        components.minute=30
        let date=Calendar.current.date(from: components) ?? Date.now
        print(date)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
