//
//  IngridientEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 2.6.24.
//  
//

import SwiftUI

struct MealIngridientEditView<ViewState: MealIngridientEditViewStateProtocol,
                              Presenter: MealIngridientEditPresenterProtocol>: View {
    
    enum Field: Hashable {
        case name
        case weight
        case kcalsper100
        case proteinsper100
        case fatsper100
        case carbsper100
    }
    
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack {
                    HStack {
                        MealParameterCell(title: "dishparameter.kcal",
                                          value: viewState.calories)
                    }
                    HStack {
                        MealParameterCell(title: "dishparameter.proteins",
                                          value: viewState.proteins)
                        MealParameterCell(title: "dishparameter.fats",
                                          value: viewState.fats)
                        MealParameterCell(title: "dishparameter.carbs",
                                          value: viewState.carbohydrates)
                    }
                }
                FieldSectionView(titleKey: "itemEdit.label.name") {
                    TextField("", text: $viewState.name)
                        .defaultTextField()
                        .focused($focusedField, equals: .name)
                }
                FieldSectionView(titleKey: "dishparameter.weight") {
                    TextField("", text: $viewState.weight)
                        .numericTextField()
                        .focused($focusedField, equals: .weight)
                }
                FieldSectionView(titleKey: "dishparameter.kcalsper100") {
                    TextField("", text: $viewState.caloriesPer100)
                        .numericTextField()
                        .focused($focusedField, equals: .kcalsper100)
                }
                FieldSectionView(titleKey: "dishparameter.proteinsper100") {
                    TextField("", text: $viewState.proteinsPer100)
                        .numericTextField()
                        .focused($focusedField, equals: .proteinsper100)
                }
                FieldSectionView(titleKey: "dishparameter.fatsper100") {
                    TextField("", text: $viewState.fatsPer100)
                        .numericTextField()
                        .focused($focusedField, equals: .fatsper100)
                }
                FieldSectionView(titleKey: "dishparameter.carbsper100") {
                    TextField("", text: $viewState.carbsPer100)
                        .numericTextField()
                        .focused($focusedField, equals: .carbsper100)
                }
                Spacer()
            }
        }
        .onAppear {
            presenter.didAppear()
        }
        .onChange(of: focusedField) {
            presenter.submitValues()
        }
        .font(.bodyRegular)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    presenter.doneTapped()
                } label: {
                    Text("app.done")
                        .font(.titleRegular)
                        .foregroundStyle(.primaryText)
                }
            }
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button {
                        presenter.submitValues()
                        focusedField = nil
                    } label: {
                        Text("app.done")
                            .font(.keyboard)
                    }
                }
            }
        }
    }
}

struct MealIngridientEditPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        ApplicationViewBuilder(container: RootApp().container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .mealIngridientEdit(ingridientId: makeMockData()))
        }
    }
    
    private static func makeMockData() -> UUID {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        
        let context = coreDataStackService.getMainQueueContext()
        
        let ingridient = MealIngridient(context: context)
        ingridient.id = UUID()
        ingridient.name = "Potato"
        
        ingridient.weight = 50
        ingridient.caloriesPer100 = 120.1
        
        try? context.save()
        
        return ingridient.id
    }
}
