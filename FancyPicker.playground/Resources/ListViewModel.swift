struct ListViewModel: Equatable {
    let items: [ListItemViewModel]
    let selectedIndex: Int
}

struct ListItemViewModel: Equatable {
    let title: String
    let description: String
}

func == (left: ListViewModel, right: ListViewModel) -> Bool {
    return left.items == right.items &&
        left.selectedIndex == right.selectedIndex
}

func == (left: ListItemViewModel, right: ListItemViewModel) -> Bool {
    return left.title == right.title &&
        left.description == right.description
}
