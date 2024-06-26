import SwiftUI

struct ExploreSliderView: View {
        @State private var currentIndex: Int = 0
        
        let cards: [Card] = [
            Card(id: 0, color: Color.red),
            Card(id: 1, color: Color.green),
            Card(id: 2, color: Color.blue),
            Card(id: 3, color: Color.orange),
            Card(id: 4, color: Color.purple)
        ]
        
    
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    ForEach(cards) { card in
                        CarouselCardView(card: card, currentIndex: $currentIndex, geometry: geometry)
                            .offset(x: CGFloat(card.id - currentIndex) * (geometry.size.width * 0.6))
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let cardWidth = geometry.size.width * 0.3
                            let offset = value.translation.width / cardWidth
                            
                            withAnimation(Animation.spring()) {
                                if value.translation.width < -offset
                                {
                                    currentIndex = min(currentIndex + 1, cards.count - 1)
                                } else if value.translation.width > offset {
                                    currentIndex = max(currentIndex - 1, 0)
                                }
                            }
                            
                        }
                )
            }
            .padding()
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var color: Color
    }
    
    struct CarouselCardView: View {
        let card: Card
        @Binding var currentIndex: Int
        let geometry: GeometryProxy
        
        var body: some View {
            let cardWidth = geometry.size.width * 0.8
            let cardHeight = 145.0
            let offset = 90.0
            
            return VStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(card.color)
                    .frame(width: cardWidth, height: cardHeight)
                    .opacity(card.id <= currentIndex + 1 ? 1.0 : 0.0)
//                    .scaleEffect(card.id == currentIndex ? 1.0 : 0.9)
            }
            .frame(width: cardWidth, height: cardHeight)
            .offset(x: CGFloat(card.id - currentIndex) * offset)
        }
    }

#Preview {
    ExploreSliderView()
}
