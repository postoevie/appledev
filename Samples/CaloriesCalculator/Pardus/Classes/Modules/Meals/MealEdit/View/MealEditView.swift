//
//  MealEditView.swift
//  Pardus
//
//  Created by Igor Postoev on 18.5.24.
//
//

import SwiftUI

struct MealEditView<ViewState: MealEditViewStateProtocol, Presenter: MealEditPresenterProtocol>: View {
    
    @StateObject var viewState: ViewState
    @StateObject var presenter: Presenter
    
    var body: some View {
        VStack {
            DatePicker(
                "mealedit.datepicker.date",
                selection: $viewState.date,
                displayedComponents: [.date, .hourAndMinute]
            )
            .font(.bodyLarge)
            .foregroundStyle(.secondaryText)
            Spacer()
                .frame(height: 16)
            HStack {
                MealParameterCell(title: "dishparameter.kcal",
                                  value: viewState.sumKcals)
                MealParameterCell(title: "dishparameter.weight",
                                  value: viewState.weight)
            }
            HStack {
                MealParameterCell(title: "dishparameter.proteins",
                                  value: viewState.sumProteins)
                MealParameterCell(title: "dishparameter.fats",
                                  value: viewState.sumFats)
                MealParameterCell(title: "dishparameter.carbs",
                                  value: viewState.sumCarbs)
            }
            HStack {
                Text("mealedit.disheslist.title")
                Spacer()
                Menu {
                    Button("mealdishedit.ingridients.button.createNew") {
                        presenter.createDishTapped()
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.icon)
                        .foregroundStyle(.primaryText)
                }
                Spacer()
                    .frame(width: Styles.listActionPadding)
            }
            .padding(.top)
            .font(.bodyLarge)
            .foregroundStyle(.secondaryText)
            List(viewState.dishItems) { item in
                SubtitleCell(title: item.title,
                             subtitle: item.subtitle,
                             badgeColor: item.categoryColor)
                .defaultCellInsets()
                .swipeActions {
                    Button {
                        presenter.remove(dishId: item.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    Button {
                        presenter.editDish(dishId: item.id)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .tint(.orange)
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .onAppear {
            presenter.didAppear()
        }
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
        }
    }
}

struct MealEditPreviews: PreviewProvider {
    
    static let viewBuilder: ApplicationViewBuilder = {
        ApplicationViewBuilder(container: RootApp().container)
    }()
    
    static var container: Container {
        viewBuilder.container
    }
    
    static var previews: some View {
        NavigationStack {
            viewBuilder.build(view: .mealEdit(mealId: makeMockData()))
        }
    }
    
    private static func makeMockData() -> UUID {
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
        
        try? context.save()
        
        return meal.id
    }
}
