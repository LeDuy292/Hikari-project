document.addEventListener("DOMContentLoaded", () => {
  initializeForm();
  initializeExcelUpload(); // Sửa lỗi nhấn vào không được
  initializeDurationSync();
  if (document.querySelectorAll(".question-item").length === 0) {
    addQuestion();
  }
});

// Lấy context path một cách an toàn
function getContextPath() {
  return document.body.dataset.contextPath || "/Hikari";
}

// Khởi tạo form submit
function initializeForm() {
  const form = document.getElementById("createTestForm");
  if (form) {
    form.addEventListener("submit", handleFormSubmit);
  }
}

// Đồng bộ hóa thời lượng
function initializeDurationSync() {
  const durationInput = document.getElementById("duration");
  if (durationInput) {
    durationInput.addEventListener("input", updateDurationStats);
  }
}

// Cập nhật thống kê thời lượng
function updateDurationStats() {
  const duration = document.getElementById("duration").value;
  const statsDuration = document.getElementById("statsDuration");
  if (statsDuration) {
    statsDuration.textContent = duration || "N/A";
  }
}

/**
 * Xử lý sự kiện submit form duy nhất
 */
function handleFormSubmit(event) {
  event.preventDefault();
  const form = event.target;
  const submitBtn = form.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;

  submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
  submitBtn.disabled = true;

  const questions = collectQuestionsData();
  if (questions.length === 0) {
    showNotification("Vui lòng thêm ít nhất một câu hỏi.", "error");
    resetSubmitButton(submitBtn, originalText);
    return;
  }
  if (!form.checkValidity()) {
    form.reportValidity();
    showNotification("Vui lòng điền đầy đủ các trường bắt buộc.", "warning");
    resetSubmitButton(submitBtn, originalText);
    return;
  }

  const formData = new FormData(form);
  formData.append("type", "test");
  formData.append("questionsData", JSON.stringify(questions));
  
  // Đảm bảo taskID được gửi
  const taskID = document.querySelector('input[name="taskID"]')?.value;
  if (taskID) {
    formData.set("taskID", taskID);
  }

  const totalMarks = questions.reduce((sum, q) => sum + parseFloat(q.mark || 1), 0);
  formData.set("totalQuestions", questions.length);
  formData.set("totalMark", totalMarks.toFixed(1));

  console.log("=== FORM DATA TO BE SENT ===");
  for (let [key, value] of formData.entries()) {
    console.log(`${key}: ${value}`);
  }

  const createUrl = `${getContextPath()}/taskTest`;
  fetch(createUrl, {
    method: "POST",
    body: formData,
  })
    .then(async (response) => {
      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.message || `Lỗi HTTP: ${response.status}`);
      }
      return data;
    })
    .then((data) => {
      if (data.status === "success") {
        showNotification("Tạo bài test thành công! Task đã được cập nhật thành Submitted.", "success");
        setTimeout(() => {
          window.location.href = `${getContextPath()}/teacher/tasks`;
        }, 1500);
      } else {
        showNotification(data.message, "error");
      }
    })
    .catch((error) => {
      console.error("Lỗi khi tạo bài test:", error);
      showNotification("Có lỗi xảy ra: " + error.message, "error");
    })
    .finally(() => {
      resetSubmitButton(submitBtn, originalText);
    });
}

function resetSubmitButton(submitBtn, originalText) {
  submitBtn.innerHTML = originalText;
  submitBtn.disabled = false;
}

function collectQuestionsData() {
  const questions = [];
  document.querySelectorAll(".question-item").forEach((item) => {
    const questionText = item.querySelector(`textarea[name$=".questionText"]`)?.value.trim();
    const optionA = item.querySelector(`input[name$=".optionA"]`)?.value.trim();
    const optionB = item.querySelector(`input[name$=".optionB"]`)?.value.trim();
    const optionC = item.querySelector(`input[name$=".optionC"]`)?.value.trim();
    const optionD = item.querySelector(`input[name$=".optionD"]`)?.value.trim();
    const correctOption = item.querySelector(`select[name$=".correctOption"]`)?.value;
    const markValue = item.querySelector(`input[name$=".mark"]`)?.value;
    const mark = parseFloat(markValue) || 0;

    if (questionText && optionA && optionB && optionC && optionD && correctOption) {
      questions.push({
        questionText, optionA, optionB, optionC, optionD, correctOption, mark
      });
    }
  });
  return questions;
}

