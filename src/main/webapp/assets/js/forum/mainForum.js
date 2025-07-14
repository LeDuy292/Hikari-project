function openPostModal() {
    document.getElementById("createPostModal").classList.add("active");
}
function closePostModal() {
    document.getElementById("createPostModal").classList.remove("active");
}
function previewImage(event) {
    const file = event.target.files[0];
    const preview = document.getElementById("imagePreview");
    if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
            preview.src = e.target.result;
            preview.style.display = "block";
        };
        reader.readAsDataURL(file);
    }
}
function toggleLike(postId, button) {
    if (!forumUserId) {
        alert("Vui lòng đăng nhập để thích bài viết!");
        window.location.href = forumContextPath + "/view/login.jsp";
        return;
    }
    const isLiked = button.classList.contains("liked");
    const url = forumContextPath + "/forum/toggleLike";
    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const likeCountSpan = button.querySelector(".like-count");
            likeCountSpan.textContent = data.voteCount;
            button.classList.toggle("liked", !isLiked);
        } else {
            alert(data.message || "Có lỗi xảy ra khi thích bài viết!");
        }
    })
    .catch(error => {
        console.error("Error:", error);
        alert("Có lỗi xảy ra khi thích bài viết!");
    });
}
function handleSearch() {
    const search = document.getElementById("searchInput").value.trim();
    const sort = document.getElementById("sortSelect").value;
    const filter = document.getElementById("filterSelect").value;
    window.location.href = forumContextPath + "/forum?sort=" + sort + "&filter=" + filter + "&search=" + encodeURIComponent(search);
}
function toggleModerationControls(postId) {
    const controls = document.getElementById("mod-controls-" + postId);
    controls.classList.toggle("show");
}
function moderatePost(postId, action) {
    if (confirm("Bạn có chắc chắn muốn thực hiện hành động này?")) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = forumContextPath + '/forum/moderate';

        form.innerHTML = `
            <input type="hidden" name="postId" value="${postId}">
            <input type="hidden" name="action" value="${action}">
        `;
        document.body.appendChild(form);
        form.submit();
    }
}
function confirmDeletePost(postId) {
    if (confirm("Bạn có chắc chắn muốn xóa bài viết này? Hành động này không thể hoàn tác.")) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = forumContextPath + '/forum/deletePost';

        form.innerHTML = `<input type="hidden" name="postId" value="${postId}">`;
        document.body.appendChild(form);
        form.submit();
    }
}
document.querySelectorAll(".topic-list a[data-filter]").forEach(function (link) {
    link.addEventListener("click", function (e) {
        e.preventDefault();
        const topic = link.getAttribute("data-filter");
        document.querySelectorAll(".topic-list a").forEach(function (l) {
            l.classList.remove("active");
        });
        link.classList.add("active");
        const posts = document.querySelectorAll(".post-card");
        posts.forEach(function (post) {
            const tags = post.getAttribute("data-tags");
            post.style.display = (topic === "all" || tags === topic) ? "flex" : "none";
        });
    });
});
document.getElementById("createPostModal").addEventListener("click", function (e) {
    if (e.target === this) {
        closePostModal();
    }
});
function handleSortChange() {
    handleSearch();
}
function handleFilterChange() {
    handleSearch();
}
document.getElementById("searchInput").addEventListener("keypress", function (e) {
    if (e.key === "Enter") {
        handleSearch();
    }
});
document.querySelector('.topic-list a[data-filter="all"]').click();
