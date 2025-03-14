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

/// Section which items widths are calculated regarding to its' ratio
final class FLFlexItemsView: NiblessView {
    
    lazy var collectionView: UICollectionView = {
        UICollectionView(frame: .zero, collectionViewLayout: makeLayout(config: config))
    }()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<Int, UUID> = {
        makeDataSource(collectionView)
    }()
    
    var itemsByIds: [UUID: FLCellItem]
    
    private lazy var ratioGroups: [RatiosGroup] = group(ratioValues: config.flexRatios)
    
    private let interItemSpacing = 10.0
    private let interGroupSpacing = 10.0
    
    private let config: FLFlexItemsConfig
    private let cellsAdapter: FLSingleValueCellToSectionAdapter
    
    private let accessKey: String
    
    init(config: FLFlexItemsConfig,
         items: [FLCellItem],
         accessKey: String,
         cellsAdapter: FLSingleValueCellToSectionAdapter,
         style: FLSectionStyle) {
        self.config = config
        self.itemsByIds = Dictionary(uniqueKeysWithValues: items.map { ($0.uid, $0) })
        self.cellsAdapter = cellsAdapter
        self.accessKey = accessKey
        super.init()
        accessibilityIdentifier = "\(accessKey).FLFlexItems"
        
        backgroundColor = style.bodyBackgroundColor
        collectionView.accessibilityIdentifier = "\(accessKey).FLFlexItems.collectionView"
        apply(items: items)
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
    
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, UUID> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID> { [weak self] cell, indexPath, itemId in
            guard let self,
                  let item = self.itemsByIds[itemId] else {
                assertionFailure(); return
            }
            var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfiguration.backgroundColor = item.style.backgroundColor
            backgroundConfiguration.cornerRadius = 8
            cell.accessibilityIdentifier = "\(accessKey).FLFlexItems.collectionView.cell"
            switch item.data {
            case .titledSingleValue(let dataItem):
                cell.contentConfiguration = FLTitledValueContentConfiguration(delegate: cellsAdapter,
                                                                              uid: item.uid,
                                                                              data: dataItem,
                                                                              style: item.style)
                if dataItem.validationErrorText != nil {
                    backgroundConfiguration.strokeWidth = 2
                    backgroundConfiguration.strokeColor = item.style.validationColor
                }
            case .empty:
                cell.contentConfiguration = cell.defaultContentConfiguration()
            }
    
            cell.backgroundConfiguration = backgroundConfiguration
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
    
    private func apply(items: [FLCellItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(items.map{ $0.uid })
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
