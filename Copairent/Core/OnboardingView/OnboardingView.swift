//
//  OnboardingView.swift
//  Copairent
//
//  Created by Daniel Hunt on 10/8/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentTab = 0

    let onboardingData: [(image: String, title: String, description: String)] = [
        ("person.2.fill", "Connect", "Stay connected with your co-parent and manage your children's schedules efficiently."),
        ("calendar", "Organize", "Keep track of important dates, events, and shared responsibilities."),
        ("message.fill", "Communicate", "Seamless in-app messaging to discuss important matters about your children."),
        ("waveform.and.mic", "AI Voice Assistant", "Use your phone's AI voice assistant to easily add events, reminders, and notes, making organization effortless.")
    ]

    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(0..<onboardingData.count, id: \.self) { index in
                OnboardingPageView(
                    imageName: onboardingData[index].image,
                    title: onboardingData[index].title,
                    description: onboardingData[index].description
                )
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .overlay(
            VStack {
                Spacer()
                if currentTab == onboardingData.count - 1 {
                    Button(action: {
                        // Action to start using the app
                        hasCompletedOnboarding.toggle()
                    }) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
            }
        )
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 50)

            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)

            Text(description)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(hasCompletedOnboarding: .constant(false))
    }
}
