//
//  SettingsView.swift
//  appdb
//
//  Created by ned on 29/01/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        #if DEBUG
        let _ = Self._printChanges()
        #endif
        
        List {
            NavigationLink {
                NewsView()
            } label: {
                Text("News")
            }

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
