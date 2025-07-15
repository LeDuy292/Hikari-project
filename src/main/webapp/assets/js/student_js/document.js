const itemsPerPage = 4
let currentPage = 1
let documents = []
let filteredDocuments = []


document.addEventListener("DOMContentLoaded", () => {
  console.log("Document loaded, initializing...")

  const prevPage = document.getElementById("prevPage")
  const nextPage = document.getElementById("nextPage")
  const searchInput = document.getElementById("searchInput")
  const categorySelect = document.getElementById("categorySelect")
  const classSelect = document.getElementById("classSelect")
  const errorMessage = document.getElementById("errorMessage")
  const documentList = document.getElementById("documentList")

  if (!prevPage || !nextPage || !searchInput || !categorySelect || !errorMessage || !documentList) {
    console.error("One or more required elements not found:", {
      prevPage: !!prevPage,
      nextPage: !!nextPage,
      searchInput: !!searchInput,
      categorySelect: !!categorySelect,
      errorMessage: !!errorMessage,
      documentList: !!documentList,
    })
    return
  }

  // Hiển thị loading
  showLoading()

  // Fetch documents from API
  fetchDocuments()

  // Event listeners
  prevPage.addEventListener("click", () => {
    if (currentPage > 1) {
      currentPage--
      paginateDocuments()
    }
  })

  nextPage.addEventListener("click", () => {
    const totalPages = Math.ceil(filteredDocuments.length / itemsPerPage)
    if (currentPage < totalPages) {
      currentPage++
      paginateDocuments()
    }
  })

  searchInput.addEventListener("input", (e) => {
    const searchTerm = e.target.value.toLowerCase()
    filterDocuments(searchTerm, categorySelect.value.toLowerCase())
    currentPage = 1
    paginateDocuments()
  })

  categorySelect.addEventListener("change", (e) => {
    const category = e.target.value.toLowerCase()
    filterDocuments(searchInput.value.toLowerCase(), category)
    currentPage = 1
    paginateDocuments()
  })

  // Class select event listener
  if (classSelect) {
    classSelect.addEventListener("change", (e) => {
      const selectedClassId = e.target.value
      console.log("Class changed to:", selectedClassId)
      showLoading()
      fetchDocuments(selectedClassId)
    })
  }
})

function showLoading() {
  const documentList = document.getElementById("documentList")
  documentList.innerHTML = `
    <div class="col-span-full text-center py-8">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-500 mx-auto mb-4"></div>
      <p class="text-gray-500">Đang tải tài liệu từ hệ thống...</p>
    </div>
  `
}

