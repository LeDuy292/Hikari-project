// Khởi tạo biến
const itemsPerPage = 4;
let currentPage = 1;
let currentTab = initialDocType || 'free'; // Mặc định là 'free' nếu không có initialDocType
let documents = { paid: [], studying: [], free: [] };

// Hàm tạo thẻ HTML cho tài liệu trả phí
function createPaidDocumentCard(document) {
    return `
        <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
            <img src="${contextPath}${document.image}" alt="Document" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
            <h3 class="font-semibold text-lg">${document.title}</h3>
            <p class="text-gray-500 text-sm">Giảng viên: ${document.instructor}</p>
            <p class="text-gray-500 text-sm mb-2">Nội dung: ${document.content}</p>
            <div class="flex justify-between items-center mt-2">
                <span class="text-orange-500 font-bold text-lg">$${document.price}</span>
                <div class="flex items-center space-x-2">
                    <a href="${navigateToCourseInfo(document.id, document.title, 'guest')}" class="text-sm text-white bg-orange-500 px-4 py-1 rounded-full font-semibold shadow hover:bg-orange-600 transition">Xem chi tiết</a>
                    <button class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" title="Thêm vào giỏ hàng">
                        <i class="fa fa-shopping-cart"></i>
                    </button>
                </div>
            </div>
        </div>
    `;
}

// Hàm tạo thẻ HTML cho tài liệu đang học
function createStudyingDocumentCard(document) {
    return `
        <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
            <img src="${contextPath}${document.image}" alt="Document" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
            <h3 class="font-semibold text-lg">${document.title}</h3>
            <p class="text-gray-500 text-sm">Giảng viên: ${document.instructor}</p>
            <p class="text-gray-500 text-sm mb-2">Nội dung: ${document.content}</p>
            <div class="relative pt-2 mb-2">
                <div class="w-full bg-gray-200 rounded-full h-2.5">
                    <div class="bg-orange-500 h-2.5 rounded-full" style="width: ${document.progress}%"></div>
                </div>
                <p class="text-sm text-gray-500">Tiến độ: ${document.progress}%</p>
            </div>
            <div class="flex justify-between items-center mt-2">
                <a href="${navigateToContinueLearning(document.id)}" class="text-sm text-white bg-orange-500 px-4 py-1 rounded-full font-semibold shadow hover:bg-orange-600 transition">Tiếp tục học</a>
                <a href="${navigateToCourseInfo(document.id, document.title, 'student')}" class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" title="Xem chi tiết">
                    <i class="fa fa-eye"></i>
                </a>
            </div>
        </div>
    `;
}

// Hàm tạo thẻ HTML cho tài liệu miễn phí
function createFreeDocumentCard(document) {
    return `
        <div class="bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn">
            <img src="${contextPath}${document.image}" alt="Document" class="rounded-xl mb-4 w-full h-36 object-cover group-hover:scale-105 transition">
            <h3 class="font-semibold text-lg">${document.title}</h3>
            <p class="text-gray-500 text-sm">Giảng viên: ${document.instructor}</p>
            <p class="text-gray-500 text-sm mb-2">Nội dung: ${document.content}</p>
            <div class="flex justify-between items-center mt-2">
                <span class="text-orange-500 font-bold text-lg">Miễn phí</span>
                <div class="flex items-center space-x-2">
                    <a href="${navigateToCourseInfo(document.id, document.title, 'student')}" class="text-sm text-white bg-orange-500 px-4 py-1 rounded-full font-semibold shadow hover:bg-orange-600 transition">Xem chi tiết</a>
                    <button class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" title="Tải xuống">
                        <i class="fa fa-download"></i>
                    </button>
                </div>
            </div>
        </div>
    `;
}

// Hàm lấy tài liệu từ backend
async function fetchDocuments(type, query = '') {
    try {
        const response = await fetch(`${contextPath}/api/documents?type=${type}&q=${encodeURIComponent(query)}`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const text = await response.text();
        if (text.startsWith("error:")) throw new Error(text.substring(6));
        documents[type] = parseDocuments(text, type);
        if (currentTab === type) {
            displayContent();
            updatePagination();
        }
    } catch (error) {
        console.error('Error fetching documents:', error);
        document.getElementById('contentArea').innerHTML = '<p class="text-red-500 text-center">Lỗi khi tải tài liệu: ' + error.message + '</p>';
    }
}

// Hàm phân tích dữ liệu từ chuỗi phân cách dấu chấm phẩy
function parseDocuments(text, type) {
    const lines = text.trim().split('\n');
    const docs = [];
    lines.forEach(line => {
        if (line) {
            const parts = line.split(';').map(part => part.replace(/\\(.)/g, '$1')); // Unescape \; to ;
            if (type === 'paid' && parts.length === 6) {
                docs.push({
                    id: parseInt(parts[0]),
                    title: parts[1],
                    instructor: parts[2],
                    content: parts[3],
                    price: parseFloat(parts[4]),
                    image: parts[5]
                });
            } else if (type === 'studying' && parts.length === 6) {
                docs.push({
                    id: parseInt(parts[0]),
                    title: parts[1],
                    instructor: parts[2],
                    content: parts[3],
                    progress: parseInt(parts[4]),
                    image: parts[5]
                });
            } else if (type === 'free' && parts.length === 5) {
                docs.push({
                    id: parseInt(parts[0]),
                    title: parts[1],
                    instructor: parts[2],
                    content: parts[3],
                    image: parts[4]
                });
            }
        }
    });
    return docs;
}

// Hàm hiển thị nội dung
function displayContent() {
    const contentArea = document.getElementById('contentArea');
    const bannerTitle = document.getElementById('bannerTitle');
    const bannerSubtitle = document.getElementById('bannerSubtitle');
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;

    const itemsToShow = documents[currentTab].slice(startIndex, endIndex);

    if (bannerTitle) bannerTitle.textContent = currentTab === 'paid' ? 'Tài liệu trả phí' : 
                                              currentTab === 'studying' ? 'Tài liệu đang học' : 
                                              'Tài liệu miễn phí';
    if (bannerSubtitle) bannerSubtitle.textContent = currentTab === 'paid' ? 'Bộ tài liệu chất lượng cao dành riêng cho bạn' : 
                                                    currentTab === 'studying' ? 'Tiếp tục hành trình học tiếng Nhật của bạn' : 
                                                    'Khám phá tài liệu miễn phí để bắt đầu học tiếng Nhật';

    contentArea.style.opacity = '0';
    setTimeout(() => {
        contentArea.innerHTML = itemsToShow.length
          ? itemsToShow.map(item => {
              if (currentTab === 'paid') return createPaidDocumentCard(item);
              if (currentTab === 'studying') return createStudyingDocumentCard(item);
              return createFreeDocumentCard(item);
            }).join('')
          : '<p class="text-gray-500 text-center">Không tìm thấy tài liệu nào.</p>';
        contentArea.style.opacity = '1';
    }, 300);

    document.querySelectorAll('.tab-button').forEach(button => {
        button.setAttribute('aria-selected', button.id === `${currentTab}DocsTab` ? 'true' : 'false');
        button.classList.toggle('active', button.id === `${currentTab}DocsTab`);
    });
}

// Hàm cập nhật phân trang
function updatePagination() {
    const totalItems = documents[currentTab].length;
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

// Hàm điều hướng đến trang thông tin khóa học
function navigateToCourseInfo(id, title, userType) {
    const encodedTitle = encodeURIComponent(title);
    return `${contextPath}/view/${userType}/courseInfo.jsp?id=${id}&title=${encodedTitle}`;
}

// Hàm điều hướng đến trang tiếp tục học
function navigateToContinueLearning(id) {
    return `${contextPath}/view/student/continueLearning.jsp?id=${id}`;
}

// Xử lý tìm kiếm
document.getElementById('searchInput').addEventListener('input', (e) => {
    const query = e.target.value;
    currentPage = 1;
    fetchDocuments(currentTab, query);
});

// Xử lý chuyển tab
document.getElementById('paidDocsTab').addEventListener('click', () => {
    currentTab = 'paid';
    currentPage = 1;
    fetchDocuments(currentTab);
    history.pushState(null, '', `${contextPath}/view/guest/documents.jsp?type=paid`);
});

document.getElementById('studyingDocsTab').addEventListener('click', () => {
    currentTab = 'studying';
    currentPage = 1;
    fetchDocuments(currentTab);
    history.pushState(null, '', `${contextPath}/view/student/documents.jsp?type=studying`);
});

document.getElementById('freeDocsTab').addEventListener('click', () => {
    currentTab = 'free';
    currentPage = 1;
    fetchDocuments(currentTab);
    history.pushState(null, '', `${contextPath}/view/guest/documents.jsp?type=free`);
});

// Xử lý phân trang
document.getElementById('prevPage').addEventListener('click', () => {
    if (currentPage > 1) {
        currentPage--;
        displayContent();
        updatePagination();
    }
});

document.getElementById('nextPage').addEventListener('click', () => {
    const totalPages = Math.ceil(documents[currentTab].length / itemsPerPage);
    if (currentPage < totalPages) {
        currentPage++;
        displayContent();
        updatePagination();
    }
});

// Khởi động trang
fetchDocuments(currentTab);