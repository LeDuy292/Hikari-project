class ClassManager {
    constructor() {
        this.currentView = "classes";
        this.selectedClassId = null;
        this.contextPath = "";

        // Pagination settings
        this.classesPerPage = 3;
        this.studentsPerPage = 5;

        // Current data
        this.allClasses = [];
        this.allStudents = [];
        this.filteredClasses = [];
        this.filteredStudents = [];

        // Current pagination
        this.currentClassPage = 1;
        this.currentStudentPage = 1;

        // Search terms
        this.classSearchTerm = "";
        this.studentSearchTerm = "";

        this.init();
    }

    init() {
        this.bindEvents();
    }

    bindEvents() {
        // Search functionality
        const searchInput = document.getElementById("searchInput");
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener("input", (e) => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.classSearchTerm = e.target.value.toLowerCase();
                    this.filterAndPaginateClasses();
                }, 300);
            });
        }

        // Student search functionality
        const studentSearchInput = document.getElementById("studentSearchInput");
        if (studentSearchInput) {
            let studentSearchTimeout;
            studentSearchInput.addEventListener("input", (e) => {
                clearTimeout(studentSearchTimeout);
                studentSearchTimeout = setTimeout(() => {
                    this.studentSearchTerm = e.target.value.toLowerCase();
                    this.filterAndPaginateStudents();
                }, 300);
            });
        }

        // Handle browser back button
        window.addEventListener("popstate", (e) => {
            if (e.state) {
                this.handleNavigation(e.state);
            }
        });
    }

    showLoading() {
        document.getElementById("loadingSpinner").style.display = "block";
    }

    hideLoading() {
        document.getElementById("loadingSpinner").style.display = "none";
    }

    // Filter and paginate classes (client-side)
    filterAndPaginateClasses() {
        // Filter classes based on search term
        if (this.classSearchTerm.trim() === "") {
            this.filteredClasses = [...this.allClasses];
        } else {
            this.filteredClasses = this.allClasses.filter(
                (classItem) =>
                    classItem.name.toLowerCase().includes(this.classSearchTerm) ||
                    classItem.courseTitle.toLowerCase().includes(this.classSearchTerm) ||
                    classItem.teacherName.toLowerCase().includes(this.classSearchTerm),
            );
        }

        // Reset to first page when filtering
        this.currentClassPage = 1;

        // Update total count
        document.getElementById("totalClassesCount").innerHTML = `
            <i class="fas fa-users me-1"></i>
            ${this.filteredClasses.length} lớp học
        `;

        // Render classes and pagination
        this.renderClasses();
        this.renderClassPagination();
    }

    // Render classes for current page
    renderClasses() {
        const container = document.getElementById("classesGrid");
        if (!container) return;

        const startIndex = (this.currentClassPage - 1) * this.classesPerPage;
        const endIndex = startIndex + this.classesPerPage;
        const classesToShow = this.filteredClasses.slice(startIndex, endIndex);

        if (classesToShow.length === 0) {
            container.innerHTML = `
                <div class="alert alert-info text-center">
                    Không tìm thấy lớp học nào.
                </div>
            `;
            return;
        }

        container.innerHTML = classesToShow
            .map((classInfo) => `
                <div class="class-card card">
                    <div class="card-body">
                        <h5 class="card-title">${this.escapeHtml(classInfo.name)}</h5>
                        <p class="card-text">
                            <div class="detail-item">
                                <i class="fas fa-book me-2"></i>
                                <strong>Khóa học:</strong> ${this.escapeHtml(classInfo.courseTitle)}
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-id-card me-2"></i>
                                <strong>Mã lớp:</strong> ${classInfo.classID}
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-users me-2"></i>
                                <strong>Sĩ số:</strong> ${classInfo.numberOfStudents} học sinh
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-calendar me-2"></i>
                                <strong>Thời gian:</strong> 
                                ${this.formatDate(classInfo.startDate)} - 
                                ${this.formatDate(classInfo.endDate)}
                            </div>
                        </p>
                    </div>
                    <div class="class-card-footer">
                        <a class="btn btn-primary btn-sm btn-view-students" onclick="classManager.viewStudents('${classInfo.classID}')">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            `)
            .join("");
    }

    // Render class pagination
    renderClassPagination() {
        const paginationContainer = document.getElementById("classPagination");
        if (!paginationContainer) return;

        const totalPages = Math.ceil(this.filteredClasses.length / this.classesPerPage);

        let paginationHTML = "";

        // Previous button
        if (this.currentClassPage > 1) {
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToClassPage(${this.currentClassPage - 1}); return false;">
                        <i class="fas fa-chevron-left"></i>
                    </a>
                </li>
            `;
        } else {
            paginationHTML += `
                <li class="page-item disabled">
                    <span class="page-link">
                        <i class="fas fa-chevron-left"></i>
                    </span>
                </li>
            `;
        }

        // Page numbers
        const startPage = Math.max(1, this.currentClassPage - 2);
        const endPage = Math.min(totalPages, this.currentClassPage + 2);

        if (startPage > 1) {
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToClassPage(1); return false;">1</a>
                </li>
            `;
            if (startPage > 2) {
                paginationHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            paginationHTML += `
                <li class="page-item ${i === this.currentClassPage ? "active" : ""}">
                    <a class="page-link" href="#" onclick="classManager.goToClassPage(${i}); return false;">${i}</a>
                </li>
            `;
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                paginationHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
            }
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToClassPage(${totalPages}); return false;">${totalPages}</a>
                </li>
            `;
        }

        // Next button
        if (this.currentClassPage < totalPages) {
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToClassPage(${this.currentClassPage + 1}); return false;">
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </li>
            `;
        } else {
            paginationHTML += `
                <li class="page-item disabled">
                    <span class="page-link">
                        <i class="fas fa-chevron-right"></i>
                    </span>
                </li>
            `;
        }

        paginationContainer.innerHTML = paginationHTML;
    }

    // Go to specific class page
    goToClassPage(page) {
        const totalPages = Math.ceil(this.filteredClasses.length / this.classesPerPage);
        // Validate page number
        if (page < 1 || page > totalPages) return;
        this.currentClassPage = page;
        this.renderClasses(); // Added to update class list
        this.renderClassPagination();
        // Scroll to top
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    // View students in a class
    async viewStudents(classId) {
        try {
            this.selectedClassId = classId;
            this.currentStudentPage = 1;
            this.studentSearchTerm = "";

            // Clear student search input
            const studentSearchInput = document.getElementById("studentSearchInput");
            if (studentSearchInput) {
                studentSearchInput.value = "";
            }

            // Update URL
            history.pushState({ view: "students", classId: classId }, "", `?view=students&classId=${classId}`);

            // Show student view
            this.showStudentView();

            // Load class info and students
            await this.loadClassInfo(classId);
            await this.loadAllStudents(classId);
        } catch (error) {
            console.error("Error viewing students:", error);
            this.showToast("Không thể tải danh sách học sinh. Vui lòng thử lại.", "error");
        }
    }

    // Load class info
    async loadClassInfo(classId) {
        try {
            const response = await fetch(`${this.contextPath}/ClassInfoServlet?classId=${classId}`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (!response.ok) {
                throw new Error("Failed to load class info");
            }

            const classInfo = await response.json();

            // Update class info in the header
            document.getElementById("selectedClassName").textContent = classInfo.name;
            document.getElementById("selectedClassInfo").textContent =
                `${classInfo.courseTitle} • Giảng viên: ${classInfo.teacherName}`;
        } catch (error) {
            console.error("Error loading class info:", error);
        }
    }

    // Load all students for a class
    async loadAllStudents(classId) {
        try {
            this.showLoading();

            const response = await fetch(`${this.contextPath}/StudentListServlet?classId=${classId}`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json"
                }
            });

            if (!response.ok) {
                throw new Error("Failed to load students");
            }

            const data = await response.json();
            this.allStudents = data.students || [];
            this.filterAndPaginateStudents();
        } catch (error) {
            console.error("Error loading students:", error);
            this.showToast("Không thể tải danh sách học sinh. Vui lòng thử lại.", "error");
        } finally {
            this.hideLoading();
        }
    }

    // Filter and paginate students (client-side)
    filterAndPaginateStudents() {
        // Filter students based on search term
        if (this.studentSearchTerm.trim() === "") {
            this.filteredStudents = [...this.allStudents];
        } else {
            this.filteredStudents = this.allStudents.filter(
                (student) =>
                    student.fullName.toLowerCase().includes(this.studentSearchTerm) ||
                    student.email.toLowerCase().includes(this.studentSearchTerm) ||
                    student.studentID.toLowerCase().includes(this.studentSearchTerm),
            );
        }

        // Reset to first page when filtering
        this.currentStudentPage = 1;

        // Update student count
        document.getElementById("studentCount").innerHTML = `
            <i class="fas fa-user-graduate me-1"></i>
            ${this.filteredStudents.length} học sinh
        `;

        // Render students and pagination
        this.renderStudents();
        this.renderStudentPagination();
    }

    // Render students for current page
    renderStudents() {
        const tbody = document.getElementById("studentsTableBody");
        if (!tbody) return;

        const startIndex = (this.currentStudentPage - 1) * this.studentsPerPage;
        const endIndex = startIndex + this.studentsPerPage;
        const studentsToShow = this.filteredStudents.slice(startIndex, endIndex);

        if (studentsToShow.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center py-5">
                        <div class="empty-state">
                            <i class="fas fa-user-graduate"></i>
                            <h5>Không tìm thấy học sinh nào</h5>
                            <p>Thử thay đổi từ khóa tìm kiếm</p>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = studentsToShow
            .map((student, index) => {
                const progressPercentage = this.calculateProgress(student.progress);
                const progressClass = this.getProgressClass(progressPercentage);
                const averageScore = this.calculateAverageScore(student.progress);

                return `
                    <tr>
                        <td><strong>${startIndex + index + 1}</strong></td>
                        <td>
                            <div class="student-info">
                                <img src="${student.profilePicture || "/assets/images/default-avatar.png"}" 
                                     alt="${this.escapeHtml(student.fullName)}" 
                                     class="student-avatar">
                                <div>
                                    <div class="student-name">${this.escapeHtml(student.fullName)}</div>
                                    <span class="student-id-badge">${student.studentID}</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="contact-info">
                                <div class="contact-item">
                                    <i class="fas fa-envelope"></i>
                                    <span>${this.escapeHtml(student.email)}</span>
                                </div>
                                <div class="contact-item">
                                    <i class="fas fa-phone"></i>
                                    <span>${student.phone || "Chưa cập nhật"}</span>
                                </div>
                                <div class="contact-item">
                                    <i class="fas fa-calendar"></i>
                                    <span>Đăng ký: ${this.formatDate(student.enrollmentDate)}</span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="progress-info">
                                <div class="progress-text">
                                    ${student.completedLessons || 0}/${student.totalLessons || 0} bài học
                                    <span class="progress-percentage ${progressClass}">${progressPercentage}%</span>
                                </div>
                                <div class="progress-bar-custom">
                                    <div class="progress-fill ${progressClass}" style="width: ${progressPercentage}%"></div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="score-display">
                                <div class="score-number">${averageScore > 0 ? averageScore.toFixed(1) : "--"}</div>
                                <div class="score-label">điểm</div>
                            </div>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn btn-outline-primary btn-sm" onclick="classManager.viewProfile('${student.studentID}')">
                                    <i class="fas fa-chart-line me-1"></i> Tiến độ
                                </button>
                                <button class="btn btn-outline-info btn-sm" onclick="classManager.sendMessage('${student.userID}')">
                                    <i class="fas fa-comment me-1"></i> Nhắn tin
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
            })
            .join("");
    }

    // Render student pagination
    renderStudentPagination() {
        const paginationContainer = document.getElementById("studentPagination");
        if (!paginationContainer) return;

        const totalPages = Math.ceil(this.filteredStudents.length / this.studentsPerPage);

        let paginationHTML = "";

        // Previous button
        if (this.currentStudentPage > 1) {
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToStudentPage(${this.currentStudentPage - 1}); return false;">
                        <i class="fas fa-chevron-left"></i>
                    </a>
                </li>
            `;
        } else {
            paginationHTML += `
                <li class="page-item disabled">
                    <span class="page-link">
                        <i class="fas fa-chevron-left"></i>
                    </span>
                </li>
            `;
        }

        // Page numbers
        const startPage = Math.max(1, this.currentStudentPage - 2);
        const endPage = Math.min(totalPages, this.currentStudentPage + 2);

        if (startPage > 1) {
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToStudentPage(1); return false;">1</a>
                </li>
            `;
            if (startPage > 2) {
                paginationHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            paginationHTML += `
                <li class="page-item ${i === this.currentStudentPage ? "active" : ""}">
                    <a class="page-link" href="#" onclick="classManager.goToStudentPage(${i}); return false;">${i}</a>
                </li>
            `;
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                paginationHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
            }
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToStudentPage(${totalPages}); return false;">${totalPages}</a>
                </li>
            `;
        }

        // Next button
        if (this.currentStudentPage < totalPages) {
            paginationHTML += `
                <li class="page-item">
                    <a class="page-link" href="#" onclick="classManager.goToStudentPage(${this.currentStudentPage + 1}); return false;">
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </li>
            `;
        } else {
            paginationHTML += `
                <li class="page-item disabled">
                    <span class="page-link">
                        <i class="fas fa-chevron-right"></i>
                    </span>
                </li>
            `;
        }

        paginationContainer.innerHTML = paginationHTML;
    }

    // Go to specific student page
    goToStudentPage(page) {
        const totalPages = Math.ceil(this.filteredStudents.length / this.studentsPerPage);
        if (page < 1 || page > totalPages) return;
        this.currentStudentPage = page;
        this.renderStudents();
        this.renderStudentPagination();
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    // View student profile
    async viewProfile(studentId) {
        try {
            this.showLoading();

            // Update URL
            history.pushState(
                { view: "profile", classId: this.selectedClassId, studentId: studentId },
                "",
                `?view=profile&classId=${this.selectedClassId}&studentId=${studentId}`,
            );

            // Show profile view
            this.showProfileView();

            // Load student profile
            await this.loadStudentProfile(studentId);
        } catch (error) {
            console.error("Error viewing profile:", error);
            this.showToast("Không thể tải thông tin học sinh. Vui lòng thử lại.", "error");
        } finally {
            this.hideLoading();
        }
    }

    // Load student profile
    async loadStudentProfile(studentId) {
        try {
            const response = await fetch(
                `${this.contextPath}/StudentProfileServlet?studentId=${studentId}&classId=${this.selectedClassId}`,
                {
                    method: "GET",
                    headers: {
                        "Content-Type": "application/json"
                    }
                },
            );

            if (!response.ok) {
                throw new Error("Failed to load student profile");
            }

            const profile = await response.json();
            this.renderStudentProfile(profile);
        } catch (error) {
            console.error("Error loading student profile:", error);
            this.showToast("Không thể tải thông tin học sinh.", "error");
        }
    }

    // Render student profile
    renderStudentProfile(profile) {
        const container = document.getElementById("studentProfileContent");
        if (!container) return;

        const progressPercentage = this.calculateProgress(profile.progress);
        const averageScore = this.calculateAverageScore(profile.progress);

        container.innerHTML = `
            <div class="profile-header card">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-3 col-12 text-center text-md-start mb-3 mb-md-0">
                            <img src="${profile.profilePicture || "/assets/images/default-avatar.png"}" 
                                 alt="${this.escapeHtml(profile.fullName)}" 
                                 class="profile-avatar shadow-sm">
                        </div>
                        <div class="col-md-9 col-12">
                            <div class="profile-info">
                                <h2 class="mb-3">${this.escapeHtml(profile.fullName)}</h2>
                                <div class="profile-details mb-3">
                                    <div class="detail-item"><i class="fas fa-id-card me-2"></i>${profile.studentID}</div>
                                    <div class="detail-item"><i class="fas fa-envelope me-2"></i>${this.escapeHtml(profile.email)}</div>
                                    <div class="detail-item"><i class="fas fa-phone me-2"></i>${profile.phone || "Chưa cập nhật"}</div>
                                </div>
                                <div class="profile-actions">
                                    <button class="btn btn-primary btn-lg" onclick="classManager.sendMessage('${profile.userID}')">
                                        <i class="fas fa-comment me-2"></i>Nhắn tin
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="profile-stats mt-4">
                        <div class="stat-card">
                            <div class="stat-number text-high">${progressPercentage}%</div>
                            <div class="stat-text">Tiến độ</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number text-high">${profile.completedLessons || 0}</div>
                            <div class="stat-text">Bài học hoàn thành</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number ${averageScore >= 7 ? 'text-high' : averageScore >= 4 ? 'text-medium' : 'text-low'}">${averageScore.toFixed(1)}</div>
                            <div class="stat-text">Điểm trung bình</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="profile-tabs card mt-4">
                <div class="tab-content" id="profileTabContent">
                    <div class="tab-pane fade show active" id="progress" role="tabpanel">
                        ${this.renderProgressTab(profile.progress)}
                    </div>
                    <div class="tab-pane fade" id="messages" role="tabpanel">
                    </div>
                </div>
            </div>
        `;
    }

    // Render progress tab
    renderProgressTab(progress) {
        if (!progress || progress.length === 0) {
            return `
                <div class="empty-state">
                    <i class="fas fa-chart-line"></i>
                    <h5>Chưa có dữ liệu tiến độ</h5>
                    <p>Học sinh chưa bắt đầu học bài nào</p>
                </div>
            `;
        }

        return `
            <div class="row">
                <div class="col-12">
                    <h5 class="mb-4">Chi tiết tiến độ học tập</h5>
                    <div class="progress-list">
                        ${progress
                            .map(
                                (item) => `
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-1">
                                                    ${this.getStatusIcon(item.completionStatus)}
                                                </div>
                                                <div class="col-md-6">
                                                    <h6 class="mb-1">${this.escapeHtml(item.lessonTitle)}</h6>
                                                    <small class="text-muted">Chủ đề: ${this.escapeHtml(item.topicName)}</small>
                                                </div>
                                                <div class="col-md-3">
                                                    <small class="text-muted">
                                                        Bắt đầu: ${this.formatDate(item.startDate)}<br>
                                                        ${item.endDate ? `Hoàn thành: ${this.formatDate(item.endDate)}` : ""}
                                                    </small>
                                                </div>
                                                <div class="col-md-2 text-end">
                                                    ${this.getStatusBadge(item.completionStatus)}
                                                    ${item.score ? `<div class="mt-1"><small class="text-success fw-bold">Điểm: ${item.score}/100</small></div>` : ""}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                `,
                            )
                            .join("")}
                    </div>
                </div>
            </div>
        `;
    }

    // View navigation methods
    showClassView() {
        document.getElementById("classView").style.display = "block";
        document.getElementById("studentView").style.display = "none";
        document.getElementById("profileView").style.display = "none";
        this.currentView = "classes";
        history.pushState({ view: "classes" }, "", window.location.pathname);
    }

    showStudentView() {
        document.getElementById("classView").style.display = "none";
        document.getElementById("studentView").style.display = "block";
        document.getElementById("profileView").style.display = "none";
        this.currentView = "students";
    }

    showProfileView() {
        document.getElementById("classView").style.display = "none";
        document.getElementById("studentView").style.display = "none";
        document.getElementById("profileView").style.display = "block";
        this.currentView = "profile";
    }

    // Utility methods
    calculateProgress(progressData) {
        if (!progressData || progressData.length === 0) return 0;
        const completed = progressData.filter((p) => p.completionStatus === "complete").length;
        return Math.round((completed / progressData.length) * 100);
    }

    calculateAverageScore(progressData) {
        if (!progressData || progressData.length === 0) return 0;
        const scoresData = progressData.filter((p) => p.score !== undefined && p.score !== null && p.score > 0);
        if (scoresData.length === 0) return 0;
        const total = scoresData.reduce((sum, p) => sum + p.score, 0);
        return total / scoresData.length;
    }

    getProgressClass(percentage) {
        if (percentage >= 70) return "high";
        if (percentage >= 40) return "medium";
        return "low";
    }

    getStatusIcon(status) {
        switch (status) {
            case "completed":
            case "complete":
                return '<i class="fas fa-check-circle text-success fa-2x"></i>';
            case "pending":
                return '<i class="fas fa-clock text-warning fa-2x"></i>';
            case "in progress":
                return '<i class="fas fa-play-circle text-info fa-2x"></i>';
            case "overdue":
                return '<i class="fas fa-times-circle text-danger fa-2x"></i>';
            default:
                return '<i class="fas fa-question-circle text-muted fa-2x"></i>';
        }
    }

    getStatusBadge(status) {
        switch (status) {
            case "completed":
            case "complete":
                return '<span class="badge bg-success">Hoàn thành</span>';
            case "pending":
                return '<span class="badge bg-warning">Đang chờ</span>';
            case "in progress":
                return '<span class="badge bg-info">Đang học</span>';
            case "overdue":
                return '<span class="badge bg-danger">Quá hạn</span>';
            default:
                return '<span class="badge bg-secondary">Chưa bắt đầu</span>';
        }
    }

    formatDate(dateString) {
        if (!dateString) return "";
        const date = new Date(dateString);
        return date.toLocaleDateString("vi-VN");
    }

    formatDateTime(dateString) {
        if (!dateString) return "";
        const date = new Date(dateString);
        return date.toLocaleString("vi-VN");
    }

    escapeHtml(text) {
        if (!text) return "";
        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    // Message functionality
   async sendMessage(userID) {
    if (!userID) {
        this.showToast("ID người nhận không hợp lệ.", "error");
        return;
    }
    window.location.href = `${this.contextPath}/message?receiverID=${encodeURIComponent(userID)}`;
}

    // Navigation handling
    handleNavigation(state) {
        switch (state.view) {
            case "classes":
                this.showClassView();
                break;
            case "students":
                this.selectedClassId = state.classId;
                this.showStudentView();
                this.loadClassInfo(state.classId);
                this.loadAllStudents(state.classId);
                break;
            case "profile":
                this.selectedClassId = state.classId;
                this.showProfileView();
                this.loadStudentProfile(state.studentId);
                break;
        }
    }

    // Toast notification system
    showToast(message, type = "info") {
        const toastContainer = document.getElementById("toastContainer");
        if (!toastContainer) return;

        const toastId = "toast-" + Date.now();
        const toastHtml = `
            <div class="toast toast-${type}" role="alert" aria-live="assertive" aria-atomic="true" id="${toastId}">
                <div class="toast-header">
                    <i class="fas fa-${this.getToastIcon(type)} me-2"></i>
                    <strong class="me-auto">${this.getToastTitle(type)}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    ${message}
                </div>
            </div>
        `;

        toastContainer.insertAdjacentHTML("beforeend", toastHtml);

        const toastElement = document.getElementById(toastId);
        const bootstrap = window.bootstrap;
        const toast = new bootstrap.Toast(toastElement, {
            autohide: true,
            delay: 5000
        });

        toast.show();

        toastElement.addEventListener("hidden.bs.toast", () => {
            toastElement.remove();
        });
    }

    getToastIcon(type) {
        switch (type) {
            case "success":
                return "check-circle";
            case "error":
                return "exclamation-circle";
            case "warning":
                return "exclamation-triangle";
            default:
                return "info-circle";
        }
    }

    getToastTitle(type) {
        switch (type) {
            case "success":
                return "Thành công";
            case "error":
                return "Lỗi";
            case "warning":
                return "Cảnh báo";
            default:
                return "Thông báo";
        }
    }
}

// Global functions for onclick handlers
function viewStudents(classId) {
    if (window.classManager) {
        window.classManager.viewStudents(classId);
    }
}

function showClassView() {
    if (window.classManager) {
        window.classManager.showClassView();
    }
}

function showStudentView() {
    if (window.classManager) {
        window.classManager.showStudentView();
    }
}

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
    window.classManager = new ClassManager();
    const contextPathMeta = document.querySelector('meta[name="context-path"]');
    if (contextPathMeta) {
        window.classManager.contextPath = contextPathMeta.getAttribute("content");
    }
    const urlParams = new URLSearchParams(window.location.search);
    const view = urlParams.get("view");
    const classId = urlParams.get("classId");
    const studentId = urlParams.get("studentId");

    if (view && classId) {
        const state = { view, classId };
        if (studentId) state.studentId = studentId;
        window.classManager.handleNavigation(state);
    }
});