// ✅ SỬA LỖI UPLOAD EXCEL TẠI ĐÂY
function initializeExcelUpload() {
  const excelFileInput = document.getElementById("excelFile");
  const excelUploadArea = document.getElementById("excelUploadArea"); // Phần tử để người dùng nhấn vào

  if (excelFileInput && excelUploadArea) {
    // Khi người dùng nhấn vào khu vực upload
    excelUploadArea.addEventListener("click", () => {
      excelFileInput.click(); // Mở hộp thoại chọn file
    });

    // Xử lý khi người dùng đã chọn file
    excelFileInput.addEventListener("change", function () {
      if (this.files.length > 0) {
        const uploadUrl = `${getContextPath()}/UploadFileExcel`;
        handleExcelFile(this.files[0], uploadUrl);
      }
    });
  }
}

function handleExcelFile(file, url) {
  if (!file.type.includes("spreadsheetml") && !file.type.includes("ms-excel")) {
    showNotification("Định dạng file không hợp lệ. Vui lòng chọn file Excel.", "error");
    return;
  }

  const formData = new FormData();
  formData.append("excelFile", file);
  showNotification("Đang xử lý file Excel...", "info");

  fetch(url, {
    method: "POST",
    body: formData,
  })
    .then(async (response) => {
      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.message || "Lỗi khi tải file lên.");
      }
      return data;
    })
    .then((questions) => {
      if (Array.isArray(questions) && questions.length > 0) {
        showNotification(`Đã đọc thành công ${questions.length} câu hỏi.`, "success");
        importExcelQuestions(questions); // Import và hiển thị câu hỏi
      } else {
        throw new Error("File Excel rỗng hoặc không đúng định dạng.");
      }
    })
    .catch((error) => {
      showNotification(error.message, "error");
    });
}

function importExcelQuestions(questions) {
  const questionsList = document.getElementById("questionsList");
  questionsList.innerHTML = ""; // Xóa các câu hỏi cũ
  questions.forEach((question) => {
    addQuestion(question); // Thêm từng câu hỏi vào giao diện
  });
  document.getElementById("manual-tab").click();
}

function updateTestStats() {
    const questions = collectQuestionsData();
    const totalQuestions = questions.length;
    // Tổng điểm luôn là 100
    const totalPoints = 100.0;

    document.getElementById("statsQuestions").textContent = totalQuestions;
    document.getElementById("statsPoints").textContent = totalPoints.toFixed(1);
    updateDurationStats();

    document.querySelector('input[name="totalQuestions"]').value = totalQuestions;
    // Hardcode tổng điểm là 100
    document.querySelector('input[name="totalMark"]').value = totalPoints.toFixed(1);
    
    const statsSection = document.getElementById("assignmentStats");
    if (statsSection) {
        statsSection.style.display = "block";
    }
}


// ✅ THÊM HÀM TỰ ĐỘNG TÍNH ĐIỂM
function updateQuestionPoints() {
  const TOTAL_SCORE = 100.0;
  const questionItems = document.querySelectorAll(".question-item");
  const questionCount = questionItems.length;

  if (questionCount > 0) {
    const pointsPerQuestion = (TOTAL_SCORE / questionCount).toFixed(2); // Chia điểm và làm tròn 2 chữ số
    questionItems.forEach(item => {
      const markInput = item.querySelector('input[name$=".mark"]');
      if (markInput) {
        markInput.value = pointsPerQuestion;
      }
    });
  }
  // Cập nhật lại các thống kê tổng quan
  updateTestStats();
}

