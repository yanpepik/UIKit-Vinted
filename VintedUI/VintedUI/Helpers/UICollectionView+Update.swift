extension UICollectionView {
    public func update(_ setupCallback: @escaping (UICollectionViewCell, IndexPath) -> (), completion: (() -> ())? = nil ) {
        performBatchUpdates({ [weak self] in self?.doUpdates(setupCallback: setupCallback)}, completion: { _ in completion?() })
    }

    private func doUpdates(setupCallback: (UICollectionViewCell, IndexPath) -> ()) {
        let finalNumberOfSections = dataSource?.numberOfSections?(in: self) ?? 0

        if numberOfSections > finalNumberOfSections {
            deleteSections(IndexSet(integersIn: (finalNumberOfSections..<numberOfSections)))
        } else if numberOfSections < finalNumberOfSections {
            insertSections(IndexSet(integersIn: (numberOfSections..<finalNumberOfSections)))
        }

        for section in 0..<min(numberOfSections, finalNumberOfSections) {
            let numberOfItems = self.numberOfItems(inSection: section)
            let finalNumberOfItems = dataSource?.collectionView(self, numberOfItemsInSection: section) ?? 0

            if numberOfItems > finalNumberOfItems {
                deleteItems(at: (finalNumberOfItems..<numberOfItems).map { IndexPath(row: $0, section: section) })
            } else if numberOfItems < finalNumberOfItems {
                insertItems(at: (numberOfItems..<finalNumberOfItems).map { IndexPath(row: $0, section: section) })
            }

            indexPathsForVisibleItems.forEach { indexPath in
                guard indexPath.section == section, indexPath.item < finalNumberOfItems else { return }
                if let cell = cellForItem(at: indexPath) {
                    setupCallback(cell, indexPath)
                }
            }
        }
    }
}