function fetchDocuments(classId = null) {
  // Xây dựng URL API - sử dụng đúng endpoint
  let apiUrl = `${window.location.origin}/Hikari/api/documents`

  // Thêm classId nếu có
  if (classId) {
    apiUrl += `?classId=${encodeURIComponent(classId)}`
  }

  console.log("Fetching documents from:", apiUrl)

  fetch(apiUrl, {
    method: "GET",
    credentials: "same-origin",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      console.log("Response status:", response.status)
      console.log("Response headers:", Object.fromEntries(response.headers.entries()))

      if (!response.ok) {
        if (response.status === 401) {
          console.warn("Unauthorized access, but continuing with limited functionality")
          // Không show error nữa, thay vào đó tạo sample data
          return createSampleData()
        }
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.json()
    })
    .then((data) => {
      console.log("Received data from API:", data)

      if (!Array.isArray(data)) {
        console.error("Expected array but got:", typeof data, data)
        // Fallback to sample data
        data = createSampleData()
      }

      // Lọc và validate documents
      documents = data.filter((doc) => {
        const isValid = doc && doc.id && doc.title && doc.fileUrl
        if (!isValid) {
          console.log("Filtered out invalid document:", doc)
        }
        return isValid
      })

      console.log("Valid documents:", documents.length)
      updateDocumentCount(documents.length)

      if (documents.length === 0) {
        showNoDocuments()
      } else {
        filteredDocuments = [...documents]
        renderDocuments()
        paginateDocuments()
      }
    })
    .catch((error) => {
      console.error("Error fetching documents:", error)
      console.log("Using sample data as fallback")

      // Use sample data as fallback
      documents = createSampleData()
      filteredDocuments = [...documents]
      updateDocumentCount(documents.length)
      renderDocuments()
      paginateDocuments()
    })
}

function createSampleData() {
  return [
    {
      id: 1,
      title: "Hiragana cơ bản",
      description: "Tài liệu học bảng chữ cái Hiragana",
      fileUrl: "/Hikari/assets/documents/sample_documents/hiragana_basic.pdf",
      imgUrl: "/Hikari/assets/img/documents/Japanese-N5.jpg",
      uploadedBy: "T001",
      classID: "CL001",
      uploadDate: "2024-01-15",
    },
    {
      id: 2,
      title: "Katakana nâng cao",
      description: "Tài liệu học bảng chữ cái Katakana",
      fileUrl: "/Hikari/assets/documents/sample_documents/katakana_advanced.pdf",
      imgUrl: "/Hikari/assets/img/documents/Japanese-N5.jpg",
      uploadedBy: "T001",
      classID: "CL001",
      uploadDate: "2024-01-20",
    },
    {
      id: 3,
      title: "Số đếm tiếng Nhật",
      description: "Học cách đếm số từ 1-100",
      fileUrl: "/Hikari/assets/documents/sample_documents/numbers_basic.pdf",
      imgUrl: "/Hikari/assets/img/documents/Japanese-N5.jpg",
      uploadedBy: "T001",
      classID: null,
      uploadDate: "2024-01-25",
    },
    {
      id: 4,
      title: "Ngữ pháp N4",
      description: "Các cấu trúc ngữ pháp cơ bản N4",
      fileUrl: "/Hikari/assets/documents/sample_documents/grammar_n4.pdf",
      imgUrl: "/Hikari/assets/img/documents/Japanese-N4.jpg",
      uploadedBy: "T002",
      classID: "CL003",
      uploadDate: "2024-02-01",
    },
    {
      id: 5,
      title: "Kanji N5",
      description: "50 chữ Kanji đầu tiên cho người mới học",
      fileUrl: "/Hikari/assets/documents/sample_documents/kanji_n5.pdf",
      imgUrl: "/Hikari/assets/img/documents/Japanese-N5.jpg",
      uploadedBy: "T001",
      classID: null,
      uploadDate: "2024-02-05",
    },
  ]
}

function showNoDocuments() {
  const documentList = document.getElementById("documentList")
  documentList.innerHTML = `
    <div class="col-span-full text-center py-12">
      <i class="fas fa-folder-open text-6xl text-gray-300 mb-4"></i>
      <h3 class="text-xl font-semibold text-gray-600 mb-2">Chưa có tài liệu</h3>
      <p class="text-gray-500">Không có tài liệu PDF nào để hiển thị.</p>
    </div>
  `
  updatePagination()
}

function showError(message) {
  const documentList = document.getElementById("documentList")
  documentList.innerHTML = `
    <div class="col-span-full text-center py-12">
      <i class="fas fa-exclamation-triangle text-6xl text-red-300 mb-4"></i>
      <h3 class="text-xl font-semibold text-red-600 mb-2">Có lỗi xảy ra</h3>
      <p class="text-red-500">${message}</p>
      <button onclick="location.reload()" class="mt-4 px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600 transition">
        <i class="fas fa-redo mr-2"></i>Thử lại
      </button>
    </div>
  `
  updatePagination()
}

function renderDocuments() {
  const documentList = document.getElementById("documentList")
  if (!documentList) {
    console.error("Element #documentList not found")
    return
  }

  documentList.innerHTML = ""

  filteredDocuments.forEach((doc, index) => {
    const card = createDocumentCard(doc, index)
    documentList.appendChild(card)
  })

  console.log("Rendered", filteredDocuments.length, "documents")
}

function createDocumentCard(doc, index) {
  const card = document.createElement("div")
  card.className =
    "bg-white p-4 rounded-2xl shadow-lg relative hover:shadow-2xl transition group animate-fadeIn document-card"
  card.style.animationDelay = `${index * 0.1}s`

  const uploadDate = doc.uploadDate ? new Date(doc.uploadDate).toLocaleDateString("vi-VN") : "N/A"
  const imageUrl = doc.imgUrl || doc.imageUrl || "/Hikari/assets/img/documents/Japanese-N5.jpg"

  card.innerHTML = `
        <div class="relative overflow-hidden rounded-xl mb-4">
            <img src="${imageUrl}" 
                 alt="Document thumbnail" 
                 class="w-full h-36 object-cover group-hover:scale-105 transition-transform duration-300"
                 onerror="this.src='/Hikari/assets/img/documents/Japanese-N5.jpg'">
            <div class="absolute top-2 right-2 bg-orange-500 text-white text-xs px-2 py-1 rounded-full">
                PDF
            </div>
            ${doc.classID ? `<div class="absolute top-2 left-2 bg-blue-500 text-white text-xs px-2 py-1 rounded-full">${doc.classID}</div>` : '<div class="absolute top-2 left-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">Chung</div>'}
        </div>
        <h3 class="font-semibold text-lg mb-2 line-clamp-2" title="${doc.title || "Untitled"}">${doc.title || "Untitled"}</h3>
        <p class="text-gray-500 text-sm mb-1">
            <i class="fa fa-user mr-1"></i>
            Tải lên bởi: ${doc.uploadedBy || "Unknown"}
        </p>
        <p class="text-gray-500 text-sm mb-3">
            <i class="fa fa-calendar mr-1"></i>
            Ngày tải lên: ${uploadDate}
        </p>
        ${doc.description ? `<p class="text-gray-600 text-sm mb-3 line-clamp-2" title="${doc.description}">${doc.description}</p>` : ""}
        <div class="flex justify-between items-center mt-auto">
            <button onclick="previewDocument(${doc.id})" 
                    class="text-sm custom-active-btn px-4 py-2 rounded-full font-semibold shadow hover:shadow-lg transition flex items-center">
                <i class="fa fa-eye mr-1"></i>
                Xem trước
            </button>
            <button onclick="downloadDocument(${doc.id}, '${(doc.title || "document").replace(/'/g, "\\'")}')" 
                    class="bg-orange-100 text-orange-500 hover:bg-orange-500 hover:text-white rounded-full p-2 transition shadow" 
                    title="Tải về">
                <i class="fa fa-download"></i>
            </button>
        </div>
    `

  return card
}

function previewDocument(documentId) {
  console.log("Previewing document:", documentId)
  const previewUrl = `${window.location.origin}/Hikari/documents/preview/${documentId}`
  window.open(previewUrl, "_blank")
}

function downloadDocument(documentId, title) {
  console.log("Downloading document:", documentId, title)
  const downloadUrl = `${window.location.origin}/Hikari/documents/download/${documentId}`

  // Tạo link tạm thời để download
  const link = document.createElement("a")
  link.href = downloadUrl
  link.download = `${title}.pdf`
  link.target = "_blank"
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

function filterDocuments(searchTerm, category) {
  console.log("Filtering documents with search:", searchTerm, "category:", category)

  filteredDocuments = documents.filter((doc) => {
    const title = (doc.title || "").toLowerCase()
    const description = (doc.description || "").toLowerCase()
    const uploadedBy = (doc.uploadedBy || "").toLowerCase()

    const matchesSearch =
      searchTerm === "" ||
      title.includes(searchTerm) ||
      description.includes(searchTerm) ||
      uploadedBy.includes(searchTerm)

    const matchesCategory = category === "" || title.includes(category)

    return matchesSearch && matchesCategory
  })

  console.log("Filtered to", filteredDocuments.length, "documents")
  updateDocumentCount(filteredDocuments.length)

  const errorMessage = document.getElementById("errorMessage")
  if (filteredDocuments.length === 0) {
    errorMessage.classList.remove("hidden")
    document.getElementById("documentList").innerHTML =
      '<div class="col-span-full text-center py-8"><i class="fa fa-search text-4xl text-gray-300 mb-4"></i><p class="text-gray-500">Không tìm thấy tài liệu phù hợp với từ khóa tìm kiếm.</p></div>'
  } else {
    errorMessage.classList.add("hidden")
    renderDocuments()
  }
}

function updatePagination() {
  const totalItems = filteredDocuments.length
  const totalPages = Math.ceil(totalItems / itemsPerPage)
  const pageNumbers = document.getElementById("pageNumbers")

  if (!pageNumbers) {
    console.error("Element #pageNumbers not found")
    return
  }

  const prevButton = document.getElementById("prevPage")
  const nextButton = document.getElementById("nextPage")

  if (prevButton && nextButton) {
    prevButton.disabled = currentPage === 1 || totalItems === 0
    nextButton.disabled = currentPage === totalPages || totalItems === 0

    // Update button styles
    prevButton.className = `pagination-btn ${prevButton.disabled ? "opacity-50 cursor-not-allowed" : "hover:bg-orange-100"}`
    nextButton.className = `pagination-btn ${nextButton.disabled ? "opacity-50 cursor-not-allowed" : "hover:bg-orange-100"}`
  }

  let pageNumbersHTML = ""
  if (totalItems === 0) {
    pageNumbersHTML = '<span class="text-gray-500">Không có trang</span>'
  } else {
    const maxVisiblePages = 5
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2))
    const endPage = Math.min(totalPages, startPage + maxVisiblePages - 1)

    if (endPage - startPage + 1 < maxVisiblePages) {
      startPage = Math.max(1, endPage - maxVisiblePages + 1)
    }

    if (startPage > 1) {
      pageNumbersHTML += `<button class="page-number px-3 py-1 rounded-full bg-gray-100 text-gray-700 hover:bg-orange-300 hover:text-white transition" data-page="1">1</button>`
      if (startPage > 2) {
        pageNumbersHTML += '<span class="px-2 text-gray-500">...</span>'
      }
    }

    for (let i = startPage; i <= endPage; i++) {
      pageNumbersHTML += `<button class="page-number px-3 py-1 rounded-full ${currentPage === i ? "bg-orange-500 text-white" : "bg-gray-100 text-gray-700"} hover:bg-orange-300 hover:text-white transition" data-page="${i}">${i}</button>`
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageNumbersHTML += '<span class="px-2 text-gray-500">...</span>'
      }
      pageNumbersHTML += `<button class="page-number px-3 py-1 rounded-full bg-gray-100 text-gray-700 hover:bg-orange-300 hover:text-white transition" data-page="${totalPages}">${totalPages}</button>`
    }
  }

  pageNumbers.innerHTML = pageNumbersHTML

  // Add event listeners to page number buttons
  document.querySelectorAll(".page-number").forEach((button) => {
    button.addEventListener("click", () => {
      currentPage = Number.parseInt(button.dataset.page)
      paginateDocuments()
    })
  })
}

