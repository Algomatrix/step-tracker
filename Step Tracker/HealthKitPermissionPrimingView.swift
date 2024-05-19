//
//  HealthKitPermissionPrimingView.swift
//  Step Tracker
//
//  Created by Shubham Shetkar on 2024/05/17.
//

import SwiftUI
import HealthKitUI

struct HealthKitPermissionPrimingView: View {

    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingHelathKitPermission = false

    var description = """
    This app displays your steps and weight Data in interactive charts.
    
    You can also add new steps or weight data to Apple Health from this app. Your data is priavte and secured.
    """
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 10) {
                Image(.appleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 12)
                
                Text("Apple Health Integration")
                    .font(.title2.bold())
                
                Text(description)
                    .foregroundStyle(.secondary)
            }
            
            Button("Connect to Apple Health") {
                isShowingHelathKitPermission.toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)

        }
        .padding(30)
        .healthDataAccessRequest(
            store: hkManager.store,
            shareTypes: hkManager.types,
            readTypes: hkManager.types,
            trigger: isShowingHelathKitPermission) { result in
                switch result {
                case .success(_):
                    dismiss()
                case .failure(_):
                    //TODO: Code
                    dismiss()
                }
            }
    }
}

#Preview {
    HealthKitPermissionPrimingView()
        .environment(HealthKitManager())
}
