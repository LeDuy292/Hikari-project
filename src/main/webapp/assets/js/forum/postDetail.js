let postIdToDelete = null;

function toggleLike(postId, button) {
    if (!forumUserId) {
        alert("Vui lòng đăng nhập để thích bài viết!");
        window.location.href = forumContextPath + "/loginPage";
        return;
    }

    const isLiked = button.classList.contains("liked");
    const url = forumContextPath + "/forum/toggleLike";
    button.disabled = true;

    fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            button.querySelector(".like-count").textContent = `${data.voteCount} Thích`;
            button.classList.toggle("liked");
        } else {
            alert(data.message || "Có lỗi xảy ra!");
        }
    })
    .catch(error => {
        console.error("Error:", error);
        alert("Có lỗi xảy ra!");
    })
    .finally(() => {
        button.disabled = false;
    });
}

function toggleCommentLike(commentId, button) {
    if (!forumUserId) {
        alert("Vui lòng đăng nhập để thích bình luận!");
        window.location.href = forumContextPath + "/loginPage";
        return;
    }

    const url = forumContextPath + "/forum/toggleCommentLike";
    fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "commentId=" + commentId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            button.innerHTML = `<i class="fas fa-thumbs-up"></i> ${data.voteCount}`;
        } else {
            alert(data.message || "Có lỗi xảy ra khi thích bình luận!");
        }
    })
    .catch(error => {
        console.error("Error:", error);
        alert("Có lỗi xảy ra khi thích bình luận!");
    });
}

function focusCommentForm() {
    const commentText = document.getElementById('commentText');
    commentText.focus();
    commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

function replyToComment(commentId) {
    const commentText = document.getElementById('commentText');
    commentText.value = `@comment-${commentId} `;
    commentText.focus();
    commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

function sharePost() {
    if (navigator.share) {
        navigator.share({ title: document.title, url: window.location.href });
    } else {
        navigator.clipboard.writeText(window.location.href).then(() => {
            alert('Đã sao chép liên kết vào clipboard!');
        });
    }
}

function moderatePost(postId, action) {
    let confirmMessage = "";
    switch (action) {
        case 'hide': confirmMessage = "Bạn có chắc chắn muốn ẩn bài viết này?"; break;
        case 'show': confirmMessage = "Bạn có chắc chắn muốn hiện bài viết này?"; break;
        case 'pin': confirmMessage = "Bạn có chắc chắn muốn ghim bài viết này?"; break;
        case 'unpin': confirmMessage = "Bạn có chắc chắn muốn bỏ ghim bài viết này?"; break;
        default: confirmMessage = "Bạn có chắc chắn muốn thực hiện hành động này?";
    }

    if (confirm(confirmMessage)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = forumContextPath + '/forum/moderate';

        const postIdInput = document.createElement('input');
        postIdInput.type = 'hidden';
        postIdInput.name = 'postId';
        postIdInput.value = postId;
        form.appendChild(postIdInput);

        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = action;
        form.appendChild(actionInput);

        document.body.appendChild(form);
        form.submit();
    }
}

function confirmDeletePost(postId) {
    postIdToDelete = postId;
    document.getElementById('deleteModal').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeDeleteModal() {
    document.getElementById('deleteModal').classList.remove('active');
    document.body.style.overflow = '';
    postIdToDelete = null;
}

function deletePost() {
    if (postIdToDelete) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = forumContextPath + '/forum/deletePost';

        const postIdInput = document.createElement('input');
        postIdInput.type = 'hidden';
        postIdInput.name = 'postId';
        postIdInput.value = postIdToDelete;
        form.appendChild(postIdInput);

        document.body.appendChild(form);
        form.submit();
    }
}

document.getElementById('deleteModal')?.addEventListener('click', function (e) {
    if (e.target === this) {
        closeDeleteModal();
    }
});

document.getElementById('commentText')?.addEventListener('input', function () {
    this.style.height = 'auto';
    this.style.height = this.scrollHeight + 'px';
});
