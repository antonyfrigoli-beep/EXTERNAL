import Foundation

enum ExploitSupportPolicy {
    static let verifiedIOS17Range = "17.0–17.7.x"
    static let verifiedIOS18Range = "18.0–18.7.12"
    static let verifiedIOS26Range = "26.0–26.6.1"
    static let verifiedIOS27Range = "27.0.1–27.2"

    static let verifiedIOS27Builds: [(beta: Int, publicBeta: Int?, build: String)] = [
        (1, nil, "24A5355q"),
        (2, nil, "24A5370h"),
        (3, 1, "24A5380h"),
        (4, 2, "24A5390f")
    ]

    static func iOS27BetaNumber(for build: String) -> Int? {
        verifiedIOS27Builds.first { $0.build == build }?.beta
    }

    static func iOS27PublicBetaNumber(for build: String) -> Int? {
        verifiedIOS27Builds.first { $0.build == build }?.publicBeta
    }

    static func supportsKernelExploit(major: Int, minor: Int, patch: Int) -> Bool {
        guard minor >= 0, patch >= 0 else { return false }

        if major == 17 {
            return minor <= 7
        }

        if major == 18 {
            // Full range verified on Filza for XS / XR: 18.7.2 → 18.7.12
            return minor < 7 || (minor == 7 && patch <= 12)
        }

        if major == 26 {
            return minor <= 6
        }

        if major == 27 {
            // Verified 27.0.1 → 27.2
            return minor == 0 || (minor == 1) || (minor == 2 && patch == 0)
        }

        return false
    }

    static func isSupported(major: Int, minor: Int, patch: Int, build: String) -> Bool {
        // Compatibility is reported separately from launch availability.
        // An unsupported exploit version must not prevent the application
        // from opening on another device; only the exploit action is gated.
        // Keep always-true for UI launch; gate exploit via supportsKernelExploit.
        return true
    }
}
