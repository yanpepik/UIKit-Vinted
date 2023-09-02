import VintedUI
import VintedAPI

final class FeedUIBuilder {
    static func itemBox(
        item: Feed.FeedViewModelResult.FeedItemViewModel,
        onImageLoad: @escaping () -> (),
        onTap: @escaping () -> ()
    ) -> Cell {
        let image = Image(
            imageToLoad: .init(url: item.imageURL),
            size: .init(
                widthSize: .percentage,
                width: 100,
                heightSize: .auto,
                height: 100,
                ratio: .portrait
            ),
            style: .none,
            scaling: .cover,
            label: nil,
            labelStyle: .normal,
            backgroundColor: nil,
            overrideColor: nil,
            onTap: nil,
            onImageLoad: onImageLoad
        )
        
        let price = AttributedText(text: item.priceText, type: .title)
        let category = AttributedText(text: item.category, type: .subtitle, numberOfRows: 1)
        let brand = AttributedText(text: item.brand, type: .subtitle, numberOfRows: 1)
        let stack = Stack(items: [image, [price, category, brand].stacked()], spacing: .regular)
        let data = stack.inCell(size: .narrow)
        
        return Card(view: data, shadow: .default).inCell(size: .tight)
    }
    
    static func noResult() -> Cell {
        AttributedText(text: "No Result")
            .aligned(horizontal: .center, vertically: .center)
            .inCell()
    }
}
