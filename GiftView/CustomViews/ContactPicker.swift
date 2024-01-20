//
//  AddContactsButton.swift
//  GiftView
//
//  Created by Connor Hammond on 10/29/23.
//

import Foundation
import SwiftUI
import Contacts
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView

        init(parent: ContactPickerView) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            parent.didSelectContacts(contacts)
        }
    }

    var didSelectContacts: ([CNContact]) -> ()

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
}



