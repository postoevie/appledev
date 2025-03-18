//
//  FLFlexItemsView.swift
//  FlexLayout
//
//  Created by Igor Postoev on 16.2.24..
//

import SnapKit

private struct RatiosGroup {
    
    let ratios: [RatioValue]
}

public protocol FlexItemsCellType: FLCellItemType {
    
}

extension FLCellItem: FlexItemsCellType {
    
}

/// Section which items widths are calculated regarding to its' ratio
final class FLFlexItemsView<ItemId: Hashable>: NiblessView {
    
    lazy var collectionView: UICollectionView = {
        UICollectionView(frame: .zero, collectionViewLayout: makeLayout(config: config))
    }()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<Int, ItemId> = {
        makeDataSource(collectionView)
    }()
    
    var itemsByIds: [ItemId: any FLCellItemType] = [:]
    
    private lazy var ratioGroups: [RatiosGroup] = group(ratioValues: config.flexRatios)
    
    private let interItemSpacing = 10.0
    private let interGroupSpacing = 10.0
    
    private let config: FLFlexItemsConfig
    private let cellAssembly: FLCellAssemblyType
    
    private let accessKey: String
    
    init(itemIds: [ItemId],
         itemsbyIds: [ItemId: any FlexItemsCellType],
         cellAssembly: FLCellAssemblyType,
         config: FLFlexItemsConfig,
         style: FLSectionStyle,
         accessKey: String) {
        self.config = config
        self.accessKey = accessKey
        self.cellAssembly = cellAssembly
        super.init()
        
        self.itemsByIds = itemsbyIds // Ids remain same through collection lifetime
        
        backgroundColor = style.bodyBackgroundColor
        accessibilityIdentifier = "\(accessKey).flexItems"
        
        collectionView.accessibilityIdentifier = "\(accessKey).flexItems.collectionView"
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        apply(itemIds: itemIds)
    }
    
    /// Divides ratio values into groups. Sum of values in a single group is less or equal than 1
    /// e.g. [0.5,  0.5 , 0.33, 0.33, 0.33] -> ([0.5, 0.5], [0.33, 0.33, 0.33])
    private func group(ratioValues: [RatioValue]) -> [RatiosGroup] {
        /// Max value of summed ratio of group
        var remainRatio: Float = 1
        var groups = [RatiosGroup]()
        var currentRatios = [RatioValue]()
        
        /// Traverse through ratios list
        for ratio in ratioValues {
            
            /// If sum of ratios in group is about to exceed max value - create new group and refresh remain ratio
            if remainRatio + 0.1 < ratio.value {
                groups.append(RatiosGroup(ratios: currentRatios))
                currentRatios = []
                remainRatio = 1
            }
            
            /// Else, just add value to the group
            currentRatios.append(ratio)
            remainRatio -= ratio.value
        }
        if !currentRatios.isEmpty {
            groups.append(RatiosGroup(ratios: currentRatios))
        }
        return groups
    }
    
    func makeLayout(config: FLFlexItemsConfig) -> UICollectionViewLayout {
        var groups = [NSCollectionLayoutGroup]()
        var currentItems = [NSCollectionLayoutItem]()
        for ratioGroup in ratioGroups {
            for ratio in ratioGroup.ratios {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(ratio.value)),
                                                  heightDimension: .fractionalHeight(1.0))
                let layoutItem = NSCollectionLayoutItem(layoutSize: size)
                currentItems.append(layoutItem)
            }
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(config.rowHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                           subitems: currentItems)
            group.interItemSpacing = .flexible(interItemSpacing)
            groups.append(group)
            currentItems = []
        }
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .estimated(.greatestFiniteMagnitude))
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: groups)
        containerGroup.interItemSpacing = .fixed(interGroupSpacing)
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, ItemId> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ItemId> { [weak self] cell, indexPath, itemId in
            guard let self,
                  let item = self.itemsByIds[itemId] else {
                assertionFailure(); return
            }
            cell.accessibilityIdentifier = "\(accessKey).flexItems.collectionView.cell"
            cell.backgroundConfiguration = cellAssembly.buildBackgroundConfig(item: item)
            cell.contentConfiguration = cellAssembly.buildContentConfig(item: item)
        }
        return UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        guard !ratioGroups.isEmpty else {
            return size
        }
        var height = CGFloat(ratioGroups.count) * config.rowHeight // sum for cell rows
        height += CGFloat(ratioGroups.count - 1) * interGroupSpacing // sum for spacings between them
        return CGSize(width: size.width, height: height)
    }
    
    private func apply(itemIds: [ItemId]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemId>()
        snapshot.appendSections([0])
        snapshot.appendItems(itemIds)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
