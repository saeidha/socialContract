// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract SocialMedia {
    struct Post {
        uint id;
        address author;
        string content;
        uint timestamp;
    }

    Post[] public posts;
    uint public postCount = 0;

    event PostCreated(
        uint id,
        address indexed author,
        string content,
        uint timestamp
    );

    function createPost(string memory _content) public {
        postCount++;
        posts.push(Post(postCount, msg.sender, _content, block.timestamp));
        emit PostCreated(postCount, msg.sender, _content, block.timestamp);
    }

    function getPost(uint _id) public view returns (Post memory) {
        require(_id > 0 && _id <= postCount, "Post does not exist");
        return posts[_id - 1];
    }

    function getAllPosts() public view returns (Post[] memory) {
        return posts;
    }
}
