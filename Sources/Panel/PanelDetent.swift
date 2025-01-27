/**
*  Panel
*  Copyright (c) Florian Mielke 2021
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public enum PanelDetent: CaseIterable {
	case large
	case medium
	case small

	func height(for environment: PanelEnvironment) -> CGFloat {
		if environment.isCompact {
			return compactHeight(for: environment)
		} else {
			return regularHeight(for: environment)
		}
	}

	private func regularHeight(for environment: PanelEnvironment) -> CGFloat {
		switch self {
		case .large:
			return environment.geometry.size.height - (environment.insets.top + 24.0 + environment.insets.bottom)
		case .medium:
			return environment.geometry.size.height * 0.4
		case .small:
			return CGFloat(90)
		}
	}

	private func compactHeight(for environment: PanelEnvironment) -> CGFloat {
		switch self {
		case .large:
			return (environment.geometry.size.height + environment.geometry.safeAreaInsets.bottom) - 10
		case .medium:
			return environment.geometry.size.height * 0.4
		case .small:
			return environment.geometry.safeAreaInsets.bottom + 50
		}
	}
}
