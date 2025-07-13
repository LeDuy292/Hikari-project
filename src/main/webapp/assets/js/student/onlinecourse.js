const itemsPerPage = 4;
let currentPage = 1;
let currentTab = initialCourseType; // Từ JSP: 'paid' hoặc 'studying'



// Hàm hiển thị nội dung dựa trên tab và trang hiện tại
function displayContent() {
  const contentArea = document.getElementById('contentArea');
  const bannerTitle = document.getElementById('bannerTitle');
  const bannerSubtitle = document.getElementById('bannerSubtitle');
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;

  // Lọc khóa học theo tab
  let coursesToShow = coursesData.filter(course => 
    currentTab === 'paid' || (currentTab === 'studying' && course.progress > 0)
  ).slice(startIndex, endIndex);

  contentArea.style.opacity = '0';
  setTimeout(() => {
    contentArea.innerHTML = coursesToShow.length
      ? coursesToShow.map(course => {
          if (currentTab === 'paid') return createPaidCourseCard(course);
          return createStudyingCourseCard(course);
        }).join('')
      : '<p class="text-gray-500 text-center col-span-full">Không tìm thấy khoá học nào.</p>';
    contentArea.style.opacity = '1';
  }, 300);

  // Cập nhật tiêu đề banner
  if (currentTab === 'paid') {
    if (bannerTitle) bannerTitle.textContent = 'Khóa học mới';
    if (bannerSubtitle) bannerSubtitle.textContent = 'Bộ khóa học chất lượng cao dành riêng cho bạn';
  } else if (currentTab === 'studying') {
    if (bannerTitle) bannerTitle.textContent = 'Khóa đang học';
    if (bannerSubtitle) bannerSubtitle.textContent = 'Tiếp tục hành trình học tiếng Nhật của bạn';
  }

  // Cập nhật trạng thái tab
  document.getElementById('paidDocsTab').classList.toggle('active', currentTab === 'paid');
  document.getElementById('studyingDocsTab').classList.toggle('active', currentTab === 'studying');
}

// Hàm cập nhật phân trang
function updatePagination() {
  const totalItems = coursesData.filter(course => 
    currentTab === 'paid' || (currentTab === 'studying' && course.progress > 0)
  ).length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const pageNumbers = document.getElementById('pageNumbers');
  const prevButton = document.getElementById('prevPage');
  const nextButton = document.getElementById('nextPage');

  prevButton.disabled = currentPage === 1;
  nextButton.disabled = currentPage === totalPages;

  prevButton.classList.toggle('disabled', prevButton.disabled);
  nextButton.classList.toggle('disabled', nextButton.disabled);

  let pageNumbersHTML = '';
  for (let i = 1; i <= totalPages; i++) {
    pageNumbersHTML += `
      <button class="page-number px-3 py-1 rounded-full ${currentPage === i ? 'bg-orange-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-orange-100'}"
              data-page="${i}">
        ${i}
      </button>
    `;
  }
  pageNumbers.innerHTML = pageNumbersHTML;

  document.querySelectorAll('.page-number').forEach(button => {
    button.addEventListener('click', () => {
      currentPage = parseInt(button.dataset.page);
      displayContent();
      updatePagination();
    });
  });
}

// Logic chuyển tab
document.getElementById('paidDocsTab').addEventListener('click', () => {
  currentTab = 'paid';
  currentPage = 1;
  displayContent();
  updatePagination();
  history.pushState(null, '', '${pageContext.request.contextPath}/courses?category=paid');
});

document.getElementById('studyingDocsTab').addEventListener('click', () => {
  currentTab = 'studying';
  currentPage = 1;
  displayContent();
  updatePagination();
  history.pushState(null, '', '${pageContext.request.contextPath}/courses?category=studying');
});

// Sự kiện phân trang
document.getElementById('prevPage').addEventListener('click', () => {
  if (currentPage > 1) {
    currentPage--;
    displayContent();
    updatePagination();
  }
});

document.getElementById('nextPage').addEventListener('click', () => {
  const totalItems = coursesData.filter(course => 
    currentTab === 'paid' || (currentTab === 'studying' && course.progress > 0)
  ).length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  if (currentPage < totalPages) {
    currentPage++;
    displayContent();
    updatePagination();
  }
});

// Khởi tạo trang
displayContent();
updatePagination();