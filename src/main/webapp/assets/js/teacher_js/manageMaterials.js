const materials = [
    {
        id: 1,
        name: "Tài liệu Toán Cao Cấp - Chương 1",
        description: "Tài liệu về tích phân và ứng dụng trong toán cao cấp.",
        image: "https://via.placeholder.com/250x150?text=Toan+Cao+Cap",
        type: "pdf",
        url: "/assets/files/math_ch1.pdf",
        updatedBy: "Nguyễn Văn A",
        owner: "Nguyễn Văn A",
    },
    {
        id: 2,
        name: "Link tham khảo Toán Cao Cấp",
        description: "Link đến các tài liệu tham khảo toán học nâng cao.",
        image: "https://via.placeholder.com/250x150?text=Link+Toan",
        type: "link",
        url: "https://mathreference.com",
        updatedBy: "Trần Thị B",
        owner: "Trần Thị B",
    },
    {
        id: 3,
        name: "Tài liệu Python - Cơ bản",
        description: "Học các khái niệm cơ bản về lập trình Python.",
        image: "https://via.placeholder.com/250x150?text=Python+Basics",
        type: "pdf",
        url: "/assets/files/python_basics.pdf",
        updatedBy: "Nguyễn Văn A",
        owner: "Nguyễn Văn A",
    },
    {
        id: 4,
        name: "Link Python Tutorials",
        description: "Link đến các hướng dẫn lập trình Python nâng cao.",
        image: "https://via.placeholder.com/250x150?text=Python+Tutorials",
        type: "link",
        url: "https://python.org/tutorials",
        updatedBy: "Lê Văn C",
        owner: "Lê Văn C",
    },
    {
        id: 5,
        name: "Tài liệu IELTS Cơ Bản",
        description: "Tài liệu chuẩn bị cho kỳ thi IELTS cấp độ cơ bản.",
        image: "https://via.placeholder.com/250x150?text=IELTS+Foundation",
        type: "pdf",
        url: "/assets/files/ielts_foundation.pdf",
        updatedBy: "Nguyễn Văn A",
        owner: "Nguyễn Văn A",
    },
    {
        id: 6,
        name: "Tài liệu Lập Trình Java",
        description: "Học lập trình Java từ cơ bản đến nâng cao.",
        image: "https://via.placeholder.com/250x150?text=Java+Basics",
        type: "pdf",
        url: "/assets/files/java_basics.pdf",
        updatedBy: "Trần Thị B",
        owner: "Trần Thị B",
    },
    {
        id: 7,
        name: "Link Java Tutorials",
        description: "Link đến các hướng dẫn lập trình Java chính thức.",
        image: "https://via.placeholder.com/250x150?text=Java+Tutorials",
        type: "link",
        url: "https://java.oracle.com/tutorials",
        updatedBy: "Lê Văn C",
        owner: "Lê Văn C",
    },
    {
        id: 8,
        name: "Tài liệu Hóa Học - Phản Ứng",
        description: "Tài liệu về các phản ứng hóa học cơ bản.",
        image: "https://via.placeholder.com/250x150?text=Chemistry",
        type: "pdf",
        url: "/assets/files/chemistry_reactions.pdf",
        updatedBy: "Nguyễn Văn A",
        owner: "Nguyễn Văn A",
    },
];

let filteredMaterials = [...materials];
let selectedMaterialId = null;
const materialModal = new bootstrap.Modal(document.getElementById("materialModal"));
const itemsPerPage = 8; // 2 rows of 4 materials each
let currentPage = 1;
const currentUser = "Nguyễn Văn A"; // Simulate logged-in user
const currentTime = "09:46 PM, 23/05/2025"; // Updated to current time