// ✅ CẬP NHẬT HÀM ADDQUESTION
function addQuestion(question = {}) {
  const questionsList = document.getElementById("questionsList");
  const questionCount = questionsList.children.length;

  const questionDiv = document.createElement("div");
  questionDiv.className = "question-item border rounded p-3 mb-3";
  // Thêm 'readonly' vào input của điểm
  questionDiv.innerHTML = `
    <div class="d-flex justify-content-between align-items-center mb-2">
      <h6 class="mb-0">Câu hỏi ${questionCount + 1}</h6>
      <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeQuestion(this)"><i class="fas fa-trash"></i></button>
    </div>
    <div class="form-group mb-2"><textarea class="form-control" name="questions[${questionCount}].questionText" required rows="2" placeholder="Nội dung câu hỏi">${question.questionText || ""}</textarea></div>
    <div class="row">
      <div class="col-md-6 mb-2"><input type="text" class="form-control" name="questions[${questionCount}].optionA" value="${question.optionA || ""}" required placeholder="Đáp án A"></div>
      <div class="col-md-6 mb-2"><input type="text" class="form-control" name="questions[${questionCount}].optionB" value="${question.optionB || ""}" required placeholder="Đáp án B"></div>
      <div class="col-md-6 mb-2"><input type="text" class="form-control" name="questions[${questionCount}].optionC" value="${question.optionC || ""}" required placeholder="Đáp án C"></div>
      <div class="col-md-6 mb-2"><input type="text" class="form-control" name="questions[${questionCount}].optionD" value="${question.optionD || ""}" required placeholder="Đáp án D"></div>
    </div>
    <div class="row">
      <div class="col-md-6"><select class="form-control" name="questions[${questionCount}].correctOption" required><option value="">Đáp án đúng</option><option value="A" ${question.correctOption === "A" ? "selected" : ""}>A</option><option value="B" ${question.correctOption === "B" ? "selected" : ""}>B</option><option value="C" ${question.correctOption === "C" ? "selected" : ""}>C</option><option value="D" ${question.correctOption === "D" ? "selected" : ""}>D</option></select></div>
      <div class="col-md-6"><input type="number" class="form-control question-point" name="questions[${questionCount}].mark" value="1" readonly></div>
    </div>
  `;
  questionsList.appendChild(questionDiv);
  
  renumberQuestions(); // Đánh số lại và chia lại điểm
}

// ✅ CẬP NHẬT HÀM REMOVEQUESTION
function removeQuestion(button) {
  button.closest(".question-item").remove();
  renumberQuestions(); // Đánh số lại và chia lại điểm
}

function renumberQuestions() {
  document.querySelectorAll(".question-item").forEach((item, index) => {
    item.querySelector("h6").textContent = `Câu hỏi ${index + 1}`;
    item.querySelectorAll("[name^='questions']").forEach(el => {
      const oldName = el.getAttribute("name");
      if (oldName) {
        const newName = oldName.replace(/questions\[\d+\]/, `questions[${index}]`);
        el.setAttribute("name", newName);
      }
    });
  });

  // Chia lại điểm sau khi đã cập nhật số lượng câu hỏi
  updateQuestionPoints();

  if (document.querySelectorAll(".question-item").length === 0) {
    // Không thêm câu hỏi mới tự động để tránh vòng lặp vô hạn
    updateTestStats(); // Chỉ cần cập nhật stats về 0
  }
}

function showNotification(message, type = "info") {
    let container = document.getElementById("notification-container");
    if (!container) {
        container = document.createElement("div");
        container.id = "notification-container";
        container.style.cssText = "position: fixed; top: 20px; right: 20px; z-index: 9999;";
        document.body.appendChild(container);
    }
    const alert = document.createElement("div");
    alert.className = `alert alert-${type === 'error' ? 'danger' : type} alert-dismissible fade show`;
    alert.role = "alert";
    alert.innerHTML = `${message}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>`;
    container.appendChild(alert);
    setTimeout(() => {
        alert.classList.remove('show');
        setTimeout(() => alert.remove(), 150);
    }, 3000);
}