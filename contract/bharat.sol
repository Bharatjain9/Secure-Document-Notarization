// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Secure Document Notarization
 * @dev A smart contract to notarize documents by storing their hashes on the blockchain.
 */
contract DocumentNotary {

    struct Document {
        address owner;
        uint256 timestamp;
    }

    mapping(bytes32 => Document) private documents;

    event DocumentNotarized(address indexed owner, bytes32 indexed docHash, uint256 timestamp);

    /**
     * @dev Notarize a document by storing its hash.
     * @param docHash The hash of the document (e.g., SHA-256 or Keccak256).
     */
    function notarizeDocument(bytes32 docHash) external {
        require(documents[docHash].timestamp == 0, "Document already notarized.");
        documents[docHash] = Document(msg.sender, block.timestamp);
        emit DocumentNotarized(msg.sender, docHash, block.timestamp);
    }

    /**
     * @dev Verify a document hash.
     * @param docHash The hash of the document to verify.
     * @return owner The address of the person who notarized the document.
     * @return timestamp The timestamp when the document was notarized.
     */
    function verifyDocument(bytes32 docHash) external view returns (address owner, uint256 timestamp) {
        require(documents[docHash].timestamp != 0, "Document not found.");
        Document memory doc = documents[docHash];
        return (doc.owner, doc.timestamp);
    }

    /**
     * @dev Check if a document is already notarized.
     * @param docHash The hash of the document.
     * @return exists True if the document is already notarized.
     */
    function isNotarized(bytes32 docHash) external view returns (bool exists) {
        return documents[docHash].timestamp != 0;
    }
}
