let currentPage = 1;
const currentFilter = 'all'; // Fixed to 'all' as per requirement
let documentsPerPage = 8;
let allDocuments = [];
let classList = [];
const contextPath = window.contextPath || '';
const userID = window.userID || '';

function populateClassSelector(classes, selectedClassId = null) {
    const classSelect = document.getElementById('classSelect');
    if (!classSelect) {
        console.error('Error: classSelect element not found in DOM');
        return;
    }
    classSelect.innerHTML = '<option value="" disabled selected>Chọn lớp học</option>';
    if (!classes || classes.length === 0) {
        console.warn('No classes received from API');
        classSelect.innerHTML += '<option value="">Không có lớp học nào</option>';
    } else {
        classes.forEach(cls => {
            if (cls.classID && cls.name) {
                const option = document.createElement('option');
                option.value = cls.id;
                option.textContent = cls.name;
                if (cls.classID == selectedClassId) {
                    option.selected = true;
                }
                classSelect.appendChild(option);
                console.log('Added option:', { value: cls.classID, text: cls.name, selected: option.selected });
            } else {
                console.warn('Invalid class data:', cls);
            }
        });
        console.log('Class selector populated with:', classes, 'Selected value:', selectedClassId || 'None');
    }
}

function fetchClassDocuments() {
    const classSelect = document.getElementById('classSelect');
    const classId = classSelect?.value;
    console.log(`fetchClassDocuments called with classId: ${classId}`);
    if (classId) {
        localStorage.setItem('selectedClassId', classId);
        console.log(`Saved classId to localStorage: ${classId}`);
        fetchDocuments(classId);
    } else {
        console.log('No class selected, fetching all documents');
        localStorage.removeItem('selectedClassId');
        fetchDocuments();
    }
}
function fetchDocuments(classId = null) {
    const documentGrid = document.getElementById('documentGrid');
    if (!documentGrid) {
        console.error('Error: documentGrid element not found in DOM');
        return;
    }
    documentGrid.innerHTML = '<div class="no-documents">Đang tải...</div>';

    // Không lấy classId từ localStorage khi tải trang lần đầu
    const url = classId ? `${contextPath}/api/documents?filter=${currentFilter}&classId=${classId}` : `${contextPath}/api/documents?filter=${currentFilter}`;
    console.log('Fetching documents from:', url);

    const classPromise = fetch(`${contextPath}/api/documents/classes`, {
        headers: {
            'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]')?.value || '',
            'Accept': 'application/json'
        },
        credentials: 'include'
    }).then(response => {
        console.log('Classes API status:', response.status);
        if (!response.ok) {
            return response.text().then(text => {
                throw new Error(`HTTP ${response.status}: ${text || 'Error'}`);
            });
        }
        return response.json();
    }).then(data => {
        console.log('Classes API data:', data);
        return data;
    }).catch(error => {
        console.error('Error fetching classes:', error.message);
        return [];
    });

    const documentPromise = fetch(url, {
        headers: {
            'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]')?.value || '',
            'Accept': 'application/json'
        },
        credentials: 'include'
    }).then(response => {
        console.log('Documents API status:', response.status);
        if (!response.ok) {
            return response.text().then(text => {
                throw new Error(`HTTP ${response.status}: ${text || 'Error'}`);
            });
        }
        return response.json();
    }).then(data => {
        console.log('Documents API data:', data);
        return data;
    }).catch(error => {
        console.error('Error fetching documents:', error.message);
        return [];
    });

    Promise.all([documentPromise, classPromise])
        .then(([documents, classes]) => {
            allDocuments = Array.isArray(documents) ? documents : [];
            classList = Array.isArray(classes) ? classes : [];
            console.log('Documents received:', allDocuments.length);
            console.log('Classes received:', classList);
            populateClassSelector(classList, classId); // Truyền classId
            renderDocuments();
            updatePagination();
        })
        .catch(error => {
            console.error('Error in fetchDocuments:', error.message);
            documentGrid.innerHTML = `<div class="no-documents">Lỗi: ${error.message}</div>`;
            updatePagination();
        });
}
function renderDocuments() {
    const documentGrid = document.getElementById('documentGrid');
    if (!documentGrid) {
        console.error('Error: documentGrid element not found in DOM');
        return;
    }
    documentGrid.innerHTML = '';
    const start = (currentPage - 1) * documentsPerPage;
    const end = start + documentsPerPage;
    const documents = allDocuments.slice(start, end);
    if (documents.length === 0) {
        documentGrid.innerHTML = '<div class="no-documents">Không có tài liệu nào để hiển thị.</div>';
        console.warn('No documents to render');
        return;
    }
    documents.forEach(doc => {
        if (!doc.id || !doc.title) {
            console.warn('Invalid document data:', doc);
            return;
        }
        const imageUrl = doc.imgUrl || 'https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/img/Ảnh_chụp_màn_hình_2025-06-17_012223.png';
        const classInfo = classList.find(cls => cls.id == doc.classID) || { name: 'Chưa có' };
        const className = classInfo.name;

        const card = document.createElement('div');
        card.className = 'document-card';
        card.dataset.documentId = doc.id;
        card.innerHTML = `
            <img src="${imageUrl}" alt="${doc.title}" class="document-image" />
            <div class="document-content">
                <h3 class="document-title">${doc.title}</h3>
                <p class="document-description">${doc.description || 'Không có mô tả'}</p>
                <p class="document-meta"><i class="fas fa-calendar"></i> Ngày tải lên: ${doc.uploadDate ? new Date(doc.uploadDate).toLocaleString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' }) : 'N/A'}</p>
                <p class="document-meta"><i class="fas fa-chalkboard"></i> Lớp: ${className}</p>
                <div class="document-actions">
                    <button class="btn btn-primary" onclick="viewDocument('${doc.fileUrl}')"><i class="fas fa-eye"></i> Xem</button>
                    ${doc.uploadedBy === userID ? `
                        <button class="btn btn-accent" onclick="showUpdateDocumentForm(${doc.id})"><i class="fas fa-edit"></i> Cập Nhật</button>
                        <button class="btn btn-danger" onclick="deleteDocument(${doc.id})"><i class="fas fa-trash"></i> Xóa</button>
                    ` : ''}
                </div>
            </div>
        `;
        documentGrid.appendChild(card);
    });
    console.log(`Rendered ${documents.length} documents on page ${currentPage}`);
}

