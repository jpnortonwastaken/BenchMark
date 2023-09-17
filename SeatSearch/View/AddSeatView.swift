//
//  AddSeatView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/12/23.
//

import SwiftUI
import UIKit

struct AddSeatView: View {
    
    @ObservedObject var vm: SeatViewModel
    
    @Binding var showingSheet: Bool
    
    @State private var seatName = ""
    
    @State private var selectedType: Int = 0
    private let typeChoices = ["Select", "Bench", "Chair", "Rock", "Other"]
    
    @State private var selectedSize: Int = 0
    private let sizeChoices = ["Select", "Small Child", "Half a person", "1 Person", "2 People" , "3 People" , "4 People" , "5+ People"]
    
    @State private var seatRating = 0.0
    var sliderValueInt: Int {
        Int(seatRating.rounded())
    }
    
    @State private var description = ""
    @State private var pros = ""
    @State private var cons = ""
    
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var showCamera: Bool = false
    
    func loadImage() {
        //guard let selectedImage = selectedImage else { return }
        guard selectedImage != nil else { return }
        // Do something with the selected image, like saving it to your model
    }
    
    private var isRequiredInfoFilled: Bool {
        return !seatName.isEmpty && selectedType != 0 && selectedSize != 0 && seatRating != 0.0 && selectedImage != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Required Info")) {
                    TextField("Seat Name", text: $seatName)
                        .bold()
                    
                    HStack {
                        Text("Image")
                        
                        Spacer()
                        
                        Menu {
                            Button(action: {
                                showCamera = true
                            }, label: {
                                HStack {
                                    Text("Take Photo")
                                    Image(systemName: "camera")
                                }
                            })
                            Button(action: {
                                showImagePicker = true
                            }, label: {
                                HStack {
                                    Text("Select Photo")
                                    Image(systemName: "photo")
                                }
                            })
                        } label: {
                            if let image = selectedImage {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .scaledToFit()
                                        .cornerRadius(10)
                                    
                                    Circle()
                                        .foregroundColor(.blue)
                                        .frame(width: 25, height: 25)
                                        .overlay(
                                            Image(systemName: "pencil")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                        )
                                        .offset(x: 5, y: 5)
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(UIColor.tertiaryLabel), lineWidth: 1)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "plus")
                                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                }
                            }
                        }
                        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: $selectedImage)
                        }
                        .sheet(isPresented: $showCamera, onDismiss: loadImage) {
                            CameraView(showCamera: $showCamera, selectedImage: $selectedImage)
                                .background(.black)
                        }
                    }
                    
                    Picker("Seat Type", selection: $selectedType) {
                        ForEach(0..<typeChoices.count, id: \.self) { index in
                            Text(self.typeChoices[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Text("Location: Current Location")
                    
                    Picker("Size", selection: $selectedSize) {
                        ForEach(0..<sizeChoices.count, id: \.self) { index in
                            Text(self.sizeChoices[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    HStack{
                        Text("Rating")
                        
                        Spacer()
                        
                        if sliderValueInt == 0 {
                            Text("\(sliderValueInt) Stars")
                                .foregroundColor(.red)
                        } else if sliderValueInt == 1 {
                            Text("\(sliderValueInt) Star")
                                .foregroundColor(.blue)
                        } else {
                            Text("\(sliderValueInt) Stars")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Slider(
                        value: $seatRating,
                        in: 0...5,
                        step: 1
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("5")
                    }
                }
                
                Section(header: Text("Optional Info")) {
                    TextField("Description", text: $description)
                    
                    TextField("Pros", text: $pros)
                    
                    TextField("Cons", text: $cons)
                }
            }
            .navigationTitle("Add Seat")
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            showingSheet.toggle()
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            if isRequiredInfoFilled {
                let descriptionOrNil = description.isEmpty ? nil : description
                let prosOrNil = pros.isEmpty ? nil : pros
                let consOrNil = cons.isEmpty ? nil : cons
                
                Task {
                    do {
                        try await vm.addSeat(
                            id: UUID(),
                            name: seatName,
                            rating: seatRating,
                            type: SeatType(rawValue: typeChoices[selectedType])!,
                            size: SeatSize(rawValue: sizeChoices[selectedSize])!,
                            description: descriptionOrNil,
                            pros: prosOrNil,
                            cons: consOrNil,
                            image: selectedImage
                        )
                    } catch {
                        // Handle error
                    }
                }
                
                showingSheet.toggle()
            }
        }
    }
    
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct AddSeatView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var vm: SeatViewModel = SeatViewModel()
        
        AddSeatView(vm: vm, showingSheet: BottomSheetHeaderView(vm: vm).$showingSheet)
    }
}
