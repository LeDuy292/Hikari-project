class TestManager {
    constructor() {
        this.uploadedQuestions = [];
        this.tests = [];
        this.currentTest = null;
        this.currentQuestions = [];
        this.currentQuestionIndex = 0;
        this.init();
    }

    init() {
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Upload Excel button - mở modal
        const uploadBtn = document.getElementById("uploadExcelBtn");
        if (uploadBtn) {
            uploadBtn.addEventListener("click", () => {
                const modal = new window.bootstrap.Modal(document.getElementById("uploadExcelModal"));
                modal.show();
            });
        }
document.addEventListener("click", (e) => {
        const viewDetailsBtn = e.target.closest(".view-details-btn");
        if (viewDetailsBtn) {
            const testId = Number.parseInt(viewDetailsBtn.dataset.testId);
            const studentID = viewDetailsBtn.dataset.studentId;
            if (isNaN(testId) || !studentID) {
                console.error("Invalid testId or studentID:", { testId, studentID });
                this.showAlert("Lỗi: Thông tin bài làm không hợp lệ", "error");
                return;
            }
            this.showStudentAnswerDetail(testId, studentID);
        }
    });
        // File upload button trong modal
        const uploadFileBtn = document.getElementById("uploadFileBtn");
        if (uploadFileBtn) {
            uploadFileBtn.addEventListener("click", () => {
                this.handleFileUpload();
            });
        }

        // Back to tests button
        const backBtn = document.getElementById("backToTests");
        if (backBtn) {
            backBtn.addEventListener("click", (e) => {
                e.preventDefault();
                this.showTestList();
            });
        }

        // Edit question button - sẽ được gán động
        document.addEventListener("click", (e) => {
            if (e.target.id === "editQuestionBtn" || e.target.closest("#editQuestionBtn")) {
                this.showEditQuestionForm();
            }
        });
        const backToTestsFromResults = document.getElementById("backToTestsFromResults");
        if (backToTestsFromResults) {
            backToTestsFromResults.addEventListener("click", (e) => {
                e.preventDefault();
                document.getElementById("testResults").style.display = "none";
                document.getElementById("testList").style.display = "block";
            });
        }

        const backToResults = document.getElementById("backToResults");
        if (backToResults) {
            backToResults.addEventListener("click", (e) => {
                e.preventDefault();
                document.getElementById("studentAnswerDetail").style.display = "none";
                document.getElementById("testResults").style.display = "block";
            });
        }

        const searchStudents = document.getElementById("searchStudents");
        if (searchStudents) {
            searchStudents.addEventListener("input", (e) => this.filterResults(e.target.value));
        }
        // Cancel edit question buttons
        const cancelEditBtns = ["cancelEditQuestionBtn", "cancelEditBtn"];
        cancelEditBtns.forEach((btnId) => {
            document.addEventListener("click", (e) => {
                if (e.target.id === btnId || e.target.closest(`#${btnId}`)) {
                    this.hideEditQuestionForm();
                }
            });
        });

        // Save edit question button
        document.addEventListener("click", (e) => {
            if (e.target.id === "saveEditBtn" || e.target.closest("#saveEditBtn")) {
                this.saveQuestionEdit();
            }
        });

        // Add question button
        document.addEventListener("click", (e) => {
            if (e.target.id === "addQuestionBtn" || e.target.closest("#addQuestionBtn")) {
                this.showAddQuestionForm();
            }
        });

        // Cancel add question buttons
        const cancelAddBtns = ["cancelAddQuestionBtn", "cancelAddBtn"];
        cancelAddBtns.forEach((btnId) => {
            document.addEventListener("click", (e) => {
                if (e.target.id === btnId || e.target.closest(`#${btnId}`)) {
                    this.hideAddQuestionForm();
                }
            });
        });

        // Save add question button
        document.addEventListener("click", (e) => {
            if (e.target.id === "saveAddBtn" || e.target.closest("#saveAddBtn")) {
                this.saveNewQuestion();
            }
        });

        // Save test button (sẽ được tạo động)
        document.addEventListener("click", (e) => {
            if (e.target.id === "saveTestBtn") {
                this.handleSaveTest();
            }
        });
        document.addEventListener("click", (e) => {
            if (e.target.classList.contains("question-nav-item")) {
                const questionIndex = Number.parseInt(e.target.dataset.index);
                this.showAnswerDetail(questionIndex);
            }
        });

        // Question navigation
        document.addEventListener("click", (e) => {
            if (e.target.classList.contains("question-item")) {
                const questionIndex = Number.parseInt(e.target.dataset.index);
                this.showQuestion(questionIndex);
            }
        });
    }

    async handleFileUpload() {
        const fileInput = document.getElementById("excelFileInput");
        const file = fileInput.files[0];

        if (!file) {
            this.showAlert("Vui lòng chọn file Excel", "warning");
            return;
        }

        if (!file.name.match(/\.(xlsx|xls)$/)) {
            this.showAlert("Vui lòng chọn file Excel (.xlsx hoặc .xls)", "error");
            return;
        }

        const formData = new FormData();
        formData.append("excelFile", file);

        try {
            this.showLoading("Đang xử lý file Excel...");

            const response = await fetch("/Hikari/UploadFileExcel", {
                method: "POST",
                body: formData
            });

            if (response.ok) {
                const questions = await response.json();
                console.log("Uploaded questions:", questions);

                this.uploadedQuestions = questions;
                this.showTestPreview(questions);

                const uploadModal = window.bootstrap.Modal.getInstance(document.getElementById("uploadExcelModal"));
                uploadModal.hide();

                this.showAlert("Upload file thành công! Vui lòng điền thông tin bài test.", "success");
            } else {
                const errorData = await response.json();
                this.showAlert(errorData.message || "Lỗi khi upload file", "error");
            }
        } catch (error) {
            console.error("Upload error:", error);
            this.showAlert("Lỗi khi upload file: " + error.message, "error");
        } finally {
            this.hideLoading();
        }
    }

    // Edit test functionality
    async editTest(testId) {
        try {
            this.showLoading("Đang tải thông tin bài test...");

            // Fetch test details
            const response = await fetch(`/Hikari/GetTestDetailsServlet?testId=${testId}`);
            if (!response.ok) {
                throw new Error("Không thể tải thông tin bài test");
            }

            const testData = await response.json();
            this.currentTest = testData.test;
            this.currentQuestions = testData.questions;

            this.showTestDetail();
        } catch (error) {
            console.error("Error editing test:", error);
            this.showAlert("Lỗi khi tải thông tin bài test: " + error.message, "error");
        } finally {
            this.hideLoading();
        }
    }

    async viewResults(testId) {
        try {
            this.showLoading("Đang tải kết quả bài test...");

            // Gọi API để lấy dữ liệu kết quả
            const response = await fetch(`/Hikari/ViewTestResultsServlet?testId=${testId}`);

            if (!response.ok) {
                throw new Error("Không thể tải kết quả bài test");
            }

            const data = await response.json();

            if (data.status === "error") {
                throw new Error(data.message);
            }

            this.currentTest = data.test;
            this.currentResults = data.results;
            console.log(data.results);
            this.currentStatistics = {
                totalStudents: data.totalStudents,
                completedTests: data.completedTests,
                passedTests: data.passedTests,
                averageScore: data.averageScore,
                highestScore: data.highestScore,
                lowestScore: data.lowestScore,
                passRate: data.passRate
            };

            // Hiển thị giao diện kết quả
            this.showTestResults();
        } catch (error) {
            console.error("Error viewing results:", error);
            this.showAlert("Lỗi khi xem kết quả: " + error.message, "error");
        } finally {
            this.hideLoading();
        }
    }
    showTestList() {
        document.getElementById("testList").style.display = "block";
        document.getElementById("questionDetail").style.display = "none";
        document.getElementById("testResults").style.display = "none";
        document.getElementById("studentAnswerDetail").style.display = "none";
        this.hideEditQuestionForm();
        this.hideAddQuestionForm();
    }
    // Show test detail view
    showTestDetail() {
        document.getElementById("testList").style.display = "none";
        document.getElementById("questionDetail").style.display = "block";

        // Update test info header
        if (this.currentTest) {
            const titleElement = document.getElementById("currentTestTitle");
            const levelElement = document.getElementById("currentTestLevel");
            const durationElement = document.getElementById("currentTestDuration");

            if (titleElement)
                titleElement.textContent = this.currentTest.title;
            if (levelElement)
                levelElement.textContent = `Level: ${this.currentTest.jlptLevel}`;
            if (durationElement)
                durationElement.textContent = `${this.currentTest.duration} phút`;
        }

        if (this.currentQuestions.length > 0) {
            this.createQuestionNavigation();
            this.showQuestion(0);
        } else {
            this.showEmptyQuestionState();
        }
    }

    // Show test list view
    showTestList() {
        document.getElementById("testList").style.display = "block";
        document.getElementById("questionDetail").style.display = "none";
        this.hideEditQuestionForm();
        this.hideAddQuestionForm();
    }

    // Show empty question state
    showEmptyQuestionState() {
        const questionContent = document.getElementById("questionContent");
        if (questionContent) {
            questionContent.innerHTML = `
        <div class="empty-question-state">
          <i class="fas fa-question-circle"></i>
          <h4>Chưa có câu hỏi nào</h4>
          <p>Hãy thêm câu hỏi đầu tiên cho bài test này</p>
        </div>
      `;
        }
        ;
        this.updateQuestionStats();
    }

    // Create question navigation
    createQuestionNavigation() {
        const questionProgress = document.getElementById("questionProgress");
        if (questionProgress) {
            questionProgress.innerHTML = this.currentQuestions
                    .map(
                            (q, index) => `
          <div class="question-item" data-index="${index}">
            ${index + 1}
          </div>
        `,
                            )
                    .join("");
        }
        this.updateQuestionStats();
    }

    // Update question statistics
    updateQuestionStats() {
        const totalElement = document.getElementById("totalQuestions");

            totalElement.textContent = this.currentQuestions.length;
       
    }

    // Show specific question
    showQuestion(index) {
        if (index < 0 || index >= this.currentQuestions.length)
            return;

        this.currentQuestionIndex = index;
        const question = this.currentQuestions[index];

        // Update navigation
        document.querySelectorAll(".question-item").forEach((item, i) => {
            item.classList.toggle("active", i === index);
        });

        // Update question content
        this.updateQuestionContent(question, index);
        this.hideEditQuestionForm();
        this.hideAddQuestionForm();
    }

    // Update question content display
    updateQuestionContent(question, index) {
        const questionContent = document.getElementById("questionContent");
        if (!questionContent)
            return;

        questionContent.innerHTML = `
      <div class="question-header">
        <h3 class="question-title">Câu hỏi ${index + 1}</h3>
        <div class="question-meta">
          <span class="question-type-badge multiple-choice">Trắc nghiệm</span>
        </div>
      </div>
      <div class="question-text">${question.questionText}</div>
      <div class="question-options" id="questionOptions">
        <div class="option-item ${question.correctOption === "A" ? "correct" : ""}">
          <span>A. ${question.optionA}</span>
        </div>
        <div class="option-item ${question.correctOption === "B" ? "correct" : ""}">
          <span>B. ${question.optionB}</span>
        </div>
        <div class="option-item ${question.correctOption === "C" ? "correct" : ""}">
          <span>C. ${question.optionC}</span>
        </div>
        <div class="option-item ${question.correctOption === "D" ? "correct" : ""}">
          <span>D. ${question.optionD}</span>
        </div>
      </div>
      <div class="question-actions">
        <button class="btn btn-primary" id="editQuestionBtn">
          <i class="fas fa-edit"></i> Chỉnh sửa câu hỏi
        </button>
        <button class="btn btn-danger" onclick="testManager.deleteQuestion(${question.id})">
          <i class="fas fa-trash"></i> Xóa câu hỏi
        </button>
      </div>
    `;
    }
    ;
            // Show edit question form
            showEditQuestionForm() {
        const question = this.currentQuestions[this.currentQuestionIndex];
        const editForm = document.getElementById("editQuestionForm");
        const questionContent = document.getElementById("questionContent");

        if (editForm && questionContent) {
            questionContent.style.display = "none";
            editForm.style.display = "block";

            // Populate form with current question data
            document.getElementById("editQuestionText").value = question.questionText;
            const optionInputs = document.querySelectorAll("#editQuestionForm .option-input");
            if (optionInputs.length >= 4) {
                optionInputs[0].value = question.optionA;
                optionInputs[1].value = question.optionB;
                optionInputs[2].value = question.optionC;
                optionInputs[3].value = question.optionD;
            }

            // Set correct answer radio button
            const correctRadio = document.querySelector(`input[name="correctAnswer"][value="${question.correctOption}"]`);
            if (correctRadio) {
                correctRadio.checked = true;
            }

            document.getElementById("editQuestionNumber").textContent = this.currentQuestionIndex + 1;
        }
    }

    // Hide edit question form
    hideEditQuestionForm() {
        const editForm = document.getElementById("editQuestionForm");
        const questionContent = document.getElementById("questionContent");

        if (editForm && questionContent) {
            editForm.style.display = "none";
            questionContent.style.display = "block";
        }
    }
// Trong class TestManager
    showTestResults() {
        // Hiển thị section kết quả và ẩn các section khác
        document.getElementById("testList").style.display = "none";
        document.getElementById("questionDetail").style.display = "none";
        document.getElementById("testResults").style.display = "block";
        document.getElementById("studentAnswerDetail").style.display = "none";

        // Cập nhật thông tin bài test
        if (this.currentTest) {
            const titleElement = document.getElementById("resultsTestTitle");
            const levelElement = document.getElementById("resultsTestLevel");
            const durationElement = document.getElementById("resultsTestDuration");
            const questionsElement = document.getElementById("resultsTestQuestions");

            if (titleElement)
                titleElement.textContent = this.currentTest.title;
            if (levelElement)
                levelElement.textContent = `Level: ${this.currentTest.jlptLevel}`;
            if (durationElement)
                durationElement.textContent = `${this.currentTest.duration} phút`;
            if (questionsElement)
                questionsElement.textContent = `${this.currentQuestions.length} câu`;
        }

        // Hiển thị thống kê kết quả
        this.updateResultsStatistics();

        // Hiển thị danh sách kết quả học sinh
        this.renderResultsTable();

        // Hiển thị pagination nếu cần
        this.updateResultsPagination();

        // Hiển thị empty state nếu chưa có kết quả
        if (this.currentResults.length === 0) {
            document.getElementById("emptyResultsState").style.display = "block";
            const containers = document.getElementsByClassName("results-table-container");
            for (let container of containers) {
                container.style.display = "none";
            }
            document.getElementById("resultsPagination").style.display = "none";
        } else {
            document.getElementById("emptyResultsState").style.display = "none";
            document.getElementById("resultsTable").style.display = "table";
            document.getElementById("resultsPagination").style.display = "block";
        }
    }

// Hàm hỗ trợ cập nhật thống kê kết quả
    updateResultsStatistics() {
        const stats = this.currentStatistics;

        // Cập nhật các chỉ số thống kê
        document.getElementById("totalStudentsCount").textContent = stats.totalStudents;
        document.getElementById("completedCount").textContent = stats.completedTests;
        document.getElementById("averageScore").textContent = stats.averageScore.toFixed(2);
        document.getElementById("passRate").textContent = `${stats.passRate.toFixed(1)}%`;
    }

// Hàm hỗ trợ render bảng kết quả
    renderResultsTable() {
    const tbody = document.getElementById("resultsTableBody");
    if (!tbody) {
        console.error("resultsTableBody element not found");
        this.showAlert("Lỗi giao diện: Không tìm thấy bảng kết quả", "error");
        return;
    }
    tbody.innerHTML = "";
    this.currentResults.forEach((result, index) => {
        if (!result.studentID || !result.testId) {
            console.error(`Result at index ${index} is missing studentID or testId`, result);
            this.showAlert(`Lỗi: Kết quả số ${index + 1} thiếu thông tin`, "error");
            return;
        }
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${index + 1}</td>
            <td>${result.studentID}</td>
            <td>${result.studentName}</td>
            <td>${result.score}/100</td>
            <td>${this.formatTime(result.timeTaken)}</td>
            <td>${this.getSubmissionStatus(result.status)}</td>
            <td>
                <button class="btn btn-sm btn-primary view-details-btn" 
                        data-test-id="${result.testId}" 
                        data-student-id="${result.studentID}">
                    <i class="fas fa-eye"></i> Xem chi tiết
                </button>
            </td>
        `;
        tbody.appendChild(row);
    });
}
 // Show student answer detail
 async showStudentAnswerDetail(testId, studentID) {
    if (!testId || !studentID) {
        this.showAlert("Lỗi: Thiếu testId hoặc studentID", "error");
        return;
    }
    console.log(`testID: ${testId}, studentID: ${studentID}`);
    try {
        this.showLoading("Đang tải chi tiết bài làm...");
        const response = await fetch(`/Hikari/GetStudentAnswersServlet?testId=${testId}&studentID=${studentID}`);
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const data = await response.json();
        if (data.status === "error") {
            throw new Error(data.message || "Lỗi từ server");
        }

        // Kiểm tra và gán dữ liệu
        this.currentQuestions = Array.isArray(data.questions) ? data.questions : [];
        this.currentStudentAnswers = Array.isArray(data.studentAnswers) ? data.studentAnswers : [];

        if (this.currentQuestions.length === 0) {
            this.showAlert("Không có câu hỏi nào cho bài kiểm tra này", "warning");
            return;
        }

        this.currentStudent = this.currentResults.find(result => result.testId === testId && result.studentID === studentID);
        if (!this.currentStudent) {
            throw new Error("Không tìm thấy thông tin học sinh");
        }

        // Ẩn các phần tử giao diện khác
        document.getElementById("testList").style.display = "none";
        document.getElementById("questionDetail").style.display = "none";
        document.getElementById("testResults").style.display = "none";
        document.getElementById("studentAnswerDetail").style.display = "block";

        this.createAnswerNavigation();
        this.showAnswerDetail(0);
    } catch (error) {
        console.error("Error loading student answers:", error);
        this.showAlert(`Lỗi khi tải chi tiết bài làm: ${error.message}`, "error");
    } finally {
        this.hideLoading();
    }
}
    // Create answer navigation
  createAnswerNavigation() {
    const questionNavGrid = document.getElementById("questionNavGrid");
    if (!questionNavGrid) {
        this.showAlert("Lỗi giao diện: Không tìm thấy phần tử điều hướng", "error");
        return;
    }

    if (!Array.isArray(this.currentQuestions) || this.currentQuestions.length === 0) {
        this.showAlert("Không có câu hỏi nào để hiển thị", "warning");
        questionNavGrid.innerHTML = "<div>Chưa có câu hỏi</div>";
        return;
    }

    const answers = Array.isArray(this.currentStudentAnswers) ? this.currentStudentAnswers : [];
    const answerMap = new Map(answers.map(ans => [ans.questionId, ans]));
    let correctCount = 0, wrongCount = 0, unansweredCount = this.currentQuestions.length;

    questionNavGrid.innerHTML = this.currentQuestions.map((question, index) => {
        if (!question.id) {
            console.warn(`Câu hỏi tại chỉ số ${index} thiếu ID`, question);
            return "";
        }
        const answer = answerMap.get(question.id);
        let statusClass = "unanswered";
        if (answer && answer.answered) {
            unansweredCount--;
            statusClass = answer.correct ? "correct" : "wrong";
            answer.correct ? correctCount++ : wrongCount++;
        }
        return `
            <div class="question-nav-item ${statusClass}" data-index="${index}" role="button" aria-label="Câu hỏi ${index + 1}: ${statusClass}">
                ${index + 1}
            </div>
        `;
    }).filter(item => item).join("");

    const updateStat = (id, count) => {
        const element = document.getElementById(id);
        if (element) element.textContent = count;
        else console.warn(`Không tìm thấy phần tử ${id}`);
    };
    updateStat("correctAnswersCount", correctCount);
    updateStat("wrongAnswersCount", wrongCount);
    updateStat("unansweredCount", unansweredCount);
}
    // Show specific answer detail
 showAnswerDetail(index) {
    if (!Array.isArray(this.currentQuestions) || index >= this.currentQuestions.length) {
        this.showAlert("Không có câu hỏi để hiển thị", "warning");
        return;
    }
    const question = this.currentQuestions[index];
    const answer = Array.isArray(this.currentStudentAnswers) 
        ? this.currentStudentAnswers.find(a => a.questionId === question.id)
        : null;
    this.updateAnswerContent(question, answer, index);
}

updateAnswerContent(question, answer, index) {
    const answerContent = document.getElementById("answerContent");
    if (!answerContent) {
        this.showAlert("Lỗi giao diện: Không tìm thấy nội dung câu trả lời", "error");
        return;
    }

    const status = answer && answer.answered
        ? answer.correct ? "Đúng" : "Sai"
        : "Chưa trả lời";
    const studentAnswer = answer && answer.answered ? answer.studentAnswer : "-";
    const safeText = str => str ? str.replace(/</g, "<").replace(/>/g, ">") : "";

    answerContent.innerHTML = `
        <div class="answer-header">
            <h3>Câu hỏi ${index + 1}</h3>
            <div class="answer-status">${status}</div>
        </div>
        <div class="question-text">${safeText(question.questionText)}</div>
        <div class="question-options">
            <div class="option-item ${question.correctOption === "A" ? "correct" : ""} ${studentAnswer === "A" ? "selected" : ""}">
                A. ${safeText(question.optionA)}
            </div>
            <div class="option-item ${question.correctOption === "B" ? "correct" : ""} ${studentAnswer === "B" ? "selected" : ""}">
                B. ${safeText(question.optionB)}
            </div>
            <div class="option-item ${question.correctOption === "C" ? "correct" : ""} ${studentAnswer === "C" ? "selected" : ""}">
                C. ${safeText(question.optionC)}
            </div>
            <div class="option-item ${question.correctOption === "D" ? "correct" : ""} ${studentAnswer === "D" ? "selected" : ""}">
                D. ${safeText(question.optionD)}
            </div>
        </div>
        <div class="answer-meta">
            <div>Đáp án của học sinh: ${safeText(studentAnswer)}</div>
            <div>Đáp án đúng: ${safeText(question.correctOption)}</div>
        </div>
    `;
}

// Hàm hỗ trợ cập nhật pagination
    updateResultsPagination() {
        const pagination = document.getElementById("resultsPagination");
        const totalPages = Math.ceil(this.currentResults.length / 10); // 10 kết quả/trang

        pagination.style.display = "block";
        const pageList = pagination.querySelector("ul");
        pageList.innerHTML = "";

        for (let i = 1; i <= totalPages; i++) {
            const li = document.createElement("li");
            li.className = `page-item ${i === this.currentPage ? 'active' : ''}`;
            li.innerHTML = `<a class="page-link" href="#" onclick="testManager.changeResultsPage(${i})">${i}</a>`;
            pageList.appendChild(li);
        }
    }

// Các hàm helper
    formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
    }

    getSubmissionStatus(status) {
        const statusMap = {
            'completed': 'Hoàn thành',
            'in_progress': 'Đang làm',
            'pending': 'Chưa bắt đầu'
        };
        return statusMap[status] || status;
    }

    formatDate(dateString) {
        return new Date(dateString).toLocaleDateString('vi-VN');
    }
    // Show add question form
    showAddQuestionForm() {
        const addForm = document.getElementById("addQuestionForm");
        const questionContent = document.getElementById("questionContent");

        if (addForm && questionContent) {
            questionContent.style.display = "none";
            addForm.style.display = "block";

            // Clear form
            document.getElementById("addQuestionText").value = "";
            const optionInputs = document.querySelectorAll("#addQuestionForm .option-input-add");
            optionInputs.forEach((input) => (input.value = ""));

            // Clear radio buttons
            const radioButtons = document.querySelectorAll('input[name="correctAnswerAdd"]');
            radioButtons.forEach((radio) => (radio.checked = false));
        }
    }

    // Hide add question form
    hideAddQuestionForm() {
        const addForm = document.getElementById("addQuestionForm");
        const questionContent = document.getElementById("questionContent");

        if (addForm && questionContent) {
            addForm.style.display = "none";
            questionContent.style.display = "block";
        }
    }

    // Save new question
    async saveNewQuestion() {
        // Get form data
        const questionText = document.getElementById("addQuestionText").value.trim();
        const optionInputs = document.querySelectorAll("#addQuestionForm .option-input-add");
        const correctAnswer = document.querySelector('input[name="correctAnswerAdd"]:checked');

        // Validation
        if (!questionText) {
            this.showAlert("Vui lòng nhập nội dung câu hỏi", "warning");
            return;
        }

        if (!correctAnswer) {
            this.showAlert("Vui lòng chọn đáp án đúng", "warning");
            return;
        }

        // Check if all options are filled
        for (let i = 0; i < optionInputs.length; i++) {
            if (!optionInputs[i].value.trim()) {
                this.showAlert(`Vui lòng nhập đáp án ${String.fromCharCode(65 + i)}`, "warning");
                return;
            }
        }

        // Create new question object
        const newQuestion = {
            questionText: questionText,
            optionA: optionInputs[0].value.trim(),
            optionB: optionInputs[1].value.trim(),
            optionC: optionInputs[2].value.trim(),
            optionD: optionInputs[3].value.trim(),
            correctOption: correctAnswer.value,
            mark: 1.0,
            entityType: "test",
            entityID: this.currentTest.id
        };

        try {
            this.showLoading("Đang thêm câu hỏi...");

            const response = await fetch("/Hikari/AddQuestionServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(newQuestion)
            });

            if (response.ok) {
                const result = await response.json();

                // Add to local array
                newQuestion.id = result.questionId;
                this.currentQuestions.push(newQuestion);

                // Update navigation
                this.createQuestionNavigation();

                // Show the new question
                this.showQuestion(this.currentQuestions.length - 1);
                this.hideAddQuestionForm();

                this.showAlert("Thêm câu hỏi thành công!", "success");
            } else {
                const errorData = await response.json();
                this.showAlert(errorData.message || "Lỗi khi thêm câu hỏi", "error");
            }
        } catch (error) {
            console.error("Error adding question:", error);
            this.showAlert("Lỗi khi thêm câu hỏi: " + error.message, "error");
        } finally {
            this.hideLoading();
        }
    }

    // Save question edit
    async saveQuestionEdit() {
        const question = this.currentQuestions[this.currentQuestionIndex];

        // Get form data
        const questionText = document.getElementById("editQuestionText").value.trim();
        const optionInputs = document.querySelectorAll("#editQuestionForm .option-input");
        const correctAnswer = document.querySelector('input[name="correctAnswer"]:checked');

        // Validation
        if (!questionText) {
            this.showAlert("Vui lòng nhập nội dung câu hỏi", "warning");
            return;
        }

        if (!correctAnswer) {
            this.showAlert("Vui lòng chọn đáp án đúng", "warning");
            return;
        }

        // Update question object
        const updatedQuestion = {
            ...question,
            questionText: questionText,
            optionA: optionInputs[0].value.trim(),
            optionB: optionInputs[1].value.trim(),
            optionC: optionInputs[2].value.trim(),
            optionD: optionInputs[3].value.trim(),
            correctOption: correctAnswer.value
        };

        try {
            this.showLoading("Đang lưu câu hỏi...");

            const response = await fetch("/Hikari/UpdateQuestionServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(updatedQuestion)
            });

            if (response.ok) {
                // Update local data
                this.currentQuestions[this.currentQuestionIndex] = updatedQuestion;

                // Refresh display
                this.updateQuestionContent(updatedQuestion, this.currentQuestionIndex);
                this.hideEditQuestionForm();

                this.showAlert("Cập nhật câu hỏi thành công!", "success");
            } else {
                const errorData = await response.json();
                this.showAlert(errorData.message || "Lỗi khi cập nhật câu hỏi", "error");
            }
        } catch (error) {
            console.error("Error updating question:", error);
            this.showAlert("Lỗi khi cập nhật câu hỏi: " + error.message, "error");
        } finally {
            this.hideLoading();
        }
    }

    // Delete question
    async deleteQuestion(questionId) {
        if (!confirm("Bạn có chắc chắn muốn xóa câu hỏi này?")) {
            return;
        }

        try {
            this.showLoading("Đang xóa câu hỏi...");

            const response = await fetch("/Hikari/DeleteQuestionServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({questionId: questionId})
            });

            if (response.ok) {
                // Remove from local array
                this.currentQuestions = this.currentQuestions.filter((q) => q.id !== questionId);

                // Update navigation
                this.createQuestionNavigation();

                // Show previous question or first question or empty state
                if (this.currentQuestions.length > 0) {
                    const newIndex = Math.max(0, this.currentQuestionIndex - 1);
                    this.showQuestion(newIndex);
                } else {
                    this.showEmptyQuestionState();
                }

                this.showAlert("Xóa câu hỏi thành công!", "success");
            } else {
                const errorData = await response.json();
                this.showAlert(errorData.message || "Lỗi khi xóa câu hỏi", "error");
            }
        } catch (error) {
            console.error("Error deleting question:", error);
            this.showAlert("Lỗi khi xóa câu hỏi: " + error.message, "error");
        } finally {
            this.hideLoading();
        }
    }

    // Search functionality
    setupSearchFunctionality() {
        const searchInput = document.getElementById("searchInput");
        if (searchInput) {
            searchInput.addEventListener("input", (e) => {
                this.filterTests(e.target.value);
            });
        }
    }

    // Filter tests based on search term
    filterTests(searchTerm) {
        const testCards = document.querySelectorAll(".test-card");
        const term = searchTerm.toLowerCase();

        testCards.forEach((card) => {
            const title = card.querySelector(".test-title").textContent.toLowerCase();
            const description = card.querySelector(".test-description").textContent.toLowerCase();
            const level = card.querySelector(".jlptLevel").textContent.toLowerCase();

            const matches = title.includes(term) || description.includes(term) || level.includes(term);
            card.style.display = matches ? "block" : "none";
        });
    }

    showTestPreview(questions) {
        let previewModal = document.getElementById("testPreviewModal");
        if (!previewModal) {
            previewModal = this.createTestPreviewModal();
        }

        document.getElementById("previewTotalQuestions").textContent = questions.length;
        document.getElementById("previewEstimatedDuration").value = Math.max(30, questions.length * 2);

        const questionsList = document.getElementById("previewQuestionsList");
        questionsList.innerHTML = questions
                .slice(0, Math.min(5, questions.length))
                .map(
                        (q, index) => `
        <div class="question-preview-item">
          <div class="question-number">Câu ${index + 1}:</div>
          <div class="question-text">${q.questionText}</div>
          <div class="question-options">
            <div class="option ${q.correctOption === "A" ? "correct-option" : ""}">A. ${q.optionA}</div>
            <div class="option ${q.correctOption === "B" ? "correct-option" : ""}">B. ${q.optionB}</div>
            <div class="option ${q.correctOption === "C" ? "correct-option" : ""}">C. ${q.optionC}</div>
            <div class="option ${q.correctOption === "D" ? "correct-option" : ""}">D. ${q.optionD}</div>
          </div>
          <div class="correct-answer">Đáp án đúng: ${q.correctOption}</div>
        </div>
      `,
                        )
                .join("");

        if (questions.length > 5) {
            questionsList.innerHTML += `
        <div class="more-questions">
          ... và ${questions.length - 5} câu hỏi khác
        </div>
      `;
        }

        const modal = new window.bootstrap.Modal(previewModal);
        modal.show();
    }

    createTestPreviewModal() {
        const modalHTML = `
      <div class="modal fade" id="testPreviewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Xem trước và tạo bài test</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              <div class="preview-stats">
                <div class="stat-item">
                  <span class="stat-label">Tổng số câu hỏi:</span>
                  <span class="stat-value" id="previewTotalQuestions">0</span>
                </div>
              </div>
              
              <div class="preview-questions mb-4">
                <h6>Câu hỏi mẫu:</h6>
                <div id="previewQuestionsList" style="max-height: 300px; overflow-y: auto;"></div>
              </div>
              
              <div class="test-info-form">
                <h6>Thông tin bài test:</h6>
                <div class="mb-3">
                  <label for="testTitle" class="form-label">Tiêu đề bài test *</label>
                  <input type="text" class="form-control" id="testTitle" required>
                </div>
                <div class="mb-3">
                  <label for="testDescription" class="form-label">Mô tả</label>
                  <textarea class="form-control" id="testDescription" rows="3"></textarea>
                </div>
                <div class="row">
                  <div class="col-md-6">
                    <label for="previewEstimatedDuration" class="form-label">Thời gian làm bài (phút) *</label>
                    <input type="number" class="form-control" id="previewEstimatedDuration" min="1" required>
                  </div>
                  <div class="col-md-6">
                    <label for="testJlptLevel" class="form-label">JLPT Level *</label>
                    <select class="form-control" id="testJlptLevel" required>
                      <option value="">Chọn level</option>
                      <option value="N5">N5</option>
                      <option value="N4">N4</option>
                      <option value="N3">N3</option>
                      <option value="N2">N2</option>
                      <option value="N1">N1</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
              <button type="button" class="btn btn-primary" id="saveTestBtn">
                <i class="fas fa-save"></i> Tạo bài test
              </button>
            </div>
          </div>
        </div>
      </div>
    `;

        document.body.insertAdjacentHTML("beforeend", modalHTML);
        return document.getElementById("testPreviewModal");
    }

    async handleSaveTest() {
        const title = document.getElementById("testTitle").value.trim();
        const description = document.getElementById("testDescription").value.trim();
        const duration = document.getElementById("previewEstimatedDuration").value;
        const jlptLevel = document.getElementById("testJlptLevel").value;

        if (!title || !duration || !jlptLevel) {
            this.showAlert("Vui lòng điền đầy đủ thông tin bắt buộc", "warning");
            return;
        }

        if (!duration || duration < 1) {
            this.showAlert("Vui lòng nhập thời gian làm bài hợp lệ", "warning");
            return;
        }
        const formData = new FormData();
        formData.append("type", "test");
        formData.append("title", title);
        formData.append("description", description);
        formData.append("duration", duration);
        formData.append("jlptLevel", jlptLevel);
        formData.append("questions", JSON.stringify(this.uploadedQuestions));

        try {
            this.showLoading("Đang tạo bài test...");

            const response = await fetch("/Hikari/SaveQuestionServlet", {
                method: "POST",
                body: formData
            });

            const result = await response.json();

            if (result.status === "success") {
                this.showAlert("Tạo bài test thành công!", "success");

                const modal = window.bootstrap.Modal.getInstance(document.getElementById("testPreviewModal"));
                modal.hide();

                this.clearForm();

                // Reload page to show new test
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            } else {
                this.showAlert(result.message || "Lỗi khi tạo bài test", "error");
            }
        } catch (error) {
            console.error("Save error:", error);
            this.showAlert("Lỗi khi tạo bài test: " + error.message, "error");
        } finally {
            this.hideLoading();
        }
    }

    clearForm() {
        const elements = ["testTitle", "testDescription", "previewEstimatedDuration", "testJlptLevel", "excelFileInput"];
        elements.forEach((id) => {
            const element = document.getElementById(id);
            if (element)
                element.value = "";
        });
        this.uploadedQuestions = [];
    }

    showAlert(message, type = "info") {
        const alertClass =
                {
                    success: "alert-success",
                    error: "alert-danger",
                    warning: "alert-warning",
                    info: "alert-info"
                }[type] || "alert-info";

        const iconClass =
                {
                    success: "fa-check-circle",
                    error: "fa-exclamation-circle",
                    warning: "fa-exclamation-triangle",
                    info: "fa-info-circle"
                }[type] || "fa-info-circle";

        const alertHTML = `
      <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
           style="top: 20px; right: 20px; z-index: 9999; min-width: 300px;" role="alert">
        <i class="fas ${iconClass} me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    `;

        document.body.insertAdjacentHTML("beforeend", alertHTML);

        setTimeout(() => {
            const alerts = document.querySelectorAll(".alert");
            alerts.forEach((alert) => {
                if (alert.textContent.includes(message)) {
                    alert.remove();
                }
            });
        }, 5000);
    }

    showLoading(message = "Đang xử lý...") {
        const loadingHTML = `
      <div id="loadingOverlay" class="position-fixed top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center" 
           style="background-color: rgba(0,0,0,0.5); z-index: 9999;">
        <div class="bg-white p-4 rounded shadow text-center">
          <div class="spinner-border text-primary mb-3" role="status"></div>
          <div>${message}</div>
        </div>
      </div>
    `;

        document.body.insertAdjacentHTML("beforeend", loadingHTML);
    }

    hideLoading() {
        const loading = document.getElementById("loadingOverlay");
        if (loading) {
            loading.remove();
        }
    }
}

// Global instance
let testManager;

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
    testManager = new TestManager();
});

// Global functions for existing buttons
function editTest(testId) {
    if (testManager) {
        testManager.editTest(testId);
    }
}

function viewResults(testId) {
    if (testManager) {
        testManager.viewResults(testId);
    }
}

// Additional utility functions
function confirmDelete(testId) {
    if (confirm("Bạn có chắc chắn muốn xóa bài test này?")) {
        deleteTest(testId);
    }
}

async function deleteTest(testId) {
    try {
        testManager.showLoading("Đang xóa bài test...");

        const response = await fetch("/Hikari/DeleteTest", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({testId: testId})
        });

        if (response.ok) {
            testManager.showAlert("Xóa bài test thành công!", "success");
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        } else {
            const errorData = await response.json();
            testManager.showAlert(errorData.message || "Lỗi khi xóa bài test", "error");
        }
    } catch (error) {
        console.error("Error deleting test:", error);
        testManager.showAlert("Lỗi khi xóa bài test: " + error.message, "error");
    } finally {
        testManager.hideLoading();
    }
}


