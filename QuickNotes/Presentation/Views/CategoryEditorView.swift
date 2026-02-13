import SwiftUI

// MARK: - CategoryEditorView

struct CategoryEditorView: View {

    @State var viewModel: CategoryEditorViewModel
    @Environment(\.dismiss) private var dismiss

    private var showCancelButton: Bool

    init(viewModel: CategoryEditorViewModel, showCancelButton: Bool = false) {
        _viewModel = State(initialValue: viewModel)
        self.showCancelButton = showCancelButton
    }

    var body: some View {
        NavigationStack {
            Form {
                nameSection
                iconSection
                colorSection
            }
            .navigationTitle(viewModel.isEditing ? "Edit Category" : "New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showCancelButton {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.save()
                            if viewModel.isSaved { dismiss() }
                        }
                    }
                    .fontWeight(.semibold)
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Saving...")
                        .appTypography(AppTypography.bodyMedium)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.clearError() } }
            )) {
                Button("OK") { viewModel.clearError() }
            } message: {
                if let message = viewModel.errorMessage {
                    Text(message)
                }
            }
        }
    }

    private var nameSection: some View {
        Section {
            TextField("Category name", text: $viewModel.name)
                .appTypography(AppTypography.bodyLarge)
        } header: {
            Text("Name")
        }
    }

    private var iconSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 52))], spacing: 12) {
                ForEach(CategoryEditorViewModel.availableIcons, id: \.sfSymbol) { item in
                    Button {
                        viewModel.selectedIcon = item.sfSymbol
                    } label: {
                        Image(systemName: item.sfSymbol)
                            .appTypography(AppTypography.headingLarge, colorOverride: viewModel.selectedIcon == item.sfSymbol ? .white : Color(hex: viewModel.selectedColorHex))
                            .frame(width: 44, height: 44)
                            .background(
                                viewModel.selectedIcon == item.sfSymbol
                                    ? Color(hex: viewModel.selectedColorHex)
                                    : Color(hex: viewModel.selectedColorHex).opacity(0.2)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("Icon")
        }
    }

    private var colorSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                ForEach(CategoryEditorViewModel.availableColors, id: \.hex) { item in
                    Button {
                        viewModel.selectedColorHex = item.hex
                    } label: {
                        Circle()
                            .fill(Color(hex: item.hex))
                            .frame(width: 36, height: 36)
                            .overlay {
                                if viewModel.selectedColorHex == item.hex {
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 3)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("Color")
        }
    }
}
