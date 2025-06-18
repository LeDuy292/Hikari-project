document.addEventListener('DOMContentLoaded', () => {
    // Element references
    const courseList = document.getElementById('courseList');
    const lessonDetail = document.getElementById('lessonDetail');
    const headerTitle = document.getElementById('headerTitle');
    const backToCourses = document.getElementById('backToCourses');
    const editLessonBtn = document.getElementById('editLessonBtn');
    const editLessonForm = document.getElementById('editLessonForm');
    const cancelEditLessonBtn = document.getElementById('cancelEditLessonBtn');
    const lessonSearch = document.getElementById('lessonSearch');
    const lessonList = document.getElementById('lessonList');
    const lessonCount = document.getElementById('lessonCount');
    const showLessonBtn = document.getElementById('showLessonBtn');
    const showExerciseBtn = document.getElementById('showExerciseBtn');
    const lessonContent = document.getElementById('lessonContent');
    const exerciseSection = document.getElementById('exerciseSection');
    const editExerciseBtn = document.getElementById('editExerciseBtn');
    const editExerciseForm = document.getElementById('editExerciseForm');
    const cancelEditExerciseBtn = document.getElementById('cancelEditExerciseBtn');
    const addLessonBtn = document.getElementById('addLessonBtn');
    const addLessonForm = document.getElementById('addLessonForm');
    const saveAddLessonBtn = document.getElementById('saveAddLessonBtn');
    const cancelAddLessonBtn = document.getElementById('cancelAddLessonBtn');

    let currentCourseID = null;

    // Check critical elements
    if (!courseList || !lessonDetail) {
        console.error('Critical elements missing:', { courseList, lessonDetail });
        return;
    }

    // Load lessons for a course
    function loadLessons(courseID) {
        fetch(`/LessonManagementServlet?courseID=${courseID}`)
            .then(response => response.json())
            .then(data => {
                lessonList.innerHTML = '';
                lessonCount.textContent = data.length;
                const topics = {};
                data.forEach(lesson => {
                    if (!topics[lesson.topic]) {
                        topics[lesson.topic] = [];
                    }
                    topics[lesson.topic].push(lesson);
                });
                Object.keys(topics).forEach((topic, index) => {
                    const section = document.createElement('div');
                    section.className = 'section';
                    section.innerHTML = `
                        <div class="section-header" data-section="section-${index}">
                            <div class="section-title">${topic}</div>
                            <div class="section-toggle"><i class="fas fa-chevron-right"></i></div>
                        </div>
                        <div class="section-content" id="section-${index}">
                            ${topics[topic].map(lesson => `
                                <div class="lesson-item" data-lesson-id="${lesson.id}">
                                    <span>${lesson.title}</span>
                                    <div class="lesson-status ${lesson.isCompleted ? 'completed' : ''}"></div>
                                </div>
                            `).join('')}
                        </div>
                    `;
                    lessonList.appendChild(section);
                });
                // Re-attach section toggle events
                document.querySelectorAll('.section-header').forEach(header => {
                    header.addEventListener('click', () => {
                        const sectionId = header.getAttribute('data-section');
                        const content = document.getElementById(sectionId);
                        const toggleIcon = header.querySelector('.section-toggle i');
                        if (content) {
                            content.classList.toggle('show');
                            if (toggleIcon) {
                                toggleIcon.classList.toggle('fa-chevron-right', !content.classList.contains('show'));
                                toggleIcon.classList.toggle('fa-chevron-down', content.classList.contains('show'));
                            }
                        }
                    });
                });
            })
            .catch(error => console.error('Error loading lessons:', error));
    }

    // Event delegation for course action buttons
    document.addEventListener('click', (e) => {
        if (e.target.classList.contains('course-action-btn')) {
            const courseCard = e.target.closest('.course-card');
            if (!courseCard) return;
            currentCourseID = courseCard.getAttribute('data-course-id');
            const courseTitle = courseCard.querySelector('.course-title')?.textContent || 'Unknown Course';

            // Toggle visibility
            courseList.style.display = 'none';
            lessonDetail.style.display = 'block';
            if (headerTitle) headerTitle.textContent = `Bài Học - ${courseTitle}`;
            if (showLessonBtn) showLessonBtn.classList.add('active');
            if (showExerciseBtn) showExerciseBtn.classList.remove('active');
            if (lessonContent) lessonContent.style.display = 'block';
            if (exerciseSection) exerciseSection.style.display = 'none';
            if (editLessonForm) editLessonForm.style.display = 'none';
            if (editExerciseForm) editExerciseForm.style.display = 'none';
            if (addLessonForm) addLessonForm.style.display = 'none';
            if (editLessonBtn) editLessonBtn.style.display = 'block';
            if (editExerciseBtn) editExerciseBtn.style.display = 'block';

            // Load lessons
            loadLessons(currentCourseID);
        }
    });

    // Handle back to courses
    if (backToCourses) {
        backToCourses.addEventListener('click', (e) => {
            e.preventDefault();
            courseList.style.display = 'block';
            lessonDetail.style.display = 'none';
            if (headerTitle) headerTitle.textContent = 'Quản Lý Khóa Học';
        });
    }

    // Handle show lesson/exercise buttons
    if (showLessonBtn && showExerciseBtn) {
        showLessonBtn.addEventListener('click', () => {
            showLessonBtn.classList.add('active');
            showExerciseBtn.classList.remove('active');
            if (lessonContent) lessonContent.style.display = 'block';
            if (exerciseSection) exerciseSection.style.display = 'none';
            if (editExerciseForm) editExerciseForm.style.display = 'none';
            if (editLessonForm) editLessonForm.style.display = 'none';
            if (addLessonForm) addLessonForm.style.display = 'none';
            if (editLessonBtn) editLessonBtn.style.display = 'block';
        });

        showExerciseBtn.addEventListener('click', () => {
            showExerciseBtn.classList.add('active');
            showLessonBtn.classList.remove('active');
            if (lessonContent) lessonContent.style.display = 'none';
            if (exerciseSection) exerciseSection.style.display = 'block';
            if (editLessonForm) editLessonForm.style.display = 'none';
            if (editExerciseForm) editExerciseForm.style.display = 'none';
            if (addLessonForm) addLessonForm.style.display = 'none';
            if (editExerciseBtn) editExerciseBtn.style.display = 'block';
        });
    }

    // Handle edit lesson/exercise buttons
    if (editLessonBtn && editLessonForm && cancelEditLessonBtn) {
        editLessonBtn.addEventListener('click', () => {
            editLessonForm.style.display = 'block';
            editLessonBtn.style.display = 'none';
            if (addLessonForm) addLessonForm.style.display = 'none';
        });

        cancelEditLessonBtn.addEventListener('click', () => {
            editLessonForm.style.display = 'none';
            editLessonBtn.style.display = 'block';
        });
    }

    if (editExerciseBtn && editExerciseForm && cancelEditExerciseBtn) {
        editExerciseBtn.addEventListener('click', () => {
            editExerciseForm.style.display = 'block';
            editExerciseBtn.style.display = 'none';
            if (addLessonForm) addLessonForm.style.display = 'none';
        });

        cancelEditExerciseBtn.addEventListener('click', () => {
            editExerciseForm.style.display = 'none';
            editExerciseBtn.style.display = 'block';
        });
    }

    // Handle add lesson button
    if (addLessonBtn && addLessonForm && cancelAddLessonBtn && saveAddLessonBtn) {
        addLessonBtn.addEventListener('click', () => {
            addLessonForm.style.display = 'block';
            if (editLessonForm) editLessonForm.style.display = 'none';
            if (editExerciseForm) editExerciseForm.style.display = 'none';
            if (lessonContent) lessonContent.style.display = 'none';
            if (exerciseSection) exerciseSection.style.display = 'none';
            if (editLessonBtn) editLessonBtn.style.display = 'none';
            if (editExerciseBtn) editExerciseBtn.style.display = 'none';
        });

        cancelAddLessonBtn.addEventListener('click', () => {
            addLessonForm.style.display = 'none';
            if (lessonContent) lessonContent.style.display = 'block';
            if (editLessonBtn) editLessonBtn.style.display = 'block';
            if (editExerciseBtn) editExerciseBtn.style.display = 'block';
        });

        saveAddLessonBtn.addEventListener('click', () => {
            const lessonData = {
                courseID: currentCourseID,
                title: document.getElementById('addLessonName').value,
                description: document.getElementById('addLessonDescription').value,
                duration: parseInt(document.getElementById('addLessonDuration').value),
                mediaUrl: document.getElementById('addLessonResource').value,
                skill: document.getElementById('addLessonSkill').value,
                topic: document.getElementById('addLessonTopic').value,
                isActive: true
            };

            if (!lessonData.title || !lessonData.skill || !lessonData.topic) {
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return;
            }

            fetch('/api/lessons', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(lessonData)
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        addLessonForm.style.display = 'none';
                        if (lessonContent) lessonContent.style.display = 'block';
                        if (editLessonBtn) editLessonBtn.style.display = 'block';
                        if (editExerciseBtn) editExerciseBtn.style.display = 'block';
                        loadLessons(currentCourseID);
                        alert('Thêm bài học thành công!');
                    } else {
                        alert('Lỗi khi thêm bài học: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error adding lesson:', error);
                    alert('Đã xảy ra lỗi khi thêm bài học!');
                });
        });
    }

    // Handle lesson search
    if (lessonSearch && lessonList) {
        lessonSearch.addEventListener('input', () => {
            const searchValue = lessonSearch.value.toLowerCase();
            lessonList.querySelectorAll('.lesson-item').forEach(item => {
                const lessonTitle = item.querySelector('span').textContent.toLowerCase();
                item.style.display = lessonTitle.includes(searchValue) ? 'flex' : 'none';
            });
        });
    }

    // Handle lesson item click
    lessonList.addEventListener('click', (e) => {
        const lessonItem = e.target.closest('.lesson-item');
        if (lessonItem) {
            const lessonId = lessonItem.getAttribute('data-lesson-id');
            fetch(`/api/lessons/${lessonId}`)
                .then(response => response.json())
                .then(data => {
                    if (lessonContent) {
                        lessonContent.innerHTML = `
                            <h3>${data.title}</h3>
                            <div class="lesson-meta">
                                <span><i class="fas fa-clock"></i> ${data.duration} phút</span>
                                <span><i class="fas fa-link"></i> <a href="${data.mediaUrl}" target="_blank">Xem tài liệu</a></span>
                            </div>
                            <p>${data.description}</p>
                            <div class="lesson-actions">
                                <button class="btn btn-primary" id="editLessonBtn">Chỉnh sửa bài học</button>
                            </div>
                        `;
                        if (showLessonBtn) showLessonBtn.click();
                    }
                })
                .catch(error => console.error('Error loading lesson details:', error));
        }
    });
});