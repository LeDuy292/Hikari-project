// Data for paid documents
const paidDocuments = [
  { id: 1, title: "Tài liệu N5", instructor: "Nguyễn Văn A", content: "Học từ vựng và ngữ pháp N5", price: 20, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 2, title: "Future Plans", instructor: "Trần Thị B", content: "Lập kế hoạch tương lai bằng tiếng Nhật", price: 25, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 3, title: "Passives", instructor: "Lê Văn C", content: "Ngữ pháp câu bị động", price: 20, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 4, title: "Quantifiers", instructor: "Phạm Thị D", content: "Cách sử dụng lượng từ", price: 22, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 5, title: "Modal Verbs", instructor: "Hoàng Văn E", content: "Động từ khuyết thiếu", price: 20, image: "image/course.jpg" },
  { id: 6, title: "Stative Verbs", instructor: "Nguyễn Thị F", content: "Động từ trạng thái", price: 20, image: "image/course.jpg" },
  { id: 7, title: "Intensifiers", instructor: "Trần Văn G", content: "Cách dùng từ tăng cường", price: 20, image: "image/course.jpg" },
  { id: 8, title: "Adjective Order", instructor: "Lê Thị H", content: "Thứ tự tính từ", price: 20, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 9, title: "Vocabulary N4", instructor: "Phạm Văn I", content: "Từ vựng trình độ N4", price: 25, image: "image/course.jpg" },
  { id: 10, title: "Grammar N4", instructor: "Hoàng Thị K", content: "Ngữ pháp trình độ N4", price: 25, image: "image/course.jpg" }
];

// Data for studying documents
const studyingDocuments = [
  { id: 1, title: "Tài liệu N5", instructor: "Nguyễn Văn A", content: "Học từ vựng và ngữ pháp N5", progress: 75, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 2, title: "Future Plans", instructor: "Trần Thị B", content: "Lập kế hoạch tương lai bằng tiếng Nhật", progress: 40, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 3, title: "Passives", instructor: "Lê Văn C", content: "Ngữ pháp câu bị động", progress: 60, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 4, title: "Quantifiers", instructor: "Phạm Thị D", content: "Cách sử dụng lượng từ", progress: 20, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 5, title: "Modal Verbs", instructor: "Hoàng Văn E", content: "Động từ khuyết thiếu", progress: 90, image: "image/course.jpg" },
  { id: 6, title: "Stative Verbs", instructor: "Nguyễn Thị F", content: "Động từ trạng thái", progress: 50, image: "image/course.jpg" },
  { id: 7, title: "Intensifiers", instructor: "Trần Văn G", content: "Cách dùng từ tăng cường", progress: 30, image: "image/course.jpg" },
  { id: 8, title: "Adjective Order", instructor: "Lê Thị H", content: "Thứ tự tính từ", progress: 80, image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 9, title: "Vocabulary N4", instructor: "Phạm Văn I", content: "Từ vựng trình độ N4", progress: 65, image: "image/course.jpg" },
  { id: 10, title: "Grammar N4", instructor: "Hoàng Thị K", content: "Ngữ pháp trình độ N4", progress: 25, image: "image/course.jpg" }
];

// Data for free documents
const freeDocuments = [
  { id: 1, title: "Từ vựng cơ bản N5", instructor: "Nguyễn Văn A", content: "Học 100 từ vựng cơ bản miễn phí", image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 2, title: "Ngữ pháp N5 cơ bản", instructor: "Trần Thị B", content: "Giới thiệu các cấu trúc ngữ pháp N5", image: "image/course.jpg" },
  { id: 3, title: "Hội thoại hàng ngày", instructor: "Lê Văn C", content: "Luyện hội thoại tiếng Nhật cơ bản", image: "image/Yamanakako-lake-in-fall.jpeg" },
  { id: 4, title: "Kanji N5", instructor: "Phạm Thị D", content: "Học 50 chữ Kanji cơ bản", image: "image/course.jpg" }
];

const itemsPerPage = 4;
let currentPage = 1;
// Use the initialDocType passed from JSP
let currentTab = initialDocType; // Set the initial tab based on the URL parameter

// Function to create paid document card HTML
function createPaidDocumentCard(document) {
  return `
    <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
      <img src="${document.image}" alt="Document" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
      <h3 class="font-semibold text-lg">${document.title}</h3>
      <p class="text-gray-500 text-sm">Giảng viên: ${document.instructor}</p>
      <p class="text-gray-500 text-sm mb-2">Nội dung: ${document.content}</p>
      <div class="flex justify-between items-center mt-2">
        <span class="text-orange-500 font-bold text-lg">$${document.price}</span>
        <div class="flex items-center space-x-2">
          <a href="${document.id === 1 ? 'CourseDetail.html' : '#'}" class="text-sm text-white bg-orange-500 px-4 py-1 rounded-full font-semibold shadow hover:bg-orange-600 transition">Xem chi tiết</a>
          <button class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" title="Thêm vào giỏ hàng">
            <i class="fa fa-shopping-cart"></i>
          </button>
        </div>
      </div>
    </div>
  `;
}

// Function to create studying document card HTML
function createStudyingDocumentCard(document) {
  return `
    <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
      <img src="${document.image}" alt="Document" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
      <h3 class="font-semibold text-lg">${document.title}</h3>
      <p class="text-gray-500 text-sm">Giảng viên: ${document.instructor}</p>
      <p class="text-gray-500 text-sm mb-2">Nội dung: ${document.content}</p>
      <div class="relative pt-2 mb-2"></div>
      <div class="flex justify-between items-center mt-2">
        <a href="${document.id === 1 ? 'ContinueLearning.html' : '#'}" class="text-sm text-white bg-orange-500 px-4 py-1 rounded-full font-semibold shadow hover:bg-orange-600 transition">Tiếp tục học</a>
        <a href="${document.id === 1 ? 'CourseDetail.html' : '#'}" class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" title="Xem chi tiết">
          <i class="fa fa-eye"></i>
        </a>
      </div>
    </div>
  `;
}

// Function to create free document card HTML
function createFreeDocumentCard(document) {
  return `
    <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
      <img src="${document.image}" alt="Document" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
      <h3 class="font-semibold text-lg">${document.title}</h3>
      <p class="text-gray-500 text-sm">Giảng viên: ${document.instructor}</p>
      <p class="text-gray-500 text-sm mb-2">Nội dung: ${document.content}</p>
      <div class="flex justify-between items-center mt-2">
        <span class="text-orange-500 font-bold text-lg">Miễn phí</span>
        <div class="flex items-center space-x-2">
          <a href="${document.id === 1 ? 'CourseDetail.html' : '#'}" class="text-sm text-white bg-orange-500 px-4 py-1 rounded-full font-semibold shadow hover:bg-orange-600 transition">Xem chi tiết</a>
          <button class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" title="Tải xuống">
            <i class="fa fa-download"></i>
          </button>
        </div>
      </div>
    </div>
  `;
}

// Function to display content based on current tab and page
function displayContent() {
  const contentArea = document.getElementById('contentArea');
  const bannerTitle = document.getElementById('bannerTitle');
  const bannerSubtitle = document.getElementById('bannerSubtitle');
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;

  let itemsToShow = [];
  if (currentTab === 'paid') {
    itemsToShow = paidDocuments.slice(startIndex, endIndex);
    bannerTitle.textContent = 'Tài liệu trả phí';
    bannerSubtitle.textContent = 'Bộ tài liệu chất lượng cao dành riêng cho bạn';
  } else if (currentTab === 'studying') {
    itemsToShow = studyingDocuments.slice(startIndex, endIndex);
    bannerTitle.textContent = 'Tài liệu đang học';
    bannerSubtitle.textContent = 'Tiếp tục hành trình học tiếng Nhật của bạn';
  } else {
    itemsToShow = freeDocuments.slice(startIndex, endIndex);
    bannerTitle.textContent = 'Tài liệu miễn phí';
    bannerSubtitle.textContent = 'Khám phá tài liệu miễn phí để bắt đầu học tiếng Nhật';
  }

  contentArea.style.opacity = '0';
  setTimeout(() => {
    contentArea.innerHTML = itemsToShow.map(item => {
      if (currentTab === 'paid') return createPaidDocumentCard(item);
      if (currentTab === 'studying') return createStudyingDocumentCard(item);
      return createFreeDocumentCard(item);
    }).join('');
    contentArea.style.opacity = '1';
  }, 300);

  // Update active tab button
  document.getElementById('paidDocsTab').classList.remove('active');
  document.getElementById('studyingDocsTab').classList.remove('active');
  document.getElementById('freeDocsTab').classList.remove('active');
  document.getElementById(`${currentTab}DocsTab`).classList.add('active');
}

// Function to update pagination
function updatePagination() {
  const totalItems = currentTab === 'paid' ? paidDocuments.length : 
                    currentTab === 'studying' ? studyingDocuments.length : 
                    freeDocuments.length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  const pageNumbers = document.getElementById('pageNumbers');
  const prevButton = document.getElementById('prevPage');
  const nextButton = document.getElementById('nextPage');

  prevButton.disabled = currentPage === 1;
  nextButton.disabled = currentPage === totalPages;

  if (prevButton.disabled) {
    prevButton.classList.add('disabled');
  } else {
    prevButton.classList.remove('disabled');
  }

  if (nextButton.disabled) {
    nextButton.classList.add('disabled');
  } else {
    nextButton.classList.remove('disabled');
  }

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
      displayContent();
      updatePagination();
    });
  });
}

// Tab switching logic
document.getElementById('paidDocsTab').addEventListener('click', () => {
  currentTab = 'paid';
  currentPage = 1;
  displayContent();
  updatePagination();
  // Update URL without reloading
  history.pushState(null, '', 'documents.jsp?type=paid');
});

document.getElementById('studyingDocsTab').addEventListener('click', () => {
  currentTab = 'studying';
  currentPage = 1;
  displayContent();
  updatePagination();
  history.pushState(null, '', 'documents.jsp?type=studying');
});

document.getElementById('freeDocsTab').addEventListener('click', () => {
  currentTab = 'free';
  currentPage = 1;
  displayContent();
  updatePagination();
  history.pushState(null, '', 'documents.jsp?type=free');
});

// Pagination event listeners
document.getElementById('prevPage').addEventListener('click', () => {
  if (currentPage > 1) {
    currentPage--;
    displayContent();
    updatePagination();
  }
});

document.getElementById('nextPage').addEventListener('click', () => {
  const totalItems = currentTab === 'paid' ? paidDocuments.length : 
                    currentTab === 'studying' ? studyingDocuments.length : 
                    freeDocuments.length;
  const totalPages = Math.ceil(totalItems / itemsPerPage);
  if (currentPage < totalPages) {
    currentPage++;
    displayContent();
    updatePagination();
  }
});

// Initialize the page
displayContent();
updatePagination();