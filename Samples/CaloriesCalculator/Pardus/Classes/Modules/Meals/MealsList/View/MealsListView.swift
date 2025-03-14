//
//  MealsListView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealsListView<ViewState: MealsListViewStateProtocol,
                     Presenter: MealsListPresenterProtocol>: View {
    
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        VStack {
            if viewState.dateSelectionVisible {
                DatePicker("mealslist.datepicker.selectedDate",
                           selection: $viewState.selectedDate,
                           displayedComponents: .date)
                .font(.bodyRegular)
                .foregroundStyle(.secondaryText)
            }
            List(viewState.sections, id: \.title) { section in
                Section {
                    ForEach(section.items) { item in
                        Button {
                            presenter.tapItem(uid: item.id)
                        } label: {
                            SubtitleCell(title: item.title,
                                         subtitle: item.subtitle,
                                         titleColor: .tertiaryText,
                                         subtitleColor: .tertiaryText)
                        }
                        .listRowInsets(.init(top: 0,
                                             leading: 0,
                                             bottom: 0,
                                             trailing: 0))
                        .buttonStyle(CustomButtonStyle())
                        .listRowSeparator(.hidden)
                        .swipeActions {
                            Button {
                                presenter.deleteItem(uid: item.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                } header: {
                    VStack {
                        Text(section.title)
                            .foregroundStyle(.secondaryText)
                            .font(.bodyRegular)
                    }
                    .defaultCellInsets()
                }
            }
            .listRowSpacing(8)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        .navigationTitle("mealslist.navigation.title")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup {
                Button {
                    presenter.tapToggleDateFilter()
                } label: {
                    Image(systemName: presenter.getFilterImageName())
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
                Button {
                    presenter.tapAddNewItem()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.icon2)
                        .foregroundStyle(.primaryText)
                }
            }
        }
        .onAppear {
            presenter.didAppear()
        }
    }
}

private struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(.dishListCell)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct MealsListPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        let container = RootApp().container
        makeMockData(container: container)
        return ApplicationViewBuilder(container: container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        Group {
            NavigationStack {
                viewBuilder.build(view: .mealsList)
            }
            NavigationStack {
                viewBuilder.build(view: .mealsList)
            }.preferredColorScheme(.dark)
        }
    }

    private static func makeMockData(container: Container) {
        let coreDataStackService = container.resolve(CoreDataStackServiceAssembly.self).build()
        
        let context = coreDataStackService.getMainQueueContext()
        
        let dishCategory = DishCategory(context: context)
        dishCategory.name = "Salads"
        dishCategory.colorHex = "#00AA00"
        dishCategory.id = UUID()
        
        let dish = Dish(context: context)
        dish.id = UUID()
        dish.name = "Carrot salad 🥕"
        dish.category = dishCategory
        
        let soup = Dish(context: context)
        soup.id = UUID()
        soup.name = "Soup 🍜"
        soup.category = dishCategory
        
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.date = Date()
        meal.dishes = Set()
    
        let mealDish = MealDish(context: context)
        mealDish.id = UUID()
        
        let soupMealDish = MealDish(context: context)
        soupMealDish.id = UUID()
        
        mealDish.meal = meal
        mealDish.dish = dish
        
        soupMealDish.meal = meal
        soupMealDish.dish = soup
        
        let meal2 = Meal(context: context)
        meal2.id = UUID()
        meal2.date = Calendar.current.date(byAdding: .day,
                                           value: 1,
                                           to: Date()) ?? Date()
        meal2.dishes = Set()
        
        let meal3 = Meal(context: context)
        meal3.id = UUID()
        meal3.date = Date()
        meal3.dishes = Set()
        
        try? context.save()
    }
}