function paginateDocuments() {
  const startIndex = (currentPage - 1) * itemsPerPage
  const endIndex = startIndex + itemsPerPage

  const cards = document.querySelectorAll(".document-card")
  cards.forEach((card, index) => {
    if (index >= startIndex && index < endIndex) {
      card.style.display = "block"
      card.style.animation = `fadeIn 0.5s ease-in-out ${(index - startIndex) * 0.1}s both`
    } else {
      card.style.display = "none"
    }
  })

  updatePagination()

  // Scroll to top of document list
  document.getElementById("documentList").scrollIntoView({ behavior: "smooth", block: "start" })
}

function updateDocumentCount(count) {
  const documentCountElement = document.getElementById("documentCount")
  if (documentCountElement) {
    documentCountElement.textContent = `${count} tài liệu`
  }
}

// CSS animations
const style = document.createElement("style")
style.textContent = `
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .animate-fadeIn {
        animation: fadeIn 0.5s ease-in-out both;
    }
    
    .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .pagination-btn {
        padding: 8px 12px;
        border: 1px solid #e5e7eb;
        background: white;
        border-radius: 8px;
        transition: all 0.2s;
    }
    
    .pagination-btn:hover:not(:disabled) {
        background: #fed7aa;
        border-color: #fb923c;
    }
    
    .custom-active-btn {
        background: linear-gradient(135deg, #fb923c, #f97316);
        color: white;
        border: none;
        transition: all 0.3s ease;
    }
    
    .custom-active-btn:hover {
        background: linear-gradient(135deg, #ea580c, #dc2626);
        transform: translateY(-1px);
    }
`
document.head.appendChild(style)
