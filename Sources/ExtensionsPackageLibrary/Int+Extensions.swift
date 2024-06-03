extension BinaryInteger {
	public func roundedTowardZero(toMultipleOf m: Self) -> Self {
		return self - (self % m)
	}

	public func roundedAwayFromZero(toMultipleOf m: Self) -> Self {
		let x = self.roundedTowardZero(toMultipleOf: m)
		if x == self { return x }
		return (m.signum() == self.signum()) ? (x + m) : (x - m)
	}

	public func roundedDown(toMultipleOf m: Self) -> Self {
		return (self < 0) ? self.roundedAwayFromZero(toMultipleOf: m)
		: self.roundedTowardZero(toMultipleOf: m)
	}

	public func roundedUp(toMultipleOf m: Self) -> Self {
		return (self > 0) ? self.roundedAwayFromZero(toMultipleOf: m)
		: self.roundedTowardZero(toMultipleOf: m)
	}
}
