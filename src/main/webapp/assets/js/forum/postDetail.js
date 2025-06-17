
        let postIdToDelete = null;

        // User menu toggle
        function toggleUserMenu() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }

        // Actions menu toggle
        function toggleActionsMenu() {
            const menu = document.getElementById('actionsMenu');
            menu.classList.toggle('show');
        }

        // Close dropdowns when clicking outside
        document.addEventListener('click', function(event) {
            const userMenu = document.querySelector('.user-menu');
            const userDropdown = document.getElementById('userDropdown');
            const actionsMenu = document.getElementById('actionsMenu');
            
            if (!userMenu.contains(event.target)) {
                userDropdown.classList.remove('show');
            }
            
            if (!event.target.closest('.post-actions')) {
                actionsMenu.classList.remove('show');
            }
        });

        // Like toggle
        function toggleLike(postId, button) {
            const userId = "<%= request.getSession().getAttribute("userId") != null ? request.getSession().getAttribute("userId") : "" %>";
            if (!userId) {
                alert("Vui lòng đăng nhập để thích bài viết!");
                window.location.href = "<%= request.getContextPath() %>/login";
                return;
            }
            
            const isLiked = button.classList.contains("liked");
            const url = "<%= request.getContextPath() %>/forum/toggleLike";
            
            // Add loading state
            button.disabled = true;
            
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
                    // Update like count in stats
                    const statsLikes = document.querySelector('.stat-item:first-child span');
                    statsLikes.textContent = `${data.voteCount} lượt thích`;
                    
                    // Update button
                    const likeCountSpan = button.querySelector(".like-count");
                    likeCountSpan.textContent = data.voteCount;
                    
                    if (isLiked) {
                        button.classList.remove("liked");
                    } else {
                        button.classList.add("liked");
                    }
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

        // Focus comment form
        function focusCommentForm() {
            const commentText = document.getElementById('commentText');
            commentText.focus();
            commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Reply to comment
        function replyToComment(commentId) {
            const commentText = document.getElementById('commentText');
            commentText.value = `@comment-${commentId} `;
            commentText.focus();
            commentText.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // Share post
        function sharePost() {
            if (navigator.share) {
                navigator.share({
                    title: document.title,
                    url: window.location.href
                });
            } else {
                // Fallback: copy to clipboard
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('Đã sao chép liên kết vào clipboard!');
                });
            }
        }

        // Delete confirmation
        function confirmDelete(postId) {
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
                form.action = '<%= request.getContextPath() %>/forum/deletePost';
                
                const postIdInput = document.createElement('input');
                postIdInput.type = 'hidden';
                postIdInput.name = 'postId';
                postIdInput.value = postIdToDelete;
                
                form.appendChild(postIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Close modal on outside click
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeDeleteModal();
            }
        });

        // Auto-resize textarea
        document.getElementById('commentText').addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });