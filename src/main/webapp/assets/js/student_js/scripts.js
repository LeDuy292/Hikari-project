
// Sample course data
const courses = [
    {title: "Tài liệu", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/study.jpg"},
    {title: "Future plans", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Passives", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Quantifiers", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Modal verbs", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Stative verbs", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Intensifiers", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Adjective order", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Vocabulary", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"},
    {title: "Grammar", instructor: "abcxyz", content: "abcxyz", price: 20, image: "${pageContext.request.contextPath}/assets/img/img_student/course.jpg"}
];

const itemsPerPage = 4;
let currentPage = 1;

// Function to create course card HTML
function createCourseCard(course) {
    return `
        <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
    <img src="${course.image}" alt="Course" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
    <h3 class="font-semibold text-lg">${course.title}</h3>
    <p class="text-gray-500 text-sm">Giảng viên: ${course.instructor}</p>
    <p class="text-gray-500 text-sm mb-2">Nội dung: ${course.content}</p>
    <div class="flex justify-between items-center mt-2">
        <span class="price">$ ${course.price}</span>
        <div class="flex items-center space-x-2">
            <button class="text-sm custom-active-btn px-4 py-1 rounded-full font-semibold shadow hover:shadow-lg transition">Xem chi tiết</button>
            <button class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" title="Thêm vào giỏ hàng">
                <i class="fa fa-shopping-cart"></i>
            </button>
        </div>
    </div>
</div>
`;
}

// Function to display courses for current page
function displayCourses() {
    const courseList = document.getElementById('courseList');
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const coursesToShow = courses.slice(startIndex, endIndex);
    courseList.style.opacity = '0';
    setTimeout(() => {
        courseList.innerHTML = coursesToShow.map(course => createCourseCard(course)).join('');
        courseList.style.opacity = '1';
    }, 300);
}

// Function to update pagination
function updatePagination() {
    const totalPages = Math.ceil(courses.length / itemsPerPage);
    const pageNumbers = document.getElementById('pageNumbers');
    const prevButton = document.getElementById('prevPage');
    const nextButton = document.getElementById('nextPage');
    prevButton.disabled = currentPage === 1;
    nextButton.disabled = currentPage === totalPages;
    let pageNumbersHTML = '';
    for (let i = 1; i <= totalPages; i++) {
        pageNumbersHTML += `
    <button class="page-number ${currentPage === i ? 'active' : ''}" data-page="${i}">
      ${i}
    </button>
  `;
    }
    pageNumbers.innerHTML = pageNumbersHTML;
    document.querySelectorAll('.page-number').forEach(button => {
        button.addEventListener('click', () => {
            currentPage = parseInt(button.dataset.page);
            displayCourses();
            updatePagination();
        });
    });
}

// Modal control functions
function openModal() {
    document.getElementById('signupModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('signupModal').style.display = 'none';
}

// Close modal when clicking outside
window.onclick = function (event) {
    const modal = document.getElementById('signupModal');
    if (event.target === modal) {
        closeModal();
    }
}

// Initialize the page
displayCourses();
updatePagination();

