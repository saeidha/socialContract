// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Contract.sol";

contract SocialMediaTest is Test {
    SocialMedia socialMedia;

    function setUp() public {
        socialMedia = new SocialMedia();
    }

    function testCreatePost() public {
        // Arrange
        string memory content = "Hello, this is my first post!";

        // Act
        vm.prank(address(1));
        socialMedia.createPost(content);

        // Assert
    SocialMedia.Post memory post = socialMedia.getPost(1);
    uint id = post.id;
    address author = post.author;
    string memory retrievedContent = post.content;
    uint timestamp = post.timestamp;

        assertEq(id, 1);
        assertEq(author, address(1));
        assertEq(retrievedContent, content);
        assertTrue(timestamp > 0);

        // Check the event
        vm.expectEmit(true, true, false, true);
        emit SocialMedia.PostCreated(1, address(1), content, block.timestamp);
    }

    function testGetPost() public {
    // Arrange
    string memory content = "Hello, this is my first post!";

    // Capture the block timestamp before creating the post
    uint beforeTimestamp = block.timestamp;

    // Act
    vm.prank(address(1));
    socialMedia.createPost(content);

    // Assert
    SocialMedia.Post memory post = socialMedia.getPost(1);
    uint id = post.id;
    address author = post.author;
    string memory retrievedContent = post.content;
    uint timestamp = post.timestamp;

    assertEq(id, 1);
    assertEq(author, address(1));
    assertEq(retrievedContent, content);

    // Assert that the timestamp is correct (it should be equal to or greater than the captured timestamp)
    assertGe(timestamp, beforeTimestamp);

    // Optional: Assert that the timestamp is not too far in the future (e.g., within 1 minute)
    assertLe(timestamp, block.timestamp + 60);

    // Check the event
    vm.expectEmit(true, true, false, true);
    emit SocialMedia.PostCreated(1, address(1), content, block.timestamp);
    }

    function testGetAllPosts() public {
        // Arrange
        string memory content1 = "First post";
        string memory content2 = "Second post";

        vm.prank(address(1));
        socialMedia.createPost(content1);

        vm.prank(address(2));
        socialMedia.createPost(content2);

        // Act
        SocialMedia.Post[] memory allPosts = socialMedia.getAllPosts();

        // Assert
        assertEq(allPosts.length, 2);
        assertEq(allPosts[0].content, content1);
        assertEq(allPosts[1].content, content2);
    }
}
