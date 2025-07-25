import SwiftUI

@main
struct CounterTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, idealWidth: 450, minHeight: 300, idealHeight: 350)
        }
        .windowResizability(.contentSize)
    }
}

struct ContentView: View {
    @State private var counter = 0
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Counter App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Text("\(counter)")
                    .font(.system(size: 72, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAnimating)
            }
            .frame(width: 200, height: 120)
            
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation {
                        counter -= 1
                        triggerAnimation()
                    }
                }) {
                    Label("Decrement", systemImage: "minus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 44))
                        .foregroundStyle(.red)
                        .scaleEffect(1.0)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .help("Decrement counter")
                
                Button(action: {
                    withAnimation {
                        counter = 0
                        triggerAnimation()
                    }
                }) {
                    Text("Reset")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.blue)
                                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        )
                }
                .buttonStyle(.plain)
                .help("Reset counter to zero")
                
                Button(action: {
                    withAnimation {
                        counter += 1
                        triggerAnimation()
                    }
                }) {
                    Label("Increment", systemImage: "plus.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 44))
                        .foregroundStyle(.green)
                        .scaleEffect(1.0)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .help("Increment counter")
            }
            
            Text("Click + or - to change the counter")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 10)
        }
        .padding(40)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func triggerAnimation() {
        isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isAnimating = false
        }
    }
}