function viewDocument(url) {
    try {
        const encodedUrl = encodeURI(url);
        window.open(encodedUrl, '_blank');
    } catch (error) {
        console.error('Error opening document:', error);
        alert('Không thể mở tài liệu. Vui lòng kiểm tra lại.');
    }
}

function showAddDocumentForm() {
    document.getElementById('documentModalLabel').textContent = 'Thêm Tài Liệu';
    document.getElementById('documentForm').reset();
    document.getElementById('documentId').value = '';
    document.getElementById('documentFileInput').style.display = 'block';
    document.getElementById('documentFile').setAttribute('required', 'required');
    document.getElementById('classId').innerHTML = '<option value="" disabled selected>Chọn lớp học</option>';

    fetch(`${contextPath}/api/documents/classes`, {
        headers: {
            'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]')?.value || '',
            'Accept': 'application/json'
        },
        credentials: 'include'
    })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(`HTTP ${response.status}: ${text || 'Không thể tải danh sách lớp'}`);
                });
            }
            return response.json();
        })
        .then(classes => {
            classList = Array.isArray(classes) ? classes : [];
            const classSelect = document.getElementById('classId');
            if (classList.length === 0) {
                classSelect.innerHTML += '<option value="">Không có lớp học nào</option>';
            } else {
                classList.forEach(cls => {
                    if (cls.id && cls.name) {
                        const option = document.createElement('option');
                        option.value = cls.id;
                        option.textContent = cls.name;
                        classSelect.appendChild(option);
                    }
                });
            }
            console.log('Modal class selector populated with:', classList);
        })
        .catch(error => {
            console.error('Error fetching classes for modal:', error);
            alert('Lỗi tải danh sách lớp: ' + error.message);
        });
    new bootstrap.Modal(document.getElementById('documentModal'), { focus: false }).show();
}

function showUpdateDocumentForm(documentId) {
    const doc = allDocuments.find(d => d.id == documentId);
    if (!doc) {
        console.error('Document not found:', documentId);
        alert('Không tìm thấy tài liệu.');
        return;
    }
    document.getElementById('documentModalLabel').textContent = 'Cập Nhật Tài Liệu';
    document.getElementById('documentId').value = doc.id;
    document.getElementById('documentName').value = doc.title || '';
    document.getElementById('documentDescription').value = doc.description || '';
    document.getElementById('documentFileInput').style.display = 'none';
    document.getElementById('documentFile').removeAttribute('required');
    document.getElementById('classId').innerHTML = '<option value="" disabled selected>Chọn lớp học</option>';

    fetch(`${contextPath}/api/documents/classes`, {
        headers: {
            'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]')?.value || '',
            'Accept': 'application/json'
        },
        credentials: 'include'
    })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    throw new Error(`HTTP ${response.status}: ${text || 'Không thể tải danh sách lớp'}`);
                });
            }
            return response.json();
        })
        .then(classes => {
            classList = Array.isArray(classes) ? classes : [];
            const classSelect = document.getElementById('classId');
            if (classList.length === 0) {
                classSelect.innerHTML += '<option value="">Không có lớp học nào</option>';
            } else {
                classList.forEach(cls => {
                    if (cls.classID && cls.name) {
                        const option = document.createElement('option');
                        option.value = cls.classID;
                        option.textContent = cls.name;
                        if (cls.classID == doc.classID) {
                            option.selected = true;
                        }
                        classSelect.appendChild(option);
                    }
                });
            }
            console.log('Modal class selector populated with:', classList);
        })
        .catch(error => {
            console.error('Error fetching classes for modal:', error);
            alert('Lỗi tải danh sách lớp: ' + error.message);
        });
    new bootstrap.Modal(document.getElementById('documentModal'), { focus: false }).show();
}