// Render material grid
function renderMaterials() {
    const grid = document.getElementById("materialGrid");
    grid.innerHTML = "";
    const start = (currentPage - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const paginatedMaterials = filteredMaterials.slice(start, end);

    const filterType = document.querySelector(".filter-btn.active").textContent === "Tài liệu của tôi" ? "mine" : "all";
    const isMyMaterials = filterType === "mine";

    paginatedMaterials.forEach((material) => {
        const card = document.createElement("div");
        card.className = "material-card";
        const actionsHTML = isMyMaterials && material.owner === currentUser
                ? `
              <button class="btn btn-primary" onclick="viewMaterial('${material.url}', '${material.type}')"><i class="fas fa-eye"></i> Xem</button>
              <button class="btn btn-accent" onclick="showUpdateMaterialForm(${material.id})"><i class="fas fa-edit"></i> Cập Nhật</button>
              <button class="btn btn-danger" onclick="deleteMaterial(${material.id})"><i class="fas fa-trash"></i> Xóa</button>
            `
                : `
              <button class="btn btn-primary" onclick="viewMaterial('${material.url}', '${material.type}')"><i class="fas fa-eye"></i> Xem</button>
            `;
        card.innerHTML = `
            <img src="${material.image}" alt="${material.name}" class="material-image" />
            <div class="material-content">
              <h3 class="material-title">${material.name}</h3>
              <p class="material-description">${material.description}</p>
              <p class="material-meta"><i class="fas fa-user"></i> Cập nhật bởi: ${material.updatedBy}</p>
              <div class="material-actions">
                ${actionsHTML}
              </div>
            </div>
          `;
        grid.appendChild(card);
    });

    updatePagination();
    // Show or hide the Add Material button based on filter
    document.getElementById("addMaterialBtn").style.display = isMyMaterials ? "block" : "none";
}

// View material
function viewMaterial(url, type) {
    if (type === "link") {
        window.open(url, "_blank");
    } else {
        alert(`Mở tài liệu tại: ${url}. Vui lòng tích hợp trình xem PDF tại đây!`);
    }
}

// Show add material form
function showAddMaterialForm() {
    const filterType = document.querySelector(".filter-btn.active").textContent === "Tài liệu của tôi" ? "mine" : "all";
    if (filterType !== "mine") {
        alert("Vui lòng chọn 'Tài liệu của tôi' để thêm tài liệu!");
        return;
    }
    selectedMaterialId = null;
    document.getElementById("materialModalLabel").textContent = "Thêm Tài Liệu Mới";
    document.getElementById("materialForm").reset();
    document.getElementById("materialType").value = "pdf";
    toggleMaterialInput();
    materialModal.show();
}

// Show update material form
function showUpdateMaterialForm(materialId) {
    const filterType = document.querySelector(".filter-btn.active").textContent === "Tài liệu của tôi" ? "mine" : "all";
    if (filterType !== "mine") {
        alert("Vui lòng chọn 'Tài liệu của tôi' để cập nhật tài liệu!");
        return;
    }
    const material = materials.find((m) => m.id === materialId);
    if (material.owner !== currentUser) {
        alert("Bạn chỉ có thể cập nhật tài liệu của mình!");
        return;
    }
    selectedMaterialId = materialId;
    document.getElementById("materialModalLabel").textContent = "Cập Nhật Tài Liệu";
    document.getElementById("materialName").value = material.name;
    document.getElementById("materialDescription").value = material.description;
    document.getElementById("materialType").value = material.type;
    document.getElementById("materialLink").value = material.type === "link" ? material.url : "";
    toggleMaterialInput();
    materialModal.show();
}

// Delete material
function deleteMaterial(materialId) {
    const filterType = document.querySelector(".filter-btn.active").textContent === "Tài liệu của tôi" ? "mine" : "all";
    if (filterType !== "mine") {
        alert("Vui lòng chọn 'Tài liệu của tôi' để xóa tài liệu!");
        return;
    }
    const material = materials.find((m) => m.id === materialId);
    if (material.owner !== currentUser) {
        alert("Bạn chỉ có thể xóa tài liệu của mình!");
        return;
    }
    if (confirm("Bạn có chắc chắn muốn xóa tài liệu này?")) {
        const index = materials.findIndex((m) => m.id === materialId);
        materials.splice(index, 1);
        applyFilter('mine'); // Reapply filter after deletion to stay in "Tài liệu của tôi"
    }
}

// Toggle material input based on type
function toggleMaterialInput() {
    const materialType = document.getElementById("materialType").value;
    document.getElementById("materialFileInput").style.display = materialType === "pdf" ? "block" : "none";
    document.getElementById("materialLinkInput").style.display = materialType === "link" ? "block" : "none";
}

// Handle form submission
document.getElementById("materialForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const name = document.getElementById("materialName").value;
    const description = document.getElementById("materialDescription").value;
    const type = document.getElementById("materialType").value;
    let url = "";
    let image = "https://via.placeholder.com/250x150?text=" + encodeURIComponent(name);

    if (type === "pdf") {
        const fileInput = document.getElementById("materialFile");
        if (fileInput.files.length > 0) {
            url = `/assets/files/${fileInput.files[0].name}`; // Placeholder for actual file upload
        } else if (selectedMaterialId) {
            const material = materials.find((m) => m.id === selectedMaterialId);
            url = material.url; // Keep existing URL if no new file
        }
    } else {
        url = document.getElementById("materialLink").value;
    }

    const imageInput = document.getElementById("materialImage");
    if (imageInput.files.length > 0) {
        image = `/assets/images/${imageInput.files[0].name}`; // Placeholder for actual image upload
    } else if (selectedMaterialId) {
        const material = materials.find((m) => m.id === selectedMaterialId);
        image = material.image; // Keep existing image if no new file
    }

    if (selectedMaterialId) {
        // Update existing material
        const material = materials.find((m) => m.id === selectedMaterialId);
        material.name = name;
        material.description = description;
        material.type = type;
        material.url = url;
        material.image = image;
        material.updatedBy = currentUser;
    } else {
        // Add new material
        const newMaterial = {
            id: materials.length ? Math.max(...materials.map((m) => m.id)) + 1 : 1,
            name,
            description,
            image,
            type,
            url,
            updatedBy: currentUser,
            owner: currentUser,
        };
        materials.push(newMaterial);
    }

    applyFilter('mine'); // Reapply filter after submission to stay in "Tài liệu của tôi"
    materialModal.hide();
});

