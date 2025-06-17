
function toggleDropdown(e) {
    e.stopPropagation();
    document.getElementById("accountDropdown").classList.toggle("open");
}
document.body.addEventListener("click", function () {
    document.getElementById("accountDropdown").classList.remove("open");
});
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
function openCommentSection(postId) {
    const section = document.getElementById("comment-section-" + postId);
    section.style.display = section.style.display === "none" ? "block" : "none";
}
function toggleLike(postId, button) {
    const userId = "<%= request.getSession().getAttribute("userId") != null ? request.getSession().getAttribute("userId") : "" %>";
            if (!userId) {
        alert("Vui lòng đăng nhập để thích bài viết!");
        window.location.href = "<%= request.getContextPath() %>/login";
        return;
    }
    const isLiked = button.classList.contains("liked");
    const url = "<%= request.getContextPath() %>/forum/toggleLike";
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
                    if (isLiked) {
                        button.classList.remove("liked");
                    } else {
                        button.classList.add("liked");
                    }
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
    window.location.href = "<%= request.getContextPath() %>/forum?sort=" + sort + "&filter=" + filter + "&search=" + encodeURIComponent(search);
}
document.querySelectorAll(".topic-list a").forEach(function (link) {
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
            if (topic === "all" || tags === topic) {
                post.style.display = "flex";
            } else {
                post.style.display = "none";
            }
        });
    });
});
document.getElementById("createPostModal").addEventListener("click", function (e) {
    if (e.target === this) {
        closePostModal();
    }
});
function toggleMobileMenu() {
    document.querySelector(".sidebar-left").classList.toggle("active");
}
function handleSortChange() {
    const sort = document.getElementById("sortSelect").value;
    const filter = document.getElementById("filterSelect").value;
    const search = document.getElementById("searchInput").value.trim();
    window.location.href = "<%= request.getContextPath() %>/forum?sort=" + sort + "&filter=" + filter + "&search=" + encodeURIComponent(search);
}
function handleFilterChange() {
    const sort = document.getElementById("sortSelect").value;
    const filter = document.getElementById("filterSelect").value;
    const search = document.getElementById("searchInput").value.trim();
    window.location.href = "<%= request.getContextPath() %>/forum?sort=" + sort + "&filter=" + filter + "&search=" + encodeURIComponent(search);
}
document.getElementById("searchInput").addEventListener("keypress", function (e) {
    if (e.key === "Enter") {
        handleSearch();
    }
});
document.querySelector('.topic-list a[data-filter="all"]').click();