import Foundation

public class GildedRose {
    private static let agedBrieString = "aged brie"
    private static let backstagePassString = "backstage passes"
    private static let sulfurasString = "sulfuras"
    private static let conjuredString = "conjured"
    
    private static let minimumQuality = 0
    private static let maximumQuality = 50
    
    var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
    
    private func checkIfItemNameContainsString(_ item: Item, string: String) -> Bool {
        return item.name.lowercased().range(of: string) != nil
    }
    
    private func calculateDegradeRate(_ item: Item, isExpired: Bool) -> Int {
        let degradeRate = self.checkIfItemNameContainsString(item, string: GildedRose.conjuredString) ? -2 : -1
        return isExpired ? degradeRate * 2 : degradeRate
    }
    
    private func adjustQuality(_ item: Item, adjustment: Int) {
        let adjustedQuality = item.quality + adjustment
        if adjustedQuality <= GildedRose.maximumQuality && adjustedQuality >= GildedRose.minimumQuality {
            item.quality += adjustment
        }
    }
    
    private func adjustBackstagePassQuality(_ item: Item, isExpired: Bool) {
        self.adjustQuality(item, adjustment: 1)
        if item.sellIn < 11 {
            self.adjustQuality(item, adjustment: 1)
        }
        if item.sellIn < 6 {
            self.adjustQuality(item, adjustment: 1)
        }
        if isExpired {
            self.adjustQuality(item, adjustment: -item.quality)
        }
    }

    private func updateItemQuality(_ item: Item) {
        let isExpired = item.sellIn < 1
        let itemQualityDegradationAmount = self.calculateDegradeRate(item, isExpired: isExpired)
        if !self.checkIfItemNameContainsString(item, string: GildedRose.agedBrieString) && !self.checkIfItemNameContainsString(item, string: GildedRose.backstagePassString) && !self.checkIfItemNameContainsString(item, string: GildedRose.sulfurasString) {
            self.adjustQuality(item, adjustment: itemQualityDegradationAmount)
        }
        if self.checkIfItemNameContainsString(item, string: GildedRose.agedBrieString) {
            self.adjustQuality(item, adjustment: isExpired ? 2 : 1)
        }
        if self.checkIfItemNameContainsString(item, string: GildedRose.backstagePassString) {
            self.adjustBackstagePassQuality(item, isExpired: isExpired)
        }
        if !self.checkIfItemNameContainsString(item, string: GildedRose.sulfurasString) {
            item.sellIn = item.sellIn - 1
        }
    }
    
    public func updateQuality() {
        items.forEach({ item in
            updateItemQuality(item)
        })
    }
}