// Apply filter based on button click
function applyFilter(filterType) {
    const searchTerm = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll(".filter-btn").forEach(btn => btn.classList.remove("active"));
    event.target.classList.add("active");

    if (filterType === "mine" || (event.target.textContent === "Tài liệu của tôi")) {
        filteredMaterials = materials.filter(
                (material) =>
            material.owner === currentUser &&
                    material.name.toLowerCase().includes(searchTerm)
        );
    } else {
        filteredMaterials = materials.filter((material) =>
            material.name.toLowerCase().includes(searchTerm)
        );
    }

    currentPage = 1;
    renderMaterials();
}

// Filter materials based on search input
function filterMaterials() {
    applyFilter(document.querySelector(".filter-btn.active").textContent === "Tài liệu của tôi" ? "mine" : "all");
}

// Update pagination
function updatePagination() {
    const totalPages = Math.ceil(filteredMaterials.length / itemsPerPage);
    const paginationDots = document.getElementById("paginationDots");
    paginationDots.innerHTML = "";

    for (let i = 1; i <= totalPages; i++) {
        const dot = document.createElement("div");
        dot.className = `pagination-dot ${i === currentPage ? "active" : ""}`;
        dot.onclick = () => {
            currentPage = i;
            renderMaterials();
        };
        paginationDots.appendChild(dot);
    }

    document.getElementById("prevBtn").disabled = currentPage === 1;
    document.getElementById("nextBtn").disabled = currentPage === totalPages;
}

// Change page
function changePage(direction) {
    const totalPages = Math.ceil(filteredMaterials.length / itemsPerPage);
    currentPage += direction;
    if (currentPage < 1)
        currentPage = 1;
    if (currentPage > totalPages)
        currentPage = totalPages;
    renderMaterials();
}

// Toggle input fields based on material type
document.getElementById("materialType").addEventListener("change", toggleMaterialInput);

// Initial render
renderMaterials();