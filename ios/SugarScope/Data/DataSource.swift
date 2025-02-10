import Foundation
import os
import SwiftUI

protocol DataSource {
    func getLast12h() async throws -> [GlucoseMeasurement]
}
