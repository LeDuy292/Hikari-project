// Placeholder for dynamic data - replace with API call or server-side data
let classes = []; // To be populated from backend (e.g., via fetch or JSP/JSTL)
let selectedClass = null;

// Render classes table
function renderClasses(data) {
    const tbody = document.getElementById("classTableBody");
    tbody.innerHTML = "";

    data.forEach((item) => {
        const row = document.createElement("tr");
        row.className = "section-card";
        row.innerHTML = `
            <td>${item.name}</td>
            <td>${item.time}</td>
            <td>${item.days}</td>
            <td>${item.sessions}</td>
            <td>${item.studentsCount}</td>
            <td>${item.course}</td>
            <td>
              <button class="btn btn-sm btn-accent" onclick="showStudentView(${item.id})">
                <i class="fas fa-eye"></i> Xem Chi Tiết
              </button>
            </td>
          `;
        tbody.appendChild(row);
    });
}

// Search functionality
document.getElementById("searchInput").addEventListener("input", (e) => {
    const searchTerm = e.target.value.toLowerCase();
    const filteredClasses = classes.filter(
        (c) =>
            c.name.toLowerCase().includes(searchTerm) ||
            c.course.toLowerCase().includes(searchTerm) ||
            c.days.toLowerCase().includes(searchTerm)
    );
    renderClasses(filteredClasses);
});

// Show student view
function showStudentView(classId) {
    selectedClass = classes.find((c) => c.id === classId);
    document.getElementById("classView").style.display = "none";
    document.getElementById("studentView").style.display = "block";
    document.getElementById("selectedClassName").textContent = selectedClass.name;

    const tbody = document.getElementById("studentTableBody");
    tbody.innerHTML = "";

    selectedClass.students.forEach((student) => {
        const row = document.createElement("tr");
        row.className = "section-card";
        const progressElement = `<div class="progress-bar"><div class="progress" style="width: ${student.progress}%" data-progress="${student.progress}"></div></div>`;
        row.innerHTML = `
            <td>${student.name}</td>
            <td>${student.email}</td>
            <td>${progressElement}</td>
            <td>
              <button class="btn btn-sm btn-accent" data-bs-toggle="modal" data-bs-target="#studentDetailsModal" onclick="showStudentSubmissions(${student.id})">
                <a href="${pageContext.request.contextPath}/view/teacher/grade.jsp""><i class="fas fa-eye"></i> Xem Bài Làm
                
              </button>
            </td>
            <td>
              <button class="btn btn-sm btn-accent" onclick="sendMessage(${student.id}, '${student.email}')">
                <a href="${pageContext.request.contextPath}/view/notification/message.jsp""><i class="fas fa-envelope"></i> Nhắn Tin
              </button>
            </td>
          `;
        tbody.appendChild(row);

        // Set progress bar color based on percentage
        const progressBar = row.querySelector('.progress');
        const progressValue = student.progress;
        if (progressValue >= 70) {
            progressBar.classList.add('green');
        } else if (progressValue >= 40) {
            progressBar.classList.add('yellow');
        } else {
            progressBar.classList.add('red');
        }
    });
}

// Show class view
function showClassView() {
    document.getElementById("studentView").style.display = "none";
    document.getElementById("classView").style.display = "block";
    selectedClass = null;
    renderClasses(classes);
}

// Show student submissions
function showStudentSubmissions(studentId) {
    const student = selectedClass.students.find((s) => s.id === studentId);
    document.getElementById("studentName").textContent = student.name;
    document.getElementById("studentEmail").textContent = `Email: ${student.email}`;
    document.getElementById("studentProgress").style.width = `${student.progress}%`;
    document.getElementById("progressText").textContent = `Hoàn thành: ${student.progress}%`;

    const testSubmissions = document.getElementById("testSubmissions");
    testSubmissions.innerHTML = "";
    student.tests.forEach((test) => {
        const li = document.createElement("li");
        li.textContent = `${test.testName}: ${test.submission}`;
        testSubmissions.appendChild(li);
    });
}

// Send message (placeholder function)
function sendMessage(studentId, email) {
    alert(`Gửi tin nhắn đến ${email} (Student ID: ${studentId}). Vui lòng tích hợp logic nhắn tin thực tế tại đây!`);
}

// Initial render - to be replaced with dynamic data fetch
// Example: fetch('/api/classes').then(response => response.json()).then(data => { classes = data; renderClasses(classes); });
renderClasses(classes);