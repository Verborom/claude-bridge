import SwiftUI

@main
struct DiceRollerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 450, idealWidth: 500, minHeight: 550, idealHeight: 600)
        }
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    @State private var diceValue = 1
    @State private var rollCount = 0
    @State private var isRolling = false
    @State private var rotation3D = 0.0
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 10) {
                Text("🎲 Dice Roller")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Roll Count: \(rollCount)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            
            // Dice Display
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 250, height: 250)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    )
                
                DiceView(value: diceValue)
                    .frame(width: 180, height: 180)
                    .rotation3DEffect(
                        .degrees(rotation3D),
                        axis: (x: 1, y: 1, z: 0)
                    )
                    .scaleEffect(isRolling ? 0.85 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isRolling)
            }
            
            // Roll Button
            Button(action: rollDice) {
                HStack(spacing: 12) {
                    Image(systemName: "dice.fill")
                        .font(.title2)
                    Text("Roll Dice")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(width: 200, height: 50)
                .background(
                    LinearGradient(
                        colors: isRolling ? [.orange, .red] : [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: isRolling ? .red.opacity(0.4) : .blue.opacity(0.4), 
                        radius: 10, x: 0, y: 5)
            }
            .buttonStyle(.plain)
            .disabled(isRolling)
            
            // Reset Button
            Button(action: resetCount) {
                Label("Reset Count", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
            .disabled(rollCount == 0)
            
            Spacer()
        }
        .padding(30)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func rollDice() {
        guard !isRolling else { return }
        
        isRolling = true
        rollCount += 1
        
        // Animate rolling
        withAnimation(.linear(duration: 0.8)) {
            rotation3D += 720
        }
        
        // Generate random value after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            diceValue = Int.random(in: 1...6)
            isRolling = false
        }
    }
    
    private func resetCount() {
        withAnimation(.easeInOut) {
            rollCount = 0
        }
    }
}

struct DiceView: View {
    let value: Int
    
    var body: some View {
        ZStack {
            // Dice background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            
            // Dice dots
            GeometryReader { geometry in
                let dotSize = geometry.size.width * 0.18
                let padding = geometry.size.width * 0.2
                let center = geometry.size.width / 2
                
                Group {
                    // Center dot (for 1, 3, 5)
                    if value % 2 == 1 {
                        Circle()
                            .fill(Color.black)
                            .frame(width: dotSize, height: dotSize)
                            .position(x: center, y: center)
                    }
                    
                    // Top-left and bottom-right (for 2, 3, 4, 5, 6)
                    if value >= 2 {
                        Circle()
                            .fill(Color.black)
                            .frame(width: dotSize, height: dotSize)
                            .position(x: padding, y: padding)
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: dotSize, height: dotSize)
                            .position(x: geometry.size.width - padding, 
                                    y: geometry.size.height - padding)
                    }
                    
                    // Top-right and bottom-left (for 4, 5, 6)
                    if value >= 4 {
                        Circle()
                            .fill(Color.black)
                            .frame(width: dotSize, height: dotSize)
                            .position(x: geometry.size.width - padding, y: padding)
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: dotSize, height: dotSize)
                            .position(x: padding, y: geometry.size.height - padding)
                    }
                    
                    // Middle sides (for 6)
                    if value == 6 {
                        Circle()
                            .fill(Color.black)
                            .frame(width: dotSize, height: dotSize)
                            .position(x: padding, y: center)
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: dotSize, height: dotSize)
                            .position(x: geometry.size.width - padding, y: center)
                    }
                }
            }
        }
    }
}