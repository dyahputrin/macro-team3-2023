//
//  OnboardingViewControllerWrapper.swift
//  Coba Gabung RoomPlan dan GuidedCapture
//
//  Created by Jefry Gunawan on 09/10/23.
//

import SwiftUI

struct OnboardingViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> OnboardingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace with your storyboard name
        let viewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: OnboardingViewController, context: Context) {
        // Update any necessary properties or data when needed
    }
}
