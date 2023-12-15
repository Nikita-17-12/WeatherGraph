//
//  WeatherGraphView.swift
//  WeatherGraph
//
//

import SwiftUI

struct WeatherGraphView: View {
    
    @State private var progress: CGFloat = 0.0 // Initial progress value
    @State private var dragAmount: CGSize = .zero
    @State private var isOn: Bool = false
    @State private var tempStr: String = "_ _°"
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private func roundedString(from value: Double, decimalPlaces: Int) -> String {
          let formatter = NumberFormatter()
          formatter.minimumFractionDigits = decimalPlaces
          formatter.maximumFractionDigits = decimalPlaces
          formatter.roundingMode = .ceiling
          formatter.roundingIncrement = 0.5
          return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
      }
  
    var body: some View {
        VStack {
            
            Text("Temperature Controller")
                .font(.title)
                .frame(height: 50)
                .padding()
            Spacer()
            ZStack {
                //Progress bar
                ZStack {
                    // Background Circle
                    Circle()
                        .trim(from: 0.123, to: 1)
                        .stroke(Color.gray, lineWidth: 35)
                        .opacity(0.3)
                        .frame(width: 200, height: 200)
                        .rotationEffect(Angle(degrees: -112))
                        .gesture(DragGesture()
                            .onChanged { value in
                                if isOn {
                                    self.updateProgress(value: value)
                                }
                            }
                            .onEnded { _ in
                                feedbackGenerator.impactOccurred()
                            }
                        )
                    // Progress Circle
                    Circle()
                        .trim(from: 0.15, to: progress)
                        .stroke(gradientColor(), style: StrokeStyle(lineWidth: 35, lineCap: .square))
                        .frame(width: 200, height: 200)
                        .rotationEffect(Angle(degrees: -115))
                        .gesture(DragGesture()
                            .onChanged { value in
                                self.updateProgress(value: value)
                              
                            }
                            .onEnded { _ in
                                feedbackGenerator.impactOccurred()
                            }
                        )
                    
                    // Line Cap Circle
                    Circle()
                        .trim(from: progress - 0.001, to: progress)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(Angle(degrees: -100))
                        .gesture(DragGesture()
                            .onChanged { value in
                                self.updateProgress(value: value)
                              
                            }
                            .onEnded { _ in
                                feedbackGenerator.impactOccurred()
                            }
                        )
                      
                }
                .rotationEffect(Angle(degrees: 180))
                VStack {
                    Spacer()
//                     Image Overlay
                    Image(isOn ? "on" : "off")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 50)
                        .padding(.horizontal, 15)
                        .background(.clear)
                        .onTapGesture {
                            isOn.toggle()
                            dragAmount = .zero
                            if isOn {
                                progress = 0.099
                                tempStr = "0°"
                            } else {
                                progress = 0.0
                                tempStr = "_ _°"
                            }
                        }
                    
                }.frame(height: 240)
                VStack {
                    Text(tempStr)
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .frame(height: 50)
                    Text("Temperature")
                        .foregroundColor(Color.black)
                        .frame(height: 50)
                        .offset(y: -20)
                }
            }
            .frame(width: 350, height: 350)
            .padding()
            
            Spacer()
        }
    }

    
    private func updateProgress(value: DragGesture.Value) {
        let newDragAmount = CGSize(width: value.translation.width + dragAmount.width, height: value.translation.height + dragAmount.height)
        print("width:\(newDragAmount.width) height: \(newDragAmount.height)")

           let vector = CGVector(dx: newDragAmount.width, dy: newDragAmount.height)
           
           let angle = atan2(vector.dy, vector.dx)
        let normalizedAngle = angle < 0 ? angle + 2 * .pi : angle
        let newProgress = normalizedAngle / .pi
         print(newProgress)
           self.progress = newProgress
           // Update the dragAmount smoothly
           withAnimation {
               dragAmount = newDragAmount
           }
        let percent = Double(progress * 100)
        
        if percent > 99 {
                tempStr = "99°"
                isOn = false
        } else {
           // tempStr = "\(percent)°"
         //   tempStr = "\(String(format: "%.1f", percent))°"
            print(percent)
            tempStr = "\(roundedString(from: percent, decimalPlaces: 1))°"
       }
    }

   
   
    private func gradientColor() -> LinearGradient {
          let gradientColors = [Color.orange.opacity(1),Color.orange.opacity(0.5),Color.green.opacity(0.5),Color.green.opacity(1)]
          return LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
          }
}

#Preview {
    WeatherGraphView()
}
