extension ViewData {

    public func inCard(shadow: Shadow = .default) -> Card {
        return Card(
            view: self,
            shadow: shadow
        )
    }
}
