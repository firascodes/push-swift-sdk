import Push
import XCTest

class GetUserTests: XCTestCase {

  func testUserGetReturnsNilWhenUserDoesNotExist() async throws {
    let nonEixstingUser = "eip155:0x265422EcbC75BEb6f3BedDf0C3480Eb6072d021d"
    let env = ENV.STAGING

    let res = try await PushUser.get(account: nonEixstingUser, env: env)

    XCTAssertNil(res, "Expected the User to be nil.")
  }

  func testUserGetReturnsUserWhenUserExist() async throws {
    let account = "eip155:0x03fAD591aEb926bFD95FE1E38D51811167a5ad5c"
    let env = ENV.STAGING

    let user = try await PushUser.get(account: account, env: env)!

    XCTAssertNotNil(user, "Expected the User not to be nil.")
    XCTAssertEqual(account, user.did, "Expected the User DID to match.")
    XCTAssertEqual(account, user.wallets, "Expected the User wallet to match.")
    XCTAssertEqual(account, user.wallets, "Expected the User wallet to match.")
    XCTAssertTrue(
      user.getPGPPublickey().contains("-----BEGIN PGP PUBLIC KEY BLOCK-----"),
      "Expected user to have valid public key")
    XCTAssertTrue(user.profilePicture.contains("data:image/png;base64,"))
  }

  func testUserGetReturnsUserWithEthAddress() async throws {
    let account = "0x03fAD591aEb926bFD95FE1E38D51811167a5ad5c"
    let env = ENV.STAGING
    let user = try await PushUser.get(account: account, env: env)!

    XCTAssertNotNil(user, "Expected the User not to be nil.")
    XCTAssertTrue(
      user.getPGPPublickey().contains("-----BEGIN PGP PUBLIC KEY BLOCK-----"),
      "Expected user to have valid public key")
    XCTAssertTrue(user.profilePicture.contains("data:image/png;base64,"))
  }

  func testUserProfileCreated() async throws {
    let existingAccount = "0x03fAD591aEb926bFD95FE1E38D51811167a5ad5c"
    let notExistingAccount = generateRandomEthereumAddress()

    let res1 = try await PushUser.userProfileCreated(account: existingAccount, env: .STAGING)
    let res2 = try await PushUser.userProfileCreated(account: notExistingAccount, env: .STAGING)

    XCTAssertTrue(res1)
    XCTAssertFalse(res2)
  }

}
