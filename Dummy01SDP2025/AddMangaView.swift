//
//  AddMangaView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 8/1/26.
//

//
//  AddMangaView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 8/1/26.
//

import SwiftUI
import SwiftData

struct AddMangaView: View {
    
    //@FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var vmCover = CoverVM()
    @State var vm: AddMangaVM
    
    @Binding var reload: Bool
    
    var body: some View {
            
        NavigationStack {
            
            Form {
                
                if vm.isSliderEnabled {
                    
                    Section {
                        
                        Slider(
                            value: $vm.readingVolume,
                            in: 0...Double(vm.maxVolumes),
                            step: 1
                        )
                        //.disabled(!vm.isSliderEnabled)
                        
                        Text(Int(vm.readingVolume) == 0 ? "Selecciona un volumen" : "Volumen: \(Int(vm.readingVolume))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                    } header: {
                        Text(vm.maxVolumes == 1 ? "Volumen en lectura" : "Volumen en lectura de los \(vm.maxVolumes)")
                    } footer: {
                        Text("Desliza para seleccionar el volumen que estás leyendo.")
                    }
                    
                } else {
                    //No hay volúmenes
                    Section {
                        
                        TextField("Escribe el número que estás leyendo", text: $vm.readingVolumeText)
                            .keyboardType(.numberPad)
                            //.focused($isTextFieldFocused)
                        
                    } header: {
                        Text("Volumen en lectura")
                    } footer: {
                        Text("No hay info sobre volúmenes.")
                    }
                }
                
                
                // Comprados
                if vm.isSliderEnabled {
                    
                    Section {
                        
                        HStack(spacing: 12) {
                            Slider(
                                value: $vm.currentVolume,
                                in: 0...Double(vm.maxVolumes),
                                step: 1
                            )
                            //.disabled(!vm.isSliderEnabled)
                            
                            //if vm.isSliderEnabled {
                            Button {
                                vm.addVolume()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.blue, in: Circle())
                            }
                            /*} else {
                             Image(systemName: "plus")
                             .font(.title3)
                             .fontWeight(.semibold)
                             .foregroundStyle(.white)
                             .frame(width: 44, height: 44)
                             .background(.gray, in: Circle())
                             .opacity(0.5)
                             }*/
                        }
                        
                        // Current Volume Display
                        Text(Int(vm.currentVolume) == 0 ? "Selecciona un volumen" : "Volumen: \(Int(vm.currentVolume))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        if !vm.addedVolumes.isEmpty {
                            Section {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Volúmenes añadidos:")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    LazyVGrid(
                                        columns: [GridItem(.adaptive(minimum: 50), spacing: 6)],
                                        alignment: .leading,
                                        spacing: 8
                                    ) {
                                        ForEach(vm.addedVolumes, id: \.self) { volume in
                                            Button {
                                                vm.removeVolume(volume)
                                            } label: {
                                                Text("\(volume)")
                                                    .font(.callout)
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.blue)
                                                //.padding(.horizontal, 16)
                                                    .frame(width: 44)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .fill(.blue.opacity(0.1))
                                                            .strokeBorder(.blue.opacity(0.3), lineWidth: 1)
                                                    )
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.leading, 10)
                                }
                            }
                        }
                        
                    } header: {
                        Text(vm.maxVolumes == 1 ? "Volumen comprado" : "Volúmenes comprados de los \(vm.maxVolumes)")
                    } footer: {
                        Text("Desliza para seleccionar un volumen y pulsa + para añadirlo. Toca un número para eliminarlo.")
                    }
                    
                } else {
                    Section {
                        TextField("Escribe números separados por coma", text: $vm.addedVolumesText)
                            .keyboardType(.decimalPad)
                            //.focused($isTextFieldFocused)
                    } header: {
                        Text("Volúmenes comprados")
                    } footer: {
                        Text("No hay info sobre volúmenes.")
                    }
                }
                
                Section {
                    Toggle("Tengo la colección completa", isOn: $vm.completeCollection)
                    
                } header: {
                    Text("Colección")
                }
            }
            //.navigationTitle(vm.mangaTitle.isEmpty ? "Nuevo Manga" : vm.mangaTitle)
            .navigationTitle(vm.mangaCollection.manga.title)
            .navigationBarTitleDisplayMode(.inline)
            /*.onTapGesture {
             isTextFieldFocused = false
             }*/
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        // Handle cancel
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task {
                            await vm.saveManga()
                            if vm.collectionSaved {
                                
                                do {
                                    if (try deleteFavouriteManga(vm.mangaCollection.manga.id)) {
                                    }
                                } catch {
                                    print("ERROR en el borrado de favoritos")
                                }
                                
                                reload.toggle()
                                dismiss()
                            }
                        }
                    }
                    //.disabled(!vm.isFormValid)
                }
            }
            .onAppear {
                vmCover.getImage(cover: URL(string: .getStringMainPicture(mainPicture: vm.mangaCollection.manga.mainPicture ?? "")))
            }
        }
    }
    
    func deleteFavouriteManga(_ id: Int) throws -> Bool {
        let fetch = FetchDescriptor<MangaData>(predicate: #Predicate{$0.id == id})
        let results = try modelContext.fetch(fetch)
        
        guard let mangaToDelete = results.first else {
            return false
        }
        
        modelContext.delete(mangaToDelete)
        return true
    }
}



#Preview {
    let userCollection = UserCollection(
        id: "",
        manga: Manga.testMangas[0],
        volumesOwned: [],
        completeCollection: false,
        readingVolume: 0
    )
    let detailVM = AddMangaVM(mangaCollection: userCollection)
    AddMangaView(vm: detailVM, reload: .constant(false))
}

