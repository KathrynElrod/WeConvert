//
//  ContentView.swift
//  WeConvert
//
//  Created by Kathryn Elrod on 3/1/21.
//

import SwiftUI

struct ContentView: View {
    // Top Section
    @State private var domains = ["Temp", "Length", "Time", "Volume"]
    @State private var type = 0
    
    // Middle Section
    @State private var input = ""
    
    var fromUnits: [String] {
        switch domains[type] {
        case "Temp":
            return ["°C", "°F", "K"]
        case "Length":
            return ["m", "ft", "mi"]
        case "Time":
            return ["sec", "min", "hr"]
        case "Volume":
            return ["ml", "oz", "gal"]
        default:
            return []
        }
    }
    @State private var fromUnit = 0
    
    // Bottom Section
    var toUnits: [String] {
        // Returns fromUnits, but without the chosen fromUnit
        var to = fromUnits
        to.remove(at: fromUnit)
        return to
    }
    @State private var toUnit = 0
    
    
    var result: Double {
        // This is a whole long thing with lots
        // of magic numbers, but it does work!
        let sanitizedInput = Double(input) ?? 0
        
        switch domains[type] {
        case "Temp":
            var K: Double = 0
            
            switch fromUnits[fromUnit] {
            case "°C":
                K = sanitizedInput + 273.15
            case "°F":
                K = (sanitizedInput - 32) * (5/9) + 273.15
            case "K":
                K = sanitizedInput
            default:
                return 0
            }
            
            switch toUnits[toUnit] {
            case "°C":
                return K - 273.15
            case "°F":
                return (K - 273.15) * (9/5) + 32
            case "K":
                return K
            default:
                return 0
            }
        case "Length":
            var m: Double = 0
            
            switch fromUnits[fromUnit] {
            case "m":
                m = sanitizedInput
            case "ft":
                m = sanitizedInput / 3.281
            case "mi":
                m = sanitizedInput * 1609.34
            default:
                return 0
            }
            
            switch toUnits[toUnit] {
            case "m":
                return m
            case "ft":
                return m * 3.281
            case "mi":
                return m / 1609.34
            default:
                return 0
            }
        case "Time":
            var s: Double = 0
            
            switch fromUnits[fromUnit] {
            case "sec":
                s = sanitizedInput
            case "min":
                s = sanitizedInput * 60
            case "hr":
                s = sanitizedInput * 3600
            default:
                return 0
            }
            
            switch toUnits[toUnit] {
            case "sec":
                return s
            case "min":
                return s / 60
            case "hr":
                return s / 3600
            default:
                return 0
            }
        case "Volume":
            var ml: Double = 0
            
            switch fromUnits[fromUnit] {
            case "ml":
                ml = sanitizedInput
            case "oz":
                ml = sanitizedInput * 29.5735
            case "gal":
                ml = sanitizedInput * 3785.41
            default:
                return 0
            }
            
            switch toUnits[toUnit] {
            case "ml":
                return ml
            case "oz":
                return ml / 29.5735
            case "gal":
                return ml / 3785.41
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("Conversion type", selection: $type) {
                        ForEach(0 ..< domains.count) {
                            Text("\(self.domains[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        TextField("Amount", text: $input)
                            .keyboardType(.decimalPad)
                        
                        Picker("From", selection: $fromUnit) {
                            // magically changes based on conversion type
                            ForEach(0 ..< fromUnits.count) {
                                Text("\(self.fromUnits[$0])")
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    HStack {
                        Text("Convert to:")
                        
                        Picker("To", selection: $toUnit) {
                            // magically changes based on conversion
                            // type and chosen "from" unit
                            ForEach(0 ..< toUnits.count) {
                                Text("\(self.toUnits[$0])")
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    HStack {
                        Spacer()
                        Text("\(result, specifier: "%g") \(toUnits[toUnit])")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("WeConvert")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
