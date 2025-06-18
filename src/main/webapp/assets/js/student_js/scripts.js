document.addEventListener('DOMContentLoaded', () => {
    const courseList = document.getElementById('courseList');
    const prevPageBtn = document.getElementById('prevPage');
    const nextPageBtn = document.getElementById('nextPage');
    const pageNumbers = document.getElementById('pageNumbers');
    const errorMessage = document.getElementById('errorMessage');
    const searchInput = document.querySelector('input[placeholder="Tìm kiếm..."]');
    const enrolledCoursesBtn = document.getElementById('enrolledCoursesBtn');
    const itemsPerPage = 4;
    let currentPage = 1;
    let totalPages = 1;

    // Function to create course card HTML
    function createCourseCard(course) {
        return `
            <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
                <img src="${course.image || '${pageContext.request.contextPath}/assets/img/img_student/course.jpg'}" alt="Course" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
                <h3 class="font-semibold text-lg">${course.title || 'Không có tiêu đề'}</h3>
                <p class="text-gray-500 text-sm">Giảng viên: ${course.instructor || 'Không rõ'}</p>
                <p class="text-gray-500 text-sm mb-2">Nội dung: ${course.content || 'Không có nội dung'}</p>
                <div class="flex justify-between items-center mt-2">
                    <span class="price">$ ${course.price || 0}</span>
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

    // Function to fetch courses from backend
    function fetchCourses(search = '', sortBy = 'newest') {
        const url = `${window.location.pathname.split('/')[0]}/courses?page=${currentPage}&search=${encodeURIComponent(search)}&sortBy=${sortBy}`;
        courseList.style.opacity = '0';
        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                courseList.innerHTML = '';
                errorMessage.classList.add('hidden');
                if (data.courses && data.courses.length > 0) {
                    data.courses.forEach(course => {
                        courseList.insertAdjacentHTML('beforeend', createCourseCard({
                            title: course.title,
                            instructor: course.instructor || 'Không rõ',
                            content: course.description || 'Không có nội dung',
                            price: course.fee || 0,
                            image: course.isActive ? `${window.location.pathname.split('/')[0]}/assets/img/courses/${course.courseID}.jpg` : `${window.location.pathname.split('/')[0]}/assets/img/img_student/course.jpg`
                        }));
                    });
                } else {
                    courseList.innerHTML = '<p class="text-center text-gray-500">Không có khóa học nào.</p>';
                }
                totalPages = data.totalPages || 1;
                updatePagination();
                setTimeout(() => {
                    courseList.style.opacity = '1';
                }, 300);
            })
            .catch(error => {
                console.error('Error fetching courses:', error);
                errorMessage.textContent = error.message || 'Có lỗi xảy ra khi tải dữ liệu. Vui lòng thử lại!';
                errorMessage.classList.remove('hidden');
                courseList.innerHTML = '';
                totalPages = 1;
                updatePagination();
            });
    }

    // Function to update pagination
    function updatePagination() {
        pageNumbers.innerHTML = '';
        prevPageBtn.disabled = currentPage === 1;
        nextPageBtn.disabled = currentPage === totalPages;
        for (let i = 1; i <= totalPages; i++) {
            pageNumbers.innerHTML += `
                <button class="page-number ${currentPage === i ? 'active' : ''}" data-page="${i}">
                    ${i}
                </button>
            `;
        }
        document.querySelectorAll('.page-number').forEach(button => {
            button.addEventListener('click', () => {
                currentPage = parseInt(button.dataset.page);
                fetchCourses(searchInput.value);
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

    // Event listeners
    prevPageBtn.addEventListener('click', () => {
        if (currentPage > 1) {
            currentPage--;
            fetchCourses(searchInput.value);
        }
    });

    nextPageBtn.addEventListener('click', () => {
        if (currentPage < totalPages) {
            currentPage++;
            fetchCourses(searchInput.value);
        }
    });

    document.querySelector('.custom-active-btn').addEventListener('click', () => {
        currentPage = 1;
        fetchCourses(searchInput.value, 'newest');
    });

    enrolledCoursesBtn.addEventListener('click', () => {
        currentPage = 1;
        fetchCourses(searchInput.value, 'enrolled');
    });

    searchInput.addEventListener('input', (e) => {
        currentPage = 1;
        fetchCourses(e.target.value);
    });

    // Initialize the page
    fetchCourses();
});