function deleteDocument(documentId) {
    if (confirm('Bạn có chắc chắn muốn xóa tài liệu này?')) {
        fetch(`${contextPath}/api/documents/${documentId}`, {
            method: 'DELETE',
            headers: {
                'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]')?.value || '',
                'Accept': 'application/json'
            },
            credentials: 'include'
        })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(`HTTP ${response.status}: ${text || 'Không thể xóa tài liệu'}`);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Document deleted:', documentId);
                fetchDocuments(document.getElementById('classSelect').value || null);
                alert('Tài liệu đã được xóa.');
            })
            .catch(error => {
                console.error('Error deleting document:', error);
                alert('Có lỗi xảy ra khi xóa tài liệu: ' + error.message);
            });
    }
}

function changePage(direction) {
    currentPage += direction;
    if (currentPage < 1) currentPage = 1;
    console.log(`Changing to page ${currentPage}`);
    renderDocuments();
    updatePagination();
}

function updatePagination() {
    const paginationDots = document.getElementById('paginationDots');
    if (!paginationDots) {
        console.error('Error: paginationDots element not found in DOM');
        return;
    }
    paginationDots.innerHTML = '';
    const totalPages = Math.ceil(allDocuments.length / documentsPerPage) || 1;
    for (let i = 1; i <= totalPages; i++) {
        const dot = document.createElement('div');
        dot.className = `pagination-dot ${i === currentPage ? 'active' : ''}`;
        dot.onclick = () => {
            currentPage = i;
            renderDocuments();
            updatePagination();
        };
        paginationDots.appendChild(dot);
    }
    document.getElementById('prevBtn').disabled = currentPage === 1;
    document.getElementById('nextBtn').disabled = currentPage === totalPages;
    console.log(`Pagination updated: ${totalPages} pages, current page ${currentPage}`);
}

document.getElementById('documentForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const formData = new FormData(this);
    const documentId = document.getElementById('documentId').value;
    const classId = document.getElementById('classId').value;
    if (!classId || isNaN(classId) || classId === '') {
        console.warn('Invalid classId selected:', classId);
        alert('Vui lòng chọn một lớp học hợp lệ.');
        return;
    }
    const url = documentId ? `${contextPath}/api/documents/${documentId}` : `${contextPath}/api/documents`;
    const method = documentId ? 'PUT' : 'POST';

    console.log('Submitting form:', { method, url, documentId, classId });
    for (let [key, value] of formData.entries()) {
        console.log(`FormData: ${key}=${value}`);
    }

    fetch(url, {
        method: method,
        body: formData,
        headers: {
            'X-CSRF-TOKEN': document.querySelector('input[name="_csrf"]')?.value || '',
            'Accept': 'application/json'
        },
        credentials: 'include'
    })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => {
                    let errorMessage = text;
                    try {
                        const json = JSON.parse(text);
                        errorMessage = json.error || text;
                    } catch (e) {
                        // Not JSON, use text as is
                    }
                    throw new Error(`HTTP ${response.status}: ${errorMessage}`);
                });
            }
            return response.json();
        })
        .then(data => {
            console.log('Form submission response:', data);
            bootstrap.Modal.getInstance(document.getElementById('documentModal')).hide();
            fetchDocuments(document.getElementById('classSelect').value || null);
            alert(documentId ? 'Tài liệu đã được cập nhật.' : 'Tài liệu đã được thêm.');
        })
        .catch(error => {
            console.error('Error submitting form:', error);
            alert('Có lỗi xảy ra: ' + error.message);
        });
});

document.addEventListener('DOMContentLoaded', () => {
    console.log('Page loaded, initializing fetchDocuments');
    fetchDocuments(); // Fetch all documents and classes on page